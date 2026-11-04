# Prompt sửa lỗi UI/UX và luồng đặt phòng StayNest

Bạn là senior Flutter engineer. Hãy **sửa trực tiếp mã nguồn** của dự án StayNest (Flutter, `flutter_riverpod`, `go_router`, REST API Node/Express) theo yêu cầu dưới đây. Không thay đổi API public hoặc schema backend nếu không thật sự cần thiết. Ưu tiên Riverpod, code có kiểu dữ liệu rõ ràng, và không dùng state cục bộ cho dữ liệu dùng chung giữa các màn hình.

## Bối cảnh đã rà soát

- User đang có `currentUserProvider` tại `lib/data/staynest_api.dart`; API `/me` trả về `full_name`, `avatar_url` (có thể `null`). Tuy nhiên các AppBar hiện tự vẽ nhiều `CircleAvatar`/asset khác nhau: ví dụ avatar ảnh cứng ở `lib/screens/explore_home_screen.dart`, icon teal ở `favorites_screen.dart`, `my_trips_screen.dart`, `booking_summary_screen.dart`, `booking_price_screen.dart`, và `property_detail_screen.dart`.
- Favorite hiện là `FutureProvider` (`myFavoritesProvider`) nhưng mỗi màn lại có state riêng: `_isSaved` + gọi `api.favorites()` ở Home, `saved` + `_loadFavorite()` ở Property Detail, và nút ở `search_results_list_screen.dart` gọi `setFavorite(slug, true)` **mà không invalidate provider**. Đây là nguyên nhân trực tiếp của trạng thái tim/list/count bị lệch.
- Profile Edit đi từ `ProfileScreen` bằng `context.push('/profile/edit')`, nhưng `Hủy` và Back chỉ gọi `context.pop()`. Nếu route được mở trực tiếp, hoặc stack không thể pop, thao tác không có fallback nên người dùng bị kẹt. Vùng chạm của Back cũng chỉ là SVG 16x16.
- Trips có sẵn `intl`, nhưng `_LiveTripCard` trong `my_trips_screen.dart` và `LiveTripDetailScreen` vẫn in trực tiếp `check_in_date` / `check_out_date`, khiến ISO timestamp xuất hiện nguyên văn.
- `BookingSummaryScreen` đã kiểm tra availability ở một số nơi, nhưng disabled button lại dùng màu teal như button active; cần gom điều kiện thành một biến duy nhất để cảnh báo, phần giá và CTA không mâu thuẫn. `BookingPriceScreen` lại kiểm tra `< 1`, bỏ qua `draft.roomCount` khi khách đặt nhiều phòng.
- `BookingPriceScreen` gọi `vnd(quote?['...'])`; hàm này fallback `0`, nên toàn bộ giá và tổng tiền render `0đ` trước khi quote về. Spinner hiện chỉ nằm phía dưới các card nên không ngăn được flash.

## Công việc bắt buộc

### 1. Avatar dùng chung, cập nhật đồng bộ

1. Tạo `lib/widgets/user_avatar_app_bar.dart` với `UserAvatarAppBar` là `ConsumerWidget`.
2. Widget phải theo dõi `currentUserProvider` bằng `ref.watch`, nhận các tham số tối thiểu: `radius`/`size`, callback `onTap`, và cách hiển thị lúc loading/không đăng nhập.
3. Khi có `avatar_url`, hiển thị `Image.network`/`NetworkImage` an toàn (placeholder và `errorBuilder`). Nếu API có thể trả đường dẫn tương đối, chuẩn hóa nó bằng `StayNestApi.mediaUrl`; không hard-code ảnh `nguyen_an.jpg` như ảnh đại diện của người dùng.
4. Khi không có avatar, render initials lấy từ `full_name` (tối đa 2 ký tự); chỉ dùng biểu tượng person cho anonymous/loading nếu cần. Không hiển thị chữ cố định `ND`.
5. Thay tất cả avatar ở góc phải AppBar/header của Home, Favorites, Trips, chi tiết homestay, Profile/Account, các màn booking/payment có avatar bằng widget này. Giữ layout/kích thước theo từng screen, nhưng nguồn dữ liệu phải chỉ có một.
6. Sau cập nhật profile, dùng kết quả API hoặc invalidate/refresh `currentUserProvider` để mọi avatar đổi ngay. Tránh `ref.read(...).value` cho UI cần reactive.

### 2. Không kẹt ở Chỉnh Sửa Hồ Sơ

1. Trong `ProfileEditScreen`, tạo một hàm thoát duy nhất, ví dụ `_closeEditor()`:

```dart
void _closeEditor() {
  if (context.canPop()) {
    context.pop();
  } else {
    context.go('/profile');
  }
}
```

2. Gắn cả Back và `Hủy` vào hàm này. Dùng `IconButton` hoặc `SizedBox` tối thiểu 44x44 cho Back để bảo đảm hit target. Không gọi `Navigator.pop` với một `BuildContext` của dialog/nested navigator khi đóng page.
3. Xử lý hệ thống back cùng quy tắc (qua `PopScope` nếu cần). Nếu bổ sung cảnh báo dữ liệu chưa lưu thì chỉ hiện khi form thực sự dirty, và cả Back/Hủy/system-back phải có hành vi nhất quán.
4. Save thành công phải trở về `/profile` và UI profile/avatar phản ánh dữ liệu mới; save thất bại không được điều hướng đi.

### 3. Một nguồn trạng thái Favorite duy nhất

