import { createHash, randomBytes } from 'node:crypto';
import { Router } from 'express';
import { authenticated } from './auth.js';
import { requireDatabase, withTransaction } from './db.js';
import { fail, positiveInt, requireText, route } from './http.js';
import { calculateQuote, nightsBetween } from './pricing.js';

export const bookingRouter = Router();

async function roomFor(db, id, lock = false) {
  const result = await db.query(`SELECT r.*,p.id AS property_id,p.name AS property_name,p.slug AS property_slug,
    c.name AS policy_name,c.free_before_hours,c.partial_refund_percent,c.description AS policy_description,
    p.check_in_time
    FROM room_types r JOIN properties p ON p.id=r.property_id
    LEFT JOIN cancellation_policies c ON c.id=r.cancellation_policy_id
    WHERE r.id=$1 AND r.is_active AND p.is_published ${lock ? 'FOR UPDATE OF r' : ''}`, [id]);
  if (!result.rowCount) throw fail(404, 'ROOM_NOT_FOUND', 'Room not found');
  return result.rows[0];
}

async function promotionFor(db, code, lock = false) {
  if (!code) return null;
  const result = await db.query(`SELECT p.* FROM promotions p WHERE p.code=$1 ${lock ? 'FOR UPDATE OF p' : ''}`,
    [String(code).toUpperCase()]);
  if (!result.rowCount) throw fail(422, 'PROMOTION_INVALID', 'Promotion not found');
  // Run the count after the promotion lock so a concurrent booking is visible.
  const usage = await db.query(`SELECT count(*)::int AS used_count FROM bookings b WHERE b.promotion_id=$1
    AND (b.status IN ('CONFIRMED_DEMO','COMPLETED')
      OR (b.status='PENDING_PAYMENT' AND b.hold_expires_at>now()))`, [result.rows[0].id]);
  return { ...result.rows[0], used_count: usage.rows[0].used_count };
}

async function occupiedUnits(db, roomId, checkIn, checkOut) {
  const result = await db.query(`SELECT COALESCE(sum(room_count),0)::int AS occupied FROM bookings
    WHERE room_type_id=$1 AND check_in_date<$3::date AND check_out_date>$2::date
    AND (status IN ('CONFIRMED_DEMO','COMPLETED') OR (status='PENDING_PAYMENT' AND hold_expires_at>now()))`,
  [roomId, checkIn, checkOut]);
  return result.rows[0].occupied;
}

async function ownedBooking(db, id, userId, lock = false) {
  if (!/^\d+$/.test(String(id))) throw fail(404, 'BOOKING_NOT_FOUND', 'Booking not found');
  const found = await db.query(`SELECT b.*,r.name AS room_name,p.name AS property_name,p.slug AS property_slug
    FROM bookings b JOIN room_types r ON r.id=b.room_type_id JOIN properties p ON p.id=r.property_id
    WHERE b.id=$1 AND b.user_id=$2 ${lock ? 'FOR UPDATE OF b' : ''}`, [id, userId]);
  if (!found.rowCount) throw fail(404, 'BOOKING_NOT_FOUND', 'Booking not found');
  return found.rows[0];
}

async function quoteFromBody(db, body, lock = false) {
  const roomTypeId = positiveInt(body?.roomTypeId, 'roomTypeId', 2147483647);
  const room = await roomFor(db, roomTypeId, lock);
  const promotion = await promotionFor(db, body.promotionCode, lock);
  const quote = calculateQuote({
    room,
    promotion,
    checkIn: body.checkIn,
    checkOut: body.checkOut,
    adults: body.adults,
    children: body.children ?? 0,
    roomCount: body.roomCount ?? 1,
  });
  const occupied = await occupiedUnits(db, room.id, body.checkIn, body.checkOut);
  return { room, promotion, quote, availableUnits: Number(room.total_units) - occupied };
}

bookingRouter.post('/booking-quotes', route(async (request, response) => {
  const db = await requireDatabase();
  const { room, quote, availableUnits } = await quoteFromBody(db, request.body);
  response.json({ roomTypeId: room.id, availableUnits, ...quote });
}));

