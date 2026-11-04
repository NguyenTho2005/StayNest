-- Adapted from staynest_schema.sql (MySQL 8) to PostgreSQL for the Flutter Page 1 flows.
-- VND amounts are integer bigint values. Payment and refund records are DEMO only.
CREATE TABLE users (
  id bigserial PRIMARY KEY,
  full_name varchar(150) NOT NULL,
  email varchar(255) NOT NULL UNIQUE,
  phone varchar(25) UNIQUE,
  password_hash varchar(255) NOT NULL,
  birth_date date,
  nationality varchar(100),
  avatar_url text,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE auth_sessions (
  id bigserial PRIMARY KEY,
  user_id bigint NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  token_hash char(64) NOT NULL UNIQUE,
  expires_at timestamptz NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX auth_sessions_user_idx ON auth_sessions(user_id);
CREATE TABLE destinations (
  id bigserial PRIMARY KEY,
  slug varchar(100) NOT NULL UNIQUE,
  name varchar(150) NOT NULL,
  province varchar(150) NOT NULL,
  description text,
  image_path text
);
CREATE TABLE properties (
  id bigserial PRIMARY KEY,
  slug varchar(120) NOT NULL UNIQUE,
  destination_id bigint NOT NULL REFERENCES destinations(id),
  name varchar(200) NOT NULL,
  property_type varchar(20) NOT NULL CHECK (property_type IN ('HOMESTAY','HOTEL','VILLA','APARTMENT','RESORT','OTHER')),
  description text,
  address varchar(500) NOT NULL,
  latitude numeric(10,7),
  longitude numeric(10,7),
  check_in_time time,
  check_out_time time,
  house_rules text,
  is_published boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX properties_search_idx ON properties(destination_id, property_type) WHERE is_published;
CREATE TABLE property_images (
  id bigserial PRIMARY KEY,
  property_id bigint NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  image_path text NOT NULL,
  alt_text varchar(255),
  sort_order int NOT NULL DEFAULT 0
);
CREATE TABLE amenities (
  id bigserial PRIMARY KEY,
  name varchar(120) NOT NULL UNIQUE,
  icon_name varchar(100)
);
CREATE TABLE property_amenities (
  property_id bigint NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  amenity_id bigint NOT NULL REFERENCES amenities(id),
  PRIMARY KEY (property_id, amenity_id)
);
CREATE TABLE cancellation_policies (
  id bigserial PRIMARY KEY,
  name varchar(120) NOT NULL,
  free_before_hours int NOT NULL CHECK (free_before_hours >= 0),
  partial_refund_percent int NOT NULL DEFAULT 0 CHECK (partial_refund_percent BETWEEN 0 AND 100),
  description text
);
CREATE TABLE room_types (
  id bigserial PRIMARY KEY,
  property_id bigint NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  cancellation_policy_id bigint REFERENCES cancellation_policies(id),
  name varchar(180) NOT NULL,
  description text,
  area_sqm numeric(7,2),
  max_adults smallint NOT NULL CHECK (max_adults > 0),
  max_children smallint NOT NULL DEFAULT 0 CHECK (max_children >= 0),
  bed_description varchar(180),
  view_description varchar(180),
  total_units smallint NOT NULL CHECK (total_units > 0),
  base_price_vnd bigint NOT NULL CHECK (base_price_vnd >= 0),
  is_active boolean NOT NULL DEFAULT true,
  UNIQUE (property_id, name)
);
CREATE TABLE room_images (
  id bigserial PRIMARY KEY,
  room_type_id bigint NOT NULL REFERENCES room_types(id) ON DELETE CASCADE,
  image_path text NOT NULL,
  sort_order int NOT NULL DEFAULT 0
);
CREATE TABLE room_amenities (
  room_type_id bigint NOT NULL REFERENCES room_types(id) ON DELETE CASCADE,
  amenity_id bigint NOT NULL REFERENCES amenities(id),
  PRIMARY KEY (room_type_id, amenity_id)
);
CREATE TABLE promotions (
  id bigserial PRIMARY KEY,
  code varchar(60) NOT NULL UNIQUE,
  title varchar(200) NOT NULL,
  discount_type varchar(10) NOT NULL CHECK (discount_type IN ('FIXED','PERCENT')),
  discount_value bigint NOT NULL CHECK (discount_value >= 0),
  max_discount_vnd bigint CHECK (max_discount_vnd >= 0),
  min_order_vnd bigint NOT NULL DEFAULT 0 CHECK (min_order_vnd >= 0),
  starts_at timestamptz NOT NULL,
  ends_at timestamptz NOT NULL CHECK (ends_at > starts_at),
  usage_limit int CHECK (usage_limit >= 0),
  used_count int NOT NULL DEFAULT 0 CHECK (used_count >= 0),
  is_active boolean NOT NULL DEFAULT true,
  CHECK (discount_type <> 'PERCENT' OR discount_value <= 100)
);
CREATE TABLE bookings (
  id bigserial PRIMARY KEY,
  booking_code varchar(40) NOT NULL UNIQUE,
  user_id bigint NOT NULL REFERENCES users(id),
  room_type_id bigint NOT NULL REFERENCES room_types(id),
  promotion_id bigint REFERENCES promotions(id),
  check_in_date date NOT NULL,
  check_out_date date NOT NULL CHECK (check_out_date > check_in_date),
  adults smallint NOT NULL CHECK (adults > 0),
  children smallint NOT NULL DEFAULT 0 CHECK (children >= 0),
  room_count smallint NOT NULL DEFAULT 1 CHECK (room_count > 0),
  guest_name varchar(150) NOT NULL,
  guest_email varchar(255) NOT NULL,
  guest_phone varchar(25) NOT NULL,
  arrival_window varchar(80),
  special_request varchar(250),
  status varchar(24) NOT NULL DEFAULT 'PENDING_PAYMENT' CHECK (status IN ('PENDING_PAYMENT','CONFIRMED_DEMO','CANCELLED','COMPLETED','EXPIRED')),
  nightly_price_vnd bigint NOT NULL CHECK (nightly_price_vnd >= 0),
  room_subtotal_vnd bigint NOT NULL CHECK (room_subtotal_vnd >= 0),
  tax_vnd bigint NOT NULL DEFAULT 0 CHECK (tax_vnd >= 0),
  service_fee_vnd bigint NOT NULL DEFAULT 0 CHECK (service_fee_vnd >= 0),
  discount_vnd bigint NOT NULL DEFAULT 0 CHECK (discount_vnd >= 0),
  total_vnd bigint NOT NULL CHECK (total_vnd >= 0),
  currency char(3) NOT NULL DEFAULT 'VND' CHECK (currency = 'VND'),
  price_snapshot jsonb NOT NULL,
  cancellation_policy_snapshot jsonb NOT NULL,
  hold_expires_at timestamptz,
  confirmed_at timestamptz,
  cancelled_at timestamptz,
  created_at timestamptz NOT NULL DEFAULT now(),
  CHECK (total_vnd = room_subtotal_vnd + tax_vnd + service_fee_vnd - discount_vnd)
);
CREATE INDEX bookings_availability_idx ON bookings(room_type_id, check_in_date, check_out_date) WHERE status IN ('PENDING_PAYMENT','CONFIRMED_DEMO','COMPLETED');
CREATE INDEX bookings_user_idx ON bookings(user_id, created_at DESC);
CREATE TABLE booking_idempotency (
  user_id bigint NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  idempotency_key varchar(120) NOT NULL,
  request_hash char(64) NOT NULL,
  booking_id bigint NOT NULL UNIQUE REFERENCES bookings(id),
  PRIMARY KEY (user_id, idempotency_key)
);
CREATE TABLE demo_payments (
  id bigserial PRIMARY KEY,
  booking_id bigint NOT NULL REFERENCES bookings(id),
  method varchar(20) NOT NULL CHECK (method IN ('EWALLET','DOMESTIC_CARD','INTERNATIONAL_CARD')),
  status varchar(12) NOT NULL CHECK (status IN ('PENDING','SUCCEEDED','FAILED')),
  amount_vnd bigint NOT NULL CHECK (amount_vnd >= 0),
  demo_reference varchar(120) NOT NULL UNIQUE,
  receipt jsonb,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE cancellation_requests (
  id bigserial PRIMARY KEY,
  booking_id bigint NOT NULL UNIQUE REFERENCES bookings(id),
  reason varchar(255) NOT NULL,
  note text,
  estimated_refund_vnd bigint NOT NULL CHECK (estimated_refund_vnd >= 0),
  requested_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE demo_refunds (
  id bigserial PRIMARY KEY,
  cancellation_request_id bigint NOT NULL UNIQUE REFERENCES cancellation_requests(id),
  demo_refund_code varchar(40) NOT NULL UNIQUE,
  amount_vnd bigint NOT NULL CHECK (amount_vnd >= 0),
  status varchar(12) NOT NULL DEFAULT 'PROCESSING' CHECK (status IN ('PENDING','PROCESSING','SUCCEEDED','FAILED')),
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE date_change_requests (
  id bigserial PRIMARY KEY,
  booking_id bigint NOT NULL REFERENCES bookings(id),
  new_check_in date NOT NULL,
  new_check_out date NOT NULL CHECK (new_check_out > new_check_in),
  status varchar(12) NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING','APPROVED','REJECTED','WITHDRAWN')),
  requested_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE favorites (
  user_id bigint NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  property_id bigint NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  created_at timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, property_id)
);
CREATE TABLE reviews (
  id bigserial PRIMARY KEY,
  booking_id bigint NOT NULL UNIQUE REFERENCES bookings(id),
  user_id bigint NOT NULL REFERENCES users(id),
  property_id bigint NOT NULL REFERENCES properties(id),
  rating smallint NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);
CREATE INDEX reviews_property_idx ON reviews(property_id, created_at DESC);