1. Thay `myFavoritesProvider` dạng `FutureProvider<List<dynamic>>` bằng một `AsyncNotifier`/`Notifier` typed (ví dụ `FavoriteController` + `FavoriteState`), quản lý `AsyncValue<Set<String>>` hoặc danh sách property typed. Controller cần `load`, `isFavorite(slug)`, `toggle(slug)`, `remove(slug)`.
2. `toggle` phải optimistic update, chặn double tap theo slug, gọi `api.setFavorite`, rồi rollback chính xác khi lỗi và hiển thị lỗi cho caller. Khi đăng nhập/đăng xuất đổi user, phải reset/reload state phù hợp; không rò favorite của user cũ.
3. Mọi nơi toggle (Home, Property Detail, Search Results, Favorites và các card khác) phải gọi controller; xóa hoàn toàn `_isSaved`, `saved`, `_loadFavorite`, `_checkFavorite` và các API fetch/toggle riêng lẻ dùng cho cùng chức năng.
4. Favorites tab watch state này để list, filter count, `So sánh (n)`, Profile count cùng re-render trong cùng frame/optimistic state. Bảo toàn loading/error/empty state và retry.
5. Nếu cần trả list đầy đủ từ backend, state có thể lưu cả item và derive `Set<String>`; đừng fetch lại `/me/favorites` sau từng tap nếu optimistic state đã đủ. Cần xử lý toggle ở Search Results hiện chỉ `setFavorite(slug, true)` nhưng không invalidate state.

### 4. Format ngày chuyến đi bằng `intl`

1. Viết helper dùng chung (ví dụ `lib/utils/date_formatters.dart`) nhận `Object?`, parse an toàn `DateTime`, và format `DateFormat('dd/MM/yyyy', 'vi_VN')`. Có thể dùng `dd/MM/yyyy HH:mm` chỉ khi API thực sự chứa giờ và UI cần giờ.
2. Thay mọi raw interpolation của `check_in_date`/`check_out_date`, ít nhất trong `MyTripsScreen`, `LiveTripDetailScreen`, và các màn receipt/success có dữ liệu booking live.
3. Không dùng `DateTime.toString()`, `substring` hay tự nối `day/month/year` trong các màn live. Với chuỗi date-only `YYYY-MM-DD`, parse theo ngày calendar (không để UTC làm lùi ngày ở timezone Việt Nam). Với ISO có `Z`, đổi sang local trước format. Nếu parse thất bại, dùng fallback thân thiện `Chưa cập nhật`, không in ISO thô.

### 5. Availability nhất quán và chặn đặt phòng thật sự

1. Trong `BookingSummaryScreen` derive một biến duy nhất, chẳng hạn:

```dart
final isQuoteLoading = quote == null && error == null;
final isAvailable = quote != null &&
    toInt(quote!['availableUnits']) >= draft.roomCount;
final availabilityMessage = quote == null ? null : isAvailable ? null :
    'Không đủ ${draft.roomCount} phòng cho ngày đã chọn.';
```

2. Chỉ render warning đỏ khi quote đã load và `!isAvailable`; nếu available tuyệt đối không render warning. Khi unavailable: dùng warning card rõ ràng, không hiển thị/tổng kết giá như thể có thể tiếp tục (có thể vẫn cho xem breakdown với nhãn “không thể giữ phòng”, nhưng CTA bắt buộc disabled và không gọi navigate).
3. CTA cần có disabled màu xám/teal nhạt, semantics hợp lý, label rõ (`Đang kiểm tra phòng…`, `Chọn ngày khác`, hoặc `Không còn phòng`), không dùng màu active cho disabled. Khi chưa có quote/đang lỗi không được phép tiếp tục; có retry khi lỗi.
4. Áp dụng đúng cùng điều kiện `availableUnits >= draft.roomCount` tại `BookingPriceScreen`, `createBooking` guard, và bất kỳ CTA đặt phòng khác. Backend vẫn là hàng rào cuối qua `NO_AVAILABILITY`; bắt 409 và reload quote, báo người dùng chọn ngày/phòng khác.

### 6. Không chớp `0đ` ở Thanh toán

1. `BookingPriceScreen` chỉ render thông tin giá, tổng, coupon discount và CTA thanh toán sau khi quote sẵn sàng. Khi `quote == null && error == null`, thay toàn bộ vùng nội dung/bottom CTA bằng loading screen phủ màn hình hoặc skeleton/shimmer có kích thước tương đương. Không gọi formatter có fallback `0` cho dữ liệu chưa có.
2. Khi quote lỗi, chỉ hiện error state + retry; không hiện 0đ và không cho tạo booking. Sau khi đổi coupon/dates, quay lại loading state trước khi request mới hoàn tất.
3. Sau khi tạo booking, `PaymentMethodScreen` phải lấy amount từ booking đã có và có guard/loading/error nếu `draft.booking` hoặc `total_vnd` chưa tồn tại; không hiển thị 0đ như một giá trị hợp lệ.

## Chất lượng và kiểm thử

1. Giữ conventions Dart (`dart format`), dispose controller, kiểm tra `mounted` sau async, không gọi `setState` khi disposed.
2. Không thay đổi kiến trúc route ngoài phần cần thiết; ưu tiên named route hiện có.
3. Viết/cập nhật widget/unit tests cho: avatar đổi sau khi current user cập nhật; favorite optimistic sync giữa card và Favorites/count, gồm rollback; Profile Edit Back/Hủy có fallback; ISO date format; availability với `availableUnits < roomCount`; và màn payment không có `0đ` trước quote.
4. Chạy `flutter analyze` và `flutter test`. Nếu môi trường không cho Flutter cập nhật engine cache, ghi rõ lỗi môi trường đó, nhưng vẫn chạy các kiểm tra khả thi.
5. Khi hoàn tất, báo cáo: file thay đổi, flow state mới, test đã chạy/kết quả, và mọi limitation còn lại. Không chỉ mô tả giải pháp: phải thực hiện sửa code.
