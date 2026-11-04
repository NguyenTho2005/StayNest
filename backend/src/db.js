import pg from 'pg';
import { readFileSync } from 'node:fs';
import { config } from './config.js';

// Parse int8 / bigserial / bigint columns as JavaScript numbers rather than strings.
pg.types.setTypeParser(pg.types.builtins.INT8, (val) => (val === null ? null : parseInt(val, 10)));

const EmbeddedPostgres = config.embeddedDemo
  ? (await import('@electric-sql/pglite')).PGlite
  : null;

const ssl = config.databaseSsl
  ? {
      // Do not weaken certificate verification for an Internet-facing database.
      // Managed providers with a private CA can supply it via a mounted secret.
      rejectUnauthorized: true,
      ...(config.databaseSslCaFile
        ? { ca: readFileSync(config.databaseSslCaFile, 'utf8') }
        : {}),
    }
  : undefined;

export const pool = config.databaseUrl
  ? new pg.Pool({
      connectionString: config.databaseUrl,
      ...(ssl ? { ssl } : {}),
      connectionTimeoutMillis: 3000,
      query_timeout: 5000,
      max: 10,
    })
  : EmbeddedPostgres ? new EmbeddedPostgres() : null;

if (pool && config.databaseUrl) {
  pool.on('error', (err) => {
    // Avoid crashing the process on background/idle client disconnects while logging securely
    process.stderr.write(`[database-pool] Idle client error: ${err.message}\n`);
  });
}

let embeddedTail = Promise.resolve();

export async function requireDatabase() {
  if (!pool) {
    const error = new Error('PostgreSQL is not configured');
    error.status = 503;
    error.code = 'DATABASE_UNAVAILABLE';
    throw error;
  }
  return pool;
}

export async function withTransaction(work) {
  const database = await requireDatabase();
  if (config.embeddedDemo) {
    let unlock;
    const previous = embeddedTail;
    embeddedTail = new Promise((resolve) => { unlock = resolve; });
    await previous;
    try {
      await database.query('BEGIN');
      const result = await work(database);
      await database.query('COMMIT');
      return result;
    } catch (error) {
      await database.query('ROLLBACK');
      throw error;
    } finally {
      unlock();
    }
  }
  const client = await database.connect();
  try {
    await client.query('BEGIN');
    const result = await work(client);
    await client.query('COMMIT');
    return result;
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
}

export async function initializeEmbeddedDemo() {
  if (!config.embeddedDemo) return;
  const { runMigrations } = await import('./migrate.js');
  const { seedCatalog } = await import('./seed.js');
  await runMigrations(pool);
  await withTransaction(seedCatalog);
}

export async function closeDatabase() {
  if (config.embeddedDemo) await pool.close();
  else await pool?.end();
}
