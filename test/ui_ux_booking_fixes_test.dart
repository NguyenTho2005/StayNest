import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:staynest/data/staynest_api.dart';
import 'package:staynest/screens/booking_price_screen.dart';
import 'package:staynest/screens/booking_summary_screen.dart';
import 'package:staynest/screens/payment_method_screen.dart';
import 'package:staynest/screens/profile_edit_screen.dart';
import 'package:staynest/utils/date_formatters.dart';
import 'package:staynest/widgets/user_avatar_app_bar.dart';

class MockHttpClient extends http.BaseClient {
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    return http.StreamedResponse(Stream.value([]), 200);
  }
}

class FakeStayNestApi extends StayNestApi {
  FakeStayNestApi({
    this.currentUser,
    this.initialFavorites = const [],
    this.quoteAvailableUnits = 5,
    this.failSetFavorite = false,
    this.failQuote = false,
  }) : super(client: MockHttpClient());

  Map<String, dynamic>? currentUser;
  List<dynamic> initialFavorites;
  int quoteAvailableUnits;
  bool failSetFavorite;
  bool failQuote;
  int setFavoriteCalls = 0;

  @override
  Future<String?> get token async => 'fake-valid-token';

  @override
  Future<Map<String, dynamic>> getMe() async {
    if (currentUser != null) return currentUser!;
    throw const StayNestApiException('UNAUTHENTICATED', 'Not signed in', 401);
  }

  @override
  Future<Map<String, dynamic>> updateMe(Map<String, dynamic> changes) async {
    currentUser = {...?currentUser, ...changes};
    return currentUser!;
  }

  @override
  Future<List<dynamic>> favorites() async => initialFavorites;

  @override
  Future<void> setFavorite(String slug, bool saved) async {
    setFavoriteCalls++;
    if (failSetFavorite) {
      throw const StayNestApiException('NETWORK_ERROR', 'Lỗi kết nối máy chủ', 500);
    }
    if (saved) {
      if (!initialFavorites.any((i) => i['slug'] == slug)) {
        initialFavorites = [
          ...initialFavorites,
          {'slug': slug, 'name': 'Chỗ ở $slug', 'address': 'Đà Nẵng'},
        ];
      }
    } else {
      initialFavorites =
          initialFavorites.where((i) => i['slug'] != slug).toList();
    }
  }

  @override
  Future<Map<String, dynamic>> property(String slug) async => {
    'id': 1,
    'slug': slug,
    'name': 'Mây Homestay',
    'address': 'Hội An, Quảng Nam',
    'destination_slug': 'hoi-an',
    'rooms': [
      {
        'id': 101,
        'name': 'Phòng Studio',
        'base_price_vnd': 750000,
        'max_adults': 2,
      },
    ],
  };

  @override
  Future<Map<String, dynamic>> quote(Map<String, dynamic> details) async {
    if (failQuote) {
      throw const StayNestApiException('QUOTE_FAILED', 'Không thể tính giá', 500);
    }
    return {
      'availableUnits': quoteAvailableUnits,
      'nightlyPriceVnd': 750000,
      'roomSubtotalVnd': 1500000,
      'nights': 2,
      'taxVnd': 150000,
      'serviceFeeVnd': 75000,
      'discountVnd': 0,
      'totalVnd': 1725000,
    };
  }
}

