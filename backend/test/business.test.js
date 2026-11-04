import assert from 'node:assert/strict';
import test from 'node:test';
import { calculateQuote, nightsBetween } from '../src/pricing.js';
import { refundAmount } from '../src/bookings.js';
import { passwordHash, passwordMatches } from '../src/auth.js';

const room = { base_price_vnd: 850000, max_adults: 2, max_children: 1 };
const promotion = {
  discount_type: 'FIXED', discount_value: 100000, min_order_vnd: 1000000,
  max_discount_vnd: null, usage_limit: 100, used_count: 0, is_active: true,
  starts_at: '2026-01-01T00:00:00Z', ends_at: '2027-01-01T00:00:00Z',
};
const today = new Date('2026-11-04T10:00:00Z');

test('Figma two-night quote uses integer VND and policy fee', () => {
  const quote = calculateQuote({ room, promotion, checkIn: '2026-11-14', checkOut: '2026-11-16', adults: 2, today });
  assert.deepEqual(quote, {
    nights: 2, nightlyPriceVnd: 850000, roomSubtotalVnd: 1700000,
    taxVnd: 170000, serviceFeeVnd: 30000, discountVnd: 100000,
    totalVnd: 1800000, currency: 'VND',
  });
});

test('rejects invalid dates and guest capacity', () => {
  assert.throws(() => nightsBetween('2026-02-30', '2026-03-02', today), { code: 'INVALID_DATES' });
  assert.throws(() => calculateQuote({ room, checkIn: '2026-11-16', checkOut: '2026-11-14', adults: 2, today }), { code: 'INVALID_STAY' });
  assert.throws(() => calculateQuote({ room, checkIn: '2026-11-14', checkOut: '2026-11-16', adults: 3, today }), { code: 'CAPACITY_EXCEEDED' });
});

test('promotion validity and usage limit are enforced', () => {
  assert.throws(() => calculateQuote({ room, promotion: { ...promotion, used_count: 100 }, checkIn: '2026-11-14', checkOut: '2026-11-16', adults: 2, today }), { code: 'PROMOTION_INVALID' });
});

test('demo refund follows the booking policy snapshot', () => {
  const booking = { check_in_date: '2026-11-14', total_vnd: 1800000,
    cancellation_policy_snapshot: { freeBeforeHours: 48, partialRefundPercent: 50 } };
  assert.equal(refundAmount(booking, new Date('2026-11-10T00:00:00Z')), 1800000);
  assert.equal(refundAmount(booking, new Date('2026-11-13T12:00:00Z')), 900000);
  assert.equal(refundAmount(booking, new Date('2026-11-15T00:00:00Z')), 0);
  assert.equal(refundAmount(booking, new Date('2026-11-12T06:59:00Z')), 1800000);
  assert.equal(refundAmount(booking, new Date('2026-11-12T07:01:00Z')), 900000);
});

test('passwords are salted and checked without storing plaintext', () => {
  const first = passwordHash('good-password-123');
  const second = passwordHash('good-password-123');
  assert.notEqual(first, second);
  assert.equal(passwordMatches('good-password-123', first), true);
  assert.equal(passwordMatches('wrong-password', first), false);
});
