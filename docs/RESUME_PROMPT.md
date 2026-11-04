# Figma analysis — StayNest

Ngày đọc: 2026-11-03. Nguồn: Figma MCP, file `lxtqfSd3GJZKqqDNmusSyf`. Phạm vi phân tích và triển khai được chốt là **Page 1** (`0:1`). Page 2 (`45:3`) và Page 3 (`145:4578`) là demo và bị loại khỏi danh mục màn hình, navigation và phạm vi phát triển. Phiên đọc Figma được tạo trước khi đọc file.

## Phạm vi và cách đọc

- Đã đọc cấu trúc metadata và frame trên Page 1; inventory các frame màn hình cùng tên, loại và kích thước.
- Dùng Figma Plugin API qua MCP để đọc text layer, kích thước frame, vector/image counts và mẫu màu/font trên Page 1. Các bảng dưới đây là từ dữ liệu canvas, không suy ra chỉ từ tên frame.
- Page 1 có 101 frame màn hình `SCR` và 10 node cấp page không phải màn hình (hình chữ nhật/text trang trí hoặc tên). Page 2 và Page 3 được xác định là các page demo theo chỉ dẫn của người dùng, không thuộc phạm vi phân tích hoặc triển khai.
- Các frame có viewport rộng 390 px; chiều cao được giữ theo đúng frame và dao động từ 739.5 đến 1,977 px. Đây là canvas mobile có chiều dài cuộn, không phải tất cả đều cao bằng một viewport thiết bị.

## Page 1 — màn hình chính

Kích thước ghi theo `390 × chiều cao` (px). Danh mục gồm tên frame đúng như Figma và tuyến Flutter đề xuất.

