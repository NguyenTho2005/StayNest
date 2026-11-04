import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'data/search_filter_state.dart';
import 'design/tokens.dart';
import 'widgets/responsive_app_shell.dart';
import 'screens/account_screen.dart';
import 'screens/destination_search_screen.dart';
import 'screens/explore_home_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/login_screen.dart';
import 'screens/my_trips_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/profile_edit_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/onboarding_screens.dart';
import 'screens/signup_screen.dart';
import 'screens/password_flow_screens.dart';
import 'screens/login_error_screen.dart';
import 'screens/discovery_screens.dart';
import 'screens/search_selection_screens.dart';
import 'screens/search_filter_screens.dart';
import 'screens/search_sort_screen.dart';
import 'screens/search_results_list_screen.dart';
import 'screens/search_map_screen.dart';
import 'screens/property_quick_view_screen.dart';
import 'screens/search_empty_screen.dart';
import 'screens/search_loading_screen.dart';
import 'screens/recent_searches_screen.dart';
import 'screens/destination_detail_screen.dart';
import 'screens/destination_hotels_screen.dart';
import 'screens/property_category_screen.dart';
import 'screens/applied_filters_screen.dart';
import 'screens/property_detail_screen.dart';
import 'screens/live_catalog_property_screen.dart';
import 'screens/property_photo_gallery_screen.dart';
import 'screens/photo_viewer_screen.dart';
import 'screens/property_amenities_screen.dart';
import 'screens/property_reviews_overview_screen.dart';
import 'screens/property_reviews_list_screen.dart';
import 'screens/review_filter_screen.dart';
import 'screens/property_location_screen.dart';
import 'screens/room_selection_screen.dart';
import 'screens/room_detail_screen.dart';
import 'screens/property_policies_screen.dart';
import 'screens/refund_policy_screen.dart';
import 'screens/favorite_saved_screen.dart';
import 'screens/favorites_empty_screen.dart';
import 'screens/compare_selection_screen.dart';
import 'screens/compare_table_screen.dart';
import 'screens/compare_price_screen.dart';
import 'screens/host_chat_demo_screen.dart';
import 'screens/booking_summary_screen.dart';
import 'screens/booking_start_screen.dart';
import 'screens/guest_information_screen.dart';
import 'screens/booking_requests_screen.dart';
import 'screens/booking_price_screen.dart';
import 'screens/coupon_list_screen.dart';
import 'screens/coupon_applied_demo_screen.dart';
import 'screens/payment_method_screen.dart';
import 'screens/wallet_payment_demo_screen.dart';
import 'screens/domestic_card_payment_screen.dart';
import 'screens/international_card_payment_screen.dart';
import 'screens/payment_flow_demo_screens.dart';
import 'screens/post_payment_guide_screen.dart';
import 'screens/transaction_terms_screen.dart';
import 'screens/payment_missing_information_screen.dart';
import 'screens/change_payment_method_screen.dart';
import 'screens/final_booking_check_screen.dart';
import 'screens/trip_detail_flow_screens.dart';
import 'screens/live_trip_detail_screen.dart';
import 'screens/live_payment_success_screen.dart';
import 'screens/cancellation_flow_screens.dart';
import 'screens/trip_followup_screens.dart';
import 'screens/final_page_screens.dart';
import 'screens/location_permission_screen.dart';
import 'screens/debug_figma_gallery_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const ExploreHomeScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const DestinationSearchScreen(),
      ),
      GoRoute(
        path: '/search/guests',
        builder: (context, state) => const GuestRoomPickerScreen(),
      ),
      GoRoute(
        path: '/search/dates',
        builder: (context, state) => const StayDatePickerScreen(),
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
      GoRoute(
        path: '/search/sort',
        builder: (context, state) => const SearchSortScreen(),
      ),
      GoRoute(
        path: '/search/results',
        builder: (context, state) => const SearchResultsListScreen(),
      ),
      GoRoute(
        path: '/search/map',
        builder: (context, state) => const SearchMapScreen(),
      ),
      GoRoute(
        path: '/search/quick-view',
        builder: (context, state) => const PropertyQuickViewScreen(),
      ),
      GoRoute(
        path: '/search/empty',
        builder: (context, state) => const SearchEmptyScreen(),
      ),
      GoRoute(
        path: '/search/loading',
        builder: (context, state) => const SearchLoadingScreen(),
      ),
      GoRoute(
        path: '/search/recent',
        builder: (context, state) => const RecentSearchesScreen(),
      ),
      GoRoute(
        path: '/destinations',
        builder: (context, state) => const DestinationsScreen(),
      ),
      GoRoute(
        path: '/destinations/da-nang',
        builder: (context, state) => const DestinationDetailScreen(),
      ),
      GoRoute(
        path: '/destinations/da-nang/hotels',
        builder: (context, state) => const DestinationHotelsScreen(),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const PropertyCategoryScreen(),
      ),
      GoRoute(
        path: '/search/applied-filters',
        builder: (context, state) => const AppliedFiltersScreen(),
      ),
      GoRoute(
        path: '/properties/may-homestay',
        builder: (context, state) => const PropertyDetailScreen(),
      ),
      GoRoute(
        path: '/catalog/properties/:slug',
        builder: (context, state) =>
            LiveCatalogPropertyScreen(slug: state.pathParameters['slug']!),
      ),
      GoRoute(
        path: '/properties/may-homestay/gallery',
        builder: (context, state) => const PropertyPhotoGalleryScreen(),
      ),
      GoRoute(
        path: '/properties/may-homestay/gallery/photo/:index',
        builder: (context, state) => PhotoViewerScreen(
          initialIndex: int.tryParse(state.pathParameters['index'] ?? '') ?? 2,
        ),
      ),
      GoRoute(
        path: '/properties/may-homestay/amenities',
        builder: (context, state) => const PropertyAmenitiesScreen(),
      ),
      GoRoute(
        path: '/properties/may-homestay/reviews/overview',
        builder: (context, state) => const PropertyReviewsOverviewScreen(),
      ),
      GoRoute(
        path: '/properties/may-homestay/reviews',
        builder: (context, state) => const PropertyReviewsListScreen(),
      ),
      GoRoute(
        path: '/properties/may-homestay/reviews/filter',
        builder: (context, state) => const ReviewFilterScreen(),
      ),
      GoRoute(
        path: '/properties/may-homestay/location',
        builder: (context, state) => const PropertyLocationScreen(),
      ),
      GoRoute(
        path: '/properties/may-homestay/rooms',
        builder: (context, state) =>
            const RoomSelectionScreen(slug: 'may-homestay'),
      ),
      GoRoute(
        path: '/properties/:slug/rooms',
        builder: (context, state) =>
            RoomSelectionScreen(slug: state.pathParameters['slug']!),
      ),
      GoRoute(
        path: '/properties/may-homestay/rooms/studio',
        builder: (context, state) => const RoomDetailScreen(),
      ),
      GoRoute(
        path: '/properties/may-homestay/policies',
        builder: (context, state) => const PropertyPoliciesScreen(),
      ),
      GoRoute(
        path: '/properties/may-homestay/policies/refund',
        builder: (context, state) => const RefundPolicyScreen(),
      ),
      GoRoute(
        path: '/favorites/saved',
        builder: (context, state) => const FavoriteSavedScreen(),
      ),
      GoRoute(
        path: '/favorites/empty',
        builder: (context, state) => const FavoritesEmptyScreen(),
      ),
      GoRoute(
        path: '/favorites/compare/select',
        builder: (context, state) => const CompareSelectionScreen(),
      ),
      GoRoute(
        path: '/favorites/compare',
        builder: (context, state) => const CompareTableScreen(),
      ),
      GoRoute(
        path: '/favorites/compare/prices',
        builder: (context, state) => const ComparePriceScreen(),
      ),
      GoRoute(
        path: '/properties/may-homestay/host-chat',
        builder: (context, state) => const HostChatDemoScreen(),
      ),
      GoRoute(
        path: '/booking/summary',
        builder: (context, state) => const BookingSummaryScreen(),
      ),
      GoRoute(
        path: '/booking/start',
        builder: (context, state) => const BookingStartScreen(),
      ),
      GoRoute(
        path: '/booking/guests',
        builder: (context, state) => const GuestInformationScreen(),
      ),
      GoRoute(
        path: '/booking/requests',
        builder: (context, state) => const BookingRequestsScreen(),
      ),
      GoRoute(
        path: '/booking/price',
        builder: (context, state) => const BookingPriceScreen(),
      ),
      GoRoute(
        path: '/booking/coupons',
        builder: (context, state) => const CouponListScreen(),
      ),
      GoRoute(
        path: '/booking/coupons/applied-demo',
        builder: (context, state) => const CouponAppliedDemoScreen(),
      ),
      GoRoute(
        path: '/booking/payment-method',
        builder: (context, state) => const PaymentMethodScreen(),
      ),
      GoRoute(
        path: '/booking/wallet-demo',
        builder: (context, state) => const WalletPaymentDemoScreen(),
      ),
      GoRoute(
        path: '/booking/domestic-card-demo',
        builder: (context, state) => const DomesticCardPaymentScreen(),
      ),
      GoRoute(
        path: '/booking/international-card-demo',
        builder: (context, state) => const InternationalCardPaymentScreen(),
      ),
      GoRoute(
        path: '/booking/payment-confirmation',
        builder: (context, state) => const PaymentConfirmationScreen(),
      ),
      GoRoute(
        path: '/booking/payment-processing-demo',
        builder: (context, state) => const PaymentProcessingScreen(),
      ),
      GoRoute(
        path: '/booking/payment-failure-demo',
        builder: (context, state) => const PaymentFailureScreen(),
      ),
      GoRoute(
        path: '/booking/payment-success-demo',
        builder: (context, state) => const PaymentSuccessScreen(),
      ),
      GoRoute(
        path: '/booking/payment-success-live/:id',
        builder: (context, state) => LivePaymentSuccessScreen(
          bookingId: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/booking/receipt-demo',
        builder: (context, state) => const PaymentReceiptScreen(),
      ),
      GoRoute(
        path: '/booking/post-payment-guide-demo',
        builder: (context, state) => const PostPaymentGuideScreen(),
      ),
      GoRoute(
        path: '/booking/transaction-terms',
        builder: (context, state) => const TransactionTermsScreen(),
      ),
      GoRoute(
        path: '/booking/missing-information-demo',
        builder: (context, state) => const PaymentMissingInformationScreen(),
      ),
      GoRoute(
        path: '/booking/change-payment-method',
        builder: (context, state) => const ChangePaymentMethodScreen(),
      ),
      GoRoute(
        path: '/booking/final-check-demo',
        builder: (context, state) => const FinalBookingCheckScreen(),
      ),
      GoRoute(
        path: '/trips/booking',
        builder: (context, state) => const BookingDetailScreen(),
      ),
      GoRoute(
        path: '/trips/booking/live/:id',
        builder: (context, state) => LiveTripDetailScreen(
          bookingId: int.parse(state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/trips/booking/voucher',
        builder: (context, state) => const BookingVoucherScreen(),
      ),
      GoRoute(
        path: '/trips/booking/directions',
        builder: (context, state) => const DirectionsContactScreen(),
      ),
      GoRoute(
        path: '/trips/booking/change-dates',
        builder: (context, state) => const ChangeDatesScreen(),
      ),
      GoRoute(
        path: '/trips/booking/change-dates/result-demo',
        builder: (context, state) => const ChangeDatesResultScreen(),
      ),
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
      GoRoute(
        path: '/trips/cancelled-demo',
        builder: (context, state) => const CancelledTripsScreen(),
      ),
      GoRoute(
        path: '/trips/refund-tracking-demo',
        builder: (context, state) => const RefundTrackingScreen(),
      ),
      GoRoute(
        path: '/trips/refund-complete-demo',
        builder: (context, state) => const RefundCompleteScreen(),
      ),
      GoRoute(
        path: '/trips/completed-demo',
        builder: (context, state) => const CompletedTripsScreen(),
      ),
      GoRoute(
        path: '/trips/completed/review',
        builder: (context, state) => const WriteReviewScreen(),
      ),
      GoRoute(
        path: '/trips/help',
        builder: (context, state) => const HelpCenterScreen(),
      ),
      GoRoute(
        path: '/trips/help/cancellation-faq',
        builder: (context, state) => const CancellationFaqScreen(),
      ),
      GoRoute(
        path: '/trips/help/chat-demo',
        builder: (context, state) => const BookingSupportChatDemoScreen(),
      ),
      GoRoute(
        path: '/trips/upcoming-empty-demo',
        builder: (context, state) => const UpcomingTripsEmptyScreen(),
      ),
      GoRoute(
        path: '/trips/overview-demo',
        builder: (context, state) => const TripOverviewScreen(),
      ),
      GoRoute(
        path: '/profile/updated-demo',
        builder: (context, state) => const ProfileUpdatedDemoScreen(),
      ),
      GoRoute(
        path: '/location-permission',
        builder: (context, state) => const LocationPermissionScreen(),
      ),
      GoRoute(
        path: '/offers',
        builder: (context, state) => const OffersScreen(),
      ),
      GoRoute(
        path: '/recommendations',
        builder: (context, state) => const RecommendationsScreen(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/trips',
        builder: (context, state) => const MyTripsScreen(),
      ),
      GoRoute(
        path: '/account',
        builder: (context, state) => const AccountScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const ProfileEditScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/login/error',
        builder: (context, state) => const LoginErrorScreen(),
      ),
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding/1',
        builder: (context, state) => const OnboardingScreen(step: 1),
      ),
      GoRoute(
        path: '/onboarding/2',
        builder: (context, state) => const OnboardingScreen(step: 2),
      ),
      GoRoute(
        path: '/onboarding/3',
        builder: (context, state) => const OnboardingScreen(step: 3),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(path: '/otp', builder: (context, state) => const OtpScreen()),
      GoRoute(
        path: '/signup/success',
        builder: (context, state) => const SignUpSuccessScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/password/reset/otp',
        builder: (context, state) => const ResetOtpScreen(),
      ),
      GoRoute(
        path: '/password/new',
        builder: (context, state) => const NewPasswordScreen(),
      ),
      GoRoute(
        path: '/password/success',
        builder: (context, state) => const PasswordResetSuccessScreen(),
      ),
      GoRoute(
        path: '/debug/figma-screens',
        builder: (context, state) => const DebugFigmaGalleryScreen(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: StayNestColors.canvas,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: StayNestColors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const ProviderScope(child: StayNestApp()));
}

class StayNestApp extends ConsumerWidget {
  const StayNestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    title: 'StayNest',
    debugShowCheckedModeBanner: false,
    theme: StayNestTheme.light,
    routerConfig: ref.watch(appRouterProvider),
    builder: (context, child) =>
        ResponsiveAppShell(child: child ?? const SizedBox.shrink()),
  );
}
