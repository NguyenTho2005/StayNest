import assert from 'node:assert/strict';
import test from 'node:test';
import { PGlite } from '@electric-sql/pglite';
import { runMigrations } from '../src/migrate.js';

test('migration runner creates tracking table and applies migrations', async () => {
  const db = new PGlite();
  try {
    const result = await runMigrations(db);
    assert.ok(result.applied.includes('001_initial.sql'));
    assert.equal(result.totalFiles, 1);

    const tracking = await db.query('SELECT filename, applied_at FROM schema_migrations ORDER BY filename');
    assert.equal(tracking.rowCount, 1);
    assert.equal(tracking.rows[0].filename, '001_initial.sql');
    assert.ok(tracking.rows[0].applied_at);

    // Verify key tables exist
    const tables = await db.query(
      "SELECT tablename FROM pg_tables WHERE schemaname='public' ORDER BY tablename",
    );
    const tableNames = tables.rows.map((row) => row.tablename);
    assert.ok(tableNames.includes('schema_migrations'));
    assert.ok(tableNames.includes('bookings'));
    assert.ok(tableNames.includes('booking_idempotency'));
    assert.ok(tableNames.includes('demo_payments'));
    assert.ok(tableNames.includes('cancellation_requests'));
    assert.ok(tableNames.includes('demo_refunds'));
  } finally {
    await db.close();
  }
});

test('migration runner is idempotent when run repeatedly', async () => {
  const db = new PGlite();
  try {
    const firstRun = await runMigrations(db);
    assert.equal(firstRun.applied.length, 1);

    const secondRun = await runMigrations(db);
    assert.equal(secondRun.applied.length, 0, 'Second run should not re-apply any migration');

    const count = await db.query('SELECT count(*)::int AS count FROM schema_migrations');
    assert.equal(count.rows[0].count, 1);
  } finally {
    await db.close();
  }
});

