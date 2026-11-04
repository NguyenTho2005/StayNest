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

test('HTTP booking inventory, ownership and demo payment lifecycle', { timeout: 45000 }, async () => {
  const port = await freePort();
  const server = spawn(process.execPath, ['src/server.js'], {
    cwd: new URL('..', import.meta.url),
    env: { ...process.env, DATABASE_URL: '', STAYNEST_EMBEDDED_DEMO: '1', PORT: String(port), HOST: '127.0.0.1', SEED_DEMO_PASSWORD: '' },
    stdio: 'pipe',
  });
  const base = `http://127.0.0.1:${port}/api/v1`;
  async function call(path, { method = 'GET', body, token, key } = {}) {
    const response = await fetch(base + path, {
      method,
      headers: {
        'Content-Type': 'application/json',
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
        ...(key ? { 'Idempotency-Key': key } : {}),
      },
      body: body ? JSON.stringify(body) : undefined,
    });
    return { status: response.status, data: await response.json() };
  }
  try {
    let ready = false;
    for (let attempt = 0; attempt < 100; attempt += 1) {
      if (server.exitCode !== null) throw new Error('Embedded demo server exited during startup');
      try { ready = (await call('/health/ready')).status === 200; } catch { /* booting */ }
      if (ready) break;
      await new Promise((resolve) => setTimeout(resolve, 100));
    }
    assert.equal(ready, true, 'embedded demo server did not start');
    const property = await call('/properties/may-homestay');
    assert.equal(property.status, 200);
    const filtered = await call('/properties?destination=hoi-an&type=HOMESTAY&minPrice=1000000&sort=price_desc');
    assert.equal(filtered.status, 200);
    assert.deepEqual(filtered.data.items.map((item) => item.slug), ['riverside-home', 'may-homestay']);
    const invalidSort = await call('/properties?sort=distance');
    assert.equal(invalidSort.status, 400);
    const roomTypeId = property.data.rooms[0].id;
    const user = await call('/auth/register', { method: 'POST', body: {
      fullName: 'Test Guest', email: 'guest@example.com', phone: '0900000001', password: 'test-password-123',
    } });
    const other = await call('/auth/register', { method: 'POST', body: {
      fullName: 'Other Guest', email: 'other@example.com', phone: '0900000002', password: 'test-password-123',
    } });
    assert.equal(user.status, 201);
    assert.equal(other.status, 201);
    const date = new Date();
    date.setUTCDate(date.getUTCDate() + 20);
    const checkIn = date.toISOString().slice(0, 10);
    date.setUTCDate(date.getUTCDate() + 2);
    const checkOut = date.toISOString().slice(0, 10);
    const details = { roomTypeId, checkIn, checkOut, adults: 2, children: 0, roomCount: 1,
      promotionCode: 'STAY100', guestName: 'Test Guest', guestEmail: 'guest@example.com', guestPhone: '0900000001' };
    const quote = await call('/booking-quotes', { method: 'POST', body: details });
    assert.equal(quote.status, 200);
    assert.equal(quote.data.totalVnd, 1800000);
    const bookings = await Promise.all([1, 2, 3].map((n) => call('/bookings', {
      method: 'POST', body: details, token: user.data.token, key: `concurrent-${n}`,
    })));
    assert.deepEqual(bookings.map((result) => result.status).sort(), [201, 201, 409]);
    const available = await call(`/properties?destination=hoi-an&checkIn=${checkIn}&checkOut=${checkOut}&adults=2`);
    assert.equal(available.status, 200);
    assert.equal(available.data.items.some((item) => item.slug === 'may-homestay'), true,
      'Garden View remains available when Studio is fully booked');
    const gardenRoom = property.data.rooms.find((room) => room.name === 'Phòng Garden View có ban công');
    const gardenDetails = { ...details, roomTypeId: gardenRoom.id };
    const gardenQuote = await call('/booking-quotes', { method: 'POST', body: gardenDetails });
    assert.equal(gardenQuote.status, 200);
    assert.equal(gardenQuote.data.roomSubtotalVnd, 2100000);
    const gardenBooking = await call('/bookings', {
      method: 'POST', body: gardenDetails, token: user.data.token, key: 'garden-independent-inventory',
    });
    assert.equal(gardenBooking.status, 201);
    assert.equal(gardenBooking.data.room_type_id, gardenRoom.id);
    const id = bookings.find((result) => result.status === 201).data.id;
    assert.equal((await call(`/bookings/${id}`, { token: other.data.token })).status, 404);
    const paid = await call(`/bookings/${id}/demo-payment`, { method: 'POST', body: { method: 'EWALLET' }, token: user.data.token });
    assert.equal(paid.status, 201);
    assert.equal(paid.data.demo, true);
    assert.equal((await call(`/bookings/${id}/receipt`, { token: user.data.token })).status, 200);
    const cancelled = await call(`/bookings/${id}/cancellations`, { method: 'POST', body: { reason: 'Changed plan' }, token: user.data.token });
    assert.equal(cancelled.status, 201);
    assert.equal((await call(`/bookings/${id}/refund`, { token: user.data.token })).status, 200);
  } finally {
    server.kill('SIGTERM');
  }
});
