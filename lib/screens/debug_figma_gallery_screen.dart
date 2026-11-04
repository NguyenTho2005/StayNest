import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/onboarding_controller.dart';
import '../data/search_filter_state.dart';
import '../design/tokens.dart';

class FigmaScreenEntry {
  const FigmaScreenEntry({
    required this.scr,
    required this.title,
    required this.route,
    required this.description,
  });

  final String scr;
  final String title;
  final String route;
  final String description;
}

class DebugFigmaGalleryScreen extends ConsumerStatefulWidget {
  const DebugFigmaGalleryScreen({super.key});

  @override
  ConsumerState<DebugFigmaGalleryScreen> createState() =>
      _DebugFigmaGalleryScreenState();
}

class _DebugFigmaGalleryScreenState
    extends ConsumerState<DebugFigmaGalleryScreen> {
  String search = '';

  static const List<(String groupTitle, List<FigmaScreenEntry> screens)>
  groups = [
    (
      '1. Khởi động & xác thực (SCR 001–014)',
      [
        FigmaScreenEntry(
          scr: 'SCR-001',
          title: 'Splash Screen',
          route: '/splash',
          description: 'Màn hình khởi động, logo StayNest',
        ),
        FigmaScreenEntry(
          scr: 'SCR-002',
          title: 'Onboarding 1',
          route: '/onboarding/1',
          description: 'Khám phá nơi ở phù hợp',
        ),
        FigmaScreenEntry(
          scr: 'SCR-003',
          title: 'Onboarding 2',
          route: '/onboarding/2',
          description: 'Lọc đúng nhu cầu (tiện nghi)',
        ),
        FigmaScreenEntry(
          scr: 'SCR-004',
          title: 'Onboarding 3',
          route: '/onboarding/3',
          description: 'Giá rõ ràng, đặt dễ dàng',
        ),
        FigmaScreenEntry(
          scr: 'SCR-005',
          title: 'Welcome Screen',
          route: '/welcome',
          description: 'Màn chào đón, nút đăng nhập/đăng ký/khám phá khách',
        ),
        FigmaScreenEntry(
          scr: 'SCR-006',
          title: 'Login',
          route: '/login',
          description: 'Đăng nhập tài khoản',
        ),
        FigmaScreenEntry(
          scr: 'SCR-007',
          title: 'Login Error',
          route: '/login/error',
          description: 'Màn hình lỗi đăng nhập minh họa',
        ),
        FigmaScreenEntry(
          scr: 'SCR-008',
          title: 'Sign Up',
          route: '/signup',
          description: 'Tạo tài khoản mới',
        ),
        FigmaScreenEntry(
          scr: 'SCR-009',
          title: 'OTP Verification',
          route: '/otp',
          description: 'Nhập mã xác thực OTP',
        ),
        FigmaScreenEntry(
          scr: 'SCR-010',
          title: 'Sign Up Success',
          route: '/signup/success',
          description: 'Đăng ký thành công',
        ),
        FigmaScreenEntry(
          scr: 'SCR-011',
          title: 'Forgot Password',
          route: '/forgot-password',
          description: 'Quên mật khẩu, gửi email',
        ),
        FigmaScreenEntry(
          scr: 'SCR-012',
          title: 'Password Reset OTP',
          route: '/password/reset/otp',
          description: 'Mã xác nhận đặt lại mật khẩu',
        ),
        FigmaScreenEntry(
          scr: 'SCR-013',
          title: 'New Password',
          route: '/password/new',
          description: 'Nhập mật khẩu mới',
        ),
        FigmaScreenEntry(
          scr: 'SCR-014',
          title: 'Password Reset Success',
          route: '/password/success',
          description: 'Đặt lại mật khẩu thành công',
        ),
      ],
    ),
    (
      '2. Khám phá & tài khoản (SCR 015–024)',
      [
        FigmaScreenEntry(
          scr: 'SCR-015',
          title: 'Account',
          route: '/account',
          description: 'Quản lý tài khoản',
        ),
        FigmaScreenEntry(
          scr: 'SCR-016',
          title: 'Profile',
          route: '/profile',
          description: 'Hồ sơ người dùng',
        ),
        FigmaScreenEntry(
          scr: 'SCR-017',
          title: 'Edit Profile',
          route: '/profile/edit',
          description: 'Chỉnh sửa họ tên, email, sđt',
        ),
        FigmaScreenEntry(
          scr: 'SCR-018',
          title: 'Profile Updated Success',
          route: '/profile/updated-demo',
          description: 'Cập nhật thông tin thành công',
        ),
        FigmaScreenEntry(
          scr: 'SCR-019',
          title: 'Settings',
          route: '/settings',
          description: 'Cài đặt ứng dụng',
        ),
        FigmaScreenEntry(
          scr: 'SCR-020',
          title: 'Notifications',
          route: '/notifications',
          description: 'Thông báo & thông điệp',
        ),
        FigmaScreenEntry(
          scr: 'SCR-021A',
          title: 'Location Permission',
          route: '/location-permission',
          description: 'Xin quyền truy cập vị trí',
        ),
        FigmaScreenEntry(
          scr: 'SCR-021B',
          title: 'Home (Explore)',
          route: '/',
          description: 'Trang chủ khám phá StayNest',
        ),
        FigmaScreenEntry(
          scr: 'SCR-022',
          title: 'Destinations',
          route: '/destinations',
          description: 'Danh mục điểm đến nổi bật',
        ),
        FigmaScreenEntry(
          scr: 'SCR-023',
          title: 'Offers',
          route: '/offers',
          description: 'Ưu đãi & khuyến mãi',
        ),
        FigmaScreenEntry(
          scr: 'SCR-024',
          title: 'Recommendations',
          route: '/recommendations',
          description: 'Gợi ý chỗ ở độc bản',
        ),
      ],
    ),
    (
      '3. Tìm kiếm (SCR 025–040)',
      [
        FigmaScreenEntry(
          scr: 'SCR-025',
          title: 'Destination Search',
          route: '/search',
          description: 'Nhập điểm đến và tìm kiếm',
        ),
        FigmaScreenEntry(
          scr: 'SCR-026',
          title: 'Guests & Rooms Picker',
          route: '/search/guests',
          description: 'Chọn số lượng khách & phòng',
        ),
        FigmaScreenEntry(
          scr: 'SCR-027',
          title: 'Stay Dates Picker',
          route: '/search/dates',
          description: 'Chọn ngày nhận & trả phòng',
        ),
        FigmaScreenEntry(
          scr: 'SCR-028',
          title: 'Filter Price & Property Type',
          route: '/search/filters/price-property',
          description: 'Lọc ngân sách và loại chỗ ở',
        ),
        FigmaScreenEntry(
          scr: 'SCR-029',
          title: 'Filter Amenities',
          route: '/search/filters/amenities',
          description: 'Lọc tiện nghi phòng',
        ),
        FigmaScreenEntry(
          scr: 'SCR-030',
          title: 'Search Sort',
          route: '/search/sort',
          description: 'Sắp xếp giá & đánh giá',
        ),
        FigmaScreenEntry(
          scr: 'SCR-031',
          title: 'Search Results List',
          route: '/search/results',
          description: 'Danh sách kết quả tìm kiếm',
        ),
        FigmaScreenEntry(
          scr: 'SCR-032',
          title: 'Search Map View',
          route: '/search/map',
          description: 'Bản đồ chỗ ở trực quan',
        ),
        FigmaScreenEntry(
          scr: 'SCR-033',
          title: 'Property Quick View',
          route: '/search/quick-view',
          description: 'Xem nhanh thông tin chỗ ở',
        ),
        FigmaScreenEntry(
          scr: 'SCR-034',
          title: 'Search Empty State',
          route: '/search/empty',
          description: 'Không tìm thấy chỗ ở',
        ),
        FigmaScreenEntry(
          scr: 'SCR-035',
          title: 'Search Loading State',
          route: '/search/loading',
          description: 'Đang tải kết quả tìm kiếm',
        ),
        FigmaScreenEntry(
          scr: 'SCR-036',
          title: 'Recent Searches',
          route: '/search/recent',
          description: 'Lịch sử tìm kiếm gần đây',
        ),
        FigmaScreenEntry(
          scr: 'SCR-037',
          title: 'Da Nang Destination Detail',
          route: '/destinations/da-nang',
          description: 'Chi tiết điểm đến Đà Nẵng',
        ),
        FigmaScreenEntry(
          scr: 'SCR-038',
          title: 'Destination Hotels List',
          route: '/destinations/da-nang/hotels',
          description: 'Khách sạn tại Đà Nẵng',
        ),
        FigmaScreenEntry(
          scr: 'SCR-039',
          title: 'Property Categories',
          route: '/categories',
          description: 'Phân loại homestay / resort',
        ),
        FigmaScreenEntry(
          scr: 'SCR-040',
          title: 'Applied Filters Overview',
          route: '/search/applied-filters',
          description: 'Tổng quan các bộ lọc đã chọn',
        ),
      ],
    ),
    (
      '4. Chỗ ở & yêu thích (SCR 041–060)',
      [
        FigmaScreenEntry(
          scr: 'SCR-041',
          title: 'Property Detail (Mây Homestay)',
          route: '/properties/may-homestay',
          description: 'Chi tiết chỗ ở đầy đủ Figma',
        ),
        FigmaScreenEntry(
          scr: 'SCR-042',
          title: 'Photo Gallery',
          route: '/properties/may-homestay/gallery',
          description: 'Thư viện hình ảnh chỗ ở',
        ),
        FigmaScreenEntry(
          scr: 'SCR-043',
          title: 'Photo Viewer',
          route: '/properties/may-homestay/gallery/photo/0',
          description: 'Xem ảnh phóng to toàn màn hình',
        ),
        FigmaScreenEntry(
          scr: 'SCR-044',
          title: 'Property Amenities List',
          route: '/properties/may-homestay/amenities',
          description: 'Danh sách tiện ích chi tiết',
        ),
        FigmaScreenEntry(
          scr: 'SCR-045',
          title: 'Reviews Overview',
          route: '/properties/may-homestay/reviews/overview',
          description: 'Tổng quan đánh giá & điểm số',
        ),
        FigmaScreenEntry(
          scr: 'SCR-046',
          title: 'Reviews List',
          route: '/properties/may-homestay/reviews',
          description: 'Danh sách đánh giá từ khách',
        ),
        FigmaScreenEntry(
          scr: 'SCR-047',
          title: 'Review Filter',
          route: '/properties/may-homestay/reviews/filter',
          description: 'Lọc đánh giá theo xếp hạng',
        ),
        FigmaScreenEntry(
          scr: 'SCR-048',
          title: 'Property Location Map',
          route: '/properties/may-homestay/location',
          description: 'Vị trí địa lý & tiện ích lân cận',
        ),
        FigmaScreenEntry(
          scr: 'SCR-049',
          title: 'Room Selection',
          route: '/properties/may-homestay/rooms',
          description: 'Chọn loại phòng lưu trú',
        ),
        FigmaScreenEntry(
          scr: 'SCR-050',
          title: 'Room Detail',
          route: '/properties/may-homestay/rooms/studio',
          description: 'Chi tiết phòng Studio có bếp',
        ),
        FigmaScreenEntry(
          scr: 'SCR-051',
          title: 'Property Policies',
          route: '/properties/may-homestay/policies',
          description: 'Chính sách & nội quy phòng',
        ),
        FigmaScreenEntry(
          scr: 'SCR-052',
          title: 'Refund Policy',
          route: '/properties/may-homestay/policies/refund',
          description: 'Chính sách hoàn tiền linh hoạt',
        ),
        FigmaScreenEntry(
          scr: 'SCR-053',
          title: 'Favorite Saved Feedback',
          route: '/favorites/saved',
          description: 'Đã lưu vào danh sách yêu thích',
        ),
        FigmaScreenEntry(
          scr: 'SCR-054',
          title: 'Favorites List',
          route: '/favorites',
          description: 'Màn hình danh sách yêu thích',
        ),
        FigmaScreenEntry(
          scr: 'SCR-055',
          title: 'Favorites Empty State',
          route: '/favorites/empty',
          description: 'Chưa có chỗ ở yêu thích',
        ),
        FigmaScreenEntry(
          scr: 'SCR-056',
          title: 'Compare Selection',
          route: '/favorites/compare/select',
          description: 'Chọn chỗ ở để so sánh',
        ),
        FigmaScreenEntry(
          scr: 'SCR-057',
          title: 'Compare Table',
          route: '/favorites/compare',
          description: 'Bảng so sánh chi tiết',
        ),
        FigmaScreenEntry(
          scr: 'SCR-058',
          title: 'Compare Price',
          route: '/favorites/compare/prices',
          description: 'So sánh mức giá phòng',
        ),
        FigmaScreenEntry(
          scr: 'SCR-059',
          title: 'Host Chat Demo',
          route: '/properties/may-homestay/host-chat',
          description: 'Trò chuyện với chủ nhà Lan',
        ),
        FigmaScreenEntry(
          scr: 'SCR-060',
          title: 'Booking Summary',
          route: '/booking/summary',
          description: 'Tóm tắt đặt phòng',
        ),
      ],
    ),
    (
      '5. Đặt phòng & thanh toán (SCR 061–080)',
      [
        FigmaScreenEntry(
          scr: 'SCR-061',
          title: 'Booking Start',
          route: '/booking/start',
          description: 'Bắt đầu quá trình đặt phòng',
        ),
        FigmaScreenEntry(
          scr: 'SCR-062',
          title: 'Guest Information',
          route: '/booking/guests',
          description: 'Nhập thông tin người lưu trú',
        ),
        FigmaScreenEntry(
          scr: 'SCR-063',
          title: 'Special Requests',
          route: '/booking/requests',
          description: 'Yêu cầu đặc biệt cho chỗ ở',
        ),
        FigmaScreenEntry(
          scr: 'SCR-064',
          title: 'Booking Price Breakdown',
          route: '/booking/price',
          description: 'Chi tiết giá & thuế phí minh bạch',
        ),
        FigmaScreenEntry(
          scr: 'SCR-065',
          title: 'Coupons List',
          route: '/booking/coupons',
          description: 'Danh sách mã giảm giá',
        ),
        FigmaScreenEntry(
          scr: 'SCR-066',
          title: 'Coupon Applied Demo',
          route: '/booking/coupons/applied-demo',
          description: 'Áp dụng mã giảm giá thành công',
        ),
        FigmaScreenEntry(
          scr: 'SCR-067',
          title: 'Payment Method Selection',
          route: '/booking/payment-method',
          description: 'Chọn phương thức thanh toán',
        ),
        FigmaScreenEntry(
          scr: 'SCR-068',
          title: 'Wallet Payment Demo',
          route: '/booking/wallet-demo',
          description: 'Thanh toán qua ví điện tử',
        ),
        FigmaScreenEntry(
          scr: 'SCR-069',
          title: 'Domestic Card Payment',
          route: '/booking/domestic-card-demo',
          description: 'Thẻ ATM nội địa Napas',
        ),
        FigmaScreenEntry(
          scr: 'SCR-070',
          title: 'International Card Payment',
          route: '/booking/international-card-demo',
          description: 'Thẻ quốc tế Visa / MasterCard',
        ),
        FigmaScreenEntry(
          scr: 'SCR-071',
          title: 'Payment Confirmation',
          route: '/booking/payment-confirmation',
          description: 'Xác nhận thông tin thanh toán',
        ),
        FigmaScreenEntry(
          scr: 'SCR-072',
          title: 'Payment Processing Demo',
          route: '/booking/payment-processing-demo',
          description: 'Màn hình đang xử lý giao dịch',
        ),
        FigmaScreenEntry(
          scr: 'SCR-073',
          title: 'Payment Failure Demo',
          route: '/booking/payment-failure-demo',
          description: 'Giao dịch không thành công & thử lại',
        ),
        FigmaScreenEntry(
          scr: 'SCR-074',
          title: 'Payment Success Demo',
          route: '/booking/payment-success-demo',
          description: 'Thanh toán thành công',
        ),
        FigmaScreenEntry(
          scr: 'SCR-075',
          title: 'Payment Receipt',
          route: '/booking/receipt-demo',
          description: 'Biên nhận điện tử StayNest',
        ),
        FigmaScreenEntry(
          scr: 'SCR-076',
          title: 'Post Payment Guide',
          route: '/booking/post-payment-guide-demo',
          description: 'Hướng dẫn nhận phòng sau thanh toán',
        ),
        FigmaScreenEntry(
          scr: 'SCR-077',
          title: 'Transaction Terms',
          route: '/booking/transaction-terms',
          description: 'Điều khoản giao dịch & bảo mật',
        ),
        FigmaScreenEntry(
          scr: 'SCR-078',
          title: 'Payment Missing Information',
          route: '/booking/missing-information-demo',
          description: 'Thiếu thông tin thanh toán',
        ),
        FigmaScreenEntry(
          scr: 'SCR-079',
          title: 'Change Payment Method',
          route: '/booking/change-payment-method',
          description: 'Đổi phương thức thanh toán',
        ),
        FigmaScreenEntry(
          scr: 'SCR-080',
          title: 'Final Booking Check',
          route: '/booking/final-check-demo',
          description: 'Kiểm tra lần cuối trước khi hoàn tất',
        ),
      ],
    ),
    (
      '6. Chuyến đi & hỗ trợ (SCR 081–100)',
      [
        FigmaScreenEntry(
          scr: 'SCR-081',
          title: 'My Trips',
          route: '/trips',
          description: 'Tab chuyến đi: sắp tới, hoàn thành, đã hủy',
        ),
        FigmaScreenEntry(
          scr: 'SCR-082',
          title: 'Booking Detail',
          route: '/trips/booking',
          description: 'Chi tiết đặt phòng đã xác nhận',
        ),
        FigmaScreenEntry(
          scr: 'SCR-083',
          title: 'Booking Voucher',
          route: '/trips/booking/voucher',
          description: 'Voucher xác nhận đặt phòng & QR code',
        ),
        FigmaScreenEntry(
          scr: 'SCR-084',
          title: 'Directions & Host Contact',
          route: '/trips/booking/directions',
          description: 'Chỉ đường tới chỗ ở & số liên hệ',
        ),
        FigmaScreenEntry(
          scr: 'SCR-085',
          title: 'Change Dates Request',
          route: '/trips/booking/change-dates',
          description: 'Yêu cầu đổi ngày lưu trú',
        ),
        FigmaScreenEntry(
          scr: 'SCR-086',
          title: 'Change Dates Result',
          route: '/trips/booking/change-dates/result-demo',
          description: 'Xác nhận yêu cầu đổi ngày đã gửi',
        ),
        FigmaScreenEntry(
          scr: 'SCR-087',
          title: 'Cancellation Start',
          route: '/trips/booking/cancel',
          description: 'Bắt đầu quy trình hủy phòng & chính sách',
        ),
        FigmaScreenEntry(
          scr: 'SCR-088',
          title: 'Refund Estimate',
          route: '/trips/booking/refund-estimate',
          description: 'Ước tính số tiền hoàn trả',
        ),
        FigmaScreenEntry(
          scr: 'SCR-089',
          title: 'Cancellation Reason',
          route: '/trips/booking/cancel/reason',
          description: 'Chọn lý do hủy & xác nhận',
        ),
        FigmaScreenEntry(
          scr: 'SCR-090',
          title: 'Cancellation Success',
          route: '/trips/booking/cancel/success-demo',
          description: 'Hủy phòng thành công & tiến trình',
        ),
        FigmaScreenEntry(
          scr: 'SCR-091',
          title: 'Cancelled Trips',
          route: '/trips/cancelled-demo',
          description: 'Danh sách đơn đặt phòng đã hủy',
        ),
        FigmaScreenEntry(
          scr: 'SCR-092',
          title: 'Refund Tracking',
          route: '/trips/refund-tracking-demo',
          description: 'Theo dõi tiến trình hoàn tiền',
        ),
        FigmaScreenEntry(
          scr: 'SCR-093',
          title: 'Refund Complete',
          route: '/trips/refund-complete-demo',
          description: 'Hoàn tiền thành công',
        ),
        FigmaScreenEntry(
          scr: 'SCR-094',
          title: 'Completed Trips',
          route: '/trips/completed-demo',
          description: 'Danh sách các chuyến đi đã hoàn thành',
        ),
        FigmaScreenEntry(
          scr: 'SCR-095',
          title: 'Write Review',
          route: '/trips/completed/review',
          description: 'Đánh giá chuyến lưu trú đã xong',
        ),
        FigmaScreenEntry(
          scr: 'SCR-096',
          title: 'Help Center',
          route: '/trips/help',
          description: 'Trung tâm trợ giúp 24/7',
        ),
        FigmaScreenEntry(
          scr: 'SCR-097',
          title: 'Cancellation FAQ',
          route: '/trips/help/cancellation-faq',
          description: 'Câu hỏi thường gặp về hủy phòng',
        ),
        FigmaScreenEntry(
          scr: 'SCR-098',
          title: 'Support Chat Demo',
          route: '/trips/help/chat-demo',
          description: 'Nhắn tin hỗ trợ với nhân viên StayNest',
        ),
        FigmaScreenEntry(
          scr: 'SCR-099',
          title: 'Upcoming Trips Empty State',
          route: '/trips/upcoming-empty-demo',
          description: 'Chưa có chuyến đi sắp tới & gợi ý',
        ),
        FigmaScreenEntry(
          scr: 'SCR-100',
          title: 'Trip Overview',
          route: '/trips/overview-demo',
          description: 'Tổng kết toàn bộ hành trình',
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) {
      return Scaffold(
        appBar: AppBar(title: const Text('Debug Only')),
        body: const Center(
          child: Text(
            'Figma Screen Gallery chỉ hoạt động trong chế độ Debug (kDebugMode).',
          ),
        ),
      );
    }

    final query = search.trim().toLowerCase();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('Figma Screens Gallery (Debug)'),
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/'),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Developer Quick Controls
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.build, size: 18, color: StayNestColors.teal),
                          SizedBox(width: 8),
                          Text(
                            'Công cụ kiểm thử nhanh',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: StayNestColors.ink,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.restart_alt, size: 16),
                            label: const Text('Reset Onboarding Flag'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE65100),
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () async {
                              await ref
                                  .read(onboardingControllerProvider.notifier)
                                  .resetOnboarding();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Đã reset cờ onboarding. Lần mở tiếp theo sẽ chạy lại Splash -> Onboarding.',
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.check, size: 16),
                            label: const Text('Hoàn tất Onboarding'),
                            onPressed: () async {
                              await ref
                                  .read(onboardingControllerProvider.notifier)
                                  .completeOnboarding();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Đã đánh dấu hoàn tất onboarding.'),
                                  ),
                                );
                              }
                            },
                          ),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.filter_alt_off, size: 16),
                            label: const Text('Reset Filters'),
                            onPressed: () {
                              ref.read(searchFilterProvider.notifier).reset();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Đã đặt lại bộ lọc.')),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Tìm theo mã SCR hoặc tên màn hình...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (val) => setState(() => search = val),
              ),
              const SizedBox(height: 16),

              // Grouped Screens
              for (final group in groups) ...[
                if (_filterScreens(group.$2, query).isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      group.$1,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: StayNestColors.ink,
                      ),
                    ),
                  ),
                  for (final item in _filterScreens(group.$2, query))
                    Card(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF7F6),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item.scr,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: StayNestColors.teal,
                            ),
                          ),
                        ),
                        title: Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${item.route} • ${item.description}',
                          style: const TextStyle(fontSize: 11),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: StayNestColors.muted,
                        ),
                        onTap: () => context.push(item.route),
                      ),
                    ),
                  const SizedBox(height: 12),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  List<FigmaScreenEntry> _filterScreens(
    List<FigmaScreenEntry> list,
    String query,
  ) {
    if (query.isEmpty) return list;
    return list
        .where(
          (s) =>
              s.scr.toLowerCase().contains(query) ||
              s.title.toLowerCase().contains(query) ||
              s.route.toLowerCase().contains(query) ||
              s.description.toLowerCase().contains(query),
        )
        .toList();
  }
}