| Frame Figma | Kích thước | Flutter screen / component |
|---|---:|---|
| SCR-001 — Splash / Khởi động | 390×844 | `SplashScreen` |
| SCR-002 — Onboarding 1 | 390×844 | `OnboardingScreen(step: 1)` — `/onboarding/1` |
| SCR-003 — Onboarding 2 | 390×844 | `OnboardingScreen(step: 2)` — `/onboarding/2` |
| SCR-004 — Onboarding 3 | 390×844 | `OnboardingScreen(step: 3)` — `/onboarding/3` |
| SCR-005 — Welcome / Bắt đầu | 390×844 | `WelcomeScreen` — `/welcome` |
| SCR-006 — Đăng nhập | 390×844 | `SignInScreen` |
| SCR-007 — Đăng nhập thất bại | 390×825 | `LoginErrorScreen` — `/login/error` |
| SCR-008 — Tạo tài khoản | 390×844 | `SignUpScreen` — `/signup` |
| SCR-009 — Xác thực OTP | 390×844 | `OtpScreen` — `/otp` |
| SCR-010 — Đăng ký thành công | 390×884 | `SignUpSuccessScreen` — `/signup/success` |
| SCR-011 — Quên mật khẩu | 390×884 | `ForgotPasswordScreen` — `/forgot-password` |
| SCR-012 — Nhập mã xác thực đặt lại mật khẩu | 390×884.5 | `ResetOtpScreen` — `/password/reset/otp` |
| SCR-013 — Đặt mật khẩu mới | 390×739.5 | `NewPasswordScreen` — `/password/new` |
| SCR-014 — Đổi mật khẩu thành công | 390×892 | `PasswordResetSuccessScreen` — `/password/success` |
| SCR-015 — Tài khoản | 390×1092.5 | `AccountScreen` |
| SCR-016 — Hồ sơ cá nhân | 390×1186 | `ProfileScreen` |
| SCR-017 — Chỉnh sửa hồ sơ | 390×1073 | `EditProfileScreen` |
| SCR-018 — Lưu hồ sơ thành công | 390×902.5 | `ProfileSavedScreen` |
| SCR-019 — Cài đặt ứng dụng | 390×814 | `SettingsScreen` |
| SCR-020 — Thông báo | 390×942 | `NotificationsScreen` |
| SCR-021 — Trang chủ khám phá | 390×1684.3 | `ExploreHomeScreen` |
| SCR-021 — Quyền truy cập vị trí | 390×889 | `LocationPermissionScreen` |
| SCR-022 — Khám phá điểm đến | 390×992 | `DestinationsScreen` — `/destinations` |
| SCR-023 — Danh sách ưu đãi | 390×1880 | `OffersScreen` — `/offers` |
| SCR-024 — Gợi ý theo sở thích | 390×1056 | `RecommendationsScreen` — `/recommendations` |
| SCR-025 — Tìm kiếm – nhập điểm đến | 390×844 | `DestinationSearchScreen` |
| SCR-026 — Tìm kiếm – chọn khách & phòng | 390×845 | `GuestRoomPickerScreen` |
| SCR-027 — Chọn ngày nhận/trả | 390×844 | `StayDatePickerScreen` |
| SCR-028 — Bộ lọc – giá & loại chỗ ở | 390×844 | `PricePropertyFilterScreen` |
| SCR-029 — Bộ lọc – tiện nghi | 390×844 | `AmenityFilterScreen` |
| SCR-030 — Sắp xếp kết quả | 390×844 | `SearchSortScreen` — `/search/sort` |
| SCR-031 — Kết quả tìm kiếm – danh sách | 390×1742 | `SearchResultsListScreen` |
| SCR-032 — Kết quả – bản đồ | 390×844 | `SearchMapScreen` |
| SCR-033 — Bottom sheet xem nhanh | 390×844 | `PropertyQuickViewSheet` trên bản đồ |
| SCR-034 — Kết quả – chưa có phòng | 390×844 | `SearchEmptyScreen` |
| SCR-035 — Kết quả – đang tải | 390×844 | `SearchLoadingScreen` |
| SCR-036 — Tìm kiếm gần đây | 390×844 | `RecentSearchesScreen` |
| SCR-037 — Điểm đến Đà Nẵng | 390×1212.4 | `DestinationDetailScreen` — implemented at `/destinations/da-nang`; Figma screenshot inspected, Flutter comparison pending |
| SCR-038 — Danh sách khách sạn Đà Nẵng | 390×884 | `DestinationHotelsScreen` at `/destinations/da-nang/hotels` — implemented; Figma screenshot inspected, Flutter comparison pending |
| SCR-039 — Tìm theo danh mục lưu trú | 390×884 | `PropertyCategoryScreen` at `/categories` — implemented; Figma screenshot inspected, Flutter comparison pending |
| SCR-040 — Bộ lọc đang áp dụng | 390×1655.3 | `AppliedFiltersScreen` at `/search/applied-filters` — implemented; Figma screenshot inspected, Flutter comparison pending |
| SCR-041 — Chi tiết chỗ ở – Mây Homestay | 390×1665.8 | `PropertyDetailScreen` at `/properties/may-homestay` — implemented; initial/lower web view compared to Figma, full pixel comparison pending |
| SCR-042 — Thư viện ảnh chỗ ở | 390×1210.1 | `PropertyPhotoGalleryScreen` at `/properties/may-homestay/gallery` — implemented; initial web viewport compared with Figma |
| SCR-043 — Ảnh toàn màn hình | 390×812 | `PhotoViewerScreen` at `/properties/may-homestay/gallery/photo/:index` — implemented; web viewer compared with Figma |
| SCR-044 — Danh sách tiện nghi | 390×1708 | `AmenitiesScreen` |
| SCR-045 — Đánh giá & phân loại | 390×1225.8 | `ReviewsScreen` |
| SCR-046 — Đánh giá chi tiết | 390×1371.8 | `ReviewDetailScreen` |
| SCR-047 — Bộ lọc đánh giá | 390×1042 | `ReviewFilterScreen` |
| SCR-048 — Vị trí & khu vực | 390×1390 | `PropertyLocationScreen` |
| SCR-049 — Chọn loại phòng | 390×1459.8 | `RoomSelectionScreen` |
| SCR-050 — Chi tiết phòng Studio | 390×1115 | `RoomDetailScreen` |
| SCR-051 — Chính sách chỗ ở | 390×1402 | `PropertyPoliciesScreen` |
| SCR-052 — Chi tiết hủy & hoàn tiền | 390×1281 | `CancellationPolicyScreen` |
| SCR-053 — Đã lưu vào yêu thích | 390×884 | `FavoriteSavedFeedback` / toast-dialog state |
| SCR-054 — Danh sách yêu thích | 390×1315 | `FavoritesScreen` |
| SCR-055 — Yêu thích trống | 390×962 | `FavoritesEmptyScreen` |
| SCR-056 — Chọn chỗ ở để so sánh | 390×960.5 | `CompareSelectionScreen` |
| SCR-057 — Bảng so sánh chỗ ở | 390×1572.8 | `PropertyComparisonScreen` |
| SCR-058 — So sánh – chi tiết giá | 390×1143 | `PriceComparisonScreen` |
| SCR-059 — Liên hệ chủ nhà (mô phỏng) | 390×1395.8 | `HostContactDemoScreen` |
| SCR-060 — Tóm tắt phòng đã chọn | 390×1483.9 | `BookingRoomSummaryScreen` |
| SCR-061 — Bắt đầu đặt phòng (Mobile) | 390×1131 | `BookingStartScreen` |
| SCR-062 — Thông tin khách lưu trú (Mobile) | 390×946.3 | `GuestDetailsScreen` |
| SCR-063 — Yêu cầu đặc biệt (Mobile) | 390×1431 | `SpecialRequestsScreen` |
| SCR-064 — Tổng kết giá minh bạch (Mobile) | 390×879 | `PriceBreakdownScreen` |
| SCR-065 — Danh sách mã giảm giá | 390×894 | `VoucherPickerScreen` |
| SCR-066 — Mã giảm giá áp dụng thành công | 390×902 | `VoucherAppliedScreen` |
| SCR-067 — Chọn phương thức thanh toán | 390×887 | `PaymentMethodScreen` |
| SCR-068 — Thanh toán bằng ví (demo) | 390×949 | `WalletPaymentDemoScreen` |
| SCR-069 — Thanh toán thẻ ngân hàng | 390×1008 | `DomesticCardPaymentScreen` |
| SCR-070 — Thanh toán thẻ quốc tế | 390×1025 | `InternationalCardPaymentScreen` |
| SCR-071 — Xác nhận thanh toán | 390×1104 | `PaymentConfirmationScreen` |
| SCR-072 — Đang xử lý thanh toán | 390×965 | `PaymentProcessingScreen` |
| SCR-073 — Thanh toán thất bại | 390×881 | `PaymentFailureScreen` |
| SCR-074 — Thanh toán thành công | 390×1325 | `PaymentSuccessScreen` |
| SCR-075 — Biên nhận thanh toán | 390×1061.7 | `PaymentReceiptScreen` |
| SCR-076 — Nhận phòng – hướng dẫn sau thanh toán | 390×1977 | `ArrivalGuideScreen` |
| SCR-077 — Điều khoản giao dịch | 390×932.3 | `TransactionTermsScreen` |
| SCR-078 — Thanh toán thiếu thông tin | 390×997 | `PaymentMissingDetailsScreen` |
| SCR-079 — Đổi phương thức trước khi trả tiền | 390×949 | `ChangePaymentMethodScreen` |
| SCR-080 — Bảng kiểm tra đặt phòng cuối | 390×1619 | `BookingFinalReviewScreen` |
| SCR-081 — Chuyến đi của tôi | 390×927 | `MyTripsScreen` |
| SCR-082 — Chi tiết đặt phòng đã xác nhận | 390×1805.5 | `BookingDetailScreen` |
| SCR-083 — Voucher xác nhận đặt phòng | 390×1066 | `BookingVoucherScreen` |
| SCR-084 — Chỉ đường & liên hệ | 390×1211 | `DirectionsContactScreen` |
| SCR-085 — Yêu cầu đổi ngày | 390×1505.6 | `ChangeDatesScreen` |
| SCR-086 — Kết quả yêu cầu đổi ngày | 390×1298 | `ChangeDatesResultScreen` |
| SCR-087 — Bắt đầu hủy đặt phòng | 390×1179 | `CancellationStartScreen` |
| SCR-088 — Ước tính hoàn tiền | 390×1098.2 | `RefundEstimateScreen` |
| SCR-089 — Chọn lý do hủy | 390×1105.3 | `CancellationReasonScreen` |
| SCR-090 — Hủy thành công | 390×1186.8 | `CancellationSuccessScreen` |
| SCR-091 — Đơn đã hủy | 390×1036.6 | `CancelledTripsScreen` / cancelled tab state |
| SCR-092 — Theo dõi hoàn tiền | 390×1303 | `RefundTrackingScreen` |
| SCR-093 — Hoàn tiền hoàn tất | 390×1282 | `RefundCompleteScreen` |
| SCR-094 — Lịch sử lưu trú hoàn thành | 390×1032 | `CompletedTripsScreen` |
| SCR-095 — Viết đánh giá sau lưu trú | 390×1141.5 | `WriteReviewScreen` |
| SCR-096 — Trung tâm hỗ trợ | 390×1021 | `HelpCenterScreen` |
| SCR-097 — FAQ hủy đặt phòng | 390×1187.5 | `CancellationFaqScreen` |
| SCR-098 — Chat hỗ trợ đơn đặt | 390×882.8 | `BookingSupportChatDemoScreen` |
| SCR-099 — Không có chuyến đi sắp tới | 390×926.3 | `UpcomingTripsEmptyScreen` |
| SCR-100 — Tổng quan chuyến đi & điểm kết | 390×1182 | `TripOverviewScreen` |

