import assert from 'node:assert/strict';
import test from 'node:test';
import { parseConfig } from '../src/config.js';

test('config parses valid local development settings', () => {
  const cfg = parseConfig({
    PORT: '4000',
    HOST: '127.0.0.1',
    DATABASE_URL: 'postgresql://staynest:secret@127.0.0.1:5432/staynest',
    DATABASE_SSL: '0',
    CORS_ORIGINS: 'http://127.0.0.1:8090,http://127.0.0.1:8087',
  });
  assert.equal(cfg.port, 4000);
  assert.equal(cfg.host, '127.0.0.1');
  assert.equal(cfg.databaseUrl, 'postgresql://staynest:secret@127.0.0.1:5432/staynest');
  assert.equal(cfg.databaseSsl, false);
  assert.equal(cfg.isProduction, false);
  assert.deepEqual(cfg.corsOrigins, ['http://127.0.0.1:8090', 'http://127.0.0.1:8087']);
});

test('config accepts postgres:// and postgresql:// URL schemes', () => {
  const cfg1 = parseConfig({ DATABASE_URL: 'postgres://user:pass@db.example.com:5432/staynest' });
  assert.equal(cfg1.databaseUrl, 'postgres://user:pass@db.example.com:5432/staynest');
  const cfg2 = parseConfig({ DATABASE_URL: 'postgresql://user:pass@db.example.com:5432/staynest' });
  assert.equal(cfg2.databaseUrl, 'postgresql://user:pass@db.example.com:5432/staynest');
});

test('config rejects non-postgresql URLs', () => {
  assert.throws(
    () => parseConfig({ DATABASE_URL: 'mysql://user:pass@127.0.0.1:3306/staynest' }),
    /DATABASE_URL must be a PostgreSQL URL/,
  );
  assert.throws(
    () => parseConfig({ DATABASE_URL: 'sqlite:///tmp/db.sqlite' }),
    /DATABASE_URL must be a PostgreSQL URL/,
  );
});

test('config enforces DATABASE_URL in production', () => {
  assert.throws(
    () => parseConfig({ NODE_ENV: 'production', DATABASE_URL: '' }),
    /DATABASE_URL is required in production/,
  );
});

test('config rejects STAYNEST_EMBEDDED_DEMO in production', () => {
  assert.throws(
    () =>
      parseConfig({
        NODE_ENV: 'production',
        STAYNEST_EMBEDDED_DEMO: '1',
        DATABASE_URL: 'postgresql://user:pass@db.example.com:5432/staynest',
      }),
    /STAYNEST_EMBEDDED_DEMO is not allowed in production/,
  );
});

test('config strictly prohibits CORS wildcard "*"', () => {
  assert.throws(
    () => parseConfig({ CORS_ORIGINS: '*' }),
    /CORS origin "\*" is strictly prohibited/,
  );
  assert.throws(
    () => parseConfig({ CORS_ORIGINS: 'https://app.example.com,*' }),
    /CORS origin "\*" is strictly prohibited/,
  );
});

test('config validates CORS origin formats', () => {
  assert.throws(
    () => parseConfig({ CORS_ORIGINS: 'https://app.example.com/subpath' }),
    /Invalid CORS origin/,
  );
  assert.throws(
    () => parseConfig({ CORS_ORIGINS: 'app.example.com' }),
    /Invalid CORS origin/,
  );
  const valid = parseConfig({
    CORS_ORIGINS: 'https://app.example.com,https://demo.staynest.vn:8443',
  });
  assert.deepEqual(valid.corsOrigins, [
    'https://app.example.com',
    'https://demo.staynest.vn:8443',
  ]);
});

test('config enforces SSL/CA dependency rules', () => {
  assert.throws(
    () => parseConfig({ DATABASE_SSL: '1', DATABASE_URL: '' }),
    /DATABASE_SSL and DATABASE_SSL_CA_FILE require DATABASE_URL/,
  );
  assert.throws(
    () =>
      parseConfig({
        DATABASE_URL: 'postgresql://user:pass@127.0.0.1:5432/staynest',
        DATABASE_SSL: '0',
        DATABASE_SSL_CA_FILE: '/path/to/ca.pem',
      }),
    /DATABASE_SSL_CA_FILE requires DATABASE_SSL=1/,
  );
});

test('config validates PORT range', () => {
  assert.throws(() => parseConfig({ PORT: '0' }), /PORT must be an integer between 1 and 65535/);
  assert.throws(() => parseConfig({ PORT: '70000' }), /PORT must be an integer between 1 and 65535/);
  assert.throws(() => parseConfig({ PORT: 'abc' }), /PORT must be an integer between 1 and 65535/);
});

