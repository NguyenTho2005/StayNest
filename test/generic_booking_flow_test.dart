import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:staynest/data/staynest_api.dart';
import 'package:staynest/screens/destination_hotels_screen.dart';
import 'package:staynest/screens/explore_home_screen.dart';
import 'package:staynest/screens/live_catalog_property_screen.dart';
import 'package:staynest/screens/room_selection_screen.dart';

class MockHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return http.StreamedResponse(Stream.value([]), 200);
  }
}

class MockStayNestApi extends StayNestApi {
  MockStayNestApi({
    this.mockUser,
    this.mockFavorites = const [],
    this.returnStringIds = false,
  }) : super(client: MockHttpClient());

  final Map<String, dynamic>? mockUser;
  final List<dynamic> mockFavorites;
  final bool returnStringIds;
  bool favoriteSet = false;

  @override
  Future<String?> get token async => 'mock-token-xyz';

  @override
  Future<Map<String, dynamic>> getMe() async {
    if (mockUser != null) return mockUser!;
    throw const StayNestApiException('UNAUTHENTICATED', 'Not signed in', 401);
  }

  @override
  Future<List<dynamic>> favorites() async => mockFavorites;

  @override
  Future<void> setFavorite(String slug, bool saved) async {
    favoriteSet = saved;
  }

  @override
  Future<Map<String, dynamic>> property(String slug) async => {
    'id': returnStringIds ? '10' : 10,
    'slug': slug,
    'name': slug == 'pine-hill-homestay'
        ? 'Pine Hill Homestay Đà Lạt'
        : 'Mây Homestay',
    'destination_slug': slug == 'pine-hill-homestay' ? 'da-lat' : 'hoi-an',
    'address': 'Đường Triệu Việt Vương, Phường 3, Đà Lạt',
    'description': 'Homestay đồi thông ngắm hoàng hôn.',
    'images': [
      {'image_path': 'room_studio_049.jpg'},
    ],
    'amenities': [
      {'name': 'Wi-Fi'},
      {'name': 'Điều hòa'},
    ],
    'rooms': [
      {
        'id': returnStringIds ? '101' : 101,
        'name': 'Phòng đồi thông view mây',
        'base_price_vnd': returnStringIds ? '750000' : 750000,
        'max_adults': returnStringIds ? '2' : 2,
        'bed_description': '1 giường King',
        'images': [
          {'image_path': 'room_studio_049.jpg'},
        ],
      },
    ],
  };
}

