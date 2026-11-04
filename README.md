# StayNest

Flutter Page 1 frontend from the supplied Figma file, with a Node.js/Express REST API and PostgreSQL schema. Page 2–3 are excluded. The Flutter UI has 101 Page 1 route/state mappings; visual comparison is still partial. See [docs/HANDOVER.md](docs/HANDOVER.md) and [docs/BACKEND_MAPPING.md](docs/BACKEND_MAPPING.md) for exact progress.

> 📖 **Hướng dẫn thiết lập & Chạy Demo:** Xem chi tiết tại [SETUP.md](SETUP.md) (Hướng dẫn cài đặt từ A-Z, kết nối Supabase PostgreSQL, chạy backend API, frontend Flutter và kịch bản demo).

## Backend choice

The agreed stack is Flutter/Dart + Riverpod + go_router, Node.js/Express, PostgreSQL. The supplied `staynest_schema.sql` was a MySQL 8 draft; `backend/db/migrations/001_initial.sql` adapts it to PostgreSQL and the actual Flutter flows. Backend prices use integer VND. Booking stores price and cancellation snapshots. Payment and refund records are explicitly **demo**; no card number or CVV is accepted or stored.

## Requirements

- Flutter SDK (this workspace used `/home/dat/flutter`)
- Node.js 20 or later and npm
- PostgreSQL 14 or later, running locally or through a container

This execution environment did not have `psql`, `postgres`, Docker or Podman, so a server-backed database integration run has not yet been completed here. The PostgreSQL migration did execute successfully in an embedded PostgreSQL test (PGlite).

For a quick local preview without installing PostgreSQL, run the API with `DATABASE_URL` unset and `STAYNEST_EMBEDDED_DEMO=1`. This starts an **in-memory development database**, applies the migration and seed at startup, and loses its data when the process stops. It is only for demo/automated checks; the normal setup above uses PostgreSQL server:

```bash
cd backend
npm ci
DATABASE_URL= STAYNEST_EMBEDDED_DEMO=1 SEED_DEMO_PASSWORD=choose-a-demo-password CORS_ORIGINS=http://127.0.0.1:8090 npm start
```

To view the built web app locally, run `python3 -m http.server 8090 --bind 127.0.0.1 --directory build/web` from the project root and open `http://127.0.0.1:8090`. Build it first with `flutter build web --no-pub`. The demo account is `an.demo@example.com` with the password chosen in `SEED_DEMO_PASSWORD`.

## PostgreSQL setup (Linux Mint example)

Install and start PostgreSQL with your package manager, then create a local role/database. Use your own password and do not commit it:

```bash
sudo apt update
sudo apt install postgresql
sudo systemctl enable --now postgresql
sudo -u postgres psql -c "CREATE USER staynest WITH PASSWORD 'choose-a-local-password';"
sudo -u postgres psql -c "CREATE DATABASE staynest OWNER staynest;"
```

Copy `backend/.env.example` to `backend/.env`, set `DATABASE_URL` to that role/database, and set `CORS_ORIGINS` to the Flutter web origin you actually use. For local seed login, set `SEED_DEMO_PASSWORD` to a password of your choice; the seed only creates `an.demo@example.com` when that variable is set. Running demo seed requires explicit permission via `ALLOW_DEMO_SEED=1`:

```bash
cd backend
cp .env.example .env
npm ci
npm run migrate
ALLOW_DEMO_SEED=1 npm run seed
npm start
```

`GET http://127.0.0.1:3000/api/v1/health` checks the process; `/api/v1/health/ready` checks PostgreSQL. `npm run dev` restarts the API when files change. Do not use the demo catalog/fee policy as a production inventory or cancellation policy.

## PostgreSQL hosted on the Internet

Flutter never connects to PostgreSQL. It only calls the Express API; only the API deployment receives `DATABASE_URL` as a secret. This makes it possible to keep the database network-private even though users access the app from the Internet.

1. Create a PostgreSQL 14+ instance and a least-privilege application role. Require TLS at the database provider, then allow incoming database traffic only from the API service's private network, security group, or fixed egress IP—never from arbitrary client IPs.
2. In the API host's secret manager or untracked `backend/.env`, set the provider's PostgreSQL URL, `DATABASE_SSL=1`, and the exact web origins that will use the API. Do not put `DATABASE_URL`, a CA certificate, or a password in Flutter, source control, build logs, or a `--dart-define` value.

   ```dotenv
   HOST=127.0.0.1
   PORT=3000
   DATABASE_URL=postgresql://staynest:your-password@db.example.com:5432/staynest
   DATABASE_SSL=1
   # Leave empty when the provider uses a public CA. For a private CA, mount the
   # certificate as a secret on the API host and use its absolute path instead.
   DATABASE_SSL_CA_FILE=
   CORS_ORIGINS=https://app.example.com
   SEED_DEMO_PASSWORD=
   ```

   `DATABASE_SSL=1` keeps certificate verification enabled. Do not work around a certificate error by disabling verification; install the database provider's CA file instead. If the provider adds an SSL option to its connection URL, retain only settings compatible with certificate verification.

