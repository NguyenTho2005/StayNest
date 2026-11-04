-- StayNest schema, MySQL 8.0. Inferred from the Figma prototype.
-- All prices are VND integer amounts. Store UTC timestamps in the application.
CREATE DATABASE IF NOT EXISTS staynest CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE staynest;

CREATE TABLE users (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  full_name VARCHAR(150) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  phone VARCHAR(25) UNIQUE,
  password_hash VARCHAR(255), -- NULL for social-only accounts
  birth_date DATE,
  nationality VARCHAR(100),
  avatar_url VARCHAR(2048),
  role ENUM('GUEST','HOST','ADMIN') NOT NULL DEFAULT 'GUEST',
  verification_level TINYINT UNSIGNED NOT NULL DEFAULT 0,
  email_verified_at DATETIME,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE auth_tokens (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  purpose ENUM('VERIFY_EMAIL','RESET_PASSWORD','VERIFY_PHONE') NOT NULL,
  token_hash CHAR(64) NOT NULL UNIQUE,
  expires_at DATETIME NOT NULL,
  consumed_at DATETIME,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE destinations (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL,
  province VARCHAR(150) NOT NULL,
  description TEXT,
  image_url VARCHAR(2048),
  UNIQUE KEY uq_destination (name, province)
);

CREATE TABLE properties (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  host_id BIGINT UNSIGNED NOT NULL,
  destination_id BIGINT UNSIGNED NOT NULL,
  name VARCHAR(200) NOT NULL,
  property_type ENUM('HOMESTAY','HOTEL','VILLA','APARTMENT','RESORT','OTHER') NOT NULL,
  description TEXT,
  address VARCHAR(500) NOT NULL,
  latitude DECIMAL(10,7),
  longitude DECIMAL(10,7),
  check_in_time TIME,
  check_out_time TIME,
  house_rules TEXT,
  is_published BOOLEAN NOT NULL DEFAULT FALSE,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (host_id) REFERENCES users(id),
  FOREIGN KEY (destination_id) REFERENCES destinations(id),
  INDEX idx_properties_search (destination_id, property_type, is_published)
);

CREATE TABLE property_images (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  property_id BIGINT UNSIGNED NOT NULL,
  image_url VARCHAR(2048) NOT NULL,
  alt_text VARCHAR(255),
  sort_order INT NOT NULL DEFAULT 0,
  FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE
);

CREATE TABLE amenities (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL UNIQUE,
  icon_name VARCHAR(100)
);
CREATE TABLE property_amenities (
  property_id BIGINT UNSIGNED NOT NULL,
  amenity_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (property_id, amenity_id),
  FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE,
  FOREIGN KEY (amenity_id) REFERENCES amenities(id)
);

CREATE TABLE cancellation_policies (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(120) NOT NULL,
  free_before_hours INT UNSIGNED NOT NULL,
  partial_refund_percent TINYINT UNSIGNED NOT NULL DEFAULT 0,
  description TEXT,
  CHECK (partial_refund_percent <= 100)
);

CREATE TABLE room_types (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  property_id BIGINT UNSIGNED NOT NULL,
  cancellation_policy_id BIGINT UNSIGNED,
  name VARCHAR(180) NOT NULL,
  description TEXT,
  area_sqm DECIMAL(7,2),
  max_adults SMALLINT UNSIGNED NOT NULL,
  max_children SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  bed_description VARCHAR(180),
  view_description VARCHAR(180),
  total_units SMALLINT UNSIGNED NOT NULL DEFAULT 1,
  base_price_vnd BIGINT UNSIGNED NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  UNIQUE KEY uq_room_name (property_id, name),
  FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE,
  FOREIGN KEY (cancellation_policy_id) REFERENCES cancellation_policies(id),
  CHECK (total_units > 0), CHECK (max_adults > 0)
);
CREATE TABLE room_images (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  room_type_id BIGINT UNSIGNED NOT NULL,
  image_url VARCHAR(2048) NOT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  FOREIGN KEY (room_type_id) REFERENCES room_types(id) ON DELETE CASCADE
);
CREATE TABLE room_amenities (
  room_type_id BIGINT UNSIGNED NOT NULL,
  amenity_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (room_type_id, amenity_id),
  FOREIGN KEY (room_type_id) REFERENCES room_types(id) ON DELETE CASCADE,
  FOREIGN KEY (amenity_id) REFERENCES amenities(id)
);

CREATE TABLE promotions (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  code VARCHAR(60) NOT NULL UNIQUE,
  title VARCHAR(200) NOT NULL,
  discount_type ENUM('FIXED','PERCENT') NOT NULL,
  discount_value BIGINT UNSIGNED NOT NULL,
  max_discount_vnd BIGINT UNSIGNED,
  min_order_vnd BIGINT UNSIGNED NOT NULL DEFAULT 0,
  starts_at DATETIME NOT NULL,
  ends_at DATETIME NOT NULL,
  usage_limit INT UNSIGNED,
  used_count INT UNSIGNED NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  CHECK (ends_at > starts_at),
  CHECK (discount_type <> 'PERCENT' OR discount_value <= 100)
);

CREATE TABLE bookings (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  booking_code VARCHAR(40) NOT NULL UNIQUE,
  user_id BIGINT UNSIGNED NOT NULL,
  room_type_id BIGINT UNSIGNED NOT NULL,
  promotion_id BIGINT UNSIGNED,
  check_in_date DATE NOT NULL,
  check_out_date DATE NOT NULL,
  adults SMALLINT UNSIGNED NOT NULL,
  children SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  room_count SMALLINT UNSIGNED NOT NULL DEFAULT 1,
  guest_name VARCHAR(150) NOT NULL,
  guest_email VARCHAR(255) NOT NULL,
  guest_phone VARCHAR(25) NOT NULL,
  arrival_window VARCHAR(80),
  special_request VARCHAR(250),
  status ENUM('PENDING_PAYMENT','CONFIRMED','CANCELLED','COMPLETED','EXPIRED') NOT NULL DEFAULT 'PENDING_PAYMENT',
  -- Snapshot of checkout quote; never derive past totals from today's price/policy.
  nightly_price_vnd BIGINT UNSIGNED NOT NULL,
  room_subtotal_vnd BIGINT UNSIGNED NOT NULL,
  tax_vnd BIGINT UNSIGNED NOT NULL DEFAULT 0,
  service_fee_vnd BIGINT UNSIGNED NOT NULL DEFAULT 0,
  discount_vnd BIGINT UNSIGNED NOT NULL DEFAULT 0,
  total_vnd BIGINT UNSIGNED NOT NULL,
  currency CHAR(3) NOT NULL DEFAULT 'VND',
  cancellation_policy_snapshot TEXT,
  confirmed_at DATETIME,
  cancelled_at DATETIME,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (room_type_id) REFERENCES room_types(id),
  FOREIGN KEY (promotion_id) REFERENCES promotions(id),
  CHECK (check_out_date > check_in_date),
  CHECK (adults > 0), CHECK (room_count > 0),
  CHECK (total_vnd = room_subtotal_vnd + tax_vnd + service_fee_vnd - discount_vnd),
  INDEX idx_booking_availability (room_type_id, status, check_in_date, check_out_date),
  INDEX idx_booking_user (user_id, created_at)
);

CREATE TABLE payments (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  booking_id BIGINT UNSIGNED NOT NULL,
  method ENUM('EWALLET','DOMESTIC_CARD','INTERNATIONAL_CARD') NOT NULL,
  status ENUM('PENDING','SUCCEEDED','FAILED') NOT NULL DEFAULT 'PENDING',
  amount_vnd BIGINT UNSIGNED NOT NULL,
  provider_reference VARCHAR(120) UNIQUE,
  failure_reason VARCHAR(500),
  paid_at DATETIME,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (booking_id) REFERENCES bookings(id),
  INDEX idx_payment_booking (booking_id, status)
);

CREATE TABLE cancellation_requests (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  booking_id BIGINT UNSIGNED NOT NULL UNIQUE,
  reason VARCHAR(255) NOT NULL,
  note TEXT,
  estimated_refund_vnd BIGINT UNSIGNED NOT NULL,
  requested_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (booking_id) REFERENCES bookings(id)
);
CREATE TABLE refunds (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  cancellation_request_id BIGINT UNSIGNED NOT NULL UNIQUE,
  payment_id BIGINT UNSIGNED NOT NULL,
  refund_code VARCHAR(40) NOT NULL UNIQUE,
  amount_vnd BIGINT UNSIGNED NOT NULL,
  status ENUM('PENDING','PROCESSING','SUCCEEDED','FAILED') NOT NULL DEFAULT 'PENDING',
  processed_at DATETIME,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (cancellation_request_id) REFERENCES cancellation_requests(id),
  FOREIGN KEY (payment_id) REFERENCES payments(id)
);

CREATE TABLE date_change_requests (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  booking_id BIGINT UNSIGNED NOT NULL,
  new_check_in DATE NOT NULL,
  new_check_out DATE NOT NULL,
  proposed_total_vnd BIGINT UNSIGNED,
  status ENUM('PENDING','APPROVED','REJECTED','WITHDRAWN') NOT NULL DEFAULT 'PENDING',
  requested_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  resolved_at DATETIME,
  FOREIGN KEY (booking_id) REFERENCES bookings(id),
  CHECK (new_check_out > new_check_in)
);

CREATE TABLE favorites (
  user_id BIGINT UNSIGNED NOT NULL,
  property_id BIGINT UNSIGNED NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id, property_id),
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE
);
CREATE TABLE reviews (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  booking_id BIGINT UNSIGNED NOT NULL UNIQUE,
  user_id BIGINT UNSIGNED NOT NULL,
  property_id BIGINT UNSIGNED NOT NULL,
  rating TINYINT UNSIGNED NOT NULL,
  title VARCHAR(100),
  comment TEXT,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (booking_id) REFERENCES bookings(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (property_id) REFERENCES properties(id),
  CHECK (rating BETWEEN 1 AND 5),
  INDEX idx_review_property (property_id, created_at)
);
CREATE TABLE review_images (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  review_id BIGINT UNSIGNED NOT NULL,
  image_url VARCHAR(2048) NOT NULL,
  FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE
);
CREATE TABLE review_tags (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL UNIQUE
);
CREATE TABLE review_tag_links (
  review_id BIGINT UNSIGNED NOT NULL,
  tag_id BIGINT UNSIGNED NOT NULL,
  PRIMARY KEY (review_id, tag_id),
  FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES review_tags(id)
);

CREATE TABLE support_conversations (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  booking_id BIGINT UNSIGNED,
  user_id BIGINT UNSIGNED NOT NULL,
  status ENUM('OPEN','CLOSED') NOT NULL DEFAULT 'OPEN',
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (booking_id) REFERENCES bookings(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);
CREATE TABLE support_messages (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  conversation_id BIGINT UNSIGNED NOT NULL,
  sender_user_id BIGINT UNSIGNED,
  sender_type ENUM('USER','AGENT','SYSTEM') NOT NULL,
  body TEXT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (conversation_id) REFERENCES support_conversations(id) ON DELETE CASCADE,
  FOREIGN KEY (sender_user_id) REFERENCES users(id)
);

CREATE TABLE notifications (
  id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id BIGINT UNSIGNED NOT NULL,
  title VARCHAR(200) NOT NULL,
  body TEXT NOT NULL,
  booking_id BIGINT UNSIGNED,
  read_at DATETIME,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  FOREIGN KEY (booking_id) REFERENCES bookings(id),
  INDEX idx_notification_unread (user_id, read_at, created_at)
);

-- Availability must be checked in a transaction with a lock on room_types.
-- Count units in overlapping CONFIRMED / PENDING_PAYMENT bookings, then insert
-- only when requested room_count fits total_units. Expire abandoned holds.
-- Never store PAN/CVV; use a payment-provider token/reference in production.