ID/sequence có một vài chỗ không tuần tự, ví dụ SCR-021 được dùng cho cả Trang chủ khám phá và Quyền truy cập vị trí.

## Trạng thái triển khai Flutter

Sau khi người dùng duyệt tiếp tục code, project Flutter đã được tạo với Riverpod, go_router, theme Inter và assets cục bộ từ Figma. Có 30 route/màn Page 1 đã triển khai UI:

| Màn hình | Figma node | Route |
|---|---|---|
| Trang chủ khám phá | `24:3` | `/` |
| Tìm kiếm – nhập điểm đến | `27:751` | `/search` |
| Khám phá điểm đến | `24:232` | `/destinations` |
| Danh sách ưu đãi | `24:368` | `/offers` |
| Gợi ý theo sở thích | `24:576` | `/recommendations` |
| Danh sách yêu thích | `39:7160` | `/favorites` |
| Chuyến đi của tôi | `89:294` | `/trips` |
| Tài khoản | `31:3837` | `/account` |
| Đăng nhập | `3:487` | `/login` |
| Đăng nhập thất bại | `31:3527` | `/login/error` |
| Hồ sơ cá nhân | `31:3665` | `/profile` |
| Chỉnh sửa hồ sơ | `31:4033` | `/profile/edit` |
| Cài đặt ứng dụng | `31:4281` | `/settings` |
| Thông báo | `31:4534` | `/notifications` |
| Splash / Khởi động | `3:363` | `/splash` |
| Onboarding 1–3 | `2:123`, `2:181`, `3:295` | `/onboarding/1`, `/onboarding/2`, `/onboarding/3` |
| Welcome / Bắt đầu | `3:414` | `/welcome` |
| Tạo tài khoản | `3:642` | `/signup` |
| Xác thực OTP | `3:571` | `/otp` |
| Đăng ký thành công | `16:847` | `/signup/success` |
| Quên mật khẩu | `16:884` | `/forgot-password` |
| Nhập mã OTP đặt lại mật khẩu | `16:927` | `/password/reset/otp` |
| Đặt mật khẩu mới | `17:989` | `/password/new` |
| Đổi mật khẩu thành công | `17:1077` | `/password/success` |
| Chọn khách & phòng | `27:853` | `/search/guests` |
| Chọn ngày nhận/trả | `27:962` | `/search/dates` |
| Bộ lọc giá & loại chỗ ở | `27:1152` | `/search/filters/price-property` |
| Bộ lọc tiện nghi | `27:1380` | `/search/filters/amenities` |
| Sắp xếp kết quả | `27:3408` | `/search/sort` |
| Kết quả tìm kiếm – danh sách | `27:1580` | `/search/results` |
| Kết quả – bản đồ | `27:1792` | `/search/map` |
| Bottom sheet xem nhanh | `40:3650` | `/search/quick-view` |
| Kết quả – chưa có phòng | `40:3843` | `/search/empty` |
| Kết quả – đang tải | `37:3542` | `/search/loading` |
| Tìm kiếm gần đây | `40:3768` | `/search/recent` |

