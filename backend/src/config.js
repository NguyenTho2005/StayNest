import dotenv from 'dotenv';
import { fileURLToPath } from 'node:url';
import { dirname, resolve } from 'node:path';

const __dirname = dirname(fileURLToPath(import.meta.url));
dotenv.config({ path: resolve(__dirname, '../.env') });
dotenv.config();

function booleanEnvironment(name, env = process.env, defaultValue = false) {
  const value = env[name];
  if (value === undefined || value === '') return defaultValue;
  if (value === '1' || String(value).toLowerCase() === 'true') return true;
  if (value === '0' || String(value).toLowerCase() === 'false') return false;
  throw new Error(`${name} must be 0, 1, true, or false`);
}

export function parseConfig(env = process.env) {
  const nodeEnv = env.NODE_ENV ?? 'development';
  const isProduction = nodeEnv === 'production';

  const port = Number(env.PORT ?? 3000);
  if (!Number.isInteger(port) || port < 1 || port > 65535) {
    throw new Error('PORT must be an integer between 1 and 65535');
  }

  const databaseUrl = env.DATABASE_URL?.trim() ?? '';
  if (databaseUrl && !/^postgres(ql)?:\/\//i.test(databaseUrl)) {
    throw new Error('DATABASE_URL must be a PostgreSQL URL');
  }

  if (isProduction && !databaseUrl) {
    throw new Error('DATABASE_URL is required in production');
  }

  const embeddedRequested = env.STAYNEST_EMBEDDED_DEMO === '1';
  if (isProduction && embeddedRequested) {
    throw new Error('STAYNEST_EMBEDDED_DEMO is not allowed in production');
  }

  const embeddedDemo = embeddedRequested && !databaseUrl;

  const databaseSsl = embeddedDemo
    ? false
    : booleanEnvironment('DATABASE_SSL', env, false);
  const databaseSslCaFile = embeddedDemo
    ? ''
    : (env.DATABASE_SSL_CA_FILE?.trim() ?? '');
  if (!databaseUrl && (databaseSsl || databaseSslCaFile)) {
    throw new Error('DATABASE_SSL and DATABASE_SSL_CA_FILE require DATABASE_URL');
  }
  if (databaseSslCaFile && !databaseSsl) {
    throw new Error('DATABASE_SSL_CA_FILE requires DATABASE_SSL=1');
  }

  const corsOrigins = (env.CORS_ORIGINS ?? '')
    .split(',')
    .map((origin) => origin.trim())
    .filter(Boolean);

  for (const origin of corsOrigins) {
    if (origin === '*') {
      throw new Error('CORS origin "*" is strictly prohibited');
    }
    if (!/^https?:\/\/[^/]+$/i.test(origin)) {
      throw new Error(
        `Invalid CORS origin "${origin}". Must be exact origin without trailing path (e.g. https://app.example.com)`,
      );
    }
  }

  const allowDemoSeed =
    booleanEnvironment('ALLOW_DEMO_SEED', env, false) ||
    booleanEnvironment('STAYNEST_ALLOW_SEED', env, false);

  return Object.freeze({
    nodeEnv,
    isProduction,
    port,
    host: env.HOST ?? '127.0.0.1',
    databaseUrl,
    // TLS is opt-in for local development so unencrypted local installs continue to work.
    // Hosted databases over the network must set DATABASE_SSL=1.
    databaseSsl,
    databaseSslCaFile,
    embeddedDemo,
    corsOrigins,
    allowDemoSeed,
  });
}

export const config = parseConfig(process.env);
