import { fail, positiveInt } from './http.js';

export function nightsBetween(checkIn, checkOut, today = new Date()) {
  const parse = (value) => {
    if (typeof value !== 'string' || !/^\d{4}-\d{2}-\d{2}$/.test(value)) {
      throw fail(400, 'INVALID_DATES', 'Dates must use YYYY-MM-DD');
    }
    const date = new Date(`${value}T00:00:00Z`);
    if (Number.isNaN(date.getTime()) || date.toISOString().slice(0, 10) !== value) {
      throw fail(400, 'INVALID_DATES', 'Invalid calendar date');
    }
    return date;
  };
  const start = parse(checkIn);
  const end = parse(checkOut);
  const current = Date.UTC(today.getUTCFullYear(), today.getUTCMonth(), today.getUTCDate());
  const count = (end - start) / 86400000;
  if (start.getTime() < current || count < 1 || count > 30) {
    throw fail(422, 'INVALID_STAY', 'Stay must start today or later and last 1–30 nights');
  }
  return count;
}

export function validateGuests(room, adults, children, roomCount) {
  positiveInt(adults, 'adults', 30);
  positiveInt(roomCount, 'roomCount', 10);
  if (!Number.isInteger(children) || children < 0 || children > 30) {
    throw fail(400, 'INVALID_INPUT', 'children must be an integer from 0 to 30');
  }
  if (adults > Number(room.max_adults) * roomCount || children > Number(room.max_children) * roomCount) {
    throw fail(422, 'CAPACITY_EXCEEDED', 'Guest count exceeds room capacity');
  }
}

export function discountFor(promotion, subtotal, at = new Date()) {
  if (!promotion) return 0;
  if (!promotion.is_active || new Date(promotion.starts_at) > at || new Date(promotion.ends_at) < at ||
      subtotal < Number(promotion.min_order_vnd) ||
      (promotion.usage_limit != null && Number(promotion.used_count) >= Number(promotion.usage_limit))) {
    throw fail(422, 'PROMOTION_INVALID', 'Promotion is unavailable for this booking');
  }
  const raw = promotion.discount_type === 'PERCENT'
    ? Math.floor(subtotal * Number(promotion.discount_value) / 100)
    : Number(promotion.discount_value);
  return Math.min(raw, Number(promotion.max_discount_vnd ?? raw), subtotal);
}

export function calculateQuote({ room, checkIn, checkOut, adults, children = 0, roomCount = 1, promotion = null, today = new Date() }) {
  const nights = nightsBetween(checkIn, checkOut, today);
  validateGuests(room, adults, children, roomCount);
  const nightlyPriceVnd = Number(room.base_price_vnd);
  if (!Number.isSafeInteger(nightlyPriceVnd) || nightlyPriceVnd < 0) {
    throw fail(500, 'PRICE_INVALID', 'Room price cannot be calculated');
  }
  const roomSubtotalVnd = nightlyPriceVnd * nights * roomCount;
  const taxVnd = Math.round(roomSubtotalVnd * 0.10);
  const serviceFeeVnd = 30000;
  const discountVnd = discountFor(promotion, roomSubtotalVnd, today);
  const totalVnd = roomSubtotalVnd + taxVnd + serviceFeeVnd - discountVnd;
  if (![roomSubtotalVnd, taxVnd, totalVnd].every(Number.isSafeInteger)) {
    throw fail(500, 'PRICE_INVALID', 'Calculated amount exceeds safe VND range');
  }
  return { nights, nightlyPriceVnd, roomSubtotalVnd, taxVnd, serviceFeeVnd, discountVnd, totalVnd, currency: 'VND' };
}