bookingRouter.post('/vouchers/validate', route(async (request, response) => {
  const db = await requireDatabase();
  const { promotion, quote } = await quoteFromBody(db, request.body);
  if (!promotion) throw fail(400, 'INVALID_INPUT', 'promotionCode is required');
  response.json({ code: promotion.code, discountVnd: quote.discountVnd, totalVnd: quote.totalVnd });
}));

bookingRouter.post('/bookings', authenticated, route(async (request, response) => {
  const key = requireText(request.get('Idempotency-Key'), 'Idempotency-Key', 120);
  const requestHash = createHash('sha256').update(JSON.stringify(request.body ?? {})).digest('hex');
  const guestName = requireText(request.body?.guestName, 'guestName', 150);
  const guestEmail = requireText(request.body?.guestEmail, 'guestEmail');
  const guestPhone = requireText(request.body?.guestPhone, 'guestPhone', 25);
  const result = await withTransaction(async (db) => {
    const existing = await db.query(`SELECT b.*,i.request_hash FROM booking_idempotency i JOIN bookings b ON b.id=i.booking_id
      WHERE i.user_id=$1 AND i.idempotency_key=$2`, [request.user.id, key]);
    if (existing.rowCount) {
      if (existing.rows[0].request_hash !== requestHash) throw fail(409, 'IDEMPOTENCY_CONFLICT', 'Key was already used with different details');
      const { request_hash: _hash, ...booking } = existing.rows[0];
      return booking;
    }
    const { room, promotion, quote, availableUnits } = await quoteFromBody(db, request.body, true);
    const afterLock = await db.query(`SELECT b.*,i.request_hash FROM booking_idempotency i JOIN bookings b ON b.id=i.booking_id
      WHERE i.user_id=$1 AND i.idempotency_key=$2`, [request.user.id, key]);
    if (afterLock.rowCount) {
      if (afterLock.rows[0].request_hash !== requestHash) throw fail(409, 'IDEMPOTENCY_CONFLICT', 'Key was already used with different details');
      const { request_hash: _hash, ...booking } = afterLock.rows[0];
      return booking;
    }
    const roomCount = request.body.roomCount ?? 1;
    if (availableUnits < roomCount) throw fail(409, 'NO_AVAILABILITY', 'Requested rooms are no longer available');
    const policy = { name: room.policy_name, freeBeforeHours: room.free_before_hours ?? 0,
      partialRefundPercent: room.partial_refund_percent ?? 0, description: room.policy_description,
      checkInTime: room.check_in_time ?? '14:00:00', utcOffset: '+07:00' };
    const code = `SN-${randomBytes(5).toString('hex').toUpperCase()}`;
    const saved = await db.query(`INSERT INTO bookings (booking_code,user_id,room_type_id,promotion_id,check_in_date,check_out_date,
      adults,children,room_count,guest_name,guest_email,guest_phone,arrival_window,special_request,
      nightly_price_vnd,room_subtotal_vnd,tax_vnd,service_fee_vnd,discount_vnd,total_vnd,
      price_snapshot,cancellation_policy_snapshot,hold_expires_at)
      VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,now()+interval '15 minutes')
      RETURNING *`, [code, request.user.id, room.id, promotion?.id ?? null, request.body.checkIn, request.body.checkOut,
      request.body.adults, request.body.children ?? 0, roomCount, guestName, guestEmail, guestPhone,
      request.body.arrivalWindow ?? null, request.body.specialRequest ?? null,
      quote.nightlyPriceVnd, quote.roomSubtotalVnd, quote.taxVnd, quote.serviceFeeVnd,
      quote.discountVnd, quote.totalVnd, JSON.stringify(quote), JSON.stringify(policy)]);
    await db.query('INSERT INTO booking_idempotency (user_id,idempotency_key,request_hash,booking_id) VALUES ($1,$2,$3,$4)',
      [request.user.id, key, requestHash, saved.rows[0].id]);
    return saved.rows[0];
  });
  response.status(201).json(result);
}));

