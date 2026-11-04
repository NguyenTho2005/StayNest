import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/staynest_api.dart';

import '../design/tokens.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/figma_asset.dart';
import '../widgets/figma_status_bar.dart';

class ExploreHomeScreen extends ConsumerStatefulWidget {
  const ExploreHomeScreen({super.key});

  @override
  ConsumerState<ExploreHomeScreen> createState() => _ExploreHomeScreenState();
}

class _ExploreHomeScreenState extends ConsumerState<ExploreHomeScreen> {
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final api = ref.read(stayNestApiProvider);
    if (await api.token == null) return;
    try {
      final favs = await api.favorites();
      if (mounted) {
        setState(() {
          _isSaved = favs.any((item) => item['slug'] == 'may-homestay');
        });
      }
    } catch (_) {}
  }

  Future<void> _toggleFavorite() async {
    final api = ref.read(stayNestApiProvider);
    if (await api.token == null) {
      if (mounted) context.push('/login');
      return;
    }
    final next = !_isSaved;
    setState(() => _isSaved = next);
    try {
      await api.setFavorite('may-homestay', next);
      ref.invalidate(myFavoritesProvider);
    } catch (error) {
      if (mounted) {
        setState(() => _isSaved = !next);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: StayNestColors.canvas,
    bottomNavigationBar: const StayNestBottomNavigation(selectedIndex: 0),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            const FigmaStatusBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _BrandBar(),
                    _Greeting(
                      name: ref
                          .watch(currentUserProvider)
                          .value?['full_name']
                          ?.toString(),
                    ),
                    _SearchCard(onSearch: () => context.go('/search')),
                    const _FeaturedBanner(),
                    const _WeekendOffer(),
                    const _Destinations(),
                    _Recommendations(
                      isSaved: _isSaved,
                      onToggleSaved: _toggleFavorite,
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 28),
                      child: Text(
                        'Mọi thông tin phòng, giá và đánh giá là dữ liệu minh họa DEMO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          height: 14 / 10,
                          color: StayNestColors.muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _BrandBar extends StatelessWidget {
  const _BrandBar();

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 64,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const FigmaRaster(
              'assets/images/staynest_logo.png',
              width: 40,
              height: 40,
            ),
          ),
          const SizedBox(width: 8),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'StayNest',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 16,
                    height: 20 / 16,
                    fontWeight: FontWeight.w600,
                    color: StayNestColors.ink,
                  ),
                ),
                Text(
                  'Khách sạn & Homestay Việt Nam',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    height: 18 / 12,
                    color: StayNestColors.body,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => context.go('/account'),
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ClipOval(
                  child: FigmaRaster(
                    'assets/images/nguyen_an.jpg',
                    width: 40,
                    height: 40,
                  ),
                ),
                Positioned(
                  right: -2,
                  bottom: -2,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: StayNestColors.teal,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _Greeting extends StatelessWidget {
  const _Greeting({this.name});
  final String? name;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'XIN CHÀO, ${name?.toUpperCase() ?? 'KHÁCH'} ✨',
          style: const TextStyle(
            fontSize: 12,
            height: 18 / 12,
            fontWeight: FontWeight.w500,
            color: StayNestColors.teal,
            letterSpacing: 0.6,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Bạn muốn đi đâu?',
          style: TextStyle(
            fontSize: 24,
            height: 30 / 24,
            fontWeight: FontWeight.w600,
            color: StayNestColors.ink,
            letterSpacing: -0.6,
          ),
        ),
      ],
    ),
  );
}

class _SearchCard extends ConsumerWidget {
  const _SearchCard({required this.onSearch});
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(bookingDraftProvider);
    final datesLabel =
        '${draft.checkIn.day}/${draft.checkIn.month}–${draft.checkOut.day}/${draft.checkOut.month}/${draft.checkOut.year}';
    final guestsLabel = '${draft.adults} lớn · ${draft.roomCount} phòng';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: StayNestColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14172B4D),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            InkWell(
              onTap: onSearch,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: StayNestColors.paleBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: const Row(
                  children: [
                    FigmaSvg(
                      'assets/icons/search.svg',
                      width: 16.5,
                      height: 16.5,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tìm điểm đến, khách sạn, homestay...',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          height: 22 / 14,
                          color: StayNestColors.body,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => context.push('/search/dates'),
                    borderRadius: BorderRadius.circular(8),
                    child: _SearchDetail(
                      icon: 'assets/icons/calendar.svg',
                      label: 'Ngày lưu trú',
                      value: datesLabel,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => context.push('/search/guests'),
                    borderRadius: BorderRadius.circular(8),
                    child: _SearchDetail(
                      icon: 'assets/icons/guests.svg',
                      label: 'Số lượng',
                      value: guestsLabel,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 52,
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onSearch,
                icon: const FigmaSvg(
                  'assets/icons/search_cta.svg',
                  width: 15,
                  height: 15,
                ),
                label: const Text(
                  'Tìm chỗ ở',
                  style: TextStyle(
                    fontSize: 14,
                    height: 22 / 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: StayNestColors.teal,
                  foregroundColor: StayNestColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchDetail extends StatelessWidget {
  const _SearchDetail({
    required this.icon,
    required this.label,
    required this.value,
  });
  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
    height: 44,
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: StayNestColors.paleBlue,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        FigmaSvg(
          icon,
          width: icon.endsWith('calendar.svg') ? 13.5 : 16.5,
          height: icon.endsWith('calendar.svg') ? 15 : 12,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 11,
                  height: 11 / 11,
                  fontWeight: FontWeight.w500,
                  color: StayNestColors.body,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  height: 18 / 12,
                  fontWeight: FontWeight.w500,
                  color: StayNestColors.ink,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _FeaturedBanner extends StatelessWidget {
  const _FeaturedBanner();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
    child: InkWell(
      onTap: () => context.push('/destinations'),
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const FigmaRaster('assets/images/featured_travel.jpg'),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x00273140),
                      Color(0x4D273140),
                      Color(0xE6273140),
                    ],
                    stops: [0, 0.46, 1],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: StayNestColors.orange.withValues(alpha: .9),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FigmaSvg(
                            'assets/icons/season_badge.svg',
                            width: 10.833,
                            height: 10.833,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Điểm hẹn mùa thu',
                            style: TextStyle(
                              fontSize: 11,
                              height: 16 / 11,
                              color: StayNestColors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Khám phá vẻ đẹp biển Đà Nẵng & Phố cổ Hội An',
                      style: TextStyle(
                        fontSize: 20,
                        height: 25 / 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFEBF1FF),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Trải nghiệm những góc homestay bản địa đầy thi vị',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        height: 18 / 12,
                        color: Color(0xCCEBF1FF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _WeekendOffer extends StatelessWidget {
  const _WeekendOffer();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
    child: InkWell(
      onTap: () => context.push('/offers'),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 82,
        decoration: BoxDecoration(
          color: StayNestColors.paleBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: StayNestColors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: FigmaSvg(
                  'assets/icons/voucher_tag.svg',
                  width: 19.975,
                  height: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: StayNestColors.orange,
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          child: Text(
                            'STAY100',
                            style: TextStyle(
                              fontSize: 11,
                              height: 16 / 11,
                              fontWeight: FontWeight.w700,
                              color: StayNestColors.white,
                              letterSpacing: .275,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Giảm 100.000đ',
                        style: TextStyle(
                          fontSize: 12,
                          height: 18 / 12,
                          fontWeight: FontWeight.w500,
                          color: StayNestColors.ink,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Áp dụng đơn từ 1.500.000đ cuối tuần',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      height: 18 / 12,
                      color: StayNestColors.body,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const FigmaSvg(
              'assets/icons/chevron_right_small.svg',
              width: 6.167,
              height: 10,
            ),
          ],
        ),
      ),
    ),
  );
}

class _Destinations extends StatelessWidget {
  const _Destinations();

  static const _data = [
    (
      'Đà Nẵng',
      'Bãi biển Mỹ Khê',
      '420+ chỗ ở',
      'assets/images/danang.jpg',
      'da-nang',
    ),
    (
      'Hội An',
      'Phố cổ đèn lồng',
      '285+ chỗ ở',
      'assets/images/hoian.jpg',
      'hoi-an',
    ),
    (
      'Đà Lạt',
      'Đồi thông mờ sương',
      '310+ chỗ ở',
      'assets/images/dalat.jpg',
      'da-lat',
    ),
  ];

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24),
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Điểm đến nổi bật',
                      style: TextStyle(
                        fontSize: 20,
                        height: 25 / 20,
                        fontWeight: FontWeight.w600,
                        color: StayNestColors.ink,
                      ),
                    ),
                    Text(
                      'Lựa chọn được yêu thích nhất tuần này',
                      style: TextStyle(
                        fontSize: 12,
                        height: 18 / 12,
                        color: StayNestColors.body,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => context.push('/destinations'),
                child: const Row(
                  children: [
                    Text(
                      'Xem tất cả',
                      style: TextStyle(
                        fontSize: 12,
                        height: 18 / 12,
                        fontWeight: FontWeight.w500,
                        color: StayNestColors.teal,
                      ),
                    ),
                    SizedBox(width: 2),
                    FigmaSvg(
                      'assets/icons/chevron_link.svg',
                      width: 4.933,
                      height: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 168,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            itemCount: _data.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) =>
                _DestinationCard(data: _data[index]),
          ),
        ),
      ],
    ),
  );
}

class _DestinationCard extends ConsumerWidget {
  const _DestinationCard({required this.data});
  final (String, String, String, String, String) data;

  @override
  Widget build(BuildContext context, WidgetRef ref) => InkWell(
    onTap: () {
      final draft = ref.read(bookingDraftProvider);
      draft.destinationSlug = data.$5;
      if (data.$5 == 'da-nang') {
        context.push('/destinations/da-nang');
      } else {
        context.push('/search/results');
      }
    },
    borderRadius: BorderRadius.circular(12),
    child: Container(
      width: 176,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: StayNestColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F172B4D),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 112,
            child: Stack(
              fit: StackFit.expand,
              children: [
                FigmaRaster(data.$4),
                Positioned(
                  left: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xBF273140),
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      data.$3,
                      style: const TextStyle(
                        fontSize: 11,
                        height: 16 / 11,
                        color: Color(0xFFEBF1FF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Text(
              data.$1,
              style: const TextStyle(
                fontSize: 14,
                height: 22 / 14,
                color: StayNestColors.ink,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              data.$2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                height: 18 / 12,
                color: StayNestColors.body,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _Recommendations extends StatelessWidget {
  const _Recommendations({required this.isSaved, required this.onToggleSaved});
  final bool isSaved;
  final VoidCallback onToggleSaved;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gợi ý dành cho bạn',
                      style: TextStyle(
                        fontSize: 20,
                        height: 25 / 20,
                        fontWeight: FontWeight.w600,
                        color: StayNestColors.ink,
                      ),
                    ),
                    Text(
                      'Homestay ấm cúng được chấm điểm xuất sắc',
                      style: TextStyle(
                        fontSize: 12,
                        height: 18 / 12,
                        color: StayNestColors.body,
                      ),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () => context.push('/recommendations'),
                child: const Row(
                  children: [
                    Text(
                      'Xem tất cả',
                      style: TextStyle(
                        fontSize: 12,
                        height: 18 / 12,
                        fontWeight: FontWeight.w500,
                        color: StayNestColors.teal,
                      ),
                    ),
                    SizedBox(width: 2),
                    FigmaSvg(
                      'assets/icons/chevron_link.svg',
                      width: 4.933,
                      height: 8,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: InkWell(
            onTap: () => context.push('/properties/may-homestay'),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: StayNestColors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x10172B4D),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const FigmaRaster('assets/images/may_homestay.jpg'),
                        Positioned(
                          left: 8,
                          bottom: 8,
                          child: _ImageBadge(
                            icon: 'assets/icons/property_icon_1.svg',
                            text: 'Studio có bếp riêng',
                          ),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Material(
                            color: StayNestColors.white.withValues(alpha: .92),
                            shape: const CircleBorder(),
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: onToggleSaved,
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Center(
                                  child: isSaved
                                      ? const Icon(
                                          Icons.favorite,
                                          color: StayNestColors.teal,
                                          size: 20,
                                        )
                                      : const FigmaSvg(
                                          'assets/icons/home_favorite_heart.svg',
                                          width: 16.667,
                                          height: 15.292,
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const FigmaSvg(
                              'assets/icons/property_icon_2.svg',
                              width: 10,
                              height: 12.5,
                            ),
                            const SizedBox(width: 4),
                            const Expanded(
                              child: Text(
                                'Hội An, Quảng Nam',
                                style: TextStyle(
                                  fontSize: 11,
                                  height: 16 / 11,
                                  color: StayNestColors.body,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: StayNestColors.paleBlue,
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: const Row(
                                children: [
                                  FigmaSvg(
                                    'assets/icons/property_icon_3.svg',
                                    width: 12.5,
                                    height: 11.875,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    '4,8',
                                    style: TextStyle(
                                      fontSize: 11,
                                      height: 16 / 11,
                                      color: StayNestColors.ink,
                                    ),
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    '(128)',
                                    style: TextStyle(
                                      fontSize: 10,
                                      height: 14 / 10,
                                      color: StayNestColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Mây Homestay',
                          style: TextStyle(
                            fontSize: 16,
                            height: 22 / 16,
                            fontWeight: FontWeight.w600,
                            color: StayNestColors.ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            _Amenity(
                              icon: 'assets/icons/property_icon_4.svg',
                              width: 14,
                              height: 9.917,
                              label: 'Wi-Fi tốc độ cao',
                            ),
                            _Amenity(
                              icon: 'assets/icons/property_icon_5.svg',
                              width: 11.667,
                              height: 11.667,
                              label: 'Điều hòa',
                            ),
                            _Amenity(
                              icon: 'assets/icons/property_icon_6.svg',
                              width: 10.5,
                              height: 10.5,
                              label: 'Bữa sáng',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              '850.000đ',
                              style: TextStyle(
                                fontSize: 14,
                                height: 20 / 14,
                                fontWeight: FontWeight.w700,
                                color: StayNestColors.teal,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '/ đêm',
                              style: TextStyle(
                                fontSize: 11,
                                height: 16 / 11,
                                color: StayNestColors.body,
                              ),
                            ),
                            const Spacer(),
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: StayNestColors.paleBlue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Hủy miễn phí trước 18:00,\n12/11/2026',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                    fontSize: 10,
                                    height: 14 / 10,
                                    color: StayNestColors.teal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _ImageBadge extends StatelessWidget {
  const _ImageBadge({required this.icon, required this.text});
  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xBF273140),
      borderRadius: BorderRadius.circular(9999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FigmaSvg(icon, width: 11.667, height: 9.333),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 10,
            height: 14 / 10,
            color: StayNestColors.white,
          ),
        ),
      ],
    ),
  );
}

class _Amenity extends StatelessWidget {
  const _Amenity({
    required this.icon,
    required this.width,
    required this.height,
    required this.label,
  });
  final String icon;
  final double width;
  final double height;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      FigmaSvg(icon, width: width, height: height),
      const SizedBox(width: 4),
      Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          height: 14 / 10,
          color: StayNestColors.body,
        ),
      ),
    ],
  );
}
