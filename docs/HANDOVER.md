# StayNest — Project handover

Last updated: 2026-11-04 (Asia/Ho_Chi_Minh)

## Responsive web mobile-first & Supabase catalog live integration — 2026-11-04

Addressed responsive web stretching and empty property catalog issues per user request:
- **Responsive Web Mobile-First (`ResponsiveAppShell`):** Created `lib/widgets/responsive_app_shell.dart` and integrated it at root into `MaterialApp.router(builder: ...)` in `lib/main.dart`.
  - On smartphone viewports (<= 480px width), the app renders naturally at 100% viewport width without letterboxing.
  - On tablet/desktop viewports (> 480px width), the entire application (including app bars, scrolling body, bottom navigation, floating/fixed buttons, modal bottom sheets, dialogs, and `ScaffoldMessenger` snackbars) is centered within a 390px mobile phone canvas with an elegant dark slate backdrop (`#0F141A`), anti-alias clipping, and elevated box shadows.
  - Form fields (e.g. signup/login), cards, and footers no longer stretch across the 1920px desktop screen.
  - Added 4 automated viewport tests in `test/responsive_app_shell_test.dart` testing 390x844, 393x852, 768x1024, and 1920x1080; all pass 100%.
- **Live Supabase Catalog Data & Da Lat Integration:**
  - Audited empty search results: confirmed Supabase database had migrations applied (`schema_migrations` present) but contained 0 rows in `destinations` and `properties` because `npm run seed` had not been executed against Supabase.
  - Extended `backend/src/seed.js` to include destination `da-lat` (Đà Lạt, Lâm Đồng), `pine-hill-homestay` (Pine Hill Homestay, 750.000đ), and `dalat-palace-hotel` (Đà Lạt Palace Hotel, 1.450.000đ), alongside Hội An and Đà Nẵng.
  - Executed idempotent seed against live Supabase PostgreSQL via TLS (`DATABASE_SSL=1` with `backend/supabase-ca.crt`). Verified 3 destinations, 6 published properties, and 7 room types are populated.
  - Updated `BookingDraft.destinationName` in `lib/data/staynest_api.dart` to support `da-lat`.
  - Unblocked Đà Lạt selection and keyword search in `lib/screens/destination_search_screen.dart` (previously displayed a demo restriction snackbar).
  - Enhanced `SearchResultsListScreen` in `lib/screens/search_results_list_screen.dart` with dedicated loading state, clear network/backend error state with retry button, and clear empty state with a "Xóa bộ lọc" action button.
- **Verification:**
  - `dart format` and `flutter analyze lib test` pass with 0 issues.
  - 6/6 Flutter tests pass (`test/responsive_app_shell_test.dart`, `test/widget_test.dart`, `test/payment_success_test.dart`).
  - 23/23 Backend tests pass (`npm run check` and `npm test`).
  - `flutter build web --debug --no-pub` compiled successfully into `build/web`.
  - Tested live Express API against Supabase over HTTP: `/api/v1/health/ready` (200 ready), `/api/v1/destinations` (3 items), `/api/v1/properties?destination=da-lat` (2 items), `/api/v1/properties?destination=hoi-an` (3 items), and live `/api/v1/auth/register` (success).

## Backend hardening & hosted PostgreSQL enablement — 2026-11-04

Hardened Express/Node backend to meet [docs/PRD_backend.md](PRD_backend.md) requirements for hosted PostgreSQL 14+ deployment:
- `backend/src/config.js`: Enforced `DATABASE_URL` presence in production; rejected `STAYNEST_EMBEDDED_DEMO=1` in production; strictly prohibited CORS wildcard `*` and validated exact origin formats; validated `DATABASE_SSL` and `DATABASE_SSL_CA_FILE` dependencies.
- `backend/src/migrate.js`: Refactored to export `runMigrations()` with `pg_advisory_lock(748391)` and `schema_migrations` tracking; idempotent on repeat runs; safe transaction wrapping per migration file.
- `backend/src/seed.js`: Prohibited running in production (`NODE_ENV=production` exits with code 1); required explicit confirmation flag (`ALLOW_DEMO_SEED=1`) for standalone execution.
- `backend/src/app.js`: Sanitized error responses to prevent database connection string or stack trace leakage on 5xx/503 errors; hardened `/api/v1/health/ready` to return 503 with sanitized error code `DATABASE_UNAVAILABLE` on database failures.
- `backend/src/server.js`: Added graceful shutdown handling `SIGINT`/`SIGTERM` with in-flight request completion and 10s fallback deadline.
- `backend/src/db.js`: Attached idle client error listener to `pg.Pool` to prevent process crashes on background disconnects.
- `backend/.env.example` and `.gitignore`: Protected `.env*` files and certificate keys (`*.pem`, `*.crt`, `*.key`, `*.pfx`); added production configuration guidance.
- `docs/RUNBOOK_HOSTED_POSTGRESQL.md`: Created operational runbook covering architecture, least-privilege roles (`staynest_migration` vs `staynest_app`), private network/static egress policy, TLS/CA mounting, migration release pipeline, backup/PITR, zero-downtime credential rotation, and disaster recovery.
- Test suite expanded from 8 to 22 tests across `api.test.js`, `business.test.js`, `schema.test.js`, `config.test.js`, `migration.test.js`, and `security.test.js`; all 22 tests pass cleanly (`npm run check` and `npm test`).

## Resumed work — 2026-11-04

User resumed the project. Backend `npm run check` passed and `npm test` passed 8/8 using embedded PGlite (the first HTTP test attempt was blocked by loopback sandbox permission, then passed after network permission was granted). Flutter package cache under `/tmp` had been cleared; `flutter pub get` restored locked dependencies. SCR-041 now fetches the room price from `/properties/may-homestay` and persists its favorite action through `/me/favorites`; unauthenticated favorite action opens login. Its former fixed “2 rooms available” claim was replaced because date-specific inventory is not exposed by that detail endpoint. Original Figma imagery/layout remains. For this edit, `flutter analyze --no-pub lib` passed, 2/2 Flutter tests passed, and web build succeeded (108.1 s). Browser inspection of SCR-041 at `http://127.0.0.1:8090/#/properties/may-homestay` showed the API price and preserved imagery/layout; this was visual runtime QA, not pixel comparison with Figma.

A follow-up search integration now passes selected price range and property type from SCR-028 to `/properties`, applies sorting from SCR-030 on SCR-031, and updates the result chips/count. The API supports `rating_desc` and rejects unsupported sorts; distance remains unavailable because the seed has no coordinates. The filter reset selects the full price range. Backend check and 8/8 tests pass, including an HTTP price/type/sort check. Flutter analyze passed, 2/2 tests passed, and web build succeeded (78.6 s). Browser QA on fresh origin `http://127.0.0.1:8092` verified that applying Homestay and a price range changed the API result list/chips; sort selection returned to the results view. The sort sheet itself still displays static Figma sample cards.

Date/guest pickers now persist their selection in `BookingDraft`; SCR-031 passes check-in/out and adults to the API and displays the chosen dates and guest count. The date shortcut is relative to today; invalid same-day checkout is rejected in UI. An HTTP test now checks that fully booked Mây is omitted from a date-filtered result. Flutter analyze passed, 2/2 tests passed, web build succeeded (78.4 s), and fresh browser QA on `http://127.0.0.1:8093/#/search/results` showed the dynamic 18–20/11/2026 dates. Backend 8/8 tests passed, including full-inventory exclusion by date.

SCR-025 gained a compact date/guest selector and “Tìm chỗ ở” action so the search UI can reach live results. It recognizes only seeded Hội An and Đà Nẵng; Đà Lạt/other text gets an explicit unavailable message. SCR-031 uses the selected destination and displays the API address per card. The seed now includes Ocean Pearl Hotel (Đà Nẵng, 1.250.000đ) from SCR-037/038, with a seed assertion; backend check and all 8 tests pass. Other hotel detail/booking frames remain unconnected; do not imply Ocean Pearl booking works. Flutter analyze passed with no issues, 2/2 Flutter tests passed, and web build succeeded (77.9 s). Browser QA on fresh origin `http://127.0.0.1:8094` verified the new search footer, selecting Đà Nẵng, and the Ocean Pearl result with its original image, Mỹ Khê address and API price 1.250.000đ. This is runtime visual QA, not Figma pixel comparison.

Non-Mây result cards now open `/catalog/properties/:slug`, a generic API-backed detail view with image, amenities, room prices, favorite state, loading/error/retry. This supplementary view has no Page 1 Figma frame and is not claimed Figma-matched. It explicitly does not offer booking yet because the existing Figma booking screens are Mây-specific; routing another property into them would create the wrong booking. Flutter analyze passed with no issues, 2/2 Flutter tests passed, and web build succeeded (78.4 s). Browser QA on `http://127.0.0.1:8095/#/catalog/properties/ocean-pearl-hotel` verified original image, API address, room name and 1.250.000đ price. This supplementary screen has no Figma frame and was not compared with one.

SCR-060 booking summary now requests a server quote for the selected dates/guests, displays the room subtotal/nightly price, shows retry/error, and disables continue when inventory is insufficient. SCR-061 reads dates/guests/subtotal from that draft and drops the fixed 14–16/11/2026 and 1.700.000đ claims; changing dates clears the prior quote. Flutter analyze passed with no issues, 2/2 tests passed and web build succeeded (78.8 s). Browser QA on fresh origin `http://127.0.0.1:8096` verified SCR-060 showed 18–20/11/2026 and 1.700.000đ room subtotal from API quote, and SCR-061 displayed the same dates/nights/subtotal. This was runtime visual QA; not a Figma pixel comparison.

The seed now includes Mây Garden View at 1.050.000đ with its original image, alongside Studio at 850.000đ; running seed twice remains idempotent. SCR-049 fetches room names/prices from `/properties/may-homestay`, calculates the provisional room subtotal for the selected nights/room count, and shows loading/error/empty states. Garden View was initially disabled; the later integration section above records its working booking path. Backend check and 8/8 tests pass after updating the catalog expectations. Flutter analyze passed, 2/2 Flutter tests passed and web build succeeded (79.6 s). Browser QA on `http://127.0.0.1:8097/#/properties/may-homestay/rooms` showed Studio 850.000đ and Garden View 1.050.000đ from API, plus 2-night subtotals 1.700.000đ and 2.100.000đ. This was runtime visual QA, not pixel comparison with Figma.

## Garden View booking integration — 2026-11-04

