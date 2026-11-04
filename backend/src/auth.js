import { createHash, randomBytes, scryptSync, timingSafeEqual } from 'node:crypto';
import { Router } from 'express';
import { requireDatabase, withTransaction } from './db.js';
import { fail, requireText, route } from './http.js';

export const authRouter = Router();
export const accountRouter = Router();
const SESSION_DAYS = 14;

export function passwordHash(password) {
  const salt = randomBytes(16).toString('hex');
  return `${salt}:${scryptSync(password, salt, 64).toString('hex')}`;
}

export function passwordMatches(password, stored) {
  const [salt, expectedHex] = stored.split(':');
  if (!salt || !expectedHex || expectedHex.length !== 128) return false;
  const actual = scryptSync(password, salt, 64);
  return timingSafeEqual(actual, Buffer.from(expectedHex, 'hex'));
}

function tokenHash(token) {
  return createHash('sha256').update(token).digest('hex');
}

async function newSession(db, userId) {
  const token = randomBytes(32).toString('base64url');
  await db.query(`INSERT INTO auth_sessions (user_id,token_hash,expires_at)
    VALUES ($1,$2,now()+interval '14 days')`, [userId, tokenHash(token)]);
  return token;
}

function publicUser(user) {
  const { password_hash: _secret, ...safe } = user;
  return safe;
}

authRouter.post('/register', route(async (request, response) => {
  const fullName = requireText(request.body?.fullName, 'fullName', 150);
  const email = requireText(request.body?.email, 'email').toLowerCase();
  const phone = request.body?.phone ? requireText(request.body.phone, 'phone', 25) : null;
  const password = requireText(request.body?.password, 'password', 200);
  if (!/^\S+@\S+\.\S+$/.test(email) || password.length < 8) {
    throw fail(400, 'INVALID_INPUT', 'A valid email and password of at least 8 characters are required');
  }
  const result = await withTransaction(async (db) => {
    try {
      const saved = await db.query(`INSERT INTO users (full_name,email,phone,password_hash)
        VALUES ($1,$2,$3,$4) RETURNING id,full_name,email,phone,birth_date,nationality,avatar_url`,
        [fullName, email, phone, passwordHash(password)]);
      const user = saved.rows[0];
      const token = await newSession(db, user.id);
      return { user, token, expiresInDays: SESSION_DAYS };
    } catch (err) {
      if (err.code === '23505') {
        const field = err.constraint?.includes('email')
          ? 'Email'
          : err.constraint?.includes('phone')
            ? 'Số điện thoại'
            : 'Thông tin tài khoản';
        throw fail(409, 'CONFLICT', `${field} này đã được sử dụng cho một tài khoản khác.`);
      }
      throw err;
    }
  });
  response.status(201).json(result);
}));

authRouter.post('/login', route(async (request, response) => {
  const identity = requireText(request.body?.identity, 'identity').toLowerCase();
  const password = requireText(request.body?.password, 'password', 200);
  const db = await requireDatabase();
  const found = await db.query('SELECT * FROM users WHERE lower(email)=$1 OR phone=$1 LIMIT 1', [identity]);
  const user = found.rows[0];
  if (!user || !passwordMatches(password, user.password_hash)) {
    throw fail(401, 'INVALID_CREDENTIALS', 'Email, phone or password is incorrect');
  }
  const token = await newSession(db, user.id);
  response.json({ user: publicUser(user), token, expiresInDays: SESSION_DAYS });
}));

export const authenticated = route(async (request, _response, next) => {
  const value = request.get('Authorization') ?? '';
  const token = value.startsWith('Bearer ') ? value.slice(7) : '';
  if (!token) throw fail(401, 'AUTH_REQUIRED', 'Sign in required');
  const db = await requireDatabase();
  const result = await db.query(`SELECT u.id,u.full_name,u.email,u.phone,u.birth_date,u.nationality,u.avatar_url
    FROM auth_sessions s JOIN users u ON u.id=s.user_id
    WHERE s.token_hash=$1 AND s.expires_at>now()`, [tokenHash(token)]);
  if (!result.rowCount) throw fail(401, 'SESSION_EXPIRED', 'Sign in again');
  request.user = result.rows[0];
  request.sessionHash = tokenHash(token);
  next();
});

accountRouter.get('/me', authenticated, (request, response) => response.json(request.user));

accountRouter.patch('/me', authenticated, route(async (request, response) => {
  const name = requireText(request.body?.fullName, 'fullName', 150);
  const phone = request.body?.phone == null ? null : requireText(request.body.phone, 'phone', 25);
  const nationality = request.body?.nationality == null ? null : requireText(request.body.nationality, 'nationality', 100);
  const birthDate = request.body?.birthDate ?? null;
  if (birthDate != null && !/^\d{4}-\d{2}-\d{2}$/.test(birthDate)) {
    throw fail(400, 'INVALID_INPUT', 'birthDate must use YYYY-MM-DD');
  }
  const db = await requireDatabase();
  const updated = await db.query(`UPDATE users SET full_name=$1,phone=COALESCE($2,phone),
    nationality=COALESCE($3,nationality),birth_date=COALESCE($4::date,birth_date),updated_at=now()
    WHERE id=$5 RETURNING id,full_name,email,phone,birth_date,nationality,avatar_url`,
    [name, phone, nationality, birthDate, request.user.id]);
  response.json(updated.rows[0]);
}));

accountRouter.post('/logout', authenticated, route(async (request, response) => {
  const db = await requireDatabase();
  await db.query('DELETE FROM auth_sessions WHERE token_hash=$1', [request.sessionHash]);
  response.status(204).end();
}));
