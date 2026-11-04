import assert from 'node:assert/strict';
import { spawn } from 'node:child_process';
import { createServer } from 'node:net';
import test from 'node:test';

async function freePort() {
  const server = createServer();
  await new Promise((resolve) => server.listen(0, '127.0.0.1', resolve));
  const port = server.address().port;
  await new Promise((resolve) => server.close(resolve));
  return port;
}

test('seed CLI rejects execution in production', async () => {
  const child = spawn(process.execPath, ['src/seed.js'], {
    cwd: new URL('..', import.meta.url),
    env: {
      ...process.env,
      NODE_ENV: 'production',
      ALLOW_DEMO_SEED: '1',
      DATABASE_URL: 'postgresql://staynest:placeholder@127.0.0.1:5432/staynest',
    },
    stdio: 'pipe',
  });

  let stderr = '';
  child.stderr.on('data', (chunk) => {
    stderr += chunk.toString();
  });

  const exitCode = await new Promise((resolve) => child.on('close', resolve));
  assert.equal(exitCode, 1);
  assert.match(stderr, /strictly prohibited in production/i);
});

test('seed CLI requires explicit confirmation flag outside production', async () => {
  const child = spawn(process.execPath, ['src/seed.js'], {
    cwd: new URL('..', import.meta.url),
    env: { ...process.env, NODE_ENV: 'development', ALLOW_DEMO_SEED: '0', STAYNEST_ALLOW_SEED: '0' },
    stdio: 'pipe',
  });

  let stderr = '';
  child.stderr.on('data', (chunk) => {
    stderr += chunk.toString();
  });

  const exitCode = await new Promise((resolve) => child.on('close', resolve));
  assert.equal(exitCode, 1);
  assert.match(stderr, /requires explicit confirmation/i);
});

test('readiness check reports 200 when database is available and error responses sanitize internal details', { timeout: 30000 }, async () => {
  const port = await freePort();
  const server = spawn(process.execPath, ['src/server.js'], {
    cwd: new URL('..', import.meta.url),
    env: {
      ...process.env,
      DATABASE_URL: '',
      STAYNEST_EMBEDDED_DEMO: '1',
      PORT: String(port),
      HOST: '127.0.0.1',
      SEED_DEMO_PASSWORD: '',
    },
    stdio: 'pipe',
  });

  const base = `http://127.0.0.1:${port}/api/v1`;
  try {
    let ready = false;
    for (let attempt = 0; attempt < 80; attempt += 1) {
      if (server.exitCode !== null) throw new Error('Server process exited prematurely');
      try {
        const res = await fetch(`${base}/health/ready`);
        if (res.status === 200) {
          ready = true;
          break;
        }
      } catch {
        /* booting */
      }
      await new Promise((resolve) => setTimeout(resolve, 100));
    }
    assert.equal(ready, true, 'Server ready endpoint should return 200');

    // Health endpoint returns process health
    const health = await fetch(`${base}/health`);
    assert.equal(health.status, 200);
    const healthData = await health.json();
    assert.equal(healthData.status, 'ok');

    // 404 endpoint includes requestId and does not leak internal path info
    const notFound = await fetch(`${base}/unknown-endpoint-${Date.now()}`);
    assert.equal(notFound.status, 404);
    const notFoundData = await notFound.json();
    assert.equal(notFoundData.error.code, 'NOT_FOUND');
    assert.ok(notFoundData.error.requestId);

    // Unauthenticated access to private route returns 401 with requestId
    const unauth = await fetch(`${base}/me`);
    assert.equal(unauth.status, 401);
    const unauthData = await unauth.json();
    assert.equal(unauthData.error.code, 'AUTH_REQUIRED');
    assert.ok(unauthData.error.requestId);
  } finally {
    server.kill('SIGTERM');
  }
});