The user asked to continue until approximately 5% of the session remains. `BookingDraft` now stores the selected room type ID/name/image. SCR-049 selection saves either Studio or Garden View; Garden View goes directly to SCR-060 because its separate room-detail frame does not exist. SCR-060 selects that exact room from the catalog before requesting the backend quote. SCR-061 and SCR-064/067 display the selected room name/image, and SCR-064 creates the booking with the selected ID. The HTTP test books Garden View after Studio is fully occupied and asserts the returned `room_type_id`; backend check and 8/8 tests pass. Flutter format/analyze passed, 2/2 Flutter tests passed, and web build succeeded (83.2 s). Browser QA on `http://127.0.0.1:8098` verified selecting Garden View showed its image/name and 2.100.000đ room subtotal on SCR-060 and SCR-061. The guest screen revealed an older fixed 1.700.000đ footer; this and the request/coupon summaries were then changed to use the draft. For the footer edits, Flutter analyze passed, 2/2 tests passed, and web build succeeded (79.5 s). Fresh browser QA at `http://127.0.0.1:8099` verified Garden View selection through SCR-049→060→061→062, with 2.100.000đ displayed in the guest footer instead of the former Studio price. This was runtime UI QA, not Figma pixel comparison. Backend check and 8/8 tests passed, including a Garden booking while Studio was full. Payment/refund remain demo only. Non-Mây booking is still disabled.

Core-flow cleanup after user priority change: browser QA on the fresh 8099 build verified Garden View through SCR-049→060→061→062, including the corrected 2.100.000đ guest footer. The next request screen still showed fixed 14–16/11 dates and a false 14:59 hold before a booking existed. These were changed to selected draft dates/room image/name and a truthful inventory check message. The guest screen’s fake `SN-1024` email promise was replaced with an on-screen demo receipt message. `dart format` and `flutter analyze --no-pub lib` passed; 2/2 Flutter tests passed; web build succeeded (79.0 s). Browser QA on fresh `http://127.0.0.1:8100/#/booking/requests` verified the dynamic 18–20/11/2026 dates, selected room label and truthful inventory text. This direct-route capture had no prior quote, so its footer correctly says to view the price in the next step. Earlier Garden QA on 8099 verified the 2.100.000đ amount through the guest step. No email sending or pre-booking room hold was added. Backend remains 8/8 tests passed; the HTTP test includes Garden booking with Studio full.

### Next concrete steps for the core demo

1. On a fresh 8100 session, complete the UI flow from Garden View through guest/request/price, sign in with the seeded demo account, and confirm the demo payment, success receipt, and trip detail. Backend HTTP tests already cover booking/payment/cancellation ownership and Garden inventory, but the full Flutter UI flow has not been visually completed end to end.
2. Remove remaining static labels on demo-only routes only when they participate in a live flow. Keep payment/refund explicitly demo and do not promise email or a room hold before the backend creates one.
3. Repeat with standalone PostgreSQL when available; this environment still lacks postgres/psql/Docker.
4. Run `npm run check --prefix backend && npm test --prefix backend`, then Flutter format/analyze/test/build after edits. No push has been made.

## Earlier pause note

The user asked to pause on 2026-11-04. The latest `dart format`, `flutter analyze lib` and `flutter test --no-pub test` completed successfully (2 Flutter tests). The final `flutter build web --no-pub` after the account/home greeting and upcoming-trip empty-state edits was still compiling when the user asked to pause and was stopped; `build/web` therefore contains an earlier successful build, not those latest edits. The embedded API on port 3000 and the Python web server on port 8090 were also stopped. Browser QA before the stopped build verified seeded login through the API and the empty trip state; it exposed the wrong upcoming empty message, now fixed in source but not rechecked in a new build. Do not claim final visual QA or a final build for these edits.

Resume with: `npm run check --prefix backend && npm test --prefix backend` (last result 8/8), then `flutter analyze lib`, `flutter test --no-pub test`, and `flutter build web --no-pub`. Restart embedded demo API/web as documented in README if visual verification is needed. Standalone PostgreSQL validation and the remaining static catalog/filter/booking summary frames are still open.

## A. Project overview