Nhóm auth gồm Splash, Onboarding 1–3, Welcome, Đăng nhập, Đăng nhập thất bại, Tạo tài khoản, OTP, đăng ký thành công, quên mật khẩu, OTP đặt lại, mật khẩu mới và đổi mật khẩu thành công đã được đọc bằng Figma MCP cùng screenshot; SVG/JPEG nguồn được lưu cục bộ. Nhóm tìm kiếm gồm SCR-022–036 được triển khai dựa trên `get_design_context`; các frame chọn khách/ngày/bộ lọc/sắp xếp dùng vector SVG gốc lưu ở `assets/icons/`, card SCR-030 dùng JPEG gốc, ba card SCR-031 dùng ảnh JPEG gốc, SCR-032 dùng frame export crop đúng `390×844` làm bản đồ mô phỏng, SCR-033 dùng SVG đường bản đồ và JPEG phòng gốc, SCR-034 dùng SVG gốc cho empty illustration/actions, SCR-035 dùng skeleton UI tĩnh, SCR-036 dùng ba mục lịch sử theo frame và SVG gốc. Ưu đãi, gợi ý, dữ liệu lưu trú và bản đồ giữ nhãn DEMO như Figma. `dart format` và lần `flutter analyze lib` mới nhất sạch (“No issues found”, 24.5 s). Chưa đối chiếu screenshot Flutter/Figma cho các route mới. Hành động cần dịch vụ auth chưa được nối; success states không được mở từ thao tác giả lập thành công. Lựa chọn bộ lọc/sắp xếp hiện chỉ là state cục bộ được trả về khi đóng route; danh sách, loading và bản đồ demo chưa có API/map provider. CTA chi tiết trong quick view đang chờ route SCR-041.

