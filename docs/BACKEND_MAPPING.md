# StayNest Page 1: màn hình → API → dữ liệu

Ngày 2026-11-04. Đối chiếu từ `lib/main.dart`, các screen Flutter và `docs/FIGMA_ANALYSIS.md`. `staynest_schema.sql` được người dùng gửi tại `/home/dat/Downloads/staynest_schema.sql`. File gốc là MySQL 8; migration `backend/db/migrations/001_initial.sql` đã chuyển sang PostgreSQL và điều chỉnh theo Flutter Page 1. Page 2–3 không thuộc phạm vi.

| Màn hình / luồng | API dự kiến (`/api/v1`) | Bảng chính | Trạng thái đích |
|---|---|---|---|
| SCR-001–005 onboarding, welcome | Không cần API | — | UI tĩnh |
| SCR-006–010 đăng ký, đăng nhập, OTP | `/auth/register`, `/auth/login`, `/me`, `/logout` | users, auth_sessions | Đăng ký/đăng nhập nối API; OTP là demo, không dùng để xác thực tài khoản |
| SCR-011–014 quên/đổi mật khẩu | Chưa mở API gửi mã | — | Mô phỏng, không báo đổi mật khẩu thành công thật |
| SCR-015–020 tài khoản, hồ sơ | `/me` GET/PATCH | users | Hồ sơ thật; thông báo vẫn mô phỏng |
| SCR-021–040 khám phá, điểm đến, tìm kiếm, lọc | `/destinations`, `/properties` | destinations, properties, room_types, amenities, property_images | Tìm kiếm Hội An/Đà Nẵng qua API với ngày lưu trú/số khách đã chọn; bộ lọc giá/loại và sắp xếp giá/đánh giá gọi API. Khoảng cách chưa hỗ trợ vì thiếu tọa độ; map và bộ lọc tiện nghi nhiều lựa chọn vẫn mô phỏng |
| SCR-041–052 chi tiết chỗ ở, phòng, ảnh, tiện nghi, chính sách, review | `/properties/:slug`, `/properties/:slug/rooms`, `/properties/:slug/reviews` | properties, room_types, property_images, amenities, reviews | SCR-041 lấy giá phòng từ API và lưu/bỏ yêu thích qua API; SCR-049 lấy hai hạng phòng/giá từ API và chọn đúng room type cho đơn Mây (Studio hoặc Garden View); thẻ chỗ ở khác mở màn catalog detail dùng ảnh/tiện nghi/phòng từ API. Các frame chi tiết Figma riêng vẫn tĩnh, cần nối tiếp |
| SCR-053–059 yêu thích, so sánh, chat host | `/me/favorites` | favorites, properties | Yêu thích thật theo tài khoản; so sánh trên dữ liệu catalog; chat host mô phỏng |
| SCR-060–066 khách lưu trú, giá, voucher | `/booking-quotes`, `/vouchers`, `/vouchers/validate`, `/bookings` | room_types, promotions, bookings | Chọn ngày, nhập khách, quote, chọn/bỏ STAY100 và tạo booking đã nối; SCR-060 lấy quote/giá phòng API và chặn tiếp tục khi không đủ phòng; SCR-061 dùng ngày/giá tạm tính từ draft; coupon summary khác còn tĩnh |
| SCR-067–080 thanh toán, xác nhận, biên nhận | `/bookings/:id/demo-payment`, `/bookings/:id/receipt` | bookings, demo_payments | Chọn phương thức rồi gọi API demo; route thành công thật đọc booking và biên nhận demo từ API sau phản hồi thành công. Các frame thẻ/biên nhận Figma riêng vẫn là UI demo; không ghi PAN/CVV |
| SCR-081–086 đặt phòng, chuyến đi, đổi ngày | `/bookings`, `/me/bookings`, `/bookings/:id`, `/bookings/:id/change-date-requests` | bookings, date_change_requests | Danh sách/chi tiết đơn thật; yêu cầu đổi ngày chờ xử lý, không tự xác nhận. Các frame demo cũ chưa thay hết |
| SCR-087–093 hủy và theo dõi hoàn tiền | `/bookings/:id/cancellation-preview`, `/bookings/:id/cancellations`, `/bookings/:id/refund` | bookings, cancellation_requests, demo_refunds | Chi tiết đơn thật gọi preview/hủy/xem refund; refund mô phỏng, không chuyển tiền thật |
| SCR-094–095 hoàn thành, đánh giá | `/me/bookings`, `/bookings/:id/reviews` | bookings, reviews | Chi tiết đơn thật cho đánh giá sau ngày trả phòng; API chỉ cho chủ đơn đánh giá |
| SCR-096–100 FAQ, chat hỗ trợ, empty/overview | Chưa có API hỗ trợ | — | UI FAQ/chat/overview demo; chưa có vận hành hỗ trợ thật |

## Ranh giới dữ liệu

- Seed local dùng tên/giá/hình ảnh có trong Flutter Page 1, ghi rõ `demo` ở thanh toán và hoàn tiền.
- API từ chối truy cập booking, favorites, profile và review của người khác.
- Tất cả tiền là integer VND. Booking lưu snapshot giá/phí/giảm giá/chính sách hủy ngay lúc tạo.
- Booking khóa hàng `room_types` trong transaction và đếm các đơn chồng ngày trước khi ghi, tránh vượt `inventory_count`.
- Không coi các route `*-demo` trên Flutter là bằng chứng giao dịch thật.

## Điều chỉnh so với schema phác thảo

- Chuyển `AUTO_INCREMENT`, `ENUM`, `DATETIME`, `ON UPDATE` và cú pháp chỉ mục MySQL sang PostgreSQL. Giữ ID dạng `bigserial` để dễ đối chiếu.
- Bỏ role host/admin vì frontend Page 1 không có luồng quản trị; catalog seed không cần gán host giả.
- Thêm `auth_sessions` với hash token, `booking_idempotency`, `hold_expires_at` 15 phút và snapshot JSONB; đây là dữ liệu cần cho phiên, retry và giữ phòng.
- Đổi `payments`/`refunds` thành `demo_payments`/`demo_refunds` để không hàm ý thu hoặc trả tiền thật. Không có cột PAN/CVV.
- Chưa tạo bảng support chat/notification vì UI đó hiện mô phỏng, không có vận hành hỗ trợ thật.
- VAT 10%, phí dịch vụ 30.000đ và mã `STAY100` 100.000đ được lấy từ SCR-064/065 trong Flutter; đây là quy tắc demo cho seed, cần chốt lại trước sản xuất.
- Refund demo: 100% trước 48 giờ, 50% sau đó trước giờ nhận phòng, 0% sau thời điểm nhận phòng. Snapshot dùng giờ nhận phòng 14:00 múi giờ Việt Nam (+07:00) nếu catalog chưa cấu hình giờ riêng. Đây là giả định seed từ nội dung Figma, không phải cam kết chính sách pháp lý.