bookingRouter.get('/me/bookings', authenticated, route(async (request, response) => {
  const db = await requireDatabase();
  const values = [request.user.id];
  let clause = '';
  if (request.query.status) {
    values.push(String(request.query.status));
    clause = 'AND b.status=$2';
  }
  const result = await db.query(`SELECT b.id,b.booking_code,b.status,b.check_in_date,b.check_out_date,b.total_vnd,
    b.created_at,p.name AS property_name,p.slug AS property_slug,r.name AS room_name,
    (SELECT image_path FROM property_images WHERE property_id=p.id ORDER BY sort_order,id LIMIT 1) AS image_path
    FROM bookings b JOIN room_types r ON r.id=b.room_type_id JOIN properties p ON p.id=r.property_id
    WHERE b.user_id=$1 ${clause} ORDER BY b.created_at DESC LIMIT 100`, values);
  response.json({ items: result.rows });
}));

bookingRouter.get('/bookings/:id', authenticated, route(async (request, response) => {
  const db = await requireDatabase();
  response.json(await ownedBooking(db, request.params.id, request.user.id));
}));

bookingRouter.post('/bookings/:id/demo-payment', authenticated, route(async (request, response) => {
  const method = request.body?.method;
  if (!['EWALLET','DOMESTIC_CARD','INTERNATIONAL_CARD'].includes(method) ||
      ['cardNumber','cvv','pan','expiry'].some((key) => key in (request.body ?? {}))) {
    throw fail(400, 'INVALID_DEMO_PAYMENT', 'Send only a demo payment method; card data is not accepted');
  }
  const result = await withTransaction(async (db) => {
    const booking = await ownedBooking(db, request.params.id, request.user.id, true);
    if (booking.status !== 'PENDING_PAYMENT' || new Date(booking.hold_expires_at) <= new Date()) {
      throw fail(409, 'BOOKING_NOT_PAYABLE', 'Booking hold has expired or is no longer payable');
    }
    const ref = `DEMO-${randomBytes(6).toString('hex').toUpperCase()}`;
    const receipt = { label: 'Thanh toán mô phỏng', bookingCode: booking.booking_code, amountVnd: Number(booking.total_vnd), currency: 'VND', demo: true };
    const payment = await db.query(`INSERT INTO demo_payments (booking_id,method,status,amount_vnd,demo_reference,receipt)
      VALUES ($1,$2,'SUCCEEDED',$3,$4,$5) RETURNING *`, [booking.id, method, booking.total_vnd, ref, JSON.stringify(receipt)]);
    await db.query(`UPDATE bookings SET status='CONFIRMED_DEMO',confirmed_at=now(),hold_expires_at=NULL WHERE id=$1`, [booking.id]);
    return payment.rows[0];
  });
  response.status(201).json({ ...result, demo: true });
}));

bookingRouter.get('/bookings/:id/receipt', authenticated, route(async (request, response) => {
  const db = await requireDatabase();
  const booking = await ownedBooking(db, request.params.id, request.user.id);
  const payment = await db.query('SELECT demo_reference,method,status,amount_vnd,receipt,created_at FROM demo_payments WHERE booking_id=$1 ORDER BY id DESC LIMIT 1', [booking.id]);
  if (!payment.rowCount) throw fail(404, 'RECEIPT_NOT_FOUND', 'Demo receipt not found');
  response.json({ bookingCode: booking.booking_code, payment: payment.rows[0], demo: true });
}));

bookingRouter.post('/bookings/:id/change-date-requests', authenticated, route(async (request, response) => {
  nightsBetween(request.body?.newCheckIn, request.body?.newCheckOut);
  const result = await withTransaction(async (db) => {
    const booking = await ownedBooking(db, request.params.id, request.user.id, true);
    if (booking.status !== 'CONFIRMED_DEMO') throw fail(409, 'CHANGE_NOT_ALLOWED', 'Only confirmed demo stays can request a date change');
    const saved = await db.query(`INSERT INTO date_change_requests (booking_id,new_check_in,new_check_out)
      VALUES ($1,$2,$3) RETURNING *`, [booking.id, request.body.newCheckIn, request.body.newCheckOut]);
    return saved.rows[0];
  });
  response.status(201).json({ ...result, note: 'Request pending; original booking dates remain unchanged' });
}));

export function refundAmount(booking, now = new Date()) {
  const policy = booking.cancellation_policy_snapshot;
  const date = booking.check_in_date instanceof Date
    ? booking.check_in_date.toISOString().slice(0, 10) : booking.check_in_date;
  const checkIn = new Date(`${date}T${policy.checkInTime ?? '14:00:00'}${policy.utcOffset ?? '+07:00'}`);
  const hours = (checkIn - now) / 3600000;
  if (hours >= Number(policy.freeBeforeHours)) return Number(booking.total_vnd);
  if (hours > 0) return Math.floor(Number(booking.total_vnd) * Number(policy.partialRefundPercent) / 100);
  return 0;
}