Đã mở bản Web và đối chiếu trực quan theo screenshot Figma cho Home, Tài khoản, Hồ sơ, Chỉnh sửa hồ sơ, Cài đặt và Thông báo. Vị trí CTA cố định ở Hồ sơ đã được chỉnh theo vùng action tại node `31:3819`. Đây mới là kiểm tra mẫu; chưa kiểm tra từng route ở đúng toàn bộ frame dimensions, chưa có bộ screenshot comparison cho đủ 101 frame và chưa tuyên bố khớp hoàn toàn.

## Page 2 và Page 3

Được người dùng xác nhận là demo. Bỏ qua toàn bộ frame, biến thể và luồng ở hai page này; chúng không phải nguồn thiết kế chuẩn và không được ánh xạ thành Flutter Screen.

## Thành phần, style, assets

- Cấu trúc lặp nhìn thấy qua layer: status bar, header/back button, thanh điều hướng dưới 5 mục, card và list item, chip/filter, nút CTA, input, rating, gallery, bản đồ mock, bottom sheet, trạng thái empty/loading/success/error, giá/booking summary và các badge trạng thái.
- Font quan sát được trên các frame Page 1: Inter với các trọng lượng Regular, Medium, Semi Bold, Bold; cỡ quan sát được khoảng 11–26 px. Cần giữ family, weight và cỡ theo từng frame để bám sát thiết kế.
- Màu mẫu lấy từ fills thực: teal `#006768` / `#0F8B8D`, navy `#172B4D` hoặc `#121C2A`, text xám `#667085`, nền sáng `#F7F9FC`/`#F8F9FF`, white, cùng trạng thái xanh lá/cam và các sắc phụ. Đây là các màu thấy trên node, không phải bảng token hoàn chỉnh.
- Đo trên các frame Home, kết quả, property, booking: corner radius thường gặp gồm 4, 6, 8, 12, 14, 16 px và pill `9999`; khoảng cách auto-layout phổ biến 2, 4, 6, 8, 10, 12, 16, 24 px; padding phổ biến 8, 10, 12, 14, 16, 20 px. Typography các frame này chủ yếu 11, 12, 14, 16, 20, 24 px. Các giá trị được đếm từ nodes, gồm cả node con/decorative; không nên coi tần suất là token hay quy tắc áp cho mọi frame.
- File không có local text styles, paint styles, effect styles; chỉ có một variable collection tên `Collection` không chứa biến. Vì vậy radius, shadow, spacing, typography scale và màu cần được trích theo node trước khi code, không thể dựa vào token library.
- Image fills có mặt rõ ở Home (7 ảnh), Favorites (2), My Trips (1) và nhiều property/gallery/destination frames. Vector assets xuất hiện rộng rãi. Không thay bằng icon/ảnh giả; ở Phase 3 cần lấy asset gốc từ MCP theo từng frame/component. Số lượng nêu ở đây là số node fill/type được thấy trong các frame đã phân tích, không khẳng định đã xuất từng file asset.
- Các frame bản đồ, chat liên hệ, ví/checkout, dữ liệu giá/chỗ ở, hoàn tiền và kết quả giao dịch có nội dung ghi rõ DEMO, “mô phỏng”, “minh họa”. Không có bằng chứng Figma rằng các tích hợp dịch vụ ngoài đã tồn tại.

