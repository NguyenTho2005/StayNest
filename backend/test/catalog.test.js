import assert from 'node:assert/strict';
import test from 'node:test';
import { PGlite } from '@electric-sql/pglite';
import { runMigrations } from '../src/migrate.js';
import { seedCatalog } from '../src/seed.js';

test('catalog seed includes Da Lat, Hoi An, Da Nang with published properties', async () => {
  const db = new PGlite();
  try {
    await runMigrations(db);
    await seedCatalog(db);

    // Verify destinations
    const destinations = await db.query('SELECT slug, name, province FROM destinations ORDER BY slug');
    const slugs = destinations.rows.map((r) => r.slug);
    assert.ok(slugs.includes('hoi-an'), 'Destinations should include hoi-an');
    assert.ok(slugs.includes('da-nang'), 'Destinations should include da-nang');
    assert.ok(slugs.includes('da-lat'), 'Destinations should include da-lat');

    // Verify Da Lat properties
    const daLatProperties = await db.query(`SELECT p.slug, p.name, p.property_type, min(r.base_price_vnd)::bigint AS min_price
      FROM properties p JOIN room_types r ON r.property_id=p.id
      JOIN destinations d ON d.id=p.destination_id
      WHERE d.slug='da-lat' AND p.is_published GROUP BY p.id ORDER BY p.slug`);

    assert.equal(daLatProperties.rowCount, 2);
    assert.equal(daLatProperties.rows[0].slug, 'dalat-palace-hotel');
    assert.equal(daLatProperties.rows[1].slug, 'pine-hill-homestay');

    // Verify May Homestay in Hoi An has both Studio and Garden View
    const mayRooms = await db.query(`SELECT r.name, r.base_price_vnd, r.total_units FROM room_types r
      JOIN properties p ON p.id=r.property_id WHERE p.slug='may-homestay' ORDER BY r.base_price_vnd`);
    assert.equal(mayRooms.rowCount, 2);
    assert.equal(mayRooms.rows[0].name, 'Phòng Studio có bếp');
    assert.equal(mayRooms.rows[1].name, 'Phòng Garden View có ban công');
  } finally {
    await db.close();
  }
});

