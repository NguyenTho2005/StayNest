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

test('Generic booking lifecycle for non-May property: Pine Hill Homestay Da Lat', { timeout: 45000 }, async () => {
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
    assert.equal(ready, true, 'server did not start');

    // 1. Query Pine Hill Homestay
    const propertyRes = await call('/properties/pine-hill-homestay');
    assert.equal(propertyRes.status, 200, 'Pine Hill Homestay should be accessible');
    assert.equal(propertyRes.data.slug, 'pine-hill-homestay');
    assert.ok(propertyRes.data.rooms.length > 0, 'Should have rooms');

    const pineRoom = propertyRes.data.rooms.find((r) => r.name.includes('đồi thông') || r.name.includes('Đồi thông')) || propertyRes.data.rooms[0];
    assert.ok(pineRoom, 'Should find pine hill room');

    // 2. Register user
    const userRes = await call('/auth/register', {
      method: 'POST',
      body: {
        fullName: 'Nguyễn Văn Đà Lạt',
        email: 'dalat@example.com',
        phone: '0988776655',
        password: 'password123',
      },
    });
    assert.equal(userRes.status, 201);
    const token = userRes.data.token;

    // 3. Request Quote
    const checkIn = '2026-11-20';
    const checkOut = '2026-11-22';
    const quoteRes = await call('/booking-quotes', {
      method: 'POST',
      body: {
        roomTypeId: pineRoom.id,
        checkIn,
        checkOut,
        adults: 2,
        children: 0,
        roomCount: 1,
      },
    });
    assert.equal(quoteRes.status, 200);
    assert.equal(quoteRes.data.roomTypeId, pineRoom.id);
    assert.ok(quoteRes.data.totalVnd > 0);

    // 4. Create Booking
    const bookingRes = await call('/bookings', {
      method: 'POST',
      token,
      key: 'dalat-booking-key-01',
      body: {
        roomTypeId: pineRoom.id,
        checkIn,
        checkOut,
        adults: 2,
        children: 0,
        roomCount: 1,
        guestName: 'Nguyễn Văn Đà Lạt',
        guestEmail: 'dalat@example.com',
        guestPhone: '0988776655',
      },
    });
    assert.equal(bookingRes.status, 201);
    const booking = bookingRes.data;
    assert.equal(booking.room_type_id, pineRoom.id);
    assert.equal(booking.status, 'PENDING_PAYMENT');

    // 5. Complete Demo Payment
    const paymentRes = await call(`/bookings/${booking.id}/demo-payment`, {
      method: 'POST',
      token,
      body: { method: 'DOMESTIC_CARD' },
    });
    assert.equal(paymentRes.status, 201);
    assert.equal(paymentRes.data.status, 'SUCCEEDED');
    assert.equal(paymentRes.data.demo, true);

    // 6. Verify booking appears in /me/bookings
    const myBookingsRes = await call('/me/bookings', { token });
    assert.equal(myBookingsRes.status, 200);
    const found = myBookingsRes.data.items.find((b) => b.id === booking.id);
    assert.ok(found, 'Booking must appear in /me/bookings');
    assert.equal(found.property_slug, 'pine-hill-homestay');
    assert.equal(found.status, 'CONFIRMED_DEMO');

    // 7. Verify receipt
    const receiptRes = await call(`/bookings/${booking.id}/receipt`, { token });
    assert.equal(receiptRes.status, 200);
    assert.ok(receiptRes.data.payment.demo_reference);
  } finally {
    server.kill('SIGTERM');
  }
});