## Luồng điều hướng đọc được từ thiết kế

1. Splash → onboarding 1–3 → welcome → đăng nhập/đăng ký → xác thực OTP; quên mật khẩu → OTP đặt lại → mật khẩu mới → thành công.
2. Khám phá → tìm điểm đến → chọn ngày/khách/phòng → bộ lọc/sắp xếp → danh sách hoặc bản đồ → quick view → chi tiết chỗ ở → phòng/đánh giá/tiện nghi/chính sách/vị trí → yêu thích/so sánh.
3. Chọn phòng → thông tin khách → yêu cầu đặc biệt → tổng kết giá/voucher → phương thức thanh toán → xác nhận/xử lý → thành công hoặc thất bại → biên nhận/hướng dẫn → chuyến đi/chi tiết/voucher/chỉ đường.
4. Chuyến đi → đổi ngày (gửi và trạng thái chờ host) hoặc hủy → chọn lý do/ước tính → hủy → theo dõi và hoàn tất refund; hỗ trợ gồm FAQ/chat. Lưu trú hoàn tất → viết đánh giá.

Đây là luồng suy ra từ các màn và nội dung CTA/trạng thái. Figma không cung cấp prototype links/interaction graph có thể xác nhận toàn bộ cạnh điều hướng trong phạm vi lần đọc này.

## Chưa đọc được / cần lưu ý khi triển khai

- Không thấy component library/file variables/styles tái sử dụng được trong local file; các component trên là phân loại từ hình thái layer và tên layer, chưa phải ánh xạ tới master component cụ thể.
- Page 1 có trùng mã SCR-021 cho Trang chủ khám phá và Quyền truy cập vị trí; ánh xạ giữ nguyên theo tên frame và node ID.
- Cần xuất/lưu đầy đủ ảnh/vector, font có giấy phép và metadata crop/position từ các frame ưu tiên. Tên frame gợi ý có ảnh nhưng không thay cho việc kiểm tra fill và export asset.
- Không xác định được từ visual: login provider thật, quyền location xin ở thời điểm nào, chính sách retention, nguồn inventory/giá/đánh giá, cổng thanh toán, cơ chế host chat, SLA/đối soát refund, phí/thuế hợp pháp, nội dung hợp đồng và hành vi khi mất mạng.

## SCR-037 implementation note (2026-11-03)

Node `43:2` was read with Figma MCP context and screenshot. The Flutter route uses the source beach and Ocean Pearl JPEG exports plus 13 original SVG exports. The date/guest change actions open existing local UI routes; area and favorite state are local. The hotel detail and room-list CTAs remain disabled until their target screens exist. `flutter analyze lib` passed. Flutter/Figma screenshot comparison is pending.

## SCR-038 implementation note (2026-11-03)

Node `47:2` was read via Figma MCP, including screenshot. The destination hotel list has one Ocean Pearl card with original image and SVGs. Filter/favorite interaction is local UI only. No Flutter screenshot comparison has been completed. `flutter analyze lib` passed.

## SCR-039 implementation note (2026-11-03)

Node `47:102` was read via Figma MCP with screenshot. Four category images and 11 SVG exports are local. `flutter analyze lib` passed. Flutter/Figma screenshot comparison is pending.

## SCR-040 implementation note (2026-11-03)

Node `51:209` was read via Figma MCP, including screenshot. Three source JPEGs and 22 SVGs are local. The visible filter summary and three result cards are implemented. Filter removal/favorites remain local UI state; detail CTA awaits SCR-041. `flutter analyze lib` passed. Flutter/Figma screenshot comparison pending.

## SCR-041 implementation note (2026-11-03)

Node `39:4835` was read via Figma MCP with screenshot. Three JPEGs and 28 SVGs were exported locally. Flutter web route `/properties/may-homestay` was opened in the in-app browser and its initial viewport plus lower review/location sections visually checked against Figma. The map placeholder rendering and fixed bottom bar need further visual review. Full-height fidelity is not confirmed. `flutter analyze lib` passed.