void main() {
  group('1. Date Formatters (Task 4)', () {
    test('formats calendar date YYYY-MM-DD safely without GMT+7 rollback', () {
      final formatted = formatStayDate('2026-11-14');
      expect(formatted, '14/11/2026');
    });

    test('formats ISO timestamp with Z timezone to local date', () {
      final formatted = formatStayDate('2026-11-14T07:00:00.000Z');
      expect(formatted, contains('14/11/2026'));
    });

    test('formats date range cleanly', () {
      final range = formatStayDateRange('2026-11-14', '2026-11-16');
      expect(range, '14/11/2026 – 16/11/2026');
    });

    test('returns friendly fallback for null or empty values', () {
      expect(formatStayDate(null), 'Chưa cập nhật');
      expect(formatStayDate(''), 'Chưa cập nhật');
      expect(formatStayDate('not-a-date'), 'Chưa cập nhật');
      expect(formatStayDateRange(null, null), 'Chưa cập nhật');
    });
  });

  group('2. UserAvatarAppBar & Initials (Task 1)', () {
    test('extractInitials extracts initials correctly and never hardcodes ND', () {
      expect(extractInitials('Nguyễn Văn Bình'), 'NB');
      expect(extractInitials('Trần An'), 'TA');
      expect(extractInitials('An'), 'AN');
      expect(extractInitials(''), '');
      expect(extractInitials(null), '');
    });

    testWidgets('renders initials when user is signed in without avatar_url', (tester) async {
      final api = FakeStayNestApi(
        currentUser: {'id': 1, 'full_name': 'Nguyễn Văn Bình', 'avatar_url': null},
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            stayNestApiProvider.overrideWithValue(api),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: UserAvatarAppBar(size: 40),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('NB'), findsOneWidget);
      expect(find.text('ND'), findsNothing);
    });

    testWidgets('renders person icon when user is not signed in', (tester) async {
      final api = FakeStayNestApi(currentUser: null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            stayNestApiProvider.overrideWithValue(api),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: UserAvatarAppBar(size: 40),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person_outline), findsOneWidget);
    });
  });

  group('3. Favorite Controller Optimistic Update & Rollback (Task 3)', () {
    testWidgets('optimistic toggle flips state instantly and rolls back on failure', (tester) async {
      final api = FakeStayNestApi(
        initialFavorites: [
          {'slug': 'may-homestay', 'name': 'Mây Homestay'},
        ],
        failSetFavorite: true, // Will fail on network call
      );

      late WidgetRef refHolder;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            stayNestApiProvider.overrideWithValue(api),
          ],
          child: Consumer(
            builder: (context, ref, _) {
              refHolder = ref;
              final isFav = ref.watch(favoriteControllerProvider).isFavorite('may-homestay');
              return MaterialApp(
                home: Scaffold(
                  body: Text(isFav ? 'FAVORITE_ACTIVE' : 'FAVORITE_INACTIVE'),
                ),
              );
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('FAVORITE_ACTIVE'), findsOneWidget);

      // Attempt to toggle removal (which will fail in backend)
      final controller = refHolder.read(favoriteControllerProvider.notifier);
      expect(
        () => controller.toggle('may-homestay'),
        throwsA(isA<StayNestApiException>()),
      );

      await tester.pumpAndSettle();

      // Because it failed, state must have rolled back to ACTIVE!
      expect(find.text('FAVORITE_ACTIVE'), findsOneWidget);
    });
  });

  group('4. ProfileEditScreen Safe Exit (Task 2)', () {
    testWidgets('ProfileEditScreen back button has min 44x44 touch target and safe fallback', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final api = FakeStayNestApi(
        currentUser: {
          'id': 1,
          'full_name': 'Trần Bình',
          'email': 'binh@example.com',
          'phone': '0901234567',
        },
      );

      final router = GoRouter(
        initialLocation: '/profile/edit',
        routes: [
          GoRoute(
            path: '/profile',
            builder: (context, state) => const Scaffold(body: Text('MAN_HO_SO_PROFILE')),
          ),
          GoRoute(
            path: '/profile/edit',
            builder: (context, state) => const ProfileEditScreen(),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            stayNestApiProvider.overrideWithValue(api),
          ],
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      // Find the 44x44 back button target
      final backButton = find.byWidgetPredicate(
        (w) => w is SizedBox && w.width == 44 && w.height == 44,
      );
      expect(backButton, findsOneWidget);

      // Tap Hủy button: with no pop stack, should safely fallback to /profile
      final cancelButton = find.text('Hủy');
      expect(cancelButton, findsOneWidget);
      await tester.tap(cancelButton);
      await tester.pumpAndSettle();

      expect(find.text('MAN_HO_SO_PROFILE'), findsOneWidget);
    });
  });

  group('5. Availability Guard & Price Screens (Task 5 & Task 6)', () {
    testWidgets('BookingSummaryScreen shows warning and disables CTA when availableUnits < roomCount', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final api = FakeStayNestApi(quoteAvailableUnits: 0); // 0 units available

      final draft = BookingDraft();
      draft.selectedRoomTypeId = 101;
      draft.roomCount = 2; // wants 2 rooms

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            stayNestApiProvider.overrideWithValue(api),
            bookingDraftProvider.overrideWithValue(draft),
          ],
          child: const MaterialApp(
            home: BookingSummaryScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Warning message must appear
      expect(find.text('Không đủ 2 phòng cho ngày đã chọn.'), findsOneWidget);

      // CTA button must be disabled with label 'Không đủ phòng'
      final ctaButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(ctaButton.onPressed, isNull);
      expect(find.text('Không đủ phòng'), findsOneWidget);
    });

    testWidgets('BookingPriceScreen does not render 0đ before quote arrives', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final api = FakeStayNestApi(failQuote: false);

      final draft = BookingDraft();
      draft.selectedRoomTypeId = 101;
      draft.roomCount = 1;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            stayNestApiProvider.overrideWithValue(api),
            bookingDraftProvider.overrideWithValue(draft),
          ],
          child: const MaterialApp(
            home: BookingPriceScreen(),
          ),
        ),
      );

      // Before pumpAndSettle completes initial loading:
      // Must not render 0đ
      expect(find.text('0đ'), findsNothing);

      await tester.pumpAndSettle();

      // After quote arrives, renders real total VND
      expect(find.text('1.725.000đ'), findsOneWidget);
    });

    testWidgets('PaymentMethodScreen guards against null booking and never renders 0đ', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final draft = BookingDraft();
      draft.booking = null; // No booking created yet

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bookingDraftProvider.overrideWithValue(draft),
          ],
          child: const MaterialApp(
            home: PaymentMethodScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Must show guard screen instead of 0đ
      expect(find.text('Chưa có thông tin đơn đặt phòng'), findsOneWidget);
      expect(find.text('0đ'), findsNothing);
    });
  });
}
