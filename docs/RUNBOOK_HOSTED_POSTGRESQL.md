# Runbook vận hành PostgreSQL Hosted — StayNest

**Phiên bản:** 1.0  
**Ngày cập nhật:** 2026-11-04  
**Đối tượng:** Devops / Platform Engineer / Operator vận hành StayNest Backend

---

## 1. Mô hình kết nối và ranh giới bảo mật

```text
+-----------------------+              HTTPS              +------------------------+
| Flutter Client        | -----------------------------> | Express API Deployment |
| (Web / iOS / Android) |  STAYNEST_API_URL               | (Behind HTTPS / LB)    |
+-----------------------+  (Không biết DATABASE_URL)      +------------------------+
                                                                      |
                                                                      | TLS (DATABASE_SSL=1)
                                                                      | Private VPC / Static Egress
                                                                      v
                                                          +------------------------+
                                                          | PostgreSQL 14+ Hosted  |
                                                          | (Mạng riêng cô lập)   |
                                                          +------------------------+
```

### Nguyên tắc bất biến
1. **Flutter client không kết nối DB:** Flutter chỉ giao tiếp với Express qua `STAYNEST_API_URL`. Tuyệt đối không đưa `DATABASE_URL` vào `--dart-define`, mã nguồn Flutter, hay lưu trữ trên client.
2. **Không public database:** PostgreSQL không bao giờ được gán IP công khai mở cho `0.0.0.0/0`.
3. **Bắt buộc TLS xác thực chứng chỉ:** Khi kết nối qua mạng, luôn cấu hình `DATABASE_SSL=1` với `rejectUnauthorized: true`. Không chấp nhận cờ bypass xác thực.
4. **Least privilege:** Tách biệt quyền của role chạy migration (schema DDL) và role runtime của ứng dụng (DML).
5. **Dữ liệu demo được cô lập:** Tuyệt đối không tự động chạy seed catalog demo trên môi trường production.

---

## 2. Thiết lập Database & Phân quyền Role (Least Privilege)

Chạy các câu lệnh SQL dưới đây bằng tài khoản quản trị cụm (ví dụ `postgres` hoặc `cloudsqlsuperuser`) trên instance PostgreSQL 14+:

```sql
-- 1. Tạo database cho ứng dụng
CREATE DATABASE staynest WITH ENCODING 'UTF8' LC_COLLATE 'C' LC_CTYPE 'C';
\c staynest;

-- 2. Tạo role chạy Migration (cần quyền DDL tạo/sửa bảng)
CREATE ROLE staynest_migration WITH LOGIN PASSWORD 'GENERATE_STRONG_MIGRATION_PASSWORD';
GRANT CONNECT ON DATABASE staynest TO staynest_migration;
GRANT CREATE ON SCHEMA public TO staynest_migration;

-- 3. Tạo role Runtime cho API (chỉ cần quyền DML đọc/ghi dữ liệu, không DDL)
CREATE ROLE staynest_app WITH LOGIN PASSWORD 'GENERATE_STRONG_APP_PASSWORD';
GRANT CONNECT ON DATABASE staynest TO staynest_app;
GRANT USAGE ON SCHEMA public TO staynest_app;

-- 4. Phân quyền bảng và sequence cho staynest_app sau khi chạy migration
-- (Lưu ý: Chạy lệnh này sau khi staynest_migration đã áp dụng các bảng)
ALTER DEFAULT PRIVILEGES FOR ROLE staynest_migration IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO staynest_app;

ALTER DEFAULT PRIVILEGES FOR ROLE staynest_migration IN SCHEMA public
  GRANT USAGE, SELECT ON SEQUENCES TO staynest_app;
```

---

## 3. Chính sách mạng (Network Policy & Security Group)

- **Môi trường Cloud VPC (AWS, GCP, Azure, Private K8s):**
  - Đặt instance PostgreSQL trong **Private Subnet** không có Internet Gateway.
  - Cấu hình Security Group / Firewall Rules:
    - Inbound cổng `5432`: Chỉ cho phép Traffic từ Security Group của Express API hoặc Subnet CIDR nội bộ của cụm API (ví dụ: `10.0.4.0/24`).
    - Khóa toàn bộ Inbound từ Internet (`0.0.0.0/0`).