## SCR-042/043 implementation note (2026-11-03)

Both nodes were read via Figma MCP with screenshots. Original images/SVGs were exported locally and used in the gallery and viewer. Flutter web initial gallery viewport and viewer image/caption/controls were viewed against Figma; full scroll/pixel comparison remains pending. Figma copy says eight images while the supplied gallery context has seven distinct raster exports; the viewer can swipe among the seven available originals. `flutter analyze lib` passed.

## SCR-044 implementation note (2026-11-03)

Node `39:5216` was read via Figma MCP with screenshot. The Flutter amenities screen uses 24 original SVGs and presents four groups, note, and fixed CTA. Initial web viewport and first two groups were compared with Figma. Lower content and full pixel comparison are pending. `flutter analyze lib` passed after restoring temporary pub cache.

Latest checkpoint: route/state coverage 101/101 Page 1 Figma frames. Figma has 100 unique SCR numbers because two distinct frames share SCR-021: Home (`24:3`) and Location Permission (`31:4439`); both have routes. SCR-018 and SCR-097–100 are also implemented. The HANDOVER route table has 101 distinct Figma nodes and no missing SCR number 001–100. `dart format`, `flutter analyze lib` (no issues), and `flutter build web --no-pub` (succeeded) completed. The build was not displayed and no tests were run. SCR-069–100, SCR-018, and Location Permission were implemented from Figma context/screenshots and asset exports but were not visually compared as rendered screens per user direction. All literal local asset references in newly added screens exist and are nonempty; SCR-075 now uses the original barcode SVG. Original SVG callsite parity, voucher QR placeholder, Flutter map drawing, icon substitutes, and lower-scroll geometry still need fidelity work. Payment, cancellation, refund, demo phone, voucher save/share, host request, review submission, profile-save confirmation, support chat, and location grant are non-operational; success states are standalone demos. Previous SCR-045–068 initial web viewports were compared with Figma; full scroll/pixel comparison pending. SCR-050/051 icon placement needs review. No backend, database, API, or remote push. Do not open Flutter web unless user changes direction. Next work is asset/visual fidelity review, not backend.

## Page 1 source parity review (2026-11-04)

Route/state coverage remains 101/101. Static audit: 452 literal local asset references across 73 Dart files with 0 missing paths; 1300 SVG files with 0 XML parse failures. Original Figma SVG placement corrected in SCR-021 Location Permission, SCR-050 Room Detail, SCR-051 Policies and SCR-084 Directions. SCR-083 voucher placeholder glyphs became a demo QR graphic; SCR-085 availability button no longer opens a fabricated result. `dart format` and `flutter analyze lib` passed. No rendered screenshot comparison was performed in this review, so full visual fidelity remains unverified. SCR-069–100 and lower-scroll geometry need further review. No tests, backend, database, API, web preview or remote push.

## Bottom navigation icon consistency (2026-11-04)

The five bottom navigation items now use one canonical SVG set (`tab_explore`, `tab_search`, `tab_favorites`, `tab_trips`, `tab_account`) in `StayNestBottomNavigation`. Removed seven screen-specific icon/size overrides that made the same tab change shape between screens. All icons render in a consistent 20×20 slot; selected state uses teal, inactive state uses dark gray, matching the supplied navigation reference. `dart format` and `flutter analyze lib` passed. The Flutter web preview was restarted for review; no tests or backend work.

## Search bottom navigation (2026-11-04)

Added the shared `StayNestBottomNavigation` to `/search` (`DestinationSearchScreen`) with tab index 1 selected. The scrollable search content remains above the fixed navigation. `dart format` and `flutter analyze lib` passed; no tests or backend work.

## Page 1 recheck (2026-11-04)

Verified 101 registered Flutter routes, 177 literal navigation calls (two gallery paths correctly resolve through `:index`), 417 literal local asset paths with none missing, and 1300 parseable SVGs. Shared bottom navigation now has no screen-specific icon overrides and `/search` includes it. This was a static review; rendered Flutter/Figma comparison is still incomplete for SCR-069–100, SCR-018, location permission, and lower-scroll sections. Substitute icons/demo artwork in late screens require frame-by-frame review before declaring visual parity.

## Rendered Figma comparison — SCR-069–070 (2026-11-04)