- **Project:** StayNest, a Vietnamese accommodation discovery and booking app.
- **Goal:** Build a Flutter mobile app closely matching the user's Figma design, then add a real Node.js/Express REST backend and PostgreSQL database.
- **Figma:** [UX-UI lộn xộn](https://www.figma.com/design/lxtqfSd3GJZKqqDNmusSyf/UX-UI-l%E1%BB%99n-x%E1%BB%99n?node-id=0-1&t=M77MGecaI8pcqvvO-1). Figma MCP was reachable and returned metadata, design code, screenshots, and exportable SVG/image assets in this session.
- **Scope:** Only Page 1 is authoritative. Page 2 and Page 3 were explicitly identified by the user as demos and are excluded.
- **Agreed stack:** Flutter/Dart, Riverpod, go_router; Node.js/Express; PostgreSQL; REST; environment-based configuration.
- **Architecture target:** Flutter client and Express API remain separate. PostgreSQL is the durable source of truth. No business behavior is to be invented where the Figma or product decisions do not define it.
- **Important design rule:** Keep source Figma layout, colors, typography, radii, spacing, vectors and images. Use local Figma exports; never use temporary Figma URLs at runtime. Do not claim full visual fidelity without screenshot comparison.

## B. Current progress

### Phases

| Phase | Status | Notes |
|---|---|---|
| 1. Figma analysis | DONE | Page 1 inventory, frames, dimensions, styles, assets, navigation in `FIGMA_ANALYSIS.md`. Page 2–3 excluded. |
| 2. System design | DONE (proposal) | Flutter/API architecture, PostgreSQL ERD proposal, REST endpoint proposal, unresolved decisions in `SYSTEM_DESIGN.md`. Nothing in the proposal has been implemented as backend. |
| 3. Flutter UI | ROUTES_COMPLETE, VISUAL_QA_PARTIAL | 101 Page 1 frames have Flutter route/state mappings, including both distinct SCR-021 frames. Figma assets and Inter are local. Rendered visual QA remains partial. |
| 4. Backend/database | IN PROGRESS | Express API, PostgreSQL migration/seed and core routes implemented. MySQL draft converted. Embedded PostgreSQL-compatible HTTP tests pass; a standalone PostgreSQL server is not installed in this environment. |
| 5. Visual verification | PARTIAL | Page 1 route coverage complete and many screens compared, but exact full-frame visual parity remains unverified. Backend wiring may change screen states and needs fresh review. |

### Implemented Flutter routes

| Figma frame | Figma node | Route / source |
|---|---|---|
| SCR-021 Trang chủ khám phá | `24:3` | `/` — `lib/screens/explore_home_screen.dart` |
| SCR-021 Quyền truy cập vị trí | `31:4439` | `/location-permission` — `LocationPermissionScreen` (location permission action non-operational) |
| SCR-025 Tìm kiếm – nhập điểm đến | `27:751` | `/search` — `lib/screens/destination_search_screen.dart` |
| SCR-022 Khám phá điểm đến | `24:232` | `/destinations` — `lib/screens/discovery_screens.dart` |
| SCR-023 Danh sách ưu đãi | `24:368` | `/offers` — `OffersScreen` |
| SCR-024 Gợi ý theo sở thích | `24:576` | `/recommendations` — `RecommendationsScreen` |
| SCR-081 Chuyến đi của tôi | `89:294` | `/trips` — `lib/screens/my_trips_screen.dart` |
| SCR-015 Tài khoản | `31:3837` | `/account` — `lib/screens/account_screen.dart` |
| SCR-006 Đăng nhập | `3:487` | `/login` — `lib/screens/login_screen.dart` |
| SCR-007 Đăng nhập thất bại | `31:3527` | `/login/error` — `lib/screens/login_error_screen.dart` |
| SCR-016 Hồ sơ cá nhân | `31:3665` | `/profile` — `lib/screens/profile_screen.dart` |
| SCR-017 Chỉnh sửa hồ sơ | `31:4033` | `/profile/edit` — `lib/screens/profile_edit_screen.dart` |
| SCR-018 Lưu hồ sơ thành công | `31:4167` | `/profile/updated-demo` — `ProfileUpdatedDemoScreen` (standalone demo state) |
| SCR-019 Cài đặt ứng dụng | `31:4281` | `/settings` — `lib/screens/settings_screen.dart` |
| SCR-020 Thông báo | `31:4534` | `/notifications` — `lib/screens/notifications_screen.dart` |
| SCR-001 Splash / Khởi động | `3:363` | `/splash` — `lib/screens/onboarding_screens.dart` |
| SCR-002 Onboarding 1 | `2:123` | `/onboarding/1` — `OnboardingScreen(step: 1)` |
| SCR-003 Onboarding 2 | `2:181` | `/onboarding/2` — `OnboardingScreen(step: 2)` |
| SCR-004 Onboarding 3 | `3:295` | `/onboarding/3` — `OnboardingScreen(step: 3)` |
| SCR-005 Welcome / Bắt đầu | `3:414` | `/welcome` — `WelcomeScreen` |
| SCR-008 Tạo tài khoản | `3:642` | `/signup` — `lib/screens/signup_screen.dart` |
| SCR-009 Xác thực OTP | `3:571` | `/otp` — `OtpScreen` (visual UI only; no OTP service) |
| SCR-010 Đăng ký thành công | `16:847` | `/signup/success` — `SignUpSuccessScreen` (Figma visual state only) |
| SCR-011 Quên mật khẩu | `16:884` | `/forgot-password` — `ForgotPasswordScreen` |
| SCR-012 Nhập mã xác thực đặt lại mật khẩu | `16:927` | `/password/reset/otp` — `ResetOtpScreen` |
| SCR-013 Đặt mật khẩu mới | `17:989` | `/password/new` — `NewPasswordScreen` |
| SCR-014 Đổi mật khẩu thành công | `17:1077` | `/password/success` — `PasswordResetSuccessScreen` (Figma visual state only) |
| SCR-026 Chọn khách & phòng | `27:853` | `/search/guests` — `GuestRoomPickerScreen` |
| SCR-027 Chọn ngày nhận/trả | `27:962` | `/search/dates` — `StayDatePickerScreen` |
| SCR-028 Bộ lọc giá & loại chỗ ở | `27:1152` | `/search/filters/price-property` — `PricePropertyFilterScreen` |
| SCR-029 Bộ lọc tiện nghi | `27:1380` | `/search/filters/amenities` — `AmenityFilterScreen` |
| SCR-030 Sắp xếp kết quả | `27:3408` | `/search/sort` — `SearchSortScreen` |
| SCR-031 Kết quả tìm kiếm – danh sách | `27:1580` | `/search/results` — `SearchResultsListScreen` |
| SCR-032 Kết quả – bản đồ | `27:1792` | `/search/map` — `SearchMapScreen` |
| SCR-033 Bottom sheet xem nhanh | `40:3650` | `/search/quick-view` — `PropertyQuickViewScreen` |
| SCR-034 Kết quả – chưa có phòng | `40:3843` | `/search/empty` — `SearchEmptyScreen` |
| SCR-035 Kết quả – đang tải | `37:3542` | `/search/loading` — `SearchLoadingScreen` |
| SCR-036 Tìm kiếm gần đây | `40:3768` | `/search/recent` — `RecentSearchesScreen` |
| SCR-037 Điểm đến Đà Nẵng | `43:2` | `/destinations/da-nang` — `DestinationDetailScreen` |
| SCR-038 Danh sách khách sạn Đà Nẵng | `47:2` | `/destinations/da-nang/hotels` — `DestinationHotelsScreen` |
| SCR-039 Tìm theo danh mục lưu trú | `47:102` | `/categories` — `PropertyCategoryScreen` |
| SCR-040 Bộ lọc đang áp dụng | `51:209` | `/search/applied-filters` — `AppliedFiltersScreen` |
| SCR-041 Chi tiết chỗ ở – Mây Homestay | `39:4835` | `/properties/may-homestay` — `PropertyDetailScreen` |
| SCR-042 Thư viện ảnh chỗ ở | `39:5039` | `/properties/may-homestay/gallery` — `PropertyPhotoGalleryScreen` |
| SCR-043 Ảnh toàn màn hình | `39:5436` | `/properties/may-homestay/gallery/photo/:index` — `PhotoViewerScreen` |
| SCR-044 Danh sách tiện nghi | `39:5216` | `/properties/may-homestay/amenities` — `PropertyAmenitiesScreen` |
| SCR-045 Đánh giá & phân loại | `39:5711` | `/properties/may-homestay/reviews/overview` — `PropertyReviewsOverviewScreen` |
| SCR-046 Đánh giá chi tiết | `39:5480` | `/properties/may-homestay/reviews` — `PropertyReviewsListScreen` |
| SCR-047 Bộ lọc đánh giá | `39:5951` | `/properties/may-homestay/reviews/filter` — `ReviewFilterScreen` |
| SCR-048 Vị trí & khu vực | `39:6083` | `/properties/may-homestay/location` — `PropertyLocationScreen` |
| SCR-049 Chọn loại phòng | `39:6301` | `/properties/may-homestay/rooms` — `RoomSelectionScreen` |
| SCR-050 Chi tiết phòng Studio | `39:6496` | `/properties/may-homestay/rooms/studio` — `RoomDetailScreen` |
| SCR-051 Chính sách chỗ ở | `39:6658` | `/properties/may-homestay/policies` — `PropertyPoliciesScreen` |
| SCR-052 Chi tiết hủy & hoàn tiền | `39:6817` | `/properties/may-homestay/policies/refund` — `RefundPolicyScreen` |
| SCR-053 Đã lưu vào yêu thích | `39:7504` | `/favorites/saved` — `FavoriteSavedScreen` (standalone demo state) |
| SCR-054 Danh sách yêu thích | `39:7160` | `/favorites` — existing `FavoritesScreen`, reviewed and corrected |
| SCR-055 Yêu thích trống | `39:7340` | `/favorites/empty` — `FavoritesEmptyScreen` |
| SCR-056 Chọn chỗ ở để so sánh | `39:6975` | `/favorites/compare/select` — `CompareSelectionScreen` |
| SCR-057 Bảng so sánh chỗ ở | `39:7625` | `/favorites/compare` — `CompareTableScreen` |
| SCR-058 So sánh – chi tiết giá | `39:7882` | `/favorites/compare/prices` — `ComparePriceScreen` |
| SCR-059 Liên hệ chủ nhà (mô phỏng) | `39:8044` | `/properties/may-homestay/host-chat` — `HostChatDemoScreen` |
| SCR-060 Tóm tắt phòng đã chọn | `39:8189` | `/booking/summary` — `BookingSummaryScreen` |
| SCR-061 Bắt đầu đặt phòng | `67:2` | `/booking/start` — `BookingStartScreen` |
| SCR-062 Thông tin khách lưu trú | `67:162` | `/booking/guests` — `GuestInformationScreen` |
| SCR-063 Yêu cầu đặc biệt | `67:284` | `/booking/requests` — `BookingRequestsScreen` |
| SCR-064 Tổng kết giá minh bạch | `67:463` | `/booking/price` — `BookingPriceScreen` |
| SCR-065 Danh sách mã giảm giá | `67:738` | `/booking/coupons` — `CouponListScreen` |
| SCR-066 Mã giảm giá áp dụng thành công | `67:616` | `/booking/coupons/applied-demo` — `CouponAppliedDemoScreen` (standalone demo state) |
| SCR-067 Chọn phương thức thanh toán | `67:861` | `/booking/payment-method` — `PaymentMethodScreen` |
| SCR-068 Thanh toán bằng ví (demo) | `67:1004` | `/booking/wallet-demo` — `WalletPaymentDemoScreen` |
| SCR-069 Thanh toán thẻ ngân hàng | `67:1459` | `/booking/domestic-card-demo` — `DomesticCardPaymentScreen` |
| SCR-070 Thanh toán thẻ quốc tế | `67:1627` | `/booking/international-card-demo` — `InternationalCardPaymentScreen` |
| SCR-071 Xác nhận thanh toán | `67:1275` | `/booking/payment-confirmation` — `PaymentConfirmationScreen` |
| SCR-072 Đang xử lý thanh toán | `67:1108` | `/booking/payment-processing-demo` — `PaymentProcessingScreen` (standalone demo state) |
| SCR-073 Thanh toán thất bại | `67:1769` | `/booking/payment-failure-demo` — `PaymentFailureScreen` (standalone demo state) |
| SCR-074 Thanh toán thành công | `67:1859` | `/booking/payment-success-demo` — `PaymentSuccessScreen` (standalone demo state) |
| SCR-075 Biên nhận thanh toán | `67:2038` | `/booking/receipt-demo` — `PaymentReceiptScreen` (standalone demo state) |
| SCR-076 Nhận phòng – hướng dẫn sau thanh toán | `67:2755` | `/booking/post-payment-guide-demo` — `PostPaymentGuideScreen` |
| SCR-077 Điều khoản giao dịch | `67:2424` | `/booking/transaction-terms` — `TransactionTermsScreen` |
| SCR-078 Thanh toán thiếu thông tin | `67:2192` | `/booking/missing-information-demo` — `PaymentMissingInformationScreen` |
| SCR-079 Đổi phương thức trước khi trả tiền | `67:2305` | `/booking/change-payment-method` — `ChangePaymentMethodScreen` |
| SCR-080 Bảng kiểm tra đặt phòng cuối | `67:2528` | `/booking/final-check-demo` — `FinalBookingCheckScreen` |
| SCR-082 Chi tiết đặt phòng đã xác nhận | `89:2` | `/trips/booking` — `BookingDetailScreen` |
| SCR-083 Voucher xác nhận đặt phòng | `89:443` | `/trips/booking/voucher` — `BookingVoucherScreen` |
| SCR-084 Chỉ đường & liên hệ | `89:588` | `/trips/booking/directions` — `DirectionsContactScreen` |
| SCR-085 Yêu cầu đổi ngày | `89:1375` | `/trips/booking/change-dates` — `ChangeDatesScreen` |
| SCR-086 Kết quả yêu cầu đổi ngày | `89:795` | `/trips/booking/change-dates/result-demo` — `ChangeDatesResultScreen` (standalone demo state) |
| SCR-087 Bắt đầu hủy đặt phòng | `89:970` | `/trips/booking/cancel` — `CancellationStartScreen` |
| SCR-088 Ước tính hoàn tiền | `89:1115` | `/trips/booking/refund-estimate` — `RefundEstimateScreen` |
| SCR-089 Chọn lý do hủy | `89:1249` | `/trips/booking/cancel/reason` — `CancellationReasonScreen` |
| SCR-090 Hủy thành công | `89:1659` | `/trips/booking/cancel/success-demo` — `CancellationSuccessScreen` (standalone demo state) |
| SCR-091 Đơn đã hủy | `89:1829` | `/trips/cancelled-demo` — `CancelledTripsScreen` (standalone demo state) |
| SCR-092 Theo dõi hoàn tiền | `89:1976` | `/trips/refund-tracking-demo` — `RefundTrackingScreen` (standalone demo state) |
| SCR-093 Hoàn tiền hoàn tất | `89:2176` | `/trips/refund-complete-demo` — `RefundCompleteScreen` (standalone demo state) |
| SCR-094 Lịch sử lưu trú hoàn thành | `89:2798` | `/trips/completed-demo` — `CompletedTripsScreen` |
| SCR-095 Viết đánh giá sau lưu trú | `89:3077` | `/trips/completed/review` — `WriteReviewScreen` |
| SCR-096 Trung tâm hỗ trợ | `89:2356` | `/trips/help` — `HelpCenterScreen` |
| SCR-097 FAQ hủy đặt phòng | `89:2526` | `/trips/help/cancellation-faq` — `CancellationFaqScreen` |
| SCR-098 Chat hỗ trợ đơn đặt | `89:2686` | `/trips/help/chat-demo` — `BookingSupportChatDemoScreen` |
| SCR-099 Không có chuyến đi sắp tới | `89:2936` | `/trips/upcoming-empty-demo` — `UpcomingTripsEmptyScreen` |
| SCR-100 Tổng quan chuyến đi & điểm kết | `89:3228` | `/trips/overview-demo` — `TripOverviewScreen` |

Page 1 has 101 top-level frames and 100 unique SCR numbers; SCR-021 is used for both Home (`24:3`) and Location Permission (`31:4439`). All 101 frames now have a route/state mapping. This is route coverage, not a claim of full visual fidelity. The Figma asset callsites and rendered visual comparison for SCR-069–100, SCR-018 and the location-permission SCR-021 remain to review. No backend, database, or API exists.

### Backend and database

- Implemented APIs: **none**.
- PostgreSQL tables/schema/migrations: **none**.
- Backend functions: **none**. UI-only copy, filters, tabs and local toggles must not be described as server-backed behavior.

### Reusable Flutter pieces

- `lib/design/tokens.dart`: Inter theme and current sampled color tokens.
- `lib/widgets/figma_asset.dart`: local SVG/raster wrappers.
- `lib/widgets/figma_status_bar.dart`, `lib/widgets/bottom_navigation.dart`: repeated mobile chrome.
- Riverpod `Provider<GoRouter>` in `lib/main.dart` owns app routing.

## C. Completed tasks

| Task | Files | Result / verification | Status |
|---|---|---|---|
| Figma Page 1 analysis | `docs/FIGMA_ANALYSIS.md` | Figma MCP metadata/context/screenshots used; inventory identifies 101 frames and dimensions. Page 2–3 excluded. | DONE |
| System design proposal | `docs/SYSTEM_DESIGN.md` | Architecture, ERD and API proposal documented; unknown business rules explicitly listed. No backend has been built. | DONE |
| Flutter scaffold/theme/assets and first route group | `pubspec.yaml`, `pubspec.lock`, `lib/main.dart`, `lib/design/`, `lib/widgets/`, `lib/screens/`, `assets/` | 10 routes, local design assets, Riverpod/go_router/flutter_svg. | DONE for this slice |
| Auth entry screens | `lib/screens/onboarding_screens.dart`, `lib/screens/signup_screen.dart`, `lib/main.dart`, `assets/icons/{splash,onboarding*,welcome,signup,otp}_*.svg`, `assets/images/{onboarding*,welcome}_01.jpg` | Added 7 Page 1 frames using MCP contexts and local exports; signup/OTP/provider behavior remains unimplemented. | DONE for this UI slice |
| Password recovery and success states | `lib/screens/password_flow_screens.dart`, `lib/screens/login_screen.dart`, `lib/main.dart`, `assets/icons/{success,forgot,resetotp,newpass,resetok}_*.svg` | Added 5 frames using MCP contexts/screenshots and local Figma SVGs. External verification/reset services remain unconfigured; success screens are not reached by actions that would imply a real success. | DONE for this UI slice |
| Login error state | `lib/screens/login_error_screen.dart`, `lib/main.dart`, `assets/icons/login_error_*.svg` | Added Page 1 node `31:3527` using Figma context and its original vectors. Error-attempt copy is a Figma visual state only; no login attempt is made. | DONE for this UI slice |
| First discovery screens | `lib/screens/discovery_screens.dart`, `lib/screens/explore_home_screen.dart`, `lib/main.dart`, `assets/icons/{destinations,offers,recommendations}_icon_*.svg`, `assets/images/{destinations,offers,recommendations}_image_*` | Read Figma contexts for nodes `24:232`, `24:368`, `24:576`; added destination exploration, offer list and preference recommendations routes; linked the corresponding Home “see all” and offer card actions. All offers/recommendation content remains explicitly marked as demo per Figma. | DONE for this UI slice |
| Search selection screens | `lib/screens/search_selection_screens.dart`, `lib/main.dart`, `assets/icons/{guest_room,stay_dates}_icon_*.svg` | Added SCR-026 guest/room counts and SCR-027 date picker from Figma contexts. Counts/date changes are local UI state; adults and rooms remain at least one. | DONE for this UI slice |
| Search filter screens | `lib/screens/search_filter_screens.dart`, `lib/main.dart`, `assets/icons/filter_{price,amenity}_*.svg` | Added SCR-028 price range/property type and SCR-029 amenity selection with Figma SVGs and selected defaults. Filter choices are returned as local route results; no API or results screen is implemented yet. | DONE for this UI slice |
| Search sort sheet | `lib/screens/search_sort_screen.dart`, `lib/main.dart`, `assets/icons/sort_results_*.svg`, `assets/images/sort_results_property.jpg` | Added SCR-030 as the dimmed search-result frame with source listing image and sort bottom sheet; choice starts at “Phù hợp nhất” and returns as local route state. | DONE for this UI slice |
| Search results list | `lib/screens/search_results_list_screen.dart`, `lib/main.dart`, `assets/icons/search_list_*.svg`, `assets/images/search_list_*.jpg` | Added SCR-031 with Figma's three explicitly demo accommodation cards, original images/icons, filters, sort entry, and bottom navigation. Filter/sort screens can be opened from the result controls. | DONE for this UI slice |
| Search map demo | `lib/screens/search_map_screen.dart`, `lib/screens/search_results_list_screen.dart`, `lib/main.dart`, `assets/images/search_map_canvas.png` | Added SCR-032 from the Figma frame export, cropped to the exact 390×844 canvas, with transparent hotspots for list, filter, sort, back, and bottom navigation. The map itself remains the static DEMO canvas; no map provider is configured. | DONE for this UI slice |
| Quick-view sheet | `lib/screens/property_quick_view_screen.dart`, `lib/screens/search_map_screen.dart`, `lib/main.dart`, `assets/icons/quick_view_*.svg`, `assets/images/quick_view_room.jpg` | Added SCR-033 using its actual Figma map geometry, room image, icons, badges, amenities and bottom sheet. The selected 850,000đ pin on SCR-032 opens it; close returns to map. Detail CTA awaits SCR-041 route implementation. | DONE for this UI slice |
| No-availability state | `lib/screens/search_empty_screen.dart`, `lib/main.dart`, `assets/icons/no_availability_*.svg` | Added SCR-034 from the real frame: restrictive filter chips, empty illustration/copy, two suggestions, reset action and shared bottom nav. Its actions route to the matching local filter/result UIs; no availability API is connected. | DONE for this UI slice |
| Search loading state | `lib/screens/search_loading_screen.dart`, `lib/main.dart`, `assets/icons/loading_results_*.svg` | Added SCR-035 with Figma header, loading status and three neutral skeleton cards. This is a visual loading state only; no network request is simulated. | DONE for this UI slice |
| Recent searches screen | `lib/screens/recent_searches_screen.dart`, `lib/main.dart`, `assets/icons/recent_search_*.svg` | Added SCR-036 with the three rows and exact copy in Figma. Clear/delete currently update local in-memory UI only; no search history API exists. | DONE for this UI slice |
| Account flow screens | `lib/screens/profile_screen.dart`, `profile_edit_screen.dart`, `settings_screen.dart`, `notifications_screen.dart`, `account_screen.dart` | Read corresponding frames with Figma MCP, downloaded local SVGs, wired Account menu routes. | DONE for this slice |
| Static analysis | `lib/**/*.dart` | `dart format` completed for changed files; latest `flutter analyze lib` reported “No issues found” (24.5 s), including SCR-035 and SCR-036. No tests were run. | DONE |
| Web build | `build/web` (generated, ignored by Git) | `flutter build web --debug --no-pub` succeeded; compilation is slow (~110 s in this environment). | DONE |
| Sample visual review | Web browser + Figma screenshots | Home, Account, Profile, Edit Profile, Settings and Notifications viewed. Profile fixed action positioned to match Figma node `31:3819`. Coverage is partial. | DONE for sample only |

## D. Remaining tasks (priority order)

| Task ID | Description | Expected files | Dependencies | Acceptance criteria | Status |
|---|---|---|---|---|---|
| P3-AUTH-01 | Implement Page 1 auth entry flow: Splash, onboarding 1–3, Welcome, Sign Up, OTP, signup success, forgot password, reset OTP, new password, reset success, login error state. Use each frame's actual Figma context/assets. | `lib/screens/`, local `assets/`, `lib/main.dart` | Figma MCP access | Each mapped frame has a route/state; Figma assets used where available; `flutter analyze lib` clean. | DONE (14 auth frames/states, including existing Login route) |
| P3-SEARCH-01 | Implement discovery/search frames: destination exploration, offers, preference recommendations, guest/room, dates, filters, sort, results/list/map/empty/loading/recent search. | `lib/screens/`, `lib/main.dart`, `assets/` | Figma MCP | All mapped Page 1 frames in this group have a route/state using source Figma visuals; unknown service behavior is not invented. | DONE (14 new frames plus existing `/search`; all SCR-022–036 represented) |
| P3-PROPERTY-01 | Implement destination/property detail, photo gallery/viewer, amenities, reviews, location, room selection/details, policies, cancellation policy. | `lib/screens/`, `lib/main.dart`, `assets/` | Figma MCP | One Screen/component per mapped frame/state; local Figma imagery/vector exports. | DONE for route coverage; visual QA pending |
| P3-FAVORITES-01 | Implement saved/empty states, compare selection/table/price comparison, host contact demo state. | `lib/screens/`, `lib/main.dart`, `assets/` | Figma MCP; retain “demo” labeling from design | Frames match source; demo states are not represented as real transactions. | DONE for route coverage; visual QA pending |
| P3-BOOKING-01 | Implement booking, guest, special request, quote, voucher, payment method/result/receipt/arrival and terms frames. | `lib/screens/`, `lib/main.dart`, `assets/` | Figma MCP; payment and booking business decisions for behavior | UI states match frames; no fake successful booking/payment action. | DONE for route coverage; visual QA pending |
| P3-TRIPS-01 | Implement booking detail, voucher, directions, date change, cancellation/refund, completed stay, review, support, empty trips and overview frames. | `lib/screens/`, `lib/main.dart`, `assets/` | Figma MCP; cancellation/refund/support product decisions | Every Page 1 frame is mapped and implemented, with unknown real actions disabled or clearly marked. | DONE for route coverage; visual QA pending |
| P3-VISUAL-01 | Render every implemented frame at exact Figma frame dimensions, save Flutter screenshots and compare typography, geometry, color, assets and alignment; fix differences and report remaining ones. | `docs/FIGMA_ANALYSIS.md`, screenshot outputs as agreed, affected UI files | Screens implemented; browser/emulator available | Screenshot record for every implemented frame; no full-match claim without evidence. | TODO (partial sample review exists) |
| P4-DECISIONS-01 | Resolve product unknowns in `SYSTEM_DESIGN.md`: auth/OTP provider, catalog/inventory source, payment provider, booking policy, cancel/refund, map/location, notification channels, demo-vs-production boundary, hosting. | `docs/SYSTEM_DESIGN.md` | User decisions | A written MVP boundary and selected integrations; do not guess. | BLOCKED pending user decisions |
| P4-API-01 | Create separate Node.js + Express backend, config validation, request validation/error handling, REST modules approved for MVP. | `backend/package.json`, `backend/src/`, `.env.example` | P4-DECISIONS-01 | API starts locally, env names documented, approved endpoints implemented; no secrets committed. | TODO |
| P4-DB-01 | Add PostgreSQL schema/migrations and local setup; add only approved tables and constraints. | `backend/db/migrations/`, `backend/src/db/` | P4-DECISIONS-01, P4-API-01 | Migrations apply and roll back safely; no destructive schema change or production seed. | TODO |
| P4-FLUTTER-API-01 | Connect approved Flutter features to real API through repositories/providers; remove static sample behavior for server-backed functions. | `lib/data/`, `lib/domain/`, `lib/features/` (or evolve current layout without a rewrite) | P4-API-01, P4-DB-01 | No fake success for backend features; loading/error/empty states match Figma. | TODO |
| P4-VERIFY-01 | Verify approved key flows and API/database behavior. | backend and Flutter source | Backend/API implemented | Report exact commands and results; do not claim unrun checks. | TODO |

## E. Current work in progress

- **Task:** `P3-AUTH-01` and `P3-SEARCH-01` are DONE for their UI frames. `P3-PROPERTY-01` is now active.
- **Auth implementation:** Read actual Figma contexts/screenshots for Splash, Onboarding 1–3, Welcome, Sign Up, OTP, Sign Up Success, Forgot Password, Password Reset OTP, New Password, Password Reset Success and Login Error. Added 13 auth routes/states; with existing Login, 14 auth frames/states are represented. `/` remains Home.
- **Search implementation:** All Page 1 search/discovery frames SCR-022–036 are represented (14 new screens/states plus existing `/search`). SCR-035 is a visual skeleton state only; SCR-036 history deletion is local in-memory UI only.
- **Verification:** `dart format` completed and `flutter analyze lib` returned “No issues found” (24.5 s). No tests or Flutter-vs-Figma screenshot comparisons for the new search screens have been run.
- **Current next step:** Review source asset placement and rendered geometry for Page 1, especially SCR-069–100 and lower-scroll content. Route coverage is complete; screenshot comparison is partial.
- **Do not start backend implementation yet:** Product-specific auth, providers and transaction behavior have unresolved decisions in `SYSTEM_DESIGN.md`.

## F. Errors and blockers

- **Full `flutter analyze` may report the generated default widget test referencing `MyApp`**, which no longer exists after the app became `StayNestApp`. Earlier `flutter analyze lib` is clean. The test file has not been run or rewritten. If full analysis is needed, inspect `test/widget_test.dart` and decide whether to adapt or remove only after review; no test has been executed.
- **Visual coverage is incomplete:** only a sample set has been compared. Different frame heights and scroll positions must be checked one by one at the frame's actual viewport.
- **Figma has duplicate SCR number 021** for Home and Location Permission; use node ID and full frame name, not the short number alone.
- **Product decisions block backend behavior:** user auth, real catalog/inventory, prices/fees, payment provider, cancellation/refund policy, OTP/SMS/email, maps/location, notifications, support chat, deployment and secrets management. See `SYSTEM_DESIGN.md` questions.
- **No Git repository detected** in the workspace (`git status` returns “not a git repository”). Do not claim a commit or clean Git status.
- **Web build time:** the Flutter Web debug build takes about 110 seconds here. Blank screenshots immediately after load were transient; wait for Flutter canvas/assets before diagnosing a render failure.

## G. Environment and commands

### Important paths

- Flutter project root: workspace directory containing `pubspec.yaml`.
- Figma/source notes: `docs/FIGMA_ANALYSIS.md`, `docs/SYSTEM_DESIGN.md`.
- Flutter source: `lib/`.
- Local Figma assets: `assets/icons/`, `assets/images/`, `assets/fonts/`.
- Flutter SDK used here: `/home/dat/flutter/bin/flutter`.
- Build output: `build/` (ignored/generated).

### Flutter

This environment needed a temporary package cache and disabled analytics to avoid home-directory writes:

```bash
PUB_CACHE=/tmp/staynest-pub-cache FLUTTER_SUPPRESS_ANALYTICS=true flutter pub get
PUB_CACHE=/tmp/staynest-pub-cache FLUTTER_SUPPRESS_ANALYTICS=true flutter analyze lib
PUB_CACHE=/tmp/staynest-pub-cache FLUTTER_SUPPRESS_ANALYTICS=true flutter run -d chrome
PUB_CACHE=/tmp/staynest-pub-cache FLUTTER_SUPPRESS_ANALYTICS=true flutter build web --debug --no-pub
```

`flutter test` was not run. The full generated test suite needs inspection because the stock test still references the old `MyApp` scaffold.

### Backend/database (not created yet)

- No backend install/start command or migrations currently exist. Once implemented, document commands in `backend/README.md` and add a root-level quick start.
- Proposed environment **names only** for later approval/implementation: `PORT`, `DATABASE_URL`, `CORS_ORIGIN`, `JWT_ACCESS_SECRET`, `JWT_REFRESH_SECRET`, `OTP_PROVIDER`, `SMS_PROVIDER_API_KEY`, `EMAIL_PROVIDER_API_KEY`, `PAYMENT_PROVIDER`, `PAYMENT_WEBHOOK_SECRET`, `MAPS_PROVIDER`, `PUSH_PROVIDER`. These are not configured or implemented. Never put values in handover.

## H. Figma implementation status

- All 101 Page 1 frames have Flutter route/state coverage; Page 2–3 are excluded. This does not establish visual fidelity.
- Implemented frames are listed in section B. The remaining frames are grouped by feature in section D; consult the full inventory for exact names, nodes and dimensions.
- Reusable components currently include SVG/raster asset wrappers, status bar, bottom navigation, shared theme tokens, and some local feature widgets. No Figma component library/styles/variables were found in the source file.
- Screenshot-checked sample: Home, Account, Profile, Edit Profile, Settings, Notifications. This is not full-frame coverage. Profile fixed action placement was tuned to the source's `Bottom Fixed Action Area` node `31:3819`.
- Known visual limitations: many frames have not been rendered and compared; viewport/frame-height comparison remains incomplete; the Flutter default scroll/viewport can conceal lower content until scrolled; a few UI controls remain presentational/local only.
- No claim of “fully matches Figma” is authorized by current evidence.

## I. Next action — exact continuation steps

1. Review SCR-069–100 source assets and lower-scroll geometry in small frame groups using Figma MCP context/screenshots.
2. Keep backend-dependent actions non-operational; result/success frames are standalone visual demos.
3. Run `dart format` and `flutter analyze lib` after each group. Do not run tests or display Flutter web unless requested.
4. Update the three handover/analysis documents with actual verification evidence. No backend, database, API or remote push.

## Latest UI batch — SCR-037

- Implemented `lib/screens/destination_detail_screen.dart` and `/destinations/da-nang`; linked the Đà Nẵng card in discovery.
- Downloaded two source JPEGs and 13 source SVGs from Figma node `43:2`. Local area chip and favorite toggle are UI state only. Hotel detail/room-list CTAs await SCR-038/041 and are disabled so they do not imply completed backend work.
- Ran `dart format` on changed Dart files and `flutter analyze lib`: No issues found. No tests were run.
- Inspected the Figma SCR-037 screenshot. No Flutter screenshot was captured or compared yet; visual fidelity remains unverified.

## Latest UI batch — SCR-038

- Implemented `DestinationHotelsScreen` from Figma node `47:2` at `/destinations/da-nang/hotels`; wired the SCR-037 primary CTA. Used the source Ocean Pearl JPEG and 12 original SVG exports.
- Filter chips and favorite toggle are local UI state. The hotel detail CTA awaits its own frame. No backend or API was added.
- Figma screenshot was inspected; no Flutter screenshot comparison has yet been performed. `dart format` and `flutter analyze lib` passed (“No issues found”). No tests were run.

## Latest UI batch — SCR-039

- Implemented `PropertyCategoryScreen` at `/categories` using four original Figma JPEGs and 11 SVG exports from node `47:102`. Homestay and hotel cards link to existing demo result routes; other categories have no invented data destination.
- Figma screenshot inspected; Flutter screenshot comparison pending. `dart format` and `flutter analyze lib` passed (“No issues found”). No tests were run.

## Latest UI batch — SCR-040

- Implemented `AppliedFiltersScreen` at `/search/applied-filters` from Figma node `51:209`, with three source JPEGs and 22 SVG exports. Removable filter chips and favorite toggles are local UI state. The Mây Homestay detail CTA awaits SCR-041 and remains disabled.
- Inspected Figma screenshot; Flutter screenshot comparison pending. Ran `dart format` and `flutter analyze lib`: No issues found. No tests run. No backend/database/API changes.

## Latest UI batch — SCR-041 and live web review

- Flutter web launched at `http://127.0.0.1:8087` with `flutter run -d web-server --web-hostname 127.0.0.1 --web-port 8087 --no-pub`; in-app browser opened at `http://127.0.0.1:8087/#/properties/may-homestay` and left visible. Web hot reload succeeded.
- Implemented `PropertyDetailScreen` from Figma node `39:4835`, 3 original JPEGs and 28 original SVG exports. Linked Mây detail from SCR-040 CTA, SCR-031 Mây card and SCR-033 quick view. Room selection remains disabled until its target frame is built; no booking is simulated.
- Visually compared the Flutter web rendering with the Figma SCR-041 screenshot for the initial viewport and the lower review/location sections. Major sections and source imagery are present. Full-height pixel comparison remains pending; the map placeholder rendering and fixed bottom bar need further review. Do not claim full fidelity.
- Ran `dart format` and `flutter analyze lib`: No issues found. No tests run. No backend/database/API changes.

## Latest UI batch — SCR-042/043

- Figma nodes `39:5039` and `39:5436` read with context/screenshot. Implemented gallery and full-screen viewer using seven gallery JPEG exports, the viewer JPEG and 15 original SVGs. Property detail thumbnail strip opens gallery; gallery images open viewer. Category chips update local UI; viewer supports pinch zoom and swipe among seven available source images. Figma copy says 8 images, but only seven distinct gallery raster assets were in the context; no eighth image was invented.
- `dart format` and `flutter analyze lib` passed (“No issues found”). No tests. No backend/API/database.
- Flutter web hot reloaded and both routes opened in the in-app browser. SCR-042 initial viewport and SCR-043 viewer image/caption/control layout were visually compared with Figma screenshots. Full scroll and exact pixel comparison remain pending.

## Latest UI batch — SCR-044

- Implemented `PropertyAmenitiesScreen` from Figma node `39:5216` at `/properties/may-homestay/amenities`, using 24 original SVGs. Linked the amenities CTA from SCR-041. Four groups, note, and fixed price/room CTA are present. Room CTA remains disabled until SCR-049 exists.
- `/tmp/staynest-pub-cache` was removed between runs; restored via `flutter pub get` using the same cache path. `dart format` and `flutter analyze lib` passed (“No issues found”) after restore. No tests. No backend/API/database.
- Flutter web server restarted at `http://127.0.0.1:8087`; SCR-044 was opened in the in-app browser. Initial viewport and first two groups were compared visually with the Figma screenshot. Lower groups and full-height pixel comparison remain pending.

## Latest UI batch — SCR-045/046/047

- Read Figma context and screenshots for nodes `39:5711`, `39:5480`, and `39:5951` before implementation. Exported the original review photos and SVGs into `assets/images` and `assets/icons`.
- Implemented review overview, detailed review list, and filter sheet at the routes above. Linked the review area of SCR-041 to the overview. Filter choices are local UI state; no backend result is simulated.
- Opened all three routes on Flutter web. Compared the initial viewport of SCR-045, SCR-046, and SCR-047 with their Figma screenshots. Full scroll and pixel comparison remain pending; no full fidelity claim.
- Ran `dart format` on changed Dart files and `flutter analyze lib` with the temporary pub cache: No issues found. No tests, backend, API, database, or remote push.
- Next: SCR-048, node `39:6083`, location and surrounding area. Keep the web server and visible browser active while working.

## Latest UI batch — SCR-048

- Read Figma node `39:6083` with context and screenshot; exported original SVG map layers. Added `PropertyLocationScreen` and linked the map preview from SCR-041.
- Opened `/properties/may-homestay/location` on Flutter web and visually compared the initial map/address viewport with Figma. The map is a static composition of original vectors; full scroll and pixel comparison remain pending. The direction button is a visual disabled state, with no navigation service behind it.
- Ran `dart format` and `flutter analyze lib`: No issues found. No tests or backend work. Next: SCR-049 room selection.

## Latest UI batch — SCR-049

- Read Figma node `39:6301` with context and screenshot; exported two source room photos and 21 SVG icons. Implemented `RoomSelectionScreen` and linked room CTAs from SCR-041 and SCR-044.
- Opened `/properties/may-homestay/rooms` on Flutter web and visually compared the initial viewport with Figma. Full scroll and pixel comparison remain pending. Room selection buttons remain visual disabled states until the corresponding detail/booking flow is implemented; no booking success is simulated.
- Ran `dart format` and `flutter analyze lib`: No issues found. No tests or backend. Next: SCR-050 node `39:6496`.

## Latest UI batch — SCR-050

- Read Figma node `39:6496` with context and screenshot; exported the original Studio image and 17 SVGs. Implemented `RoomDetailScreen` and linked the Studio card in SCR-049.
- Opened `/properties/may-homestay/rooms/studio` on Flutter web and compared the initial viewport with Figma. Some amenity SVG placement needs review; full scroll and pixel comparison remain pending. Booking remains a disabled visual state, and cancellation policy link awaits SCR-051.
- Ran `dart format` and `flutter analyze lib`: No issues found. No tests or backend. Next SCR-051 node `39:6658`.

## Latest UI batch — SCR-051

- Read Figma node `39:6658` with context and screenshot; exported 22 original SVGs. Implemented `PropertyPoliciesScreen` and linked the cancellation policy CTA from SCR-050.
- Opened `/properties/may-homestay/policies` on Flutter web and compared its initial viewport with Figma. Some icon placement and the lower scroll need visual review; full pixel comparison pending. The detail refund CTA has no destination yet and does not simulate a backend action.
- Ran `dart format` and `flutter analyze lib`: No issues found. No tests or backend. Next SCR-052; discover node ID from Page 1 metadata.

## Latest UI batch — SCR-052

- Read Figma node `39:6817` with context and screenshot; exported the source trip image and 14 SVGs. Added `RefundPolicyScreen` and linked it from SCR-051.
- Opened `/properties/may-homestay/policies/refund` on Flutter web and compared its initial viewport with Figma. Full scroll and pixel comparison pending. All trip, refund, and payment text is the Figma prototype's illustrative content; no booking or refund behavior exists.
- Ran `dart format` and `flutter analyze lib`: No issues found. No tests or backend. Next SCR-053 node `39:7504`.

## Latest UI batch — SCR-053

- Read Figma node `39:7504` with context and screenshot; exported its source image and 16 SVGs. Implemented the saved-favorite overlay as a standalone visual route `/favorites/saved`.
- Opened it on Flutter web and compared the visible viewport with Figma. Removed duplicated title that was already baked into the original image. Full pixel comparison pending. This route is not triggered by a fake save action; persistence does not exist.
- Ran `dart format` and `flutter analyze lib`: No issues found. No tests or backend. Next SCR-054 node `39:7160`.

## Latest UI batch — SCR-054

- Read Figma node `39:7160` with context/screenshot and inspected the already existing `/favorites` implementation and its original local assets. Kept that screen rather than recreating it.
- Web comparison revealed the shared bottom navigation stretched across the desktop viewport. Constrained it to 390 px for mobile frame previews and fixed Ocean Pearl distance from 400 m to the Figma 200 m. Reloaded `/favorites` and confirmed the content and navigation stay within the mobile column.
- `dart format` and `flutter analyze lib` passed. Images loaded after normal web startup. Some icon mapping and full scroll/pixel comparison remain pending. No tests or backend. Next SCR-055 node `39:7340`.

## Latest UI batch — SCR-055

- Read Figma node `39:7340` with context and screenshot. Exported three source recommendation images and the central heart SVG. Implemented empty favorites at `/favorites/empty`, leaving `/favorites` as the populated design state.
- Opened the route on Flutter web and compared the initial viewport with Figma after image/SVG load. Full scroll/pixel comparison pending. Discover action links to existing home; no favorite persistence was added.
- Ran `dart format` and `flutter analyze lib`: No issues found. No tests/backend. Next SCR-056 node `39:6975`.

## Latest UI batch — SCR-056

- Read Figma node `39:6975` with context/screenshot and exported four source property images. Implemented `CompareSelectionScreen` with up to three local selections, linked from the populated favorites banner.
- Opened `/favorites/compare/select` on Flutter web and compared the initial viewport with Figma after image load. Full scroll/pixel comparison pending. Compare CTA awaits SCR-057; no data service exists.
- Ran `dart format` and `flutter analyze lib`: No issues found. No tests/backend. Next SCR-057 node `39:7625`.

## Latest UI batch — SCR-057

- Read Figma node `39:7625` with context/screenshot; exported two source images and 23 SVGs. Implemented `CompareTableScreen` and linked the compare action from SCR-056.
- Opened `/favorites/compare` on Flutter web and compared its initial viewport with Figma. Lower content and pixel comparison pending. Price detail link awaits SCR-058; continue CTA goes to existing room selection. No live comparison data service.
- Ran `dart format` and `flutter analyze lib`: No issues found. No tests/backend. Next SCR-058 node `39:7882`.

## Latest UI batch — SCR-058

- Read Figma node `39:7882` with context/screenshot; exported two source room images and 11 SVGs. Implemented `ComparePriceScreen` and linked the price analysis row from SCR-057.
- Opened `/favorites/compare/prices` on Flutter web and visually compared its initial viewport with Figma after images loaded. Full lower scroll/pixel comparison pending. Prices are static prototype content, with no price API.
- Ran `dart format` and `flutter analyze lib`: No issues found. No tests/backend. Next SCR-059 node `39:8044`.

## Latest UI batch — SCR-059

- Read Figma node `39:8044` with context/screenshot; exported four source images and 12 SVGs. Implemented demo conversation at `/properties/may-homestay/host-chat`.
- Opened on Flutter web and compared initial viewport with Figma after images loaded. Lower scroll/pixel comparison pending. Input is disabled and conversation is static; no message sending, fake success, or backend was added.
- Ran `dart format` and `flutter analyze lib`: No issues found. No tests. Next SCR-060 node `39:8189`.

## Latest UI batch — SCR-060

- Read Figma node `39:8189` with context/screenshot and exported two original raster images. Implemented `BookingSummaryScreen` and linked it from Studio room detail SCR-050.
- Opened `/booking/summary` on Flutter web and compared its initial viewport with Figma after image load. Lower scroll/pixel comparison pending. Continue action awaits the next frontend frame; no booking submission/API was added.
- Ran `dart format` and `flutter analyze lib`: No issues found. No tests/backend. Next discover SCR-061 node from Page 1 metadata.

## Latest UI batch — SCR-061

- Read Figma node `67:2` with context/screenshot; exported the original hero image and 16 SVGs. Implemented `BookingStartScreen` and linked it from SCR-060.
- Opened `/booking/start` on Flutter web and compared its initial viewport with Figma. Lower scroll/pixel comparison pending. Guest choice is local UI state; continue awaits SCR-062, with no booking submission.
- Ran `dart format` and `flutter analyze lib`: No issues found. No tests/backend. Next SCR-062 node `67:162`.

## Latest UI batch — SCR-062

- Read Figma node `67:162` with context/screenshot and exported 12 SVGs. Implemented `GuestInformationScreen` with local editable demo fields and linked it from SCR-061.
- Opened `/booking/guests` on Flutter web and compared its initial viewport with Figma. Lower scroll/pixel comparison pending. Form values are prototype examples and are not stored or sent; continue awaits SCR-063.
- Ran `dart format` and `flutter analyze lib`: No issues found. No tests/backend. Next SCR-063 node `67:284`.

## Latest UI batch — SCR-063

- Read Figma node `67:284` with context/screenshot; exported original selected-property image. Implemented `BookingRequestsScreen` and linked it from SCR-062.
- Opened `/booking/requests` on Flutter web. A transient CanvasKit render failure caused a blank frame; reloading restored it, then the initial viewport was compared with Figma. Lower scroll/pixel comparison pending. Arrival, note, and agreement are local only; continue awaits SCR-064.
- Ran `dart format` and `flutter analyze lib`: No issues found. No tests/backend. Next SCR-064 node `67:463`.

## Latest UI batch — SCR-064

- Read Figma node `67:463` with context/screenshot; exported original room image. Implemented `BookingPriceScreen` and linked it from SCR-063 when the local agreement checkbox is selected.
- Opened `/booking/price` on Flutter web and compared initial viewport with Figma. Full scroll/pixel comparison pending. STAY100 and price breakdown are static design state; selection/payment awaits the following frontend frames. No payment/API added.
- Ran `dart format` and `flutter analyze lib`: No issues found. No tests/backend. Next SCR-065 node `67:738`.

## Latest UI batch — SCR-065

- Read Figma node `67:738` with context/screenshot; exported 11 original SVGs. Implemented `CouponListScreen`, including local available/expired tabs and selection, and linked the code row from SCR-064.
- Opened `/booking/coupons` on Flutter web and compared initial viewport with Figma. Full scroll/pixel comparison pending. Apply CTA awaits SCR-066; no coupon API or redemption.
- Ran `dart format` and `flutter analyze lib`: No issues found. No tests/backend. Next SCR-066 node `67:616`.

## Latest UI batch — SCR-066–067

- SCR-066 node `67:616`: implemented standalone coupon applied design state at `/booking/coupons/applied-demo` with original SVGs. Compared initial Flutter web viewport with Figma; full pixel/scroll comparison pending. It is not linked from coupon Apply because there is no coupon redemption service.
- SCR-067 node `67:861`: read Figma context and screenshot; exported original room image and 13 SVGs. Implemented `/booking/payment-method` with local payment-method selection, disabled pay-at-property option, and non-operational Continue CTA. Compared initial Flutter web viewport with Figma; full scroll/pixel comparison pending. Corrected header SVG assignment after visual check.
- Ran `dart format` and `flutter analyze lib`: no issues found. No tests/backend/payment API. Next SCR-068 node `67:1004`.

## Latest UI batch — SCR-068

- Read Figma node `67:1004` with screenshot; exported nine original SVGs. Implemented `/booking/wallet-demo` with static linked-wallet and booking-summary design states. The confirmation button is non-operational because no payment service exists.
- Opened Flutter web and compared the initial viewport with Figma. A wrong SVG was visible in the wallet emblem; corrected the callsite. Full scroll/pixel comparison pending.
- Ran `dart format` and `flutter analyze lib`: no issues found. No tests/backend. Next SCR-069 node `67:1459`; its Figma context/screenshot and original exports have been fetched, but no screen is coded yet.

## Latest UI batch — SCR-069–070

- Read Figma nodes `67:1459` and `67:1627` with screenshots and exported original property images and SVGs. Implemented separate domestic and international card demo routes.
- The card fields and selection are prototype UI only. Continue is non-operational; no payment data is sent or stored. Per the user's latest direction, these screens were **not opened on Flutter web or visually compared to rendered screenshots**. The original Figma images were used for layout reference. SVG callsite/geometry parity remains to review.
- Ran `dart format` and `flutter analyze lib`: no issues found. No tests/backend. Next SCR-071 node `67:1275`.

## Latest UI batch — SCR-071–075

- Read all five Figma nodes (`67:1275`, `67:1108`, `67:1769`, `67:1859`, `67:2038`) with screenshots and exported original images/SVGs. Implemented payment confirmation, processing, failure, success, and receipt states in `payment_flow_demo_screens.dart`.
- Processing/failure/success/receipt are standalone visual states. Payment confirmation CTA, failure Retry, and receipt Save Image do not claim backend success or save a file. Screens were **not opened in Flutter web** per user's latest request; no rendered screenshot comparison or exact visual match is claimed. SVG usage, barcode, and lower-scroll geometry need dedicated review.
- Ran `dart format` and `flutter analyze lib`: no issues found. No tests/backend/payment operations. Next SCR-076 node `67:2755`.

## Latest UI batch — SCR-076–080

- Read Figma nodes `67:2755`, `67:2424`, `67:2192`, `67:2305`, and `67:2528` with screenshots; exported original images/SVGs. Implemented five UI routes: post-payment guide, terms, missing information, change-method sheet, and final booking check.
- Checklist/terms/payment selection are local UI state. Demo contact and payment actions do not initiate calls or payment. Per latest user direction, Flutter web was not opened and no rendered screenshot comparison is claimed. The Figma asset callsites and lower-scroll geometry still require visual review.
- Ran `dart format` and `flutter analyze lib`: no issues found. No tests/backend. SCR-081 `/trips` already existed before this batch. Next new SCR-082 node `89:2`.

## Latest UI batch — SCR-082–086

- Read Figma nodes `89:2`, `89:443`, `89:588`, `89:1375`, and `89:795` with screenshots; exported original raster/SVG assets. Implemented trip detail, voucher, directions/contact, date-change request, and standalone result routes.
- Date selection/checklist navigation is local prototype UI. Voucher save/share, route directions, and host request confirmation are not executed. Per user direction, Flutter web was not opened; no rendered screenshot comparison is claimed. Figma asset callsites, QR placeholder, map drawing, and lower-scroll fidelity require review.
- Ran `dart format` and `flutter analyze lib`: no issues found. No tests/backend. Next SCR-087 node `89:970`; also complete missing SCR-018 node `31:4167` before declaring Page 1 complete.

## Latest UI batch — SCR-087–091

- Read Figma nodes `89:970`, `89:1115`, `89:1249`, `89:1659`, and `89:1829` with screenshots and exported original raster/SVG assets. Implemented cancellation start, estimate, reason, standalone success, and cancelled-list routes.
- Reason selection and note are local. Confirm cancellation is non-operational; success/cancelled/refund states are standalone demos because no booking or refund service exists. Per user direction, no Flutter web or rendered screenshot comparison was performed. Source SVG callsites and full visual fidelity require review.
- Ran `dart format` and `flutter analyze lib`: no issues found. No tests/backend. Next SCR-092 node `89:1976`; SCR-018 remains outstanding.

## Latest UI batch — SCR-092–096

- Read Figma nodes `89:1976`, `89:2176`, `89:2798`, `89:3077`, and `89:2356` with screenshots and exported original raster/SVG assets. Implemented refund tracking, refund complete, completed trips, write review, and help center routes.
- Refund states are standalone demo views. Review fields/tags/rating are local; Submit is non-operational. Help search is local input; no support service. No Flutter web/rendered screenshot comparison per user direction; source SVG callsite and full visual fidelity require review.
- Ran `dart format` and `flutter analyze lib`: no issues found. No tests/backend. Next SCR-097 node `89:2526`; SCR-018 remains outstanding.

## Latest UI batch — SCR-097–100, SCR-018, second SCR-021

- Read Figma nodes `89:2526`, `89:2686`, `89:2936`, `89:3228`, `31:4167`, and `31:4439` with screenshots and exported original raster/SVG assets. Implemented FAQ, support chat demo, upcoming-empty state, trip overview, profile-updated demo, and location-permission UI routes.
- The inventory audit found two distinct SCR-021 frames; both now have routes. SCR-018 and profile save success are standalone demo states. Support chat input/send, profile save confirmation, and location permission action are non-operational; no backend or native location permission is requested. Per user direction, Flutter web was not opened and no rendered screenshot comparison is claimed for this batch. SVG callsites, visual geometry, and detailed asset parity require review.
- Ran `dart format` and `flutter analyze lib`: no issues found. No tests/backend. Route coverage reached 101/101 Page 1 frames; visual QA remains partial.

## Page 1 route coverage audit (2026-11-04)

- Compared the route table with Figma Page 1 top-level metadata: 101 rows, 101 distinct Figma node IDs, 100 unique SCR numbers. The only repeated SCR number is `021`, covering Home and Location Permission. No SCR number 001–100 is missing.
- Checked literal local asset references in the newly added screens: all files exist and are nonempty. Fixed SCR-075 receipt barcode to use original Figma SVG `scr_075_02.svg`.
- Ran `dart format`, `flutter analyze lib` (no issues), and `flutter build web --no-pub` (succeeded). Build did not open or display the app. No tests, backend, database, API, or remote push.
- Coverage means a Flutter route/state exists for each frame. SCR-069–100, SCR-018, and Location Permission were **not** visually compared as rendered screens with Figma, per user's request not to put the app on web. Many original SVGs were exported but not yet used at exact callsites; several screens use Flutter icon/placeholder rendering. The map drawing and voucher QR need source-fidelity work. Do not claim full design match.

## Full Page 1 review checkpoint (2026-11-04)

Static audit: 101 distinct route/state frame mappings; 452 literal local asset references across 73 Dart files with 0 missing paths; 1300 SVGs with 0 XML parse failures. Corrected original SVG placement in Location Permission SCR-021, Room Detail SCR-050 and Policies SCR-051. Directions SCR-084 now layers original Figma map SVGs; voucher SCR-083 uses a demo QR graphic; SCR-085 availability action no longer opens a fabricated result. `dart format` and `flutter analyze lib` passed. No rendered screenshot comparison was performed in this review. Full visual fidelity, especially SCR-069–100 and lower-scroll geometry, remains unverified. No tests, backend, web preview or remote push.

## Bottom navigation icon consistency (2026-11-04)

The five bottom navigation items now use one canonical SVG set (`tab_explore`, `tab_search`, `tab_favorites`, `tab_trips`, `tab_account`) in `StayNestBottomNavigation`. Removed seven screen-specific icon/size overrides that made the same tab change shape between screens. All icons render in a consistent 20×20 slot; selected state uses teal, inactive state uses dark gray, matching the supplied navigation reference. `dart format` and `flutter analyze lib` passed. The Flutter web preview was restarted for review; no tests or backend work.

## Search bottom navigation (2026-11-04)

Added the shared `StayNestBottomNavigation` to `/search` (`DestinationSearchScreen`) with tab index 1 selected. The scrollable search content remains above the fixed navigation. `dart format` and `flutter analyze lib` passed; no tests or backend work.

## Page 1 recheck (2026-11-04)

Static review found 101 registered routes; 177 literal navigation calls. Two gallery photo paths use the declared `:index` parameter and are valid. The 417 literal local asset references resolve, and all 1300 SVGs parse as XML. No bottom-navigation icon overrides remain; `/search` uses the shared navigation. No rendered comparison was done in this pass. Main outstanding gap is visual fidelity: SCR-069–100, SCR-018, location permission, and lower-scroll sections lack comprehensive Flutter/Figma screenshot comparison; several late screens still use substitute icons or demo artwork. Do not claim full Figma match.

## Rendered Figma comparison — SCR-069–070 (2026-11-04)

Compared Figma MCP screenshots for nodes `67:1459` and `67:1627` against Flutter web at 393×1008. SCR-069 had outlined Material card-brand chips and an oversized save-card checkbox row; replaced them with compact filled brand labels and a compact checkbox so the security row fits above the fixed footer. SCR-070 initially showed an asset-load error and severe overflow: `international_payment_070.png` contained JPEG data. Renamed it to `.jpg` and updated the callsite. A fresh rendered capture showed the room image and normal layout. The demo-card number wrapped; reduced spacing to keep it on one line, but the final post-change screenshot capture was interrupted, so that last adjustment is not visually confirmed yet. `dart format` and `flutter analyze lib` passed. These are the only two late screens compared in this batch; do not mark SCR-071–100 visually checked.

## Rendered visual QA batch SCR-071–086 (2026-11-04)

Figma MCP screenshots and Flutter web were compared at mobile width for SCR-071–080 and SCR-082–086, including scrolled lower regions for SCR-076, SCR-082, SCR-085 and SCR-086. SCR-073 had an approximately 80px downward shift from vertical centering; changed it to top alignment and verified the corrected capture. SCR-074 hero image and SCR-075 room image were blank in the initial render. The underlying source bytes were JPEG while their filenames ended `.png`; copied 46 referenced JPEG assets to matching `.jpg` names, updated Dart callsites, and kept original files. Fresh captures confirmed the SCR-074 hero and SCR-075 room images. SCR-075 total-price row overflow was corrected with flexible left text and confirmed after rebuilding. SCR-079 payment sheet was shorter/lower than Figma; increased option minimum heights, pending rendered recheck. SCR-083 share voucher button was filled instead of outlined; corrected, pending rendered recheck. SCR-084–086 had the wrong secondary header text; changed the shared trip header to show each frame's status, pending rendered recheck. SCR-080 full-frame vertical spacing remains different; SCR-071–072 and SCR-076–078 retain smaller icon/spacing differences. `dart format` and `flutter analyze lib` passed. Do not mark SCR-087–100 visually checked yet.

## Visual QA batch SCR-087–091 (2026-11-04)

Compared Figma MCP screenshots with Flutter web at mobile width; scrolled to inspect lower content for SCR-087–090. SCR-087, SCR-089 and SCR-091 have the main cards, labels and actions in the expected order. SCR-088 lacks some original timeline icon/line treatment. SCR-090's pale refund amount panel rendered only at its content width; set it to full width, pending a post-change rendered capture. Minor SVG/icon substitutions and spacing differences remain in this group. `dart format` and `flutter analyze lib` passed.

## Visual QA batch SCR-092–100 (2026-11-04)

Compared Figma MCP screenshots with Flutter web at mobile width for SCR-092–100; scrolled lower content for SCR-092–094 and SCR-096. SCR-095 review text was only a hint, leaving the form empty and its count at 0/100; initialized the editable text controller with the Figma text and verified 74/100 after a hot restart. SCR-097 FAQ missed the no-cancellation-fee line; added it. SCR-098 chat missed the header subtitle and support avatar; added them. SCR-099 recommendation cards missed rating badges and /đêm units; added them. SCR-100 canceled status was unstyled and the refund percentage absent; added badge treatments. SCR-097–100 edits still need post-change rendered comparison. Timeline connector lines (SCR-092–093), icon substitutions, and exact spacing remain. `dart format` and `flutter analyze lib` passed. No tests or backend work.

## Visual QA follow-up SCR-018, second SCR-021, and late fixes (2026-11-04)

Compared Figma MCP screenshots `31:4167` and `31:4439` with Flutter web. SCR-018 profile success was about 25px too low below the banner; shortened two gaps and verified the title/card now align closely with Figma. Second SCR-021 Location Permission was inspected at top and lower scroll; map artwork, feature list, information notice, and fixed actions render, with minor chip/icon treatment differences. Post-change captures also verified SCR-097 FAQ no-fee line, SCR-098 chat header/avatar, SCR-099 rating/per-night labels, and SCR-100 canceled badge/percentage. SCR-100 hero image now starts at the Figma vertical position after spacing adjustment. Full pixel parity is still not established; earlier screens and remaining icon/spacing differences need continued review. `dart format` and `flutter analyze lib` passed. No tests, backend, or remote push.

## SCR-081 rendered comparison (2026-11-04)

Compared Figma node `89:294` with Flutter `/trips` at mobile width. Original room photo and core cards/actions render. Header used a shield and calendar instead of trip/bell symbols; corrected those icons and verified a fresh capture. Lower card spacing and some badges/icon details still differ. `dart format` and `flutter analyze lib` passed. Full Page 1 pixel parity is still open.

## Late-screen post-change recheck (2026-11-04)

Fresh Flutter captures confirmed SCR-079 payment method sheet height/options, SCR-083 outlined share button in lower scroll, SCR-084–086 status headers, and SCR-090 full-width pale refund panel. These screens still retain other spacing/icon differences from Figma. SCR-081 header icon fix was also rendered again. No further Dart changes in this recheck.

## Onboarding visual QA SCR-001–005 (2026-11-04)

Compared Figma MCP screenshots for nodes `3:363`, `2:123`, `2:181`, `3:295`, `3:414` with Flutter web at 390px mobile width. SCR-001 lacked the teal logo tile and used bar/dim loading dots; added the tile and three teal dots, then verified the revised capture. SCR-002–004 used long progress bars and blank back buttons; changed to Figma's short active marker/dots and visible arrows, verified SCR-003. SCR-003 feature chips were too small and lacked selected outlines; enlarged and styled them, verified a fresh capture. SCR-005 had an approximately 100px oversized gap between hero and sign-in; replaced the expanding gap, aligned the image/action positions, and moved the home indicator to the bottom. The last 7px image offset change passed format/analyze but has not yet been rendered again. Some typography, image crop, status bar, and exact spacing differences remain. `dart format` and `flutter analyze lib` passed; no tests or backend.


## Backend implementation handover — 2026-11-04

The user explicitly moved the project to backend/database/frontend integration work and supplied `/home/dat/Downloads/staynest_schema.sql` (copied to `docs/staynest_schema_mysql_draft.sql`). It is a MySQL 8 draft. `backend/db/migrations/001_initial.sql` converts it to PostgreSQL and adjusts it for Flutter Page 1: integer VND, price/policy snapshots, 15-minute booking hold, idempotency, hashed auth sessions, and `demo_payments`/`demo_refunds` with no PAN/CVV. `docs/BACKEND_MAPPING.md` maps screen groups to API/tables and records assumptions. VAT 10%, service fee 30.000đ, `STAY100` 100.000đ, and demo cancellation policy are inferred from SCR-064/065 and Figma, not production rules.

### Current status by flow

| Flow | Backend | Flutter | Verification / remaining work |
|---|---|---|---|
| Register/login/session/profile | Routes and scrypt password hash + opaque hashed sessions implemented | Login/signup, account name/email, voucher/trip counts, logout, profile display/edit use API; home greeting uses session. Secure storage added; unsupported loyalty counts/tier hidden. | Browser login against embedded API passed. No standalone PostgreSQL test. OTP, password reset and verification still demo. Add auth rate limit. |
| Catalog/destinations/search/property/rooms/reviews | GET routes, date/price/type/amenity filters implemented | Search/results uses destination, dates, adults, price/type and sort API filters; Mây detail price/favorite and generic catalog details read API; other Figma detail frames still static | Seed has Mây, An Villa, Riverside Home and Ocean Pearl. Embedded API/browser QA passed; standalone PostgreSQL validation and additional detail wiring remain. |
| Favorites | GET/PUT/DELETE scoped to user | Search card save and Favorites list/remove use API | Favorite add/remove was checked against the embedded HTTP API; Figma compare screens remain static demo. |
| Quote/voucher/booking | Quote with integer VND, capacity/date/voucher validation; booking transaction locks room row, counts overlap, stores snapshot and idempotency | Booking start picks dates; guest and request screens populate a shared draft; price screen loads a server quote and creates a booking with an idempotency key; coupon picker checks voucher availability and updates the draft | No live PostgreSQL/UI run yet. Earlier booking cards and coupon pricing still contain static Figma text. Run concurrent PostgreSQL integration test. |
| Demo payment/receipt | API accepts method only, records `DEMO-*`, marks `CONFIRMED_DEMO` | Payment method screen displays the active booking total and calls demo-payment; success navigates to `/booking/payment-success-live/:id`, which reads the real booking and demo receipt. The original `*-demo` success/receipt screens remain visual demos. | Confirm against a live DB and compare new live screen visually. Never pass card fields. |
| Trips/date change/cancel/refund/review | Owner-scoped backend routes implemented; refund stays demo | `/trips` now lists real bookings with loading/error/empty; `/trips/booking/live/:id` reads owner booking and calls change date, cancellation preview/cancel, refund status and post-stay review APIs. Older Figma trip subroutes remain demos. | Live DB/UI validation and visual comparison remain. Test ownership/cancellation/review against PostgreSQL. |
| Support/notifications/map | No server implementation | Existing Figma demo UI | Keep explicitly demo until product behavior/source chosen. |

### Commands run

- `npm install express pg dotenv cors --prefix backend --cache /tmp/staynest-npm-cache --no-audit --no-fund`: succeeded. `npm install --save-dev @electric-sql/pglite ...`: succeeded.
- `npm run check --prefix backend`: passed.
- `npm test --prefix backend`: 8 tests passed (quote, dates/capacity, voucher, refund policy, password hash, PostgreSQL migration/constraint, idempotent seed, HTTP booking inventory/ownership/demo payment lifecycle via embedded PGlite). Concurrent booking and owner access are verified in embedded mode; repeat against a standalone PostgreSQL server.
- Browser QA on `http://127.0.0.1:8090`: home rendered; demo seed user logged in successfully through Flutter → API; account showed returned name/email; trips API returned empty list. This exposed an incorrect empty message in the upcoming tab, fixed in source. The browser was still showing the prior build during that observation; recheck after the final build.
- `flutter pub add http flutter_secure_storage`: succeeded.
- `dart format` on touched Flutter files and `flutter analyze lib`: passed after login/signup/search/account/profile/favorites edits.
- Without database configuration, backend health returned 200 and readiness returned 503 `DATABASE_UNAVAILABLE`. With `STAYNEST_EMBEDDED_DEMO=1`, startup migrates/seeds in-memory PGlite and readiness returns 200. HTTP smoke covered catalog, auth, quote, two-of-three concurrent room inventory, ownership isolation, payment, receipt, cancellation and refund. This does not replace a standalone PostgreSQL test.
- `flutter build web --no-pub`: succeeded after initial API integration (149.3 s), after booking/trip integration (168.0 s), and after the live payment success route (160.0 s). Builds showed a non-blocking Cupertino icon font warning.
- `flutter pub get` after adding direct `intl` dependency: succeeded. `flutter test --no-pub test`: 2 passed (booking draft dates/capacity and pending payment never showing a success state). `flutter analyze lib`: no issues after live success screen and booking/trip edits. Final web build succeeded.
- Promo usage now counts active/held bookings rather than a permanent counter, so expired holds no longer consume voucher capacity. The count runs after locking the promotion row for concurrent booking creation. Refund cutoff uses the snapshot check-in time (default 14:00 +07:00). Backend check and 8 tests passed.

### Environment and next steps

No `psql`, `postgres`, Docker or Podman binaries were found, and sudo cannot run in this sandbox. The repo has no usable Git metadata (`git status` reports not a repository). During the earlier user-requested pause, the demo servers were stopped. In the resumed turn, an in-memory demo API is running on 127.0.0.1:3000 and the latest web build is served on 127.0.0.1:8100 for QA; these process sessions may not persist later. Demo login is `an.demo@example.com` / `demo-test-pass-123` for this local process only. Setup steps are in README. Do not claim standalone PostgreSQL or complete frontend integration.

1. Open the app against a real seeded PostgreSQL database to verify the new flows visually and functionally. The current environment has no PostgreSQL server, so this gate remains open.
2. Run a real PostgreSQL instance, set `backend/.env`, run migration and seed. Validate the seed, API auth/catalog/booking/payment/cancel/review flows and concurrent booking/owner isolation tests.
3. Finish booking UI: remove remaining hardcoded dates/totals in earlier cards and coupon summary; align the new live success/trip detail screens with the corresponding Figma frames. Keep existing Figma presentation and navigation. Do not display a success state before an API success.
4. Parameterize property details and other discovery screens; remove remaining hardcoded profile/trip/favorites counts and sample dates where backend data should appear.
5. Add integration tests for concurrent reservations, owner access, voucher redemption and cancellation/refund. Repeat formatter/analyze/test/build, update this handover with exact results.
