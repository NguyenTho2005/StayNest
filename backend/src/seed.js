import { randomBytes, scryptSync } from 'node:crypto';
import { fileURLToPath } from 'node:url';
import { resolve } from 'node:path';
import { config } from './config.js';
import { pool, withTransaction } from './db.js';

function hashPassword(password) {
  const salt = randomBytes(16).toString('hex');
  return `${salt}:${scryptSync(password, salt, 64).toString('hex')}`;
}

export async function seedCatalog(db) {
  if (config.isProduction) {
    throw new Error('Demo catalog seed is strictly prohibited in production');
  }

  const destinations = [
    ['hoi-an', 'Hội An', 'Quảng Nam', 'Phố cổ và homestay ấm cúng', 'hoian.jpg'],
    ['da-nang', 'Đà Nẵng', 'Đà Nẵng', 'Thành phố biển miền Trung', 'danang.jpg'],
    ['da-lat', 'Đà Lạt', 'Lâm Đồng', 'Thành phố ngàn hoa và đồi thông mộng mơ', 'danang.jpg'],
  ];
  for (const [slug, name, province, description, image] of destinations) {
    await db.query(`INSERT INTO destinations (slug, name, province, description, image_path)
      VALUES ($1,$2,$3,$4,$5) ON CONFLICT (slug) DO UPDATE SET name=EXCLUDED.name, province=EXCLUDED.province, description=EXCLUDED.description`,
      [slug, name, province, description, image]);
  }
  await db.query(`INSERT INTO cancellation_policies (id, name, free_before_hours, partial_refund_percent, description)
    VALUES (1, 'Linh hoạt minh họa', 48, 50, 'Hoàn 100% trước 48 giờ; sau đó hoàn 50% trước giờ nhận phòng. Chỉ áp dụng cho dữ liệu demo.')
    ON CONFLICT (id) DO NOTHING`);
  await db.query(`SELECT setval(pg_get_serial_sequence('cancellation_policies','id'), GREATEST((SELECT max(id) FROM cancellation_policies), 1))`);

  const properties = [
    ['may-homestay', 'hoi-an', 'Mây Homestay', 'HOMESTAY', 'Homestay ấm cúng gần phố cổ Hội An.', 'Hội An, Quảng Nam', 'search_list_may.jpg', 'Phòng Studio có bếp', 850000, 2, 2, 'room_studio_049.jpg'],
    ['an-villa', 'hoi-an', 'An Villa', 'VILLA', 'Biệt thự sân vườn yên bình.', 'Hội An, Quảng Nam', 'search_list_an.jpg', 'Phòng vườn', 980000, 2, 2, 'search_list_an.jpg'],
    ['riverside-home', 'hoi-an', 'Riverside Home', 'HOMESTAY', 'Lưu trú ven sông.', 'Hội An, Quảng Nam', 'search_list_riverside.jpg', 'Phòng ven sông', 1100000, 2, 2, 'search_list_riverside.jpg'],
    ['ocean-pearl-hotel', 'da-nang', 'Ocean Pearl Hotel', 'HOTEL', 'Khách sạn gần bãi biển Mỹ Khê tại Đà Nẵng.', 'Mỹ Khê, Đà Nẵng', 'destination_hotels_ocean.jpg', 'Phòng tiêu chuẩn', 1250000, 2, 2, 'destination_hotels_ocean.jpg'],
    ['pine-hill-homestay', 'da-lat', 'Pine Hill Homestay', 'HOMESTAY', 'Homestay đồi thông ngắm mây và hoàng hôn lãng mạn tại Đà Lạt.', 'Phường 3, Đà Lạt, Lâm Đồng', 'search_list_an.jpg', 'Phòng đồi thông', 750000, 3, 2, 'room_studio_049.jpg'],
    ['dalat-palace-hotel', 'da-lat', 'Đà Lạt Palace Hotel', 'HOTEL', 'Khách sạn phong cách cổ điển tại trung tâm Đà Lạt.', 'Trung tâm, Đà Lạt, Lâm Đồng', 'destination_hotels_ocean.jpg', 'Phòng Superior', 1450000, 2, 2, 'destination_hotels_ocean.jpg'],
  ];
  for (const [slug, destination, name, type, description, address, image, roomName, price, units, adults, roomImage] of properties) {
    const property = await db.query(`INSERT INTO properties (slug, destination_id, name, property_type, description, address, is_published)
      VALUES ($1, (SELECT id FROM destinations WHERE slug=$2), $3,$4,$5,$6,true)
      ON CONFLICT (slug) DO UPDATE SET name=EXCLUDED.name RETURNING id`, [slug, destination, name, type, description, address]);
    const propertyId = property.rows[0].id;
    await db.query(`INSERT INTO property_images (property_id, image_path, alt_text, sort_order)
      SELECT $1,$2,$3,0 WHERE NOT EXISTS (SELECT 1 FROM property_images WHERE property_id=$1 AND sort_order=0)`, [propertyId, image, name]);
    const room = await db.query(`INSERT INTO room_types (property_id, cancellation_policy_id, name, max_adults, total_units, base_price_vnd, is_active)
      VALUES ($1,1,$2,$3,$4,$5,true)
      ON CONFLICT (property_id,name) DO NOTHING RETURNING id`, [propertyId, roomName, adults, units, price]);
    const roomId = room.rows[0]?.id ?? (await db.query('SELECT id FROM room_types WHERE property_id=$1 AND name=$2', [propertyId, roomName])).rows[0].id;
    await db.query(`INSERT INTO room_images (room_type_id,image_path,sort_order) SELECT $1,$2,0
      WHERE NOT EXISTS (SELECT 1 FROM room_images WHERE room_type_id=$1 AND sort_order=0)`, [roomId, roomImage]);
  }
  const mayProperty = await db.query("SELECT id FROM properties WHERE slug='may-homestay'");
  const gardenRoom = await db.query(`INSERT INTO room_types (property_id,cancellation_policy_id,name,max_adults,total_units,base_price_vnd,is_active)
    VALUES ($1,1,'Phòng Garden View có ban công',2,2,1050000,true)
    ON CONFLICT (property_id,name) DO UPDATE SET base_price_vnd=EXCLUDED.base_price_vnd RETURNING id`,
    [mayProperty.rows[0].id]);
  await db.query(`INSERT INTO room_images (room_type_id,image_path,sort_order)
    SELECT $1,'room_garden_049.jpg',0 WHERE NOT EXISTS
      (SELECT 1 FROM room_images WHERE room_type_id=$1 AND sort_order=0)`,
    [gardenRoom.rows[0].id]);
  for (const amenity of ['Wi-Fi', 'Bếp riêng', 'Điều hòa', 'Sân vườn', 'Ven sông']) {
    await db.query('INSERT INTO amenities (name) VALUES ($1) ON CONFLICT (name) DO NOTHING', [amenity]);
  }
  for (const [slug, names] of [
    ['may-homestay', ['Wi-Fi', 'Bếp riêng', 'Điều hòa']],
    ['an-villa', ['Wi-Fi', 'Sân vườn', 'Điều hòa']],
    ['riverside-home', ['Wi-Fi', 'Bếp riêng', 'Ven sông']],
    ['pine-hill-homestay', ['Wi-Fi', 'Sân vườn', 'Điều hòa']],
    ['dalat-palace-hotel', ['Wi-Fi', 'Điều hòa']],
  ]) {
    for (const name of names) {
      await db.query(`INSERT INTO property_amenities (property_id,amenity_id)
        SELECT p.id,a.id FROM properties p,amenities a WHERE p.slug=$1 AND a.name=$2
        ON CONFLICT DO NOTHING`, [slug, name]);
    }
  }
  await db.query(`INSERT INTO promotions (code,title,discount_type,discount_value,max_discount_vnd,min_order_vnd,starts_at,ends_at,usage_limit)
    VALUES ('STAY100','Giảm 100.000đ theo màn hình StayNest','FIXED',100000,NULL,1000000,now()-interval '1 day',now()+interval '1 year',100)
    ON CONFLICT (code) DO NOTHING`);

  if (process.env.SEED_DEMO_PASSWORD) {
    await db.query(`INSERT INTO users (full_name,email,phone,password_hash,nationality)
      VALUES ('Nguyễn An','an.demo@example.com','0900000123',$1,'Việt Nam')
      ON CONFLICT (email) DO NOTHING`, [hashPassword(process.env.SEED_DEMO_PASSWORD)]);
  }
}

if (process.argv[1] && fileURLToPath(import.meta.url) === resolve(process.argv[1])) {
  if (config.isProduction) {
    process.stderr.write('Error: Demo seed is strictly prohibited in production.\n');
    process.exit(1);
  }
  if (!config.allowDemoSeed) {
    process.stderr.write(
      'Error: Demo seed requires explicit confirmation. Set ALLOW_DEMO_SEED=1 to run.\n',
    );
    process.exit(1);
  }
  await withTransaction(seedCatalog);
  await pool.end();
  process.stdout.write('StayNest demo catalog seed complete.\n');
}