- **Môi trường DBaaS có quản lý (Neon, Supabase, Railway, Aiven):**
  - Nếu kết nối qua peering/private link: Định tuyến qua Private Endpoint.
  - Nếu bắt buộc đi qua Internet có TLS: Bật tính năng **IP Allowlist** tại trang quản trị provider, chỉ thêm danh sách **Static Egress IPs (NAT Gateway)** của máy chủ Express API.

---

## 4. Cấu hình TLS & Chứng chỉ CA

Hệ thống StayNest bắt buộc xác thực tính hợp lệ của TLS certificate:

### Trường hợp A: Provider sử dụng Public CA (chứng chỉ công khai hợp lệ)
- Các nhà cung cấp hiện đại (như Supabase, Neon, AWS RDS sử dụng chứng chỉ root công khai) được tin cậy bởi hệ điều hành / Node.js.
- Cấu hình môi trường:
  ```dotenv
  DATABASE_SSL=1
  DATABASE_SSL_CA_FILE=
  ```

### Trường hợp B: Provider sử dụng Private / Internal CA (ví dụ AWS RDS CA Bundle cũ, Cloud SQL internal CA)
- Tải file CA certificate từ trang quản lý provider.
- Mount file vào máy chủ API ở dạng file bí mật chỉ đọc (ví dụ: `/etc/secrets/db-ca.pem`, quyền `chmod 400`).
- Cấu hình môi trường bằng đường dẫn tuyệt đối:
  ```dotenv
  DATABASE_SSL=1
  DATABASE_SSL_CA_FILE=/etc/secrets/db-ca.pem
  ```

---

## 5. Quản lý Secret & Biến môi trường

### Ma trận biến môi trường API

| Tên biến | Môi trường Production | Ý nghĩa & Hướng dẫn |
|---|---|---|
| `NODE_ENV` | `production` | Kích hoạt các kiểm tra bảo mật nghiêm ngặt. |
| `HOST` | `0.0.0.0` hoặc `127.0.0.1` | Bind nội bộ cho reverse proxy (Nginx / Cloud Run / ECS). |
| `PORT` | `3000` | Cổng ứng dụng lắng nghe. |
| `DATABASE_URL` | `postgresql://staynest_app:...@db...:5432/staynest` | Chuỗi kết nối inject từ Secret Manager (AWS Secrets Manager, GCP Secret Manager, Vault). **Không bao giờ commit vào repo.** |
| `DATABASE_SSL` | `1` | Bắt buộc bật TLS khi kết nối cơ sở dữ liệu qua mạng. |
| `DATABASE_SSL_CA_FILE` | Trống hoặc `/path/to/ca.pem` | Đường dẫn file CA nếu dùng Private CA. |
| `CORS_ORIGINS` | `https://staynest.vn,https://app.staynest.vn` | Danh sách URL gốc của web client, phân cách bởi dấu phẩy. **Cấm tuyệt đối `*`.** |
| `STAYNEST_EMBEDDED_DEMO` | `0` (hoặc unset) | Bị chặn hoàn toàn nếu `NODE_ENV=production`. |
| `ALLOW_DEMO_SEED` | `0` (hoặc unset) | Seed bị vô hiệu hóa trên production. |

---

## 6. Quy trình Release & Thực thi Migration

Migration được quản lý qua `schema_migrations` với `pg_advisory_lock(748391)` để chống race condition.

### Thứ tự thực hiện trong CI/CD Release Pipeline:
1. **Bước 1: Backup cơ sở dữ liệu** (Tạo snapshot hoặc logical backup tự động trước release).
2. **Bước 2: Chạy Migration Job (Một lần duy nhất)**
   - Khởi tạo 1 release job / container ngắn hạn với role `staynest_migration`:
   ```bash
   cd backend
   DATABASE_URL="postgresql://staynest_migration:${MIGRATION_PASSWORD}@${DB_HOST}:5432/staynest" \
   DATABASE_SSL=1 \
   npm run migrate
   ```
   - Migration runner sẽ ghi nhận file đã chạy vào bảng `schema_migrations`.
3. **Bước 3: Khởi chạy / Rollout dịch vụ API**
   - API chạy với role `staynest_app` (least privilege):
   ```bash
   npm start
   ```
4. **Bước 4: Kiểm tra trạng thái Readiness**
   ```bash
   curl -f http://127.0.0.1:3000/api/v1/health/ready
   # Kỳ vọng: {"status":"ready"} (HTTP 200)
   ```

