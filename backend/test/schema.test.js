import assert from 'node:assert/strict';
import { readFile } from 'node:fs/promises';
import test from 'node:test';
import { PGlite } from '@electric-sql/pglite';
import { seedCatalog } from '../src/seed.js';

test('PostgreSQL migration applies and enforces booking constraints', async () => {
  const db = new PGlite();
  try {
    const sql = await readFile(new URL('../db/migrations/001_initial.sql', import.meta.url), 'utf8');
    await db.exec(sql);
    const tables = await db.query("SELECT tablename FROM pg_tables WHERE schemaname='public'");
    assert.ok(tables.rows.some((row) => row.tablename === 'bookings'));
    assert.ok(tables.rows.some((row) => row.tablename === 'demo_payments'));
    assert.ok(tables.rows.some((row) => row.tablename === 'auth_sessions'));
    const invalid = db.query("INSERT INTO cancellation_policies (name,free_before_hours,partial_refund_percent) VALUES ('invalid',48,150)");
    await assert.rejects(invalid);
  } finally {
    await db.close();
  }
});

test('demo seed matches the catalog and can be rerun', async () => {
  const db = new PGlite();
  try {
    await db.exec(await readFile(new URL('../db/migrations/001_initial.sql', import.meta.url), 'utf8'));
    await seedCatalog(db);
    await seedCatalog(db);
    const result = await db.query(`SELECT p.slug,r.name,r.base_price_vnd FROM properties p
      JOIN room_types r ON r.property_id=p.id WHERE p.slug='may-homestay' ORDER BY r.base_price_vnd`);
    assert.equal(result.rowCount, 2);
    assert.equal(result.rows[0].name, 'Phòng Studio có bếp');
    assert.equal(Number(result.rows[0].base_price_vnd), 850000);
    assert.equal(result.rows[1].name, 'Phòng Garden View có ban công');
    assert.equal(Number(result.rows[1].base_price_vnd), 1050000);
    const daNang = await db.query("SELECT p.slug,r.base_price_vnd FROM properties p JOIN room_types r ON r.property_id=p.id WHERE p.slug='ocean-pearl-hotel'");
    assert.equal(daNang.rowCount, 1);
    assert.equal(Number(daNang.rows[0].base_price_vnd), 1250000);
    const promotion = await db.query("SELECT code FROM promotions WHERE code='STAY100'");
    assert.equal(promotion.rowCount, 1);
  } finally {
    await db.close();
  }
});