3. From the API deployment (not from Flutter), install and apply schema changes once per release. See [docs/RUNBOOK_HOSTED_POSTGRESQL.md](docs/RUNBOOK_HOSTED_POSTGRESQL.md) for detailed production deployment, least-privilege roles, and credential rotation procedures:

   ```bash
   cd backend
   npm ci
   npm run migrate
   # Demo seed is prohibited in production. For staging only (with approval):
   # ALLOW_DEMO_SEED=1 npm run seed
   npm start
   ```

4. Place Express behind an HTTPS reverse proxy or platform load balancer, keep the Node port private, and expose only `https://api.example.com`. Verify `/api/v1/health/ready` from the deployment environment. Build Flutter with the public API URL, not the database URL:

   ```bash
   flutter run --dart-define=STAYNEST_API_URL=https://api.example.com
   ```

For a mobile-only client, CORS does not restrict native app traffic; it is still needed for Flutter web and should list exact origins rather than `*`. Rotate database credentials if they are ever pasted into a chat, commit, screenshot, or public log.

## Flutter API URL

Flutter uses `STAYNEST_API_URL`, defaulting to `http://127.0.0.1:3000` for web/Linux desktop. Examples:

```bash
/home/dat/flutter/bin/flutter pub get
/home/dat/flutter/bin/flutter run -d chrome --dart-define=STAYNEST_API_URL=http://127.0.0.1:3000
# Android emulator:
/home/dat/flutter/bin/flutter run -d emulator-5554 --dart-define=STAYNEST_API_URL=http://10.0.2.2:3000
# Physical device on the same LAN: set HOST=0.0.0.0 in backend/.env and use your computer's LAN IP.
/home/dat/flutter/bin/flutter run --dart-define=STAYNEST_API_URL=http://YOUR_LAN_IP:3000
```

For web, add the exact Flutter origin (including port) to `CORS_ORIGINS`. Never include a trailing slash in `STAYNEST_API_URL`. Session tokens are saved with `flutter_secure_storage` and attached as Bearer tokens. Production deployments should use HTTPS and a real secret/configuration process.

## Implemented API surface

`/api/v1/auth/register`, `/auth/login`, `/me` GET/PATCH, `/logout`, `/destinations`, `/properties`, `/properties/:slug`, `/properties/:slug/rooms`, `/properties/:slug/reviews`, `/me/favorites`, `/vouchers`, `/vouchers/validate`, `/booking-quotes`, `/bookings`, `/me/bookings`, `/bookings/:id`, `/bookings/:id/demo-payment`, `/bookings/:id/receipt`, `/bookings/:id/change-date-requests`, `/bookings/:id/cancellation-preview`, `/bookings/:id/cancellations`, `/bookings/:id/refund`, `/bookings/:id/reviews`.

Booking creation requires an `Idempotency-Key` header. The backend locks the room type row inside a PostgreSQL transaction, checks overlapping active/held bookings, validates guests/dates/voucher, and creates a 15-minute hold. Demo payment only takes a method (`EWALLET`, `DOMESTIC_CARD`, `INTERNATIONAL_CARD`) and returns a `DEMO-*` reference. The refund endpoint reports a demo status, never a real transfer. Authenticated data queries are scoped to the session user.

## Verification

```bash
cd backend
npm run check
npm test
cd ..
/home/dat/flutter/bin/dart format lib
/home/dat/flutter/bin/flutter analyze lib
/home/dat/flutter/bin/flutter build web --no-pub
```

Current results and remaining gaps are recorded in [docs/HANDOVER.md](docs/HANDOVER.md). Backend checks and 8 business/schema/seed/HTTP tests pass, including an embedded database inventory and ownership check. Two Flutter tests pass (booking draft and pending payment guard), `flutter analyze lib` is clean, and the web build succeeds. A PostgreSQL server transaction test and full Flutter visual flow review remain open.

The connected Flutter flows are registration/login/profile, destination search with dates/guests and price/type/sort filters, favorites, booking quote/create, demo payment confirmation, and a live trip list/detail with change date, cancellation, demo refund tracking and post-stay review actions. Older Figma demo routes remain available; Mây-specific detail subframes, the non-Mây booking flow, some Figma coupon/payment demo routes and non-Mây booking still need live data wiring; Mây Studio and Garden View use real room IDs/quotes. Other catalog cards open an API-backed generic detail view. Never treat the demo payment or refund as a bank transaction.
