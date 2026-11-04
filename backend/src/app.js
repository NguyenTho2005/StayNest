import { randomUUID } from 'node:crypto';
import { fileURLToPath } from 'node:url';
import express from 'express';
import cors from 'cors';
import { config } from './config.js';
import { requireDatabase } from './db.js';
import { authRouter, accountRouter } from './auth.js';
import { catalogRouter } from './catalog.js';
import { bookingRouter } from './bookings.js';
import { favoritesRouter } from './favorites.js';

export const app = express();
app.disable('x-powered-by');
app.use((request, response, next) => {
  response.locals.requestId = randomUUID();
  response.set('X-Request-Id', response.locals.requestId);
  next();
});
const corsOriginValidator = (origin, callback) => {
  // Allow requests without Origin header (like native mobile apps, curl, server-to-server)
  if (!origin) return callback(null, true);
  if (config.corsOrigins.includes(origin)) return callback(null, true);
  // In development environments, allow any localhost/127.0.0.1 port to support Flutter dev servers on dynamic/custom ports
  if (!config.isProduction && /^https?:\/\/(localhost|127\.0\.0\.1)(:\d+)?$/i.test(origin)) {
    return callback(null, true);
  }
  return callback(null, false);
};

app.use(cors({ origin: corsOriginValidator }));
app.use(express.json({ limit: '256kb' }));
app.use('/media', express.static(fileURLToPath(new URL('../../assets/images/', import.meta.url))));
app.use('/api/v1/auth', authRouter);
app.use('/api/v1', accountRouter);
app.use('/api/v1', catalogRouter);
app.use('/api/v1', bookingRouter);
app.use('/api/v1', favoritesRouter);

app.get('/api/v1/health', (_request, response) => {
  response.json({ status: 'ok', service: 'staynest-api' });
});

app.get('/api/v1/health/ready', async (_request, response) => {
  try {
    const database = await requireDatabase();
    await database.query('SELECT 1');
    response.json({ status: 'ready' });
  } catch (_error) {
    response.status(503).json({
      status: 'unavailable',
      error: {
        code: 'DATABASE_UNAVAILABLE',
        message: 'Database readiness check failed',
        requestId: response.locals.requestId,
      },
    });
  }
});

app.use((_request, response) => {
  response.status(404).json({
    error: { code: 'NOT_FOUND', message: 'Endpoint not found', requestId: response.locals.requestId },
  });
});

app.use((error, _request, response, _next) => {
  const status = error.status ?? (error.code === '23505' ? 409 : error.type === 'entity.parse.failed' ? 400 : 500);
  const code = error.code === '23505' ? 'CONFLICT' : error.code ?? (status === 400 ? 'BAD_REQUEST' : status === 503 ? 'SERVICE_UNAVAILABLE' : 'INTERNAL_ERROR');
  const isSafeMessage = status < 500 || (status === 503 && error.code === 'DATABASE_UNAVAILABLE');
  const message = isSafeMessage ? error.message : 'Internal server error';

  response.status(status).json({
    error: {
      code,
      message,
      requestId: response.locals.requestId,
    },
  });
});
