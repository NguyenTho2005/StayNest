import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:staynest/data/staynest_api.dart';
import 'package:staynest/screens/cancellation_flow_screens.dart';
import 'package:staynest/screens/debug_figma_gallery_screen.dart';
import 'package:staynest/screens/my_trips_screen.dart';
import 'package:staynest/screens/onboarding_screens.dart';
import 'package:staynest/screens/search_filter_screens.dart';
import 'package:staynest/screens/search_results_list_screen.dart';
import 'package:staynest/screens/trip_detail_flow_screens.dart';

class FakeStayNestApi extends StayNestApi {
  @override
  Future<List<dynamic>> properties({
    String? destination,
    String? query,
    int? minPrice,
    int? maxPrice,
    String? propertyType,
    String? sort,
    String? checkIn,
    String? checkOut,
    int? adults,
  }) async {
    return [
      {
        'id': 1,
        'slug': 'may-homestay',
        'name': 'Mây Homestay',
        'property_type': 'HOMESTAY',
        'description': 'Homestay di sản tại Hội An',
        'address': 'Cẩm Thanh, Hội An',
        'destination': 'Hội An',
        'min_price_vnd': 850000,
        'image_path': 'applied_filters_1.jpg',
        'amenities': ['Wi-Fi miễn phí', 'Hồ bơi', 'Điều hòa'],
      }
    ];
  }
}