Compared Figma MCP screenshots for nodes `67:1459` and `67:1627` against Flutter web at 393×1008. SCR-069 had outlined Material card-brand chips and an oversized save-card checkbox row; replaced them with compact filled brand labels and a compact checkbox so the security row fits above the fixed footer. SCR-070 initially showed an asset-load error and severe overflow: `international_payment_070.png` contained JPEG data. Renamed it to `.jpg` and updated the callsite. A fresh rendered capture showed the room image and normal layout. The demo-card number wrapped; reduced spacing to keep it on one line, but the final post-change screenshot capture was interrupted, so that last adjustment is not visually confirmed yet. `dart format` and `flutter analyze lib` passed. These are the only two late screens compared in this batch; do not mark SCR-071–100 visually checked.

## Rendered visual QA batch SCR-071–086 (2026-11-04)

Figma MCP screenshots and Flutter web were compared at mobile width for SCR-071–080 and SCR-082–086, including scrolled lower regions for SCR-076, SCR-082, SCR-085 and SCR-086. SCR-073 had an approximately 80px downward shift from vertical centering; changed it to top alignment and verified the corrected capture. SCR-074 hero image and SCR-075 room image were blank in the initial render. The underlying source bytes were JPEG while their filenames ended `.png`; copied 46 referenced JPEG assets to matching `.jpg` names, updated Dart callsites, and kept original files. Fresh captures confirmed the SCR-074 hero and SCR-075 room images. SCR-075 total-price row overflow was corrected with flexible left text and confirmed after rebuilding. SCR-079 payment sheet was shorter/lower than Figma; increased option minimum heights, pending rendered recheck. SCR-083 share voucher button was filled instead of outlined; corrected, pending rendered recheck. SCR-084–086 had the wrong secondary header text; changed the shared trip header to show each frame's status, pending rendered recheck. SCR-080 full-frame vertical spacing remains different; SCR-071–072 and SCR-076–078 retain smaller icon/spacing differences. `dart format` and `flutter analyze lib` passed. Do not mark SCR-087–100 visually checked yet.

## Visual QA batch SCR-087–091 (2026-11-04)

Compared Figma MCP screenshots with Flutter web at mobile width; scrolled to inspect lower content for SCR-087–090. SCR-087, SCR-089 and SCR-091 have the main cards, labels and actions in the expected order. SCR-088 lacks some original timeline icon/line treatment. SCR-090's pale refund amount panel rendered only at its content width; set it to full width, pending a post-change rendered capture. Minor SVG/icon substitutions and spacing differences remain in this group. `dart format` and `flutter analyze lib` passed.

## Latest visual QA progress (2026-11-04)

SCR-092–100 Figma screenshots were compared to Flutter web at mobile width; SCR-092–094 and SCR-096 also inspected by scrolling. SCR-095 prefilled review text and 74/100 counter were fixed and rendered again. SCR-097–100 had concrete layout/detail fixes in `final_page_screens.dart`, passed format/analyze, and need a fresh post-change capture. Remaining visible differences include SCR-092–093 timeline connectors, substitute icons, and spacing. Also revisit SCR-018, the second SCR-021 location permission frame, and earlier lower-scroll sections. Do not claim complete visual parity. Do not run tests or backend work without user request.

## Latest rendered check (2026-11-04)

SCR-018 and second SCR-021 Location Permission were compared against Figma MCP screenshots. SCR-018 vertical spacing was fixed and verified. SCR-097–100 post-change captures were inspected; SCR-100 hero top aligns after adjustment. The remaining task is comprehensive visual parity review of earlier screens and known late-screen differences (timeline lines, source SVG icons, lower-scroll geometry). Keep using small frame groups, format/analyze after edits, update these docs, and avoid tests/backend.

SCR-081 `/trips` has now been visually compared; its header icons were corrected and verified. Full-height and exact icon/spacing parity remain open for this and other screens.

Post-change captures now exist for SCR-079, SCR-083–086, and SCR-090 specific corrections. Further visual work should focus on remaining SVG/icon and lower-scroll differences; avoid redoing verified fixes.

SCR-001–005 have now been compared with Figma screenshots. Their major splash/onboarding/welcome layout differences were corrected and most were rendered again. A last 7px SCR-005 image offset passed analyze but needs a fresh screenshot. Continue systematically with SCR-006 onward, checking exact geometry and lower scroll. Do not assume full visual parity from route coverage.
