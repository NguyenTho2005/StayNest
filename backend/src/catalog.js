import { Router } from 'express';
import { requireDatabase } from './db.js';
import { fail, route } from './http.js';
import { nightsBetween } from './pricing.js';

export const catalogRouter = Router();

catalogRouter.get('/destinations', route(async (_request, response) => {
  const db = await requireDatabase();
  const result = await db.query('SELECT id,slug,name,province,description,image_path FROM destinations ORDER BY id');
  response.json({ items: result.rows });
}));

catalogRouter.get('/properties', route(async (request, response) => {
  const db = await requireDatabase();
  const values = [];
  const clauses = ['p.is_published'];
  const add = (value) => { values.push(value); return `$${values.length}`; };
  if (request.query.destination) clauses.push(`d.slug=${add(String(request.query.destination))}`);
  if (request.query.type) clauses.push(`p.property_type=${add(String(request.query.type).toUpperCase())}`);
  if (request.query.q) clauses.push(`p.name ILIKE ${add(`%${String(request.query.q).slice(0, 80)}%`)}`);
  if (request.query.minPrice) {
    const amount = Number(request.query.minPrice);
    if (!Number.isSafeInteger(amount) || amount < 0) throw fail(400, 'INVALID_FILTER', 'Invalid minPrice');
    clauses.push(`r.base_price_vnd>=${add(amount)}`);
  }
  if (request.query.maxPrice) {
    const amount = Number(request.query.maxPrice);
    if (!Number.isSafeInteger(amount) || amount < 0) throw fail(400, 'INVALID_FILTER', 'Invalid maxPrice');
    clauses.push(`r.base_price_vnd<=${add(amount)}`);
  }
  if (request.query.amenity) {
    clauses.push(`EXISTS (SELECT 1 FROM property_amenities pa JOIN amenities a ON a.id=pa.amenity_id
      WHERE pa.property_id=p.id AND a.name=${add(String(request.query.amenity))})`);
  }
  if (request.query.checkIn || request.query.checkOut) {
    nightsBetween(request.query.checkIn, request.query.checkOut);
    const inParam = add(request.query.checkIn);
    const outParam = add(request.query.checkOut);
    clauses.push(`r.total_units > (SELECT COALESCE(SUM(b.room_count),0) FROM bookings b
      WHERE b.room_type_id=r.id AND (b.status IN ('CONFIRMED_DEMO','COMPLETED') OR (b.status='PENDING_PAYMENT' AND b.hold_expires_at>now()))
      AND b.check_in_date < ${outParam}::date AND b.check_out_date > ${inParam}::date)`);
  }
  if (request.query.adults) {
    const adults = Number(request.query.adults);
    if (!Number.isInteger(adults) || adults < 1 || adults > 30) throw fail(400, 'INVALID_FILTER', 'Invalid adults');
    clauses.push(`r.max_adults>=${add(adults)}`);
  }
  const sort = String(request.query.sort || 'price_asc');
  if (!['price_asc', 'price_desc', 'rating_desc'].includes(sort)) {
    throw fail(400, 'INVALID_FILTER', 'Unsupported sort order');
  }
  const order = sort === 'rating_desc' ? 'rating DESC NULLS LAST,min_price_vnd ASC'
    : sort === 'price_desc' ? 'min_price_vnd DESC' : 'min_price_vnd ASC';
  const limit = Math.min(Math.max(Number(request.query.limit) || 20, 1), 50);
  values.push(limit);
  const result = await db.query(`SELECT p.id,p.slug,p.name,p.property_type,p.description,p.address,d.name AS destination,
      min(r.base_price_vnd)::bigint AS min_price_vnd,
      (SELECT image_path FROM property_images WHERE property_id=p.id ORDER BY sort_order,id LIMIT 1) AS image_path,
      (SELECT array_agg(a.name ORDER BY a.name) FROM property_amenities pa JOIN amenities a ON a.id=pa.amenity_id WHERE pa.property_id=p.id) AS amenities,
      (SELECT round(avg(rating)::numeric,1) FROM reviews WHERE property_id=p.id) AS rating
    FROM properties p JOIN destinations d ON d.id=p.destination_id
    JOIN room_types r ON r.property_id=p.id AND r.is_active
    WHERE ${clauses.join(' AND ')}
    GROUP BY p.id,d.name ORDER BY ${order},p.id LIMIT $${values.length}`, values);
  response.json({ items: result.rows });
}));