void main() {
  testWidgets(
    'LiveCatalogPropertyScreen allows room booking without demo block',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final mockApi = MockStayNestApi(
        mockUser: {
          'id': 1,
          'full_name': 'Trần Văn Bình',
          'email': 'binh@example.com',
          'phone': '0901234567',
        },
      );
      final draft = BookingDraft();

      final router = GoRouter(
        initialLocation: '/catalog/properties/pine-hill-homestay',
        routes: [
          GoRoute(
            path: '/catalog/properties/:slug',
            builder: (context, state) =>
                LiveCatalogPropertyScreen(slug: state.pathParameters['slug']!),
          ),
          GoRoute(
            path: '/properties/:slug/rooms',
            builder: (context, state) =>
                RoomSelectionScreen(slug: state.pathParameters['slug']!),
          ),
          GoRoute(
            path: '/booking/summary',
            builder: (context, state) =>
                const Scaffold(body: Text('MÀN_TÓM_TẮT_ĐẶT_PHÒNG')),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            stayNestApiProvider.overrideWithValue(mockApi),
            bookingDraftProvider.overrideWithValue(draft),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Verify property loaded with full Figma layout
      expect(find.text('Pine Hill Homestay Đà Lạt'), findsWidgets);

      // 2. CRITICAL: The old "chưa được nối trong bản demo" message must NOT exist!
      expect(
        find.text('Đặt phòng cho chỗ ở này chưa được nối trong bản demo.'),
        findsNothing,
      );

      // 3. Verify sticky "Chọn phòng" button exists on Property Detail
      final selectRoomButton = find.widgetWithText(FilledButton, 'Chọn phòng');
      expect(selectRoomButton, findsOneWidget);

      // 4. Tap "Chọn phòng" on Property Detail -> navigates to Room Selection screen
      await tester.tap(selectRoomButton);
      await tester.pumpAndSettle();

      // 5. Verify Room Selection screen is displayed with rooms
      expect(find.text('Room Selection'), findsOneWidget);
      expect(find.text('Phòng đồi thông view mây'), findsOneWidget);

      // 6. Select the room
      final pickRoomButton = find.text('Chọn phòng này  →');
      expect(pickRoomButton, findsOneWidget);
      await tester.tap(pickRoomButton);
      await tester.pumpAndSettle();

      // 7. Verify navigation to /booking/summary and draft updated
      expect(find.text('MÀN_TÓM_TẮT_ĐẶT_PHÒNG'), findsOneWidget);
      expect(draft.propertySlug, 'pine-hill-homestay');
      expect(draft.propertyName, 'Pine Hill Homestay Đà Lạt');
      expect(draft.selectedRoomTypeId, 101);
      expect(draft.selectedRoomName, 'Phòng đồi thông view mây');
      expect(draft.guestName, 'Trần Văn Bình');
      expect(draft.guestEmail, 'binh@example.com');
      expect(draft.guestPhone, '0901234567');
    },
  );

  testWidgets('ExploreHomeScreen elements are interactive and functional', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final mockApi = MockStayNestApi(
      mockUser: {
        'id': 1,
        'full_name': 'Nguyễn An',
        'email': 'an@example.com',
        'phone': '0901112233',
      },
    );
    final draft = BookingDraft();

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const ExploreHomeScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) =>
              const Scaffold(body: Text('MÀN_TÌM_KIẾM')),
        ),
        GoRoute(
          path: '/search/dates',
          builder: (context, state) =>
              const Scaffold(body: Text('MÀN_CHỌN_NGÀY')),
        ),
        GoRoute(
          path: '/search/guests',
          builder: (context, state) =>
              const Scaffold(body: Text('MÀN_CHỌN_KHÁCH')),
        ),
        GoRoute(
          path: '/properties/may-homestay',
          builder: (context, state) =>
              const Scaffold(body: Text('MÀN_CHI_TIẾT_MÂY')),
        ),
        GoRoute(
          path: '/destinations',
          builder: (context, state) =>
              const Scaffold(body: Text('MÀN_ĐIỂM_ĐẾN')),
        ),
        GoRoute(
          path: '/recommendations',
          builder: (context, state) => const Scaffold(body: Text('MÀN_GỢI_Ý')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stayNestApiProvider.overrideWithValue(mockApi),
          bookingDraftProvider.overrideWithValue(draft),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Verify greeting renders user full name
    expect(find.text('XIN CHÀO, NGUYỄN AN ✨'), findsOneWidget);

    // 2. Tap on "Ngày lưu trú"
    await tester.tap(find.text('Ngày lưu trú'));
    await tester.pumpAndSettle();
    expect(find.text('MÀN_CHỌN_NGÀY'), findsOneWidget);

    // Go back
    router.go('/');
    await tester.pumpAndSettle();

    // 3. Tap on "Số lượng"
    await tester.tap(find.text('Số lượng'));
    await tester.pumpAndSettle();
    expect(find.text('MÀN_CHỌN_KHÁCH'), findsOneWidget);

    // Go back
    router.go('/');
    await tester.pumpAndSettle();

    // 4. Tap on Recommendation card (Mây Homestay)
    await tester.tap(find.text('Mây Homestay'));
    await tester.pumpAndSettle();
    expect(find.text('MÀN_CHI_TIẾT_MÂY'), findsOneWidget);

    // Go back
    router.go('/');
    await tester.pumpAndSettle();

    // 5. Tap on "Xem tất cả" for destinations
    final viewAllButtons = find.text('Xem tất cả');
    expect(viewAllButtons, findsAtLeastNWidgets(1));
    await tester.tap(viewAllButtons.first);
    await tester.pumpAndSettle();
    expect(find.text('MÀN_ĐIỂM_ĐẾN'), findsOneWidget);
  });

  testWidgets(
    'DestinationHotelsScreen opens Ocean Pearl Hotel detail on "Xem chi tiết" click',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final router = GoRouter(
        initialLocation: '/destinations/da-nang/hotels',
        routes: [
          GoRoute(
            path: '/destinations/da-nang/hotels',
            builder: (context, state) => const DestinationHotelsScreen(),
          ),
          GoRoute(
            path: '/catalog/properties/ocean-pearl-hotel',
            builder: (context, state) =>
                const Scaffold(body: Text('MÀN_CHI_TIẾT_OCEAN_PEARL')),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      final detailButton = find.widgetWithText(FilledButton, 'Xem chi tiết');
      expect(detailButton, findsOneWidget);
      await tester.tap(detailButton);
      await tester.pumpAndSettle();

      expect(find.text('MÀN_CHI_TIẾT_OCEAN_PEARL'), findsOneWidget);
    },
  );

  testWidgets(
    'RoomSelectionScreen safely parses string and numeric IDs and prices without TypeError',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      // API mock returning IDs and prices as raw strings (reproducing Supabase bigserial driver behavior)
      final stringMockApi = MockStayNestApi(returnStringIds: true);
      final router = GoRouter(
        initialLocation: '/properties/may-homestay/rooms',
        routes: [
          GoRoute(
            path: '/properties/may-homestay/rooms',
            builder: (context, state) =>
                const RoomSelectionScreen(slug: 'may-homestay'),
          ),
          GoRoute(
            path: '/properties/may-homestay/rooms/studio',
            builder: (context, state) =>
                const Scaffold(body: Text('MÀN_CHI_TIẾT_PHÒNG_STUDIO')),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [stayNestApiProvider.overrideWithValue(stringMockApi)],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Room Selection rendered without TypeError
      expect(find.text('Room Selection'), findsOneWidget);
      expect(find.text('Phòng đồi thông view mây'), findsOneWidget);

      // Tap select room
      final selectButton = find.text('Chọn phòng này  →');
      expect(selectButton, findsOneWidget);
      await tester.tap(selectButton);
      await tester.pumpAndSettle();

      expect(find.text('MÀN_CHI_TIẾT_PHÒNG_STUDIO'), findsOneWidget);
    },
  );
}