---

## 7. Chính sách Seed dữ liệu

- **Production:** Không bao giờ chạy `npm run seed`. Ứng dụng đã có cơ chế chặn:
  - Nếu `NODE_ENV=production`, `seed.js` lập tức từ chối và thoát mã lỗi `1`.
- **Staging / QA môi trường riêng:**
  - Nếu cần khởi tạo dữ liệu mẫu để thử nghiệm, operator phải chỉ định rõ cờ chấp thuận:
  ```bash
  ALLOW_DEMO_SEED=1 npm run seed
  ```

---

## 8. Giám sát & Health Checks

1. **Liveness Probe (Quá trình sống):**
   - Endpoint: `GET /api/v1/health`
   - Mục đích: Khẳng định tiến trình Express đang sống và phản hồi.
   - Hành vi khi lỗi: Restart container / process.
2. **Readiness Probe (Sẵn sàng phục vụ):**
   - Endpoint: `GET /api/v1/health/ready`
   - Mục đích: Thực hiện câu truy vấn `SELECT 1` trên pool kết nối PostgreSQL.
   - Hành vi khi lỗi: Trả về HTTP 503 kèm `requestId`. Load balancer tạm ngừng chuyển traffic đến instance này cho đến khi kết nối phục hồi.

---

## 9. Sao lưu (Backup) & Diễn tập phục hồi (Restore Drill)

### Chiến lược sao lưu
- **Point-in-Time Recovery (PITR):** Bật chế độ continuous WAL archiving với thời gian lưu trữ tối thiểu 7–30 ngày.
- **Automated Daily Snapshot:** Chụp snapshot hàng ngày vào khung giờ thấp điểm (02:00 UTC).

### Quy trình diễn tập phục hồi (Restore Drill định kỳ mỗi quý)
1. Tạo một instance database tạm thời biệt lập (ví dụ `staynest-drill-restore`).
2. Khôi phục bản snapshot gần nhất vào instance tạm thời này.
3. Kiểm tra tính toàn vẹn dữ liệu:
   ```sql
   SELECT count(*) FROM users;
   SELECT count(*) FROM bookings;
   SELECT max(applied_at) FROM schema_migrations;
   ```
4. Ghi nhận thời gian khôi phục thực tế (RTO) và lượng dữ liệu mất mát (RPO).
5. Hủy instance database tạm thời sau khi hoàn tất diễn tập.

---

## 10. Quy trình xoay vòng Credential (Zero-Downtime Rotation)

Khi cần đổi mật khẩu database mà không gây gián đoạn dịch vụ:

1. **Bước 1:** Tạo một role phụ song song trong PostgreSQL (ví dụ `staynest_app_v2`):
   ```sql
   CREATE ROLE staynest_app_v2 WITH LOGIN PASSWORD 'NEW_STRONG_PASSWORD';
   GRANT staynest_app TO staynest_app_v2;
   ```
2. **Bước 2:** Cập nhật secret `DATABASE_URL` trong Secret Manager để trỏ tới `staynest_app_v2`.
3. **Bước 3:** Thực hiện rolling restart các instance của Express API để nhận connection string mới.
4. **Bước 4:** Kiểm tra metrics và readiness của tất cả instance.
5. **Bước 5:** Sau khi toàn bộ instance đã kết nối qua role mới, thu hồi và xóa role cũ:
   ```sql
   DROP ROLE staynest_app;
   ```

---

## 11. Xử lý sự cố & Kế hoạch Rollback

- **Sự cố Migration thất bại:**
  - Nhờ tính chất `BEGIN ... COMMIT` theo từng file trong `migrate.js`, file gặp lỗi sẽ tự động `ROLLBACK` và không được ghi nhận vào `schema_migrations`.
  - Fix lỗi migration trong file SQL mới tăng dần, không chỉnh sửa file migration đã áp dụng thành công.
- **Rollback phiên bản ứng dụng:**
  - Giữ quy tắc **Expand/Contract** trong thiết kế schema: mã mới luôn tương thích với schema cũ trong 1 chu kỳ release.
  - Nếu cần rollback mã nguồn API, rollback về phiên bản image/commit trước đó mà không cần can thiệp rollback dữ liệu phá hủy (destructive schema drop).

