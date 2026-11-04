# Hướng dẫn Thiết lập, Chạy & Demo Dự án StayNest

Tài liệu này hướng dẫn chi tiết từ A-Z cách thiết lập môi trường, cấu hình cơ sở dữ liệu **Supabase PostgreSQL**, khởi chạy dự án bằng **Docker** (dành cho người có Docker) hoặc **thủ công** (dành cho người không có Docker), cách kết nối và xuất file APK lên **Điện thoại Android thật**, cùng **kịch bản Demo chuẩn 100 màn hình Figma**.

---

## 📋 Mục lục
1. [Yêu cầu hệ thống](#1-yêu-cầu-hệ-thống)
2. [Cấu hình Cơ sở dữ liệu Supabase PostgreSQL](#2-cấu-hình-cơ-sở-dữ-liệu-supabase-postgresql)
3. [PHƯƠNG ÁN A: Chạy dự án bằng DOCKER (Khuyên dùng - 1 Lệnh duy nhất)](#3-phương-án-a-chạy-dự-án-bằng-docker-khuyên-dùng---1-lệnh-duy-nhất)
4. [PHƯƠNG ÁN B: Chạy dự án KHÔNG DÙNG DOCKER (Thủ công)](#4-phương-án-b-chạy-dự-án-không-dùng-docker-thủ-công)
5. [PHƯƠNG ÁN C: Chạy và kết nối với ĐIỆN THOẠI ANDROID (Xuất file APK)](#5-phương-án-c-chạy-và-kết-nối-với-điện-thoại-android-xuất-file-apk)
6. [Kịch bản Demo chi tiết từng bước (Chuẩn 100 màn hình Figma)](#6-kịch-bản-demo-chi-tiết-từng-bước-chuẩn-100-màn-hình-figma)
7. [Tài khoản Demo & Đăng ký người dùng mới](#7-tài-khoản-demo--đăng-ký-người-dùng-mới)
8. [Checklist an toàn trước khi Push lên Git](#8-checklist-an-toàn-trước-khi-push-lên-git)
9. [Khắc phục sự cố thường gặp (Troubleshooting)](#9-khắc-phục-sự-cố-thường-gặp-troubleshooting)

---

## 1. Yêu cầu hệ thống

Tùy theo phương án chạy mà bạn chọn, máy tính cần đáp ứng:

| Phương án | Yêu cầu tối thiểu |
| :--- | :--- |
| **Dùng Docker** | • Docker Engine 24+ & Docker Compose v2+<br>• Trình duyệt Chrome / Edge / Firefox |
| **Không dùng Docker** | • Node.js LTS 20+ kèm `npm`<br>• Flutter SDK 3.22+ (kênh stable)<br>• Trình duyệt Google Chrome |
| **Chạy trên Android** | • Android SDK 34+ (có `adb`)<br>• Cáp USB hoặc cùng mạng Wi-Fi với máy tính |

---

## 2. Cấu hình Cơ sở dữ liệu Supabase PostgreSQL

Dự án StayNest sử dụng cơ sở dữ liệu PostgreSQL chuẩn để lưu trữ người dùng, homestay/khách sạn, loại phòng, đơn đặt phòng, voucher và thanh toán.

### Bước 2.1: Lấy thông tin từ Supabase Dashboard
1. Đăng nhập [Supabase Dashboard](https://supabase.com/dashboard) và mở project của bạn.
2. Vào **Project Settings** (biểu tượng bánh răng) ➜ **Database**:
   - Sao chép chuỗi kết nối **URI** (Direct Connection port `5432` hoặc Pooler port `6543`):
     ```text
     postgresql://postgres:[MAT_KHAU_CUA_BAN]@db.[PROJECT-REF].supabase.co:5432/postgres
     ```
   - Tại mục **SSL Configuration**, nhấn nút **Download certificate** để tải file chứng chỉ SSL (thường tên là `prod-ca-2021.crt`).
3. Đổi tên và di chuyển file chứng chỉ vào thư mục backend:
   ```text
   backend/supabase-ca.crt
   ```

### Bước 2.2: Tạo file cấu hình `backend/.env`
Tạo file `backend/.env` từ file mẫu:
```bash
cp backend/.env.example backend/.env
```
Mở file `backend/.env` và cập nhật thông tin:
```dotenv
HOST=0.0.0.0
PORT=3000
NODE_ENV=development

# Thay [MAT_KHAU] bằng mật khẩu database Supabase của bạn
DATABASE_URL=postgresql://postgres:[MAT_KHAU]@db.hjxhakavxfgxuovmshae.supabase.co:5432/postgres

DATABASE_SSL=1
DATABASE_SSL_CA_FILE=/media/tho/NEW DATA/StayNest/backend/supabase-ca.crt

STAYNEST_EMBEDDED_DEMO=0
CORS_ORIGINS=http://127.0.0.1:8080,http://localhost:8080,http://127.0.0.1:8090,http://127.0.0.1:8087
ALLOW_DEMO_SEED=1
```

> **Ghi chú:** File `backend/.env` và `backend/supabase-ca.crt` đã được đưa vào `.gitignore` để bảo mật, không bao giờ bị đẩy lên Git.

---

## 3. PHƯƠNG ÁN A: Chạy dự án bằng DOCKER (Khuyên dùng - 1 Lệnh duy nhất)

Nếu máy tính của bạn hoặc người chấm/đồng nghiệp **đã cài đặt Docker**, đây là cách tiện lợi và ổn định nhất. Không cần cài Flutter, không cần cài Node.js trên máy trạm.

### 🚀 Khởi chạy hệ sinh thái StayNest
Mở terminal tại thư mục gốc của dự án và chạy:

```bash
docker compose up --build -d
```

Docker sẽ tự động:
1. Build container **Backend API** (Node.js 20, tự động map thư mục ảnh `/media`).
2. Build container **Frontend** (Flutter Web chạy trên nền Nginx).
3. **Nginx Reverse Proxy:** Nginx trên cổng `8080` tự động chuyển tiếp toàn bộ request `/api/` và `/media/` về Backend container ➜ **Loại bỏ 100% lỗi CORS và lỗi kết nối mạng**.

### 🌐 Trải nghiệm ứng dụng:
- **Giao diện Web:** Mở trình duyệt tại 👉 [http://localhost:8080](http://localhost:8080)
- **Kiểm tra trạng thái Backend:** 👉 [http://localhost:3000/api/v1/health/ready](http://localhost:3000/api/v1/health/ready) (Trả về `{"status":"ready"}`)

### 🛠️ Chạy Offline hoàn toàn (Không cần kết nối Supabase):
Nếu bạn đang ở nơi không có mạng Internet hoặc muốn dùng PostgreSQL cục bộ trong Docker:
```bash
docker compose --profile local-db up --build -d
```
Container `staynest-postgres` sẽ tự động khởi động trên cổng 5432 và lưu trữ dữ liệu bền vững.

### 🛑 Các lệnh quản lý Docker:
```bash
# Xem logs thời gian thực của cả hệ thống:
docker compose logs -f

# Xem logs riêng của backend:
docker logs -f staynest-backend

# Dừng toàn bộ hệ thống:
docker compose down
```

---

## 4. PHƯƠNG ÁN B: Chạy dự án KHÔNG DÙNG DOCKER (Thủ công)

Dành cho máy tính phát triển thông thường đã có sẵn **Node.js** và **Flutter SDK**. Bạn cần mở **2 cửa sổ Terminal**:

### 🔹 Terminal 1: Khởi động Backend API
```bash
# 1. Cài đặt dependencies (chỉ cần chạy lần đầu)
npm install --prefix backend

# 2. Khởi chạy server API (chế độ development tự reload)
cd backend && npm run dev
```
> Khi màn hình báo: `StayNest API listening on http://0.0.0.0:3000` là backend đã sẵn sàng.

### 🔹 Terminal 2: Khởi động Flutter Web
```bash
# 1. Lấy packages Flutter (chỉ cần chạy lần đầu)
flutter pub get

# 2. Chạy ứng dụng trên Chrome
flutter run -d chrome --web-port=8080 --dart-define=STAYNEST_API_URL=http://127.0.0.1:3000
```
> Trình duyệt Chrome sẽ tự động bật lên với giao diện khung điện thoại 390px chuẩn mobile app căn giữa màn hình.

---

## 5. PHƯƠNG ÁN C: Chạy và kết nối với ĐIỆN THOẠI ANDROID (Xuất file APK)

Ứng dụng StayNest đã được thiết kế chuẩn Figma Mobile-first, tích hợp sẵn quyền Internet và cấu hình mạng Android.

### 📍 Vị trí file APK đã build sẵn trong dự án:
- **Bản Release (Tối ưu ~63MB, cài đặt cực nhanh):**
  ```text
  build/app/outputs/flutter-apk/app-release.apk
  ```
- **Bản Debug (~171MB):**
  ```text
  build/app/outputs/flutter-apk/app-debug.apk
  ```

---

### 📱 Cách 1: Kết nối trực tiếp qua cáp USB (Nhanh nhất & Dễ nhất khi lập trình)

1. **Bật chế độ gỡ lỗi trên điện thoại Android:**
   - Vào **Cài đặt (Settings)** ➜ **Thông tin điện thoại (About phone)** ➜ Nhấn 7 lần liên tục vào **Số bản dựng (Build number)** để bật *Tùy chọn nhà phát triển (Developer options)*.
   - Quay lại Cài đặt ➜ **Tùy chọn nhà phát triển** ➜ Bật **Gỡ lỗi USB (USB Debugging)**.
2. **Cắm cáp USB nối điện thoại với máy tính:**
   - Trên màn hình điện thoại hiện pop-up: *"Cho phép gỡ lỗi USB từ máy tính này?"* ➜ Chọn **Luôn cho phép**.
3. **Mở terminal máy tính chạy 2 lệnh sau:**
   ```bash
   # Bước 1: Forward cổng backend qua cáp USB (cực kỳ quan trọng để app trên điện thoại gọi thẳng backend máy tính):
   adb reverse tcp:3000 tcp:3000

   # Bước 2: Cài đặt trực tiếp file APK lên điện thoại:
   adb install -r "build/app/outputs/flutter-apk/app-release.apk"
   ```
   *(Hoặc bạn có thể gõ `flutter run` để chạy trực tiếp và dùng tính năng Hot Reload trên điện thoại).*

---

### 📡 Cách 2: Cài độc lập qua Wi-Fi (Không cần cắm cáp USB)

Nếu bạn muốn gửi file APK cho bạn bè hoặc cài lên điện thoại dùng qua mạng không dây:

1. **Điều kiện:** Điện thoại và máy tính phải **kết nối cùng 1 mạng Wi-Fi**.
2. **Lấy IP Wi-Fi của máy tính:**
   - Trên Linux/macOS: Chạy `ip route get 1.1.1.1` hoặc `ifconfig` (Ví dụ IP máy là `192.168.1.215`).
   - Trên Windows: Chạy `ipconfig`.
3. **Build file APK trỏ về IP máy tính:**
   ```bash
   flutter build apk --release --dart-define=STAYNEST_API_URL=http://192.168.1.215:3000
   ```
4. **Cài đặt lên điện thoại:**
   - Gửi file `build/app/outputs/flutter-apk/app-release.apk` qua điện thoại (bằng Zalo, Google Drive, hoặc Bluetooth).
   - Nhấn vào file APK trên điện thoại ➜ Chọn **Cài đặt** (Nếu Android cảnh báo bảo mật, chọn *Vẫn cài đặt / Install anyway*).
   - Đảm bảo Backend trên máy tính đang chạy (`npm run dev` trong thư mục `backend/`).

---

## 6. Kịch bản Demo chi tiết từng bước (Chuẩn 100 màn hình Figma)

StayNest tái hiện chính xác **100 màn hình Figma** (SCR-001 đến SCR-100). Sau đây là kịch bản dẫn dắt buổi demo trôi chảy:

### 🌟 Luồng 1: Khởi động & Onboarding (SCR-001 ➜ SCR-005)
1. Mở ứng dụng lần đầu tiên:
   - **SCR-001 (Splash):** Hiển thị màn hình Splash màu xanh thương hiệu teal với logo StayNest trong 1.2 giây.
   - **SCR-002, SCR-003, SCR-004:** Trượt qua 3 màn hình Onboarding giới thiệu tính năng tìm kiếm homestay, đặt phòng linh hoạt, ưu đãi độc quyền.
   - Có thể bấm **"Bỏ qua"** bất cứ lúc nào hoặc bấm **"Tiếp tục"** qua từng slide.
   - **SCR-005 (Welcome):** Màn hình chào mừng với 2 nút Đăng nhập / Đăng ký hoặc Khám phá ngay.
2. *Lưu ý:* Hệ thống tự động lưu trạng thái hoàn thành Onboarding bằng bộ nhớ an toàn (`FlutterSecureStorage`). Các lần mở app tiếp theo sẽ đi thẳng từ Splash vào Trang chủ (SCR-006).

---

### 🌟 Luồng 2: Khám phá & Bộ lọc tìm kiếm 2 chặng (SCR-006 ➜ SCR-031 ➜ SCR-028 ➜ SCR-029)
1. Tại Trang chủ:
   - Thanh tìm kiếm nhanh "Tìm chỗ ở".
   - Chip điểm đến nhanh (Hội An, Đà Nẵng, Đà Lạt).
   - Danh sách chỗ ở nổi bật: **Mây Homestay**, **Pine Hill Homestay**, **Ocean Pearl Hotel**.
2. Nhấn vào thanh tìm kiếm hoặc nút **"Xem tất cả"** ➜ Chuyển tới **SCR-031 (Search Results)**.
3. Bấm nút **"Lọc" (Filter chip)**:
   - Mở **SCR-028 (Bộ lọc Giá & Loại chỗ ở)**: Kéo chọn khoảng giá (ví dụ: 500.000đ - 2.500.000đ), chọn loại chỗ ở: Homestay / Khách sạn / Căn hộ.
   - Bấm nút **"Tiếp tục"** ➜ Chuỗi điều hướng thông minh mở tiếp **SCR-029 (Bộ lọc Tiện nghi)**.
   - Chọn các tiện nghi: Wi-Fi, Bể bơi, Cho phép thú cưng, Bếp,...
   - Bấm **"Xem kết quả"** ➜ Quay lại **SCR-031** với danh sách phòng được lọc chuẩn xác, badge số lượng bộ lọc đang hoạt động được hiển thị sinh động.

---

### 🌟 Luồng 3: Chi tiết Chỗ ở ➜ Chọn phòng ➜ Đặt phòng ➜ Thanh toán (SCR-037 ➜ SCR-055)
1. Bấm vào bất kỳ card chỗ ở nào (ví dụ: **Pine Hill Homestay** hoặc **Mây Homestay**):
   - Mở màn hình chi tiết giàu thông tin: Bộ sưu tập ảnh (Gallery), đánh giá sao, bản đồ vị trí, chính sách hủy phòng, danh sách tiện nghi và sticky CTA bar ở đáy màn hình.
2. Bấm **"Chọn phòng"**:
   - Danh sách loại phòng mở ra với giá tiền và số khách tối đa.
   - Bấm **"Chọn phòng này"** ➜ Chuyển sang màn hình Tóm tắt đặt phòng (Booking Summary).
3. Đăng nhập hoặc Đăng ký:
   - Nếu chưa đăng nhập, chọn Đăng ký tài khoản mới: Nhập Họ tên, Email, Số điện thoại, Mật khẩu. Bấm Đăng ký -> Tài khoản được tạo và lưu ngay vào database Supabase PostgreSQL!
   - Thông tin cá nhân tự động điền sẵn vào đơn đặt phòng mà không cần nhập lại.
4. Báo giá & Thanh toán:
   - Hệ thống tự động tính chiết tính giá phòng theo số đêm (VND chuẩn, không bao giờ flash 0đ).
   - Chọn phương thức thanh toán demo (Thẻ ngân hàng / MoMo / Chuyển khoản QR).
   - Bấm **"Thanh toán ngay"** ➜ Nhận thông báo **Đặt phòng thành công (SCR-055)** kèm mã đặt phòng (Booking ID).

---

### 🌟 Luồng 4: Quản lý Chuyến đi & Các subflow mở rộng (SCR-081 ➜ SCR-100)
Chuyển sang tab **"Chuyến đi" (Trips)** ở thanh điều hướng dưới đáy màn hình:
1. **SCR-081 & SCR-082:** Hiển thị danh sách chuyến đi đã đặt với badge "Đã xác nhận". Nhấn để mở Chi tiết đặt phòng.
2. Từ chi tiết đặt phòng, bấm trải nghiệm các subflow:
   - **SCR-083 (Voucher xác nhận):** Xem vé xác nhận phòng điện tử có mã vạch / QR code.
   - **SCR-084 (Chỉ đường):** Xem bản đồ và chỉ dẫn đường đi tới homestay.
   - **SCR-085 ➜ SCR-086 (Đổi ngày lưu trú):** Chọn ngày nhận/trả phòng mới và nhận kết quả xác nhận đổi lịch.
   - **SCR-087 ➜ SCR-090 (Hủy phòng & Hoàn tiền):** Xem chính sách hoàn tiền ➜ Chọn lý do hủy ➜ Xác nhận hủy phòng và tính toán số tiền hoàn trả minh bạch.
   - **SCR-095 (Đánh giá chuyến đi):** Viết nhận xét và chấm điểm sao sau kỳ nghỉ.
3. Nếu chưa có chuyến đi nào, tab Chuyến đi sẽ hiển thị màn hình trống thân thiện **SCR-099** với nút bấm *"Khám phá chỗ ở"* đưa người dùng về trang chủ.

---

### 🌟 Luồng 5: Menu bí mật Debug Figma Gallery (`/debug/figma-screens`)
Dành riêng cho giảng viên, hội đồng chấm điểm hoặc tester kiểm tra toàn bộ 100 màn hình:
- Trong trình duyệt web, gõ thẳng đường dẫn:
  👉 **`http://localhost:8080/debug/figma-screens`**
- Giao diện tra cứu 100 màn hình Figma được phân thành 6 nhóm danh mục:
  1. *Khởi động & Xác thực (SCR-001 đến SCR-027)*
  2. *Khám phá & Bộ lọc (SCR-028 đến SCR-036)*
  3. *Chi tiết & Đặt phòng (SCR-037 đến SCR-060)*
  4. *Yêu thích & Trò chuyện (SCR-061 đến SCR-080)*
  5. *Chuyến đi & Hậu đặt phòng (SCR-081 đến SCR-100)*
  6. *Công cụ Debug nhanh:* Nút Reset cờ Onboarding (để xem lại màn Splash), Nút Đánh dấu hoàn thành, Nút Xóa bộ lọc.

---

## 7. Tài khoản Demo & Đăng ký người dùng mới

Hệ thống hỗ trợ cả đăng nhập bằng tài khoản mẫu hoặc tự tạo tài khoản mới:

### 👤 Tài khoản mẫu có sẵn trong database:
- **Email:** `demo@staynest.local` (hoặc `an.nguyen@example.com`)
- **Mật khẩu:** `DemoPassword123!` (hoặc `password123`)

### 📝 Tự đăng ký tài khoản mới:
Tại màn hình Đăng ký, nhập bất kỳ Email và Số điện thoại hợp lệ. Hệ thống sẽ:
1. Mã hóa mật khẩu bảo mật bằng chuẩn `crypto.scryptSync`.
2. Ghi trực tiếp bản ghi vào bảng `users` trên Supabase PostgreSQL.
3. Tự động duy trì phiên đăng nhập sau khi tắt mở lại ứng dụng.

---

## 8. Checklist an toàn trước khi Push lên Git

Trước khi thực hiện `git push`, hãy kiểm tra nhanh danh sách an toàn:

- [x] Không commit file mật khẩu: `backend/.env`
- [x] Không commit chứng chỉ: `backend/supabase-ca.crt`
- [x] Không commit thư viện: `backend/node_modules/`
- [x] Không commit file build nặng: `.dart_tool/`, `build/`
- [x] Đã cập nhật file mẫu: `backend/.env.example`
- [x] Toàn bộ test case đều passed:
  ```bash
  npm test --prefix backend
  flutter test
  flutter analyze lib test
  ```

---

## 9. Khắc phục sự cố thường gặp (Troubleshooting)

### 1. Lỗi `ClientException: Failed to fetch, uri=http://127.0.0.1:3000/...`
- **Nguyên nhân:** Chưa bật backend server hoặc port 3000 bị chặn.
- **Cách xử lý:** 
  - Nếu dùng Docker: Đảm bảo chạy `docker compose up -d` (Nginx tự động proxy giúp tránh hoàn toàn lỗi này).
  - Nếu chạy thủ công: Mở terminal chạy `cd backend && npm run dev` trước khi mở Flutter.

### 2. Trên điện thoại Android không tải được danh sách phòng / báo lỗi mạng
- **Nguyên nhân:** Điện thoại chưa kết nối được tới máy tính qua cổng 3000.
- **Cách xử lý:**
  - Nếu cắm cáp USB: Mở terminal chạy lệnh `adb reverse tcp:3000 tcp:3000`.
  - Nếu dùng Wi-Fi: Đảm bảo điện thoại và máy tính chung mạng Wi-Fi và build APK với IP của máy tính: `--dart-define=STAYNEST_API_URL=http://<IP_MÁY_TÍNH>:3000`.

### 3. Lỗi `SELF_SIGNED_CERT_IN_CHAIN` khi kết nối Supabase
- **Nguyên nhân:** Thiếu chứng chỉ SSL CA của Supabase.
- **Cách xử lý:** Tải file chứng chỉ từ Supabase Dashboard về lưu tại `backend/supabase-ca.crt` và kiểm tra cấu hình `DATABASE_SSL=1` trong `backend/.env`.

---

Chúc bạn có buổi demo dự án **StayNest** thành công rực rỡ! Nếu cần hỗ trợ thêm bất kỳ luồng chức năng nào, hãy liên hệ đội ngũ phát triển.