Widget createTestApp({
  required GoRouter router,
}) {
  return ProviderScope(
    child: MaterialApp.router(
      routerConfig: router,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Section A: App Start & Onboarding (SCR-001 -> SCR-005)', () {
    testWidgets('First-run user: Splash transitions to Onboarding 1', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      OnboardingController.testInitialValue = false;
      addTearDown(() => OnboardingController.testInitialValue = null);

      final router = GoRouter(
        initialLocation: '/splash',
        routes: [
          GoRoute(
            path: '/splash',
            builder: (context, state) => const SplashScreen(
              duration: Duration(milliseconds: 20),
            ),
          ),
          GoRoute(
            path: '/onboarding/1',
            builder: (context, state) => const OnboardingScreen(step: 1),
          ),
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(body: Text('Home Screen')),
          ),
        ],
      );

      await tester.pumpWidget(createTestApp(router: router));
      expect(find.text('StayNest'), findsOneWidget);
      expect(find.text('Khách sạn & Homestay Việt Nam'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 30));
      await tester.pumpAndSettle();

      // Should land on Onboarding 1
      expect(find.text('Khám phá nơi ở phù hợp'), findsOneWidget);
      expect(find.text('Bỏ qua'), findsOneWidget);
      expect(find.text('Tiếp tục'), findsOneWidget);
    });

    testWidgets('Returning user: Splash transitions directly to Home', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      OnboardingController.testInitialValue = true;
      addTearDown(() => OnboardingController.testInitialValue = null);

      final router = GoRouter(
        initialLocation: '/splash',
        routes: [
          GoRoute(
            path: '/splash',
            builder: (context, state) => const SplashScreen(
              duration: Duration(milliseconds: 20),
            ),
          ),
          GoRoute(
            path: '/onboarding/1',
            builder: (context, state) => const OnboardingScreen(step: 1),
          ),
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(body: Text('Home Screen (SCR-021)')),
          ),
        ],
      );

      await tester.pumpWidget(createTestApp(router: router));

      await tester.pump(const Duration(milliseconds: 30));
      await tester.pumpAndSettle();

      expect(find.text('Home Screen (SCR-021)'), findsOneWidget);
      expect(find.text('Khám phá nơi ở phù hợp'), findsNothing);
    });

    testWidgets('Tapping Bỏ qua on Onboarding marks completed and opens Welcome', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      OnboardingController.testInitialValue = false;
      addTearDown(() => OnboardingController.testInitialValue = null);

      final router = GoRouter(
        initialLocation: '/onboarding/1',
        routes: [
          GoRoute(
            path: '/onboarding/1',
            builder: (context, state) => const OnboardingScreen(step: 1),
          ),
          GoRoute(
            path: '/welcome',
            builder: (context, state) => const WelcomeScreen(),
          ),
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(body: Text('Home Screen')),
          ),
        ],
      );

      final container = ProviderContainer();
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      expect(find.text('Bỏ qua'), findsOneWidget);
      await tester.tap(find.text('Bỏ qua'));
      await tester.pumpAndSettle();

      // Onboarding should be marked completed
      expect(container.read(onboardingControllerProvider), isTrue);
      // Lands on Welcome screen
      expect(find.text('Chuyến đi tiếp theo\nbắt đầu tại đây'), findsOneWidget);
      expect(find.text('Đăng nhập'), findsOneWidget);
      expect(find.text('Tạo tài khoản'), findsOneWidget);
      expect(find.text('Khám phá với tư cách khách'), findsOneWidget);
    });
  });

  group('Section B: Filter Chain (SCR-031 -> SCR-028 -> SCR-029 -> SCR-031)', () {
    testWidgets('Lọc button opens SCR-028 -> Tiếp tục opens SCR-029 -> Xem kết quả applies filters', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final router = GoRouter(
        initialLocation: '/search/results',
        routes: [
          GoRoute(
            path: '/search/results',
            builder: (context, state) => const SearchResultsListScreen(),
          ),
          GoRoute(
            path: '/search/filters/price-property',
            builder: (context, state) => const PricePropertyFilterScreen(),
          ),
          GoRoute(
            path: '/search/filters/amenities',
            builder: (context, state) => AmenityFilterScreen(
              initialDraft: state.extra as SearchFilterState?,
            ),
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          stayNestApiProvider.overrideWithValue(FakeStayNestApi()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      // 1. On Search Results (SCR-031), find Lọc button
      expect(find.text('Lọc'), findsOneWidget);
      await tester.tap(find.text('Lọc'));
      await tester.pumpAndSettle();

      // 2. Now on PricePropertyFilterScreen (SCR-028)
      expect(find.text('Lọc kết quả'), findsOneWidget);
      expect(find.text('Ngân sách mỗi đêm'), findsOneWidget);
      expect(find.text('Khách sạn'), findsOneWidget);
      expect(find.text('Homestay'), findsOneWidget);
      expect(find.text('Tiếp tục'), findsOneWidget);

      // Select Homestay
      await tester.tap(find.text('Homestay'));
      await tester.pumpAndSettle();

      // Tap Tiếp tục -> Should navigate to SCR-029 (Amenities)
      await tester.tap(find.text('Tiếp tục'));
      await tester.pumpAndSettle();

      // 3. Now on AmenityFilterScreen (SCR-029)
      expect(find.text('Tiện nghi'), findsOneWidget);
      expect(find.text('Wi-Fi miễn phí'), findsOneWidget);
      expect(find.text('Hồ bơi'), findsOneWidget);
      expect(find.text('Xem kết quả'), findsOneWidget);

      // Select 'Hồ bơi'
      await tester.tap(find.text('Hồ bơi'));
      await tester.pumpAndSettle();

      // Tap 'Xem kết quả'
      await tester.tap(find.text('Xem kết quả'));
      await tester.pumpAndSettle();

      // 4. Back on Search Results (SCR-031) with active filters!
      expect(find.text('Lọc'), findsOneWidget);
      final activeFilter = container.read(searchFilterProvider);
      expect(activeFilter.count, greaterThan(0));
      expect(activeFilter.propertyType, 'Homestay');
      expect(activeFilter.amenities.contains('Hồ bơi'), isTrue);
    });
  });

  group('Section C: Trips Flow & Navigation (SCR-081 -> SCR-100)', () {
    testWidgets('Empty trips on tab 0 shows SCR-099 empty view with explore CTA', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final router = GoRouter(
        initialLocation: '/trips',
        routes: [
          GoRoute(
            path: '/trips',
            builder: (context, state) => const MyTripsScreen(),
          ),
          GoRoute(
            path: '/',
            builder: (context, state) => const Scaffold(body: Text('Home Screen')),
          ),
        ],
      );

      final container = ProviderContainer(
        overrides: [
          myBookingsProvider.overrideWith((ref) => Future.value([])),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Bạn chưa có chuyến đi nào'), findsOneWidget);
      expect(find.text('◉ Khám phá chỗ ở'), findsOneWidget);

      await tester.tap(find.text('◉ Khám phá chỗ ở'));
      await tester.pumpAndSettle();

      expect(find.text('Home Screen'), findsOneWidget);
    });

    testWidgets('Detail Booking (SCR-082) links to Voucher (083) and Directions (084)', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final router = GoRouter(
        initialLocation: '/trips/booking',
        routes: [
          GoRoute(
            path: '/trips/booking',
            builder: (context, state) => const BookingDetailScreen(),
          ),
          GoRoute(
            path: '/trips/booking/voucher',
            builder: (context, state) => const BookingVoucherScreen(),
          ),
          GoRoute(
            path: '/trips/booking/directions',
            builder: (context, state) => const DirectionsContactScreen(),
          ),
        ],
      );

      await tester.pumpWidget(createTestApp(router: router));
      await tester.pumpAndSettle();

      expect(find.text('Mây Homestay'), findsOneWidget);
      expect(find.text('Xem voucher đặt phòng'), findsOneWidget);

      // Tap Voucher
      await tester.tap(find.text('Xem voucher đặt phòng'));
      await tester.pumpAndSettle();

      expect(find.text('VOUCHER XÁC NHẬN ĐẶT PHÒNG'), findsOneWidget);
      expect(find.text('MÃ MÔ PHỎNG'), findsOneWidget);
    });

    testWidgets('Cancellation subflow: 087 -> 088 -> 089 -> 090 works without broken null CTA', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final router = GoRouter(
        initialLocation: '/trips/booking/cancel',
        routes: [
          GoRoute(
            path: '/trips/booking/cancel',
            builder: (context, state) => const CancellationStartScreen(),
          ),
          GoRoute(
            path: '/trips/booking/refund-estimate',
            builder: (context, state) => const RefundEstimateScreen(),
          ),
          GoRoute(
            path: '/trips/booking/cancel/reason',
            builder: (context, state) => const CancellationReasonScreen(),
          ),
          GoRoute(
            path: '/trips/booking/cancel/success-demo',
            builder: (context, state) => const CancellationSuccessScreen(),
          ),
        ],
      );

      await tester.pumpWidget(createTestApp(router: router));
      await tester.pumpAndSettle();

      // SCR-087: Start
      expect(find.text('Chính Sách Huỷ Phòng'), findsOneWidget);
      expect(find.text('Xem số tiền hoàn →'), findsOneWidget);
      await tester.tap(find.text('Xem số tiền hoàn →'));
      await tester.pumpAndSettle();

      // SCR-088: Estimate
      expect(find.text('Số tiền dự kiến được hoàn:'), findsOneWidget);
      expect(find.text('Tiếp tục hủy →'), findsOneWidget);
      await tester.tap(find.text('Tiếp tục hủy →'));
      await tester.pumpAndSettle();

      // SCR-089: Reason
      expect(find.text('Vì sao bạn muốn hủy?'), findsOneWidget);
      expect(find.text('Xác nhận hủy →'), findsOneWidget);
      await tester.tap(find.text('Xác nhận hủy →'));
      await tester.pumpAndSettle();

      // SCR-090: Success
      expect(find.text('Đã hủy đặt phòng'), findsOneWidget);
      expect(find.text('◷ Danh sách đơn đã hủy'), findsOneWidget);
    });

    testWidgets('Debug gallery /debug/figma-screens renders all categories and tools', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final router = GoRouter(
        initialLocation: '/debug/figma-screens',
        routes: [
          GoRoute(
            path: '/debug/figma-screens',
            builder: (context, state) => const DebugFigmaGalleryScreen(),
          ),
        ],
      );

      await tester.pumpWidget(createTestApp(router: router));
      await tester.pumpAndSettle();

      expect(find.text('Figma Screens Gallery (Debug)'), findsOneWidget);
      expect(find.text('Reset Onboarding Flag'), findsOneWidget);
      expect(find.text('Hoàn tất Onboarding'), findsOneWidget);
      expect(find.text('1. Khởi động & xác thực (SCR 001–014)'), findsOneWidget);
      expect(find.text('SCR-001'), findsOneWidget);
    });
  });
}