bookingRouter.get('/bookings/:id/cancellation-preview', authenticated, route(async (request, response) => {
  const db = await requireDatabase();
  const booking = await ownedBooking(db, request.params.id, request.user.id);
  if (!['PENDING_PAYMENT','CONFIRMED_DEMO'].includes(booking.status)) throw fail(409, 'CANCELLATION_NOT_ALLOWED', 'Booking cannot be cancelled');
  const paid = booking.status === 'CONFIRMED_DEMO';
  response.json({ bookingId: booking.id, estimatedRefundVnd: paid ? refundAmount(booking) : 0,
    policy: booking.cancellation_policy_snapshot, demoRefund: paid });
}));

bookingRouter.post('/bookings/:id/cancellations', authenticated, route(async (request, response) => {
  const reason = requireText(request.body?.reason, 'reason', 255);
  const result = await withTransaction(async (db) => {
    const booking = await ownedBooking(db, request.params.id, request.user.id, true);
    if (!['PENDING_PAYMENT','CONFIRMED_DEMO'].includes(booking.status)) throw fail(409, 'CANCELLATION_NOT_ALLOWED', 'Booking cannot be cancelled');
    const paid = booking.status === 'CONFIRMED_DEMO';
    const amount = paid ? refundAmount(booking) : 0;
    const cancellation = await db.query(`INSERT INTO cancellation_requests (booking_id,reason,note,estimated_refund_vnd)
      VALUES ($1,$2,$3,$4) RETURNING *`, [booking.id, reason, request.body.note ?? null, amount]);
    await db.query(`UPDATE bookings SET status='CANCELLED',cancelled_at=now(),hold_expires_at=NULL WHERE id=$1`, [booking.id]);
    let refund = null;
    if (paid && amount > 0) {
      const ref = `RF-DEMO-${randomBytes(5).toString('hex').toUpperCase()}`;
      refund = (await db.query(`INSERT INTO demo_refunds (cancellation_request_id,demo_refund_code,amount_vnd)
        VALUES ($1,$2,$3) RETURNING *`, [cancellation.rows[0].id, ref, amount])).rows[0];
    }
    return { cancellation: cancellation.rows[0], refund, demo: true };
  });
  response.status(201).json(result);
}));

bookingRouter.get('/bookings/:id/refund', authenticated, route(async (request, response) => {
  const db = await requireDatabase();
  const booking = await ownedBooking(db, request.params.id, request.user.id);
  const result = await db.query(`SELECT r.* FROM demo_refunds r JOIN cancellation_requests c ON c.id=r.cancellation_request_id
    WHERE c.booking_id=$1`, [booking.id]);
  response.json({ refund: result.rows[0] ?? null, demo: true });
}));

bookingRouter.post('/bookings/:id/reviews', authenticated, route(async (request, response) => {
  const rating = positiveInt(request.body?.rating, 'rating', 5);
  const comment = requireText(request.body?.comment, 'comment', 2000);
  const result = await withTransaction(async (db) => {
    const booking = await ownedBooking(db, request.params.id, request.user.id, true);
    const checkout = booking.check_out_date instanceof Date
      ? booking.check_out_date
      : new Date(`${booking.check_out_date}T00:00:00Z`);
    if (!['CONFIRMED_DEMO','COMPLETED'].includes(booking.status) || checkout > new Date()) {
      throw fail(409, 'REVIEW_NOT_ALLOWED', 'Review is only available after a completed stay');
    }
    const property = await db.query('SELECT property_id FROM room_types WHERE id=$1', [booking.room_type_id]);
    const saved = await db.query(`INSERT INTO reviews (booking_id,user_id,property_id,rating,comment)
      VALUES ($1,$2,$3,$4,$5) RETURNING *`, [booking.id, request.user.id, property.rows[0].property_id, rating, comment]);
    await db.query(`UPDATE bookings SET status='COMPLETED' WHERE id=$1`, [booking.id]);
    return saved.rows[0];
  });
  response.status(201).json(result);
}));
