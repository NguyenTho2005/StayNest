import { Router } from 'express';
import { authenticated } from './auth.js';
import { requireDatabase } from './db.js';
import { fail, route } from './http.js';

export const favoritesRouter = Router();

favoritesRouter.get('/me/favorites', authenticated, route(async (request, response) => {
  const db = await requireDatabase();
  const result = await db.query(`SELECT p.id,p.slug,p.name,p.property_type,p.address,f.created_at,
    (SELECT image_path FROM property_images WHERE property_id=p.id ORDER BY sort_order,id LIMIT 1) AS image_path,
    (SELECT min(base_price_vnd) FROM room_types WHERE property_id=p.id AND is_active) AS min_price_vnd,
    (SELECT round(avg(rating)::numeric,1) FROM reviews WHERE property_id=p.id) AS rating,
    (SELECT count(*)::int FROM reviews WHERE property_id=p.id) AS review_count
    FROM favorites f JOIN properties p ON p.id=f.property_id
    WHERE f.user_id=$1 ORDER BY f.created_at DESC`, [request.user.id]);
  response.json({ items: result.rows });
}));

favoritesRouter.put('/me/favorites/:slug', authenticated, route(async (request, response) => {
  const db = await requireDatabase();
  const result = await db.query(`INSERT INTO favorites (user_id,property_id)
    SELECT $1,id FROM properties WHERE slug=$2 AND is_published
    ON CONFLICT DO NOTHING RETURNING property_id`, [request.user.id, request.params.slug]);
  if (!result.rowCount) {
    const existing = await db.query('SELECT id FROM properties WHERE slug=$1 AND is_published', [request.params.slug]);
    if (!existing.rowCount) throw fail(404, 'PROPERTY_NOT_FOUND', 'Property not found');
  }
  response.status(204).end();
}));

favoritesRouter.delete('/me/favorites/:slug', authenticated, route(async (request, response) => {
  const db = await requireDatabase();
  await db.query(`DELETE FROM favorites WHERE user_id=$1
    AND property_id=(SELECT id FROM properties WHERE slug=$2)`, [request.user.id, request.params.slug]);
  response.status(204).end();
}));
