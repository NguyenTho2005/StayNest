# Hướng dẫn Thiết lập & Chạy Demo Dự án StayNest

Tài liệu này hướng dẫn chi tiết từ đầu (A-Z) cách thiết lập môi trường, tạo và cấu hình cơ sở dữ liệu PostgreSQL trên **Supabase**, khởi chạy backend API Node.js/Express, chạy ứng dụng frontend Flutter và kịch bản demo đầy đủ luồng nghiệp vụ.

---

## 📋 Mục lục
1. [Yêu cầu hệ thống](#1-yêu-cầu-hệ-thống)
2. [Thiết lập Database PostgreSQL trên Supabase](#2-thiết-lập-database-postgresql-trên-supabase)
3. [Cấu hình và khởi chạy Backend API](#3-cấu-hình-và-khởi-chạy-backend-api)
4. [Cấu hình và khởi chạy Ứng dụng Flutter](#4-cấu-hình-và-khởi-chạy-ứng-dụng-flutter)
5. [Kịch bản Demo chi tiết từng bước](#5-kịch-bản-demo-chi-tiết-từng-bước)
6. [Checklist an toàn trước khi đẩy mã nguồn lên Git](#6-checklist-an-toàn-trước-khi-đẩy-mã-nguồn-lên-git)
7. [Khắc phục sự cố thường gặp (Troubleshooting)](#7-khắc-phục-sự-cố-thường-gặp-troubleshooting)

---

## 1. Yêu cầu hệ thống

Trước khi bắt đầu, đảm bảo máy tính đã cài đặt:
- **Node.js**: Phiên bản 18.x hoặc 20.x trở lên (khuyên dùng LTS 20+) kèm `npm`.
- **Flutter SDK**: Phiên bản 3.22.x trở lên và Dart SDK tương ứng.
- **Trình duyệt Google Chrome**: Dùng để chạy và kiểm thử Flutter Web.
- **Tài khoản Supabase**: Miễn phí tại [https://supabase.com](https://supabase.com).

---

## 2. Thiết lập Database PostgreSQL trên Supabase

Dự án StayNest sử dụng cơ sở dữ liệu PostgreSQL chuẩn với các bảng lưu trữ người dùng, điểm đến, cơ sở lưu trú, loại phòng, đơn đặt phòng, voucher và thanh toán demo.

### Bước 2.1: Tạo Project mới trên Supabase
1. Đăng nhập vào [Supabase Dashboard](https://supabase.com/dashboard).
2. Nhấn nút **New Project**.
3. Điền các thông tin:
   - **Name**: `staynest-db` (hoặc tên tùy chọn).
   - **Database Password**: Nhập mật khẩu mạnh và **ghi nhớ mật khẩu này**.
     > *Mẹo: Nếu mật khẩu có chứa các ký tự đặc biệt (ví dụ `@`, `:`, `/`, `#`, `%`), khi đưa vào chuỗi kết nối URI bạn cần URL-encode ký tự đó.*
   - **Region**: Chọn khu vực gần bạn nhất (ví dụ: `Singapore - ap-southeast-1`).
   - **Pricing Plan**: Chọn Free Tier.
4. Nhấn **Create new project** và đợi 1-2 phút để Supabase chuẩn bị cụm cơ sở dữ liệu.

### Bước 2.2: Lấy Connection String (URI)
1. Trong màn hình project trên Supabase, vào menu bên trái: **Project Settings** (biểu tượng bánh răng) ➜ chọn **Database**.
2. Kéo xuống phần **Connection string**:
   - Chọn tab **URI**.
   - Chọn chế độ **Direct Connection** (cổng `5432`) hoặc **Session Pooler** (cổng `5432` / `6543`).
   - Chuỗi kết nối có dạng:
     ```text
     postgresql://postgres:[YOUR-PASSWORD]@db.[PROJECT-REF].supabase.co:5432/postgres
     ```
   - Thay thế `[YOUR-PASSWORD]` bằng mật khẩu bạn đã đặt ở Bước 2.1.

### Bước 2.3: Tải chứng chỉ SSL (CA Certificate)
Supabase yêu cầu kết nối bảo mật qua SSL/TLS:
1. Cũng tại trang **Project Settings** ➜ **Database**, tìm mục **SSL Configuration**.
2. Nhấn nút **Download certificate** để tải file chứng chỉ về máy (tên mặc định thường là `prod-ca-2021.crt`).
3. Đổi tên hoặc di chuyển file này vào thư mục `backend/` của dự án StayNest:
   ```text
   backend/supabase-ca.crt
   ```
   *(File này đã được khai báo trong `.gitignore` để không bao giờ bị lộ lên kho mã nguồn Git).*

### Bước 2.4: Khởi tạo bảng dữ liệu (Migrations & Seed)
Bạn có thể khởi tạo schema bằng 1 trong 2 cách sau:

#### Cách A: Chạy migration tự động bằng lệnh CLI (Khuyên dùng)
Sau khi cấu hình file `backend/.env` (xem Mục 3), bạn chỉ cần chạy lệnh từ terminal dự án:
```bash
# 1. Chạy migration tạo bảng
npm run migrate --prefix backend

# 2. Nạp dữ liệu mẫu (Homestay, Phòng, Tiện nghi, Voucher)
ALLOW_DEMO_SEED=1 npm run seed --prefix backend
```

#### Cách B: Chạy qua giao diện Supabase SQL Editor
1. Trên Supabase Dashboard, bấm vào mục **SQL Editor** ở thanh menu bên trái.
2. Bấm **New query**.
3. Mở file [backend/db/migrations/001_initial.sql](file:///media/tho/NEW%20DATA/StayNest/backend/db/migrations/001_initial.sql) trong project, sao chép toàn bộ nội dung và dán vào SQL Editor.
4. Nhấn nút **Run** (màu xanh lá). Sau khi hoàn thành, toàn bộ 21 bảng nghiệp vụ sẽ được tạo trong schema `public`.
5. Vào menu **Table Editor** trên Supabase để xác nhận các bảng như `users`, `properties`, `room_types`, `bookings` đã xuất hiện.

---

## 3. Cấu hình và khởi chạy Backend API

Backend StayNest được xây dựng bằng Node.js + Express, xử lý toàn bộ logic nghiệp vụ, bảo mật, xác thực người dùng và kết nối trực tiếp với PostgreSQL.

### Bước 3.1: Cài đặt dependencies
Từ thư mục gốc của dự án, chạy:
```bash
npm install --prefix backend
```

### Bước 3.2: Tạo file cấu hình `backend/.env`
Tạo file `backend/.env` bằng cách nhân bản từ file mẫu:
```bash
cp backend/.env.example backend/.env
```

Mở file `backend/.env` và cập nhật thông tin thực tế:
```dotenv
HOST=127.0.0.1
PORT=3000
NODE_ENV=development

# Chuỗi kết nối PostgreSQL Supabase đã lấy ở Mục 2.2
DATABASE_URL=postgresql://postgres:MAT_KHAU_CUA_BAN@db.hjxhakavxfgxuovmshae.supabase.co:5432/postgres

# Bắt buộc bật SSL cho database lưu trữ qua mạng Internet
DATABASE_SSL=1

# Đường dẫn tuyệt đối tới file chứng chỉ đã tải ở Mục 2.3
DATABASE_SSL_CA_FILE=/media/tho/NEW DATA/StayNest/backend/supabase-ca.crt

# Tắt chế độ in-memory (PGlite) để sử dụng PostgreSQL thật
STAYNEST_EMBEDDED_DEMO=0

# Danh sách Origin được phép truy cập CORS từ Flutter Web
CORS_ORIGINS=http://127.0.0.1:8080,http://localhost:8080,http://127.0.0.1:8090,http://127.0.0.1:8087

# Cho phép seed dữ liệu mẫu trong môi trường dev
ALLOW_DEMO_SEED=1
SEED_DEMO_PASSWORD=StayNestDemo@2026
```

> **Lưu ý an toàn:** File `backend/.env` chứa mật khẩu thực tế nên đã được cấu hình trong `.gitignore`. Tuyệt đối không commit file này lên Git.

### Bước 3.3: Chạy kiểm tra và khởi động Server
1. Chạy bộ kiểm thử tự động của backend:
   ```bash
   npm test --prefix backend
   ```
   *(Đảm bảo toàn bộ 24/24 unit & integration test đều Passed).*

2. Khởi động máy chủ backend:
   ```bash
   # Chạy chế độ development tự động reload khi sửa code:
   npm run dev --prefix backend

   # Hoặc chạy chế độ thông thường:
   npm start --prefix backend
   ```
   Khi khởi động thành công, màn hình sẽ thông báo:
   ```text
   StayNest API listening on http://127.0.0.1:3000
   ```

3. Mở một terminal mới để kiểm tra trạng thái hoạt động:
   ```bash
   curl http://127.0.0.1:3000/api/v1/health
   # Trả về: {"status":"ok","service":"staynest-api"}

   curl http://127.0.0.1:3000/api/v1/health/ready
   # Trả về: {"status":"ready"}
   ```

---

## 4. Cấu hình và khởi chạy Ứng dụng Flutter

Frontend StayNest được thiết kế chuẩn Mobile-first theo Figma Page 1, sử dụng Flutter, Riverpod và GoRouter. Khi mở trên màn hình rộng (Desktop Web / Tablet), giao diện tự động căn giữa trong mobile frame 390px chuẩn điện thoại.

### Bước 4.1: Cài đặt gói thư viện Flutter
Từ thư mục gốc dự án:
```bash
flutter pub get
```

### Bước 4.2: Khởi chạy trên trình duyệt Web (Khuyên dùng cho Demo)
Chạy lệnh sau để khởi chạy ứng dụng web trên cổng `8080` kết nối tới Backend API:
```bash
flutter run -d chrome --web-port=8080 --dart-define=STAYNEST_API_URL=http://127.0.0.1:3000
```

> **Giải thích tham số:**
> - `-d chrome`: Mở trực tiếp bằng Google Chrome.
> - `--web-port=8080`: Cố định cổng 8080 để khớp với cấu hình CORS trong `backend/.env`.
> - `--dart-define=STAYNEST_API_URL=http://127.0.0.1:3000`: Chỉ định URL của backend API.

### Bước 4.3: Khởi chạy trên thiết bị Android / Giả lập
Nếu chạy trên Android Emulator:
```bash
# Trên Android Emulator, 10.0.2.2 là địa chỉ IP trỏ về localhost máy trạm:
flutter run -d android --dart-define=STAYNEST_API_URL=http://10.0.2.2:3000
```

---

## 5. Kịch bản Demo chi tiết từng bước

Dưới đây là kịch bản chuẩn để trình diễn toàn bộ tính năng của ứng dụng:

### 🌟 Bước 1: Trải nghiệm Giao diện Khám phá (Explore & Discovery)
1. Truy cập ứng dụng tại `http://127.0.0.1:8080`.
2. Quan sát giao diện:
   - Trên desktop browser, ứng dụng được bọc trong khung điện thoại 390px thanh lịch ở giữa màn hình.
   - Banner chào mừng, thanh tìm kiếm nhanh, các tab gợi ý điểm đến nổi bật (Hội An, Đà Lạt, Đà Nẵng).
3. Thử nghiệm tương tác:
   - Bấm vào biểu tượng điểm đến Đà Nẵng hoặc Đà Lạt.
   - Bấm nút **"Xem tất cả"** hoặc click trực tiếp vào các card chỗ ở như **"Pine Hill Homestay"** hoặc **"Ocean Pearl Hotel"**.

### 🌟 Bước 2: Xem Chi tiết Chỗ ở giàu thông tin (Property Detail)
1. Nhấp chọn **"Mây Homestay"** hoặc **"Pine Hill Homestay"**:
   - Bộ sưu tập ảnh thực tế (gallery).
   - Đánh giá sao, số lượt nhận xét, địa chỉ chi tiết.
   - Danh sách tiện ích đầy đủ (Wi-Fi tốc độ cao, điều hòa, bãi đỗ xe,...).
   - Chính sách hủy phòng minh bạch và cam kết đặt phòng an toàn.
   - Vị trí trên bản đồ minh họa.
2. Bấm nút **"Chọn phòng"** ở thanh ghim dưới cùng (Sticky bottom CTA) hoặc trong danh sách phòng.

### 🌟 Bước 3: Lựa chọn phòng & Cấu hình Đặt phòng (Room Selection)
1. Màn hình danh sách phòng mở ra với dữ liệu động:
   - Hiển thị tên chỗ ở và số đêm lưu trú trên thanh tiêu đề.
   - Xem các hạng phòng: *Phòng Studio Ban Công View Vườn*, *Phòng Đồi Thông View Mây*,...
   - Xem thông tin số khách tối đa, loại giường và giá tiền từng đêm bằng tiền VND rõ ràng.
2. Bấm chọn loại phòng mong muốn để chuyển sang màn hình **Tóm tắt Đặt phòng (Booking Summary)**.

### 🌟 Bước 4: Đăng ký & Đăng nhập Tài khoản mới (Authentication)
1. Tại bước nhập thông tin khách hàng, nếu chưa đăng nhập:
   - Chọn chuyển sang màn hình **Đăng ký tài khoản (Sign Up)**.
2. Điền thông tin:
   - **Họ và tên**: Ví dụ `Nguyễn Văn An`
   - **Email**: `an.test@example.com`
   - **Số điện thoại**: `0901234567`
   - **Mật khẩu**: `password123` (tối thiểu 8 ký tự)
   - Tích chọn đồng ý Điều khoản dịch vụ.
3. Bấm **"Đăng ký"**:
   - Hệ thống tự động mã hóa mật khẩu, lưu người dùng vào bảng `users` trên Supabase và tạo phiên đăng nhập an toàn.
   - Tự động điền họ tên, email, số điện thoại của bạn vào hồ sơ đặt phòng.

### 🌟 Bước 5: Áp mã Voucher & Thanh toán Demo (Payment & My Trips)
1. Tại màn hình tính tiền và thanh toán:
   - Xem bảng chiết tính chi phí minh bạch (giá phòng x số đêm + phí dịch vụ).
   - Chọn áp dụng mã giảm giá có sẵn (ví dụ: `CHAOBANMOI` hoặc `STAYNEST100K`).
2. Chọn phương thức thanh toán demo:
   - Thẻ tín dụng/ghi nợ quốc tế (Demo).
   - Ví điện tử MoMo / ZaloPay (Demo).
   - Chuyển khoản ngân hàng QR (Demo).
3. Bấm nút **"Thanh toán ngay"**:
   - Hệ thống ghi nhận giao dịch demo, trừ số lượng phòng khả dụng và tạo mã đặt phòng thành công.
4. Màn hình hiển thị thông báo **Đặt phòng thành công** kèm mã vé và chi tiết nhận phòng.
5. Chuyển sang tab **"Chuyến đi" (My Trips)** trên thanh điều hướng dưới đáy màn hình:
   - Bạn sẽ thấy đơn đặt phòng vừa tạo xuất hiện ở trạng thái **"Đã xác nhận"**.
   - Vào Supabase Dashboard ➜ **Table Editor** ➜ chọn bảng `bookings` để kiểm chứng dữ liệu thực tế vừa được lưu trữ.

---

## 6. Checklist an toàn trước khi đẩy mã nguồn lên Git

Trước khi thực hiện `git add`, `git commit` và `git push`, hãy đảm bảo tuân thủ các nguyên tắc bảo mật sau:

### ✅ Các file TUYỆT ĐỐI KHÔNG commit lên Git:
- [x] `backend/.env`: Chứa mật khẩu cơ sở dữ liệu thật và các biến môi trường nhạy cảm.
- [x] `backend/supabase-ca.crt` (hoặc các file đuôi `*.crt`, `*.pem`, `*.key`): File chứng chỉ TLS/SSL.
- [x] `backend/node_modules/`: Thư viện cài đặt của Node.js.
- [x] `.dart_tool/`, `build/`: Thư mục build của Flutter.

### ✅ Các file NÊN commit:
- [x] `backend/.env.example`: File mẫu (chỉ chứa placeholder, không chứa mật khẩu thật).
- [x] Toàn bộ mã nguồn `lib/`, `backend/src/`, `backend/db/migrations/`.
- [x] `SETUP.md` và `README.md`.
- [x] `.gitignore`.

### 🔍 Lệnh kiểm tra an toàn nhanh:
```bash
# Kiểm tra các file đang chuẩn bị commit:
git status

# Đảm bảo không thấy xuất hiện .env hay .crt:
git status | grep -E "(\.env|\.crt|\.pem|\.key)"
# (Nếu lệnh trên không in ra kết quả gì là hoàn toàn an toàn!)
```

---

## 7. Khắc phục sự cố thường gặp (Troubleshooting)

### 1. Lỗi `ClientException: Failed to fetch, uri=http://127.0.0.1:3000/...`
- **Nguyên nhân:** Máy chủ backend chưa được khởi chạy hoặc cổng 3000 bị chặn.
- **Cách xử lý:** Mở một cửa sổ terminal mới và chạy:
  ```bash
  npm start --prefix backend
  ```
  Đảm bảo thấy thông báo `StayNest API listening on http://127.0.0.1:3000`.

### 2. Lỗi `SELF_SIGNED_CERT_IN_CHAIN` khi kết nối Supabase
- **Nguyên nhân:** Node.js từ chối chứng chỉ SSL của bên thứ ba khi thiếu chứng chỉ CA gốc của Supabase.
- **Cách xử lý:** Đảm bảo bạn đã tải file `supabase-ca.crt` về `backend/` và cấu hình trong `backend/.env`:
  ```dotenv
  DATABASE_SSL=1
  DATABASE_SSL_CA_FILE=/đường/dẫn/tới/backend/supabase-ca.crt
  ```

### 3. Lỗi `PostgreSQL is not configured` (HTTP 503)
- **Nguyên nhân:** Biến `DATABASE_URL` trong `backend/.env` đang để trống hoặc file `.env` chưa được đọc.
- **Cách xử lý:** Mở `backend/.env` kiểm tra lại dòng `DATABASE_URL=postgresql://...`. Mã nguồn `backend/src/config.js` đã được cập nhật để tự động đọc file này.

### 4. Lỗi `getaddrinfo ENOTFOUND db.xxxx.supabase.co`
- **Nguyên nhân:** Máy tính bị mất kết nối Internet hoặc domain của Supabase không phân giải được DNS.
- **Cách xử lý:** Kiểm tra kết nối mạng hoặc ping thử domain Supabase của bạn.

---

Chúc bạn có buổi demo dự án **StayNest** thành công rực rỡ! Nếu cần hỗ trợ thêm bất kỳ luồng chức năng nào, hãy liên hệ đội ngũ phát triển.