async function propertyBySlug(db, slug) {
  const found = await db.query(`SELECT p.*,d.slug AS destination_slug,d.name AS destination_name
    FROM properties p JOIN destinations d ON d.id=p.destination_id
    WHERE p.slug=$1 AND p.is_published`, [slug]);
  if (!found.rowCount) throw fail(404, 'PROPERTY_NOT_FOUND', 'Property not found');
  return found.rows[0];
}

function normalizeRoom(r) {
  if (!r) return r;
  return {
    ...r,
    id: Number(r.id),
    property_id: Number(r.property_id),
    max_adults: Number(r.max_adults),
    max_children: Number(r.max_children ?? 0),
    total_units: Number(r.total_units),
    base_price_vnd: Number(r.base_price_vnd),
  };
}

catalogRouter.get('/properties/:slug', route(async (request, response) => {
  const db = await requireDatabase();
  const property = await propertyBySlug(db, request.params.slug);
  const [images, amenities, rooms, reviews] = await Promise.all([
    db.query('SELECT image_path,alt_text FROM property_images WHERE property_id=$1 ORDER BY sort_order,id', [property.id]),
    db.query(`SELECT a.name,a.icon_name FROM property_amenities pa JOIN amenities a ON a.id=pa.amenity_id WHERE pa.property_id=$1 ORDER BY a.name`, [property.id]),
    db.query(`SELECT r.id,r.name,r.description,r.max_adults,r.max_children,r.total_units,r.base_price_vnd,r.bed_description,r.view_description,
      c.name AS cancellation_policy FROM room_types r LEFT JOIN cancellation_policies c ON c.id=r.cancellation_policy_id
      WHERE r.property_id=$1 AND r.is_active ORDER BY r.base_price_vnd`, [property.id]),
    db.query('SELECT count(*)::int AS count,round(avg(rating)::numeric,1) AS average FROM reviews WHERE property_id=$1', [property.id]),
  ]);
  response.json({
    ...property,
    id: Number(property.id),
    destination_id: Number(property.destination_id),
    images: images.rows,
    amenities: amenities.rows,
    rooms: rooms.rows.map(normalizeRoom),
    reviewSummary: reviews.rows[0],
  });
}));

catalogRouter.get('/properties/:slug/rooms', route(async (request, response) => {
  const db = await requireDatabase();
  const property = await propertyBySlug(db, request.params.slug);
  const rooms = await db.query(`SELECT r.*,c.name AS cancellation_policy_name,c.description AS cancellation_policy_description
    FROM room_types r LEFT JOIN cancellation_policies c ON c.id=r.cancellation_policy_id
    WHERE r.property_id=$1 AND r.is_active ORDER BY r.base_price_vnd`, [property.id]);
  const items = await Promise.all(rooms.rows.map(async (room) => {
    const [images, amenities] = await Promise.all([
      db.query('SELECT image_path FROM room_images WHERE room_type_id=$1 ORDER BY sort_order,id', [room.id]),
      db.query(`SELECT a.name FROM room_amenities ra JOIN amenities a ON a.id=ra.amenity_id WHERE ra.room_type_id=$1 ORDER BY a.name`, [room.id]),
    ]);
    return normalizeRoom({ ...room, images: images.rows, amenities: amenities.rows });
  }));
  response.json({ items });
}));

catalogRouter.get('/properties/:slug/reviews', route(async (request, response) => {
  const db = await requireDatabase();
  const property = await propertyBySlug(db, request.params.slug);
  const result = await db.query(`SELECT r.id,r.rating,r.comment,r.created_at,u.full_name
    FROM reviews r JOIN users u ON u.id=r.user_id WHERE r.property_id=$1 ORDER BY r.created_at DESC LIMIT 50`, [property.id]);
  response.json({ items: result.rows });
}));

catalogRouter.get('/vouchers', route(async (_request, response) => {
  const db = await requireDatabase();
  const result = await db.query(`SELECT code,title,discount_type,discount_value,max_discount_vnd,min_order_vnd,ends_at
    FROM promotions WHERE is_active AND starts_at<=now() AND ends_at>now() ORDER BY ends_at`);
  response.json({ items: result.rows });
}));
