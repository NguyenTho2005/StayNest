# Prompt cho Antigravity: đưa toàn bộ flow Figma StayNest vào app chạy được

Bạn là senior Flutter engineer. Hãy sửa trực tiếp project Flutter StayNest tại workspace hiện tại. Mục tiêu không phải là tạo thêm mock screen rời rạc: phải làm cho **từng SCR Figma đã có trong source trở nên truy cập được bằng luồng UI thật khi chạy app**, đúng thứ tự và giữ fidelity với design hiện tại.

Antigravity không cần kết nối Figma. Dùng tài liệu này là design contract và tái sử dụng screen, asset (`assets/images`, `assets/icons`), token và layout Flutter có sẵn. Không thay toàn bộ UI bằng Material mặc định, không tạo màn hình placeholder, không đổi tên/di chuyển asset vô cớ.

## Sự thật đã kiểm tra

Figma file `lxtqfSd3GJZKqqDNmusSyf` có 100 frame trên Page 1; Page 2/3 trống. Hầu hết đã có class/route trong `lib/screens` và `lib/main.dart`, nhưng hiện bị “dead route” hoặc không có action dẫn tới.

Các lỗi chắc chắn cần sửa:

1. `GoRouter.initialLocation` hiện là `'/'`, tức là Home. Vì vậy SCR-001 → SCR-005 không bao giờ xuất hiện khi chạy app lần đầu, mặc dù có `/splash`, `/onboarding/1..3`, `/welcome`.
2. `SplashScreen` là `StatelessWidget`, chỉ vẽ UI và không có timeout/điều hướng.
3. `SearchResultsListScreen` chỉ mở `'/search/filters/price-property'` từ nút **Lọc**. `'/search/filters/amenities'` (SCR-029) chỉ đang được mở từ Map; bấm Tiếp tục ở SCR-028 hiện `pop` thẳng về Results. Vì vậy chuỗi SCR-028 → SCR-029 không chạy.
4. Các screen Trips từ SCR-081 đến SCR-100 có route/class nhưng phần lớn chỉ tới được nếu URL route thủ công hoặc nếu API đã có booking. Người test app mới không có cách duyệt hết luồng, nhất là khi Trips rỗng.

## Phạm vi frame bắt buộc

Thực hiện và QA toàn bộ các nhóm dưới đây. Tên/frame này là nguồn chân lý:

| Nhóm | SCR cần truy cập được |
|---|---|
| Khởi động & xác thực | 001 Splash, 002–004 Onboarding, 005 Welcome, 006 Login, 007 Login lỗi, 008 Signup, 009 OTP, 010 signup thành công, 011–014 quên/đặt lại mật khẩu |
| Khám phá & tài khoản | 015 Account, 016 Profile, 017 Edit profile, 018 Update success, 019 Settings, 020 Notifications, 021 Location permission, 021 Home, 022 Destinations, 023 Offers, 024 Recommendations |
| Tìm kiếm | 025 nhập điểm đến, 026 khách/phòng, 027 ngày, **028 filter giá/loại, 029 filter tiện nghi**, 030 sort, 031 list, 032 map, 033 quick view, 034 empty, 035 loading, 036 recent search, 037 điểm đến Đà Nẵng, 038 hotel list, 039 category, 040 applied filters |
| Chỗ ở & yêu thích | 041 property detail, 042 gallery, 043 photo viewer, 044 amenities, 045 review overview, 046 review list, 047 review filter, 048 location, 049 chọn phòng, 050 room detail, 051 policies, 052 refund policy, 053 saved, 054 favorites, 055 favorites empty, 056 chọn so sánh, 057 comparison, 058 price compare, 059 host chat, 060 booking summary |
| Đặt phòng & thanh toán | 061 start booking, 062 guest info, 063 requests, 064 price, 065 coupons, 066 coupon applied, 067 payment method, 068 wallet, 069 domestic card, 070 international card, 071 confirmation, 072 processing, 073 failed, 074 success, 075 receipt, 076 post-payment guide, 077 terms, 078 missing information, 079 change payment, 080 final check |
| Chuyến đi & hỗ trợ | **081 My Trips, 082 confirmed booking detail, 083 voucher, 084 directions/contact, 085 change dates, 086 date-change result, 087 cancel start, 088 refund estimate, 089 cancellation reason, 090 cancellation success, 091 cancelled trip, 092 refund tracking, 093 refund complete, 094 completed stays, 095 review, 096 help center, 097 cancellation FAQ, 098 support chat, 099 no upcoming trips, 100 trip overview** |

## Yêu cầu triển khai bắt buộc

### A. Sửa app start cho SCR-001 → SCR-005 thực sự chạy

1. Chuyển initial entry sang bootstrap/splash (`/splash` hoặc `AppBootstrapScreen`), không khởi động trực tiếp từ Home.
2. Chuyển `SplashScreen` sang `StatefulWidget`/`ConsumerStatefulWidget`. Splash hiển thị đủ để người dùng nhìn thấy (khoảng 1–2 giây; không hard-code delay trong test), sau đó đọc cờ onboarding hoàn thành từ storage.
3. Lần cài đặt/chạy đầu: `SCR-001 → SCR-002 → SCR-003 → SCR-004 → SCR-005`.
4. Tại Welcome: CTA đăng nhập/đăng ký đi tới SCR-006/SCR-008; CTA khám phá/guest đi Home. Hoàn tất onboarding phải lưu cờ để lần mở tiếp theo đi Home hợp lý. Cung cấp cách reset onboarding chỉ trong debug/test, không đặt nút reset lộ trên production UI.
5. Back/Skip của onboarding phải đúng thứ tự, không quay vào Splash và không bị stack loop. Dùng `context.go`/`push` có chủ đích và `context.canPop()` + fallback khi cần.

### B. Làm SCR-029 thành bước lọc thực sự có thể bấm tới

1. Trong `SearchResultsListScreen`, nút **Lọc** phải bắt đầu chain:

```text
SCR-031 Results
  → SCR-028 Price & property type
  → (Tiếp tục) SCR-029 Amenities
  → (Xem kết quả) SCR-031 Results với filter chips/count/results mới
```

2. Không để SCR-028 `pop` thẳng về Results. Có thể để Price screen mở Amenity screen rồi trả một payload gộp duy nhất về Results, hoặc dùng Riverpod `SearchFilterDraft` typed. Cách chọn phải bảo toàn lựa chọn khi Back.
3. State filter phải có kiểu rõ ràng (`minPrice`, `maxPrice`, `propertyType`, `Set<String> amenities`), có Reset, count chuẩn và không dùng `dynamic` tùy tiện.
4. Nếu backend chưa hỗ trợ query amenities, vẫn phải giữ UI/filter state và filter client-side tạm thời với chú thích/TODO rõ ràng; không giả vờ filter đã hoạt động khi không thay đổi dữ liệu. Nếu thêm API query, cập nhật backend test tương ứng.
5. Từ Map có thể còn lối tắt vào SCR-029, nhưng không được là lối vào duy nhất.

### C. Đưa SCR-081 → SCR-100 vào luồng chuyến đi chạy được

1. Bottom navigation tab Trips phải mở SCR-081 (`/trips`). Từ booking thực, card phải mở detail live tương ứng (SCR-082).
2. Từ detail booking phải có các action đúng frame: Voucher 083, Directions/Contact 084, Change dates 085 → result 086, Cancel 087 → estimate 088 → reason 089 → success 090 → cancelled 091 → tracking 092 → complete 093, completed list 094 → review 095, help 096 → FAQ 097/chat 098, no-upcoming 099, overview 100.
3. Đừng chỉ giữ các `*-demo` routes không có entry point. Mỗi route phải có ít nhất một action UI có ý nghĩa dẫn tới nó hoặc được thay bằng route live tương đương.
4. Khi không có booking, hiển thị đúng SCR-099 và CTA quay lại khám phá. Không thay empty state bằng màn trắng hoặc lỗi API.
5. Để QA có thể xem mọi state mà không cần thanh toán thật, tạo **gallery debug-only** (chỉ tồn tại trong `kDebugMode`, ví dụ `/debug/figma-screens`) có danh sách theo nhóm và link tới route fixture. Gallery không được lộ trong UI release. Fixtures phải có dữ liệu booking hợp lệ, không fake bằng map rải rác trong widget; tạo một provider/model fixture dùng chung.
6. Flow production vẫn ưu tiên API thật; debug fixture chỉ là cách xem/kiểm thử layout khi chưa có booking.

### D. Quy tắc điều hướng và dữ liệu

1. Audit tất cả `context.go`, `context.push`, `context.pop`. Với CTA mở màn hình con dùng `push`; khi kết thúc flow dùng `go` nếu cần clear stack. Nút Back/Hủy luôn fallback khi không `canPop`.
2. Không thay navigation bằng URL hard-code sai route. Tập trung sửa dead route, route mismatch và stack không thể pop.
3. Không bỏ những sửa state quan trọng đã được yêu cầu trước đó: avatar dùng chung theo `currentUserProvider`; Favorite state dùng chung; date formatter tiếng Việt; availability chặn CTA; không flash `0đ` khi quote tải.
4. Giữ screen width/responsive wrapper và Figma asset hiện có. Không dùng ảnh từ Internet thay asset Figma.

## Tiêu chí nghiệm thu

1. Chạy mới app: thấy Splash rồi Onboarding 1/2/3 và Welcome. Hoàn tất/skip sẽ vào Home; mở lại app không bị lặp onboarding.
2. Từ Home → Search → Results → Lọc: thấy SCR-028, bấm Tiếp tục thấy SCR-029, bấm Xem kết quả quay lại SCR-031 với filter state vẫn còn.
3. Từ tab Trips: có empty state SCR-099 khi chưa có booking; sau khi tạo booking hoặc dùng debug gallery, duyệt được từng flow SCR-081 → SCR-100, không dead-end, không lỗi `pop`.
4. `/debug/figma-screens` chỉ có trong debug và cho phép reviewer chạm tới mọi screen/fixture trong danh mục mà không cần gõ URL.
5. Bổ sung widget/navigation tests ít nhất cho: first-run onboarding vs returning user; SCR-028 → SCR-029 → SCR-031; and Trips debug routes/empty state. Chạy `dart format`, `flutter analyze`, `flutter test`.
6. Nếu Flutter SDK cache không có quyền ghi, ghi lại exact lỗi môi trường; đừng coi đó là test pass.

## Báo cáo khi hoàn tất

Trả về: danh sách file đổi; bảng `SCR / route / entry action`; các flow đã chạy thủ công; test/analyze kết quả; mọi screen còn demo hay bị backend chặn. Không được chỉ đưa kế hoạch — phải sửa code và verify.
