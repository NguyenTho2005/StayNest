import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/staynest_api.dart';
import '../design/tokens.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/figma_asset.dart';
import '../widgets/figma_status_bar.dart';

class SearchResultsListScreen extends ConsumerStatefulWidget {
  const SearchResultsListScreen({super.key});

  @override
  ConsumerState<SearchResultsListScreen> createState() =>
      _SearchResultsListScreenState();
}

class _SearchResultsListScreenState
    extends ConsumerState<SearchResultsListScreen> {
  late Future<List<dynamic>> results;
  int? minPrice;
  int? maxPrice;
  String? propertyType;
  String? sort;
  int get activeFilters =>
      (minPrice != null || maxPrice != null ? 1 : 0) +
      (propertyType != null ? 1 : 0);

  Future<List<dynamic>> loadResults() {
    final draft = ref.read(bookingDraftProvider);
    return ref
        .read(stayNestApiProvider)
        .properties(
          destination: draft.destinationSlug,
          minPrice: minPrice,
          maxPrice: maxPrice,
          propertyType: propertyType,
          sort: sort,
          checkIn: draft.checkInIso,
          checkOut: draft.checkOutIso,
          adults: draft.adults,
        );
  }

  @override
  void initState() {
    super.initState();
    results = loadResults();
  }

  void retry() => setState(() {
    results = loadResults();
  });

  Future<void> openControl(String path) async {
    final selected = await context.push<dynamic>(path);
    if (!mounted || selected == null) return;
    if (path == '/search/filters/price-property' && selected is Map) {
      final range = selected['price'] as RangeValues?;
      final type = selected['propertyType'] as String?;
      setState(() {
        minPrice = range == null || range.start == 0
            ? null
            : range.start.round();
        maxPrice = range == null || range.end == 3000000
            ? null
            : range.end.round();
        propertyType = switch (type) {
          'Khách sạn' => 'HOTEL',
          'Homestay' => 'HOMESTAY',
          _ => null,
        };
        results = loadResults();
      });
    } else if (path == '/search/sort' && selected is String) {
      if (selected == 'Khoảng cách') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Chưa có dữ liệu vị trí để sắp xếp theo khoảng cách.',
            ),
          ),
        );
        return;
      }
      setState(() {
        sort = selected == 'Đánh giá cao nhất' ? 'rating_desc' : 'price_asc';
        results = loadResults();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.read(bookingDraftProvider);
    final dates =
        '${draft.checkIn.day}–${draft.checkOut.day}/${draft.checkOut.month}/${draft.checkOut.year} · ${draft.checkOut.difference(draft.checkIn).inDays} đêm';
    final guests = '${draft.adults} người lớn · ${draft.roomCount} phòng';
    return Scaffold(
      backgroundColor: StayNestColors.canvas,
      bottomNavigationBar: const StayNestBottomNavigation(selectedIndex: 1),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            const FigmaStatusBar(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  _circleAction(
                    'search_list_01.svg',
                    onTap: () => context.pop(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              draft.destinationName,
                              style: TextStyle(
                                color: Color(0xFF172B4D),
                                fontSize: 22,
                                height: 30 / 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          dates,
                          style: const TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 12,
                            height: 18 / 12,
                          ),
                        ),
                        Text(
                          guests,
                          style: const TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 12,
                            height: 18 / 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _circleAction(
                    'search_list_02.svg',
                    onTap: () => context.go('/search'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  _control(
                    context,
                    icon: 'search_list_03.svg',
                    label: 'Lọc',
                    count: activeFilters == 0 ? null : '$activeFilters',
                    path: '/search/filters/price-property',
                  ),
                  const SizedBox(width: 8),
                  _control(
                    context,
                    icon: 'search_list_04.svg',
                    label: 'Sắp xếp',
                    path: '/search/sort',
                  ),
                  const SizedBox(width: 8),
                  _control(
                    context,
                    icon: 'search_list_05.svg',
                    label: 'Bản đồ',
                    path: '/search/map',
                  ),
                ],
              ),
            ),
            if (minPrice != null || maxPrice != null || propertyType != null)
              SizedBox(
                height: 34,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  children: [
                    if (minPrice != null || maxPrice != null)
                      _AppliedChip(
                        label: 'Giá đã lọc',
                        icon: 'search_list_06.svg',
                      ),
                    if (propertyType != null)
                      _AppliedChip(
                        label: propertyType!,
                        icon: 'search_list_08.svg',
                      ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Chỗ ở phù hợp',
                      style: TextStyle(
                        color: Color(0xFF172B4D),
                        fontSize: 18,
                        height: 26 / 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    activeFilters == 0 ? 'Tất cả chỗ ở' : 'Đã áp dụng bộ lọc',
                    style: const TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: results,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: StayNestColors.teal),
                          SizedBox(height: 16),
                          Text(
                            'Đang tìm kiếm chỗ ở phù hợp...',
                            style: TextStyle(
                              color: Color(0xFF667085),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE4E2),
                                border: Border.all(
                                  color: const Color(0xFFFECDCA),
                                  width: 1.5,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const FigmaSvg(
                                'assets/icons/login_error_01.svg',
                                width: 28,
                                height: 28,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Không tải được chỗ ở',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF121C2A),
                                fontSize: 16,
                                height: 24 / 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'Vui lòng đảm bảo backend API đang hoạt động hoặc thử lại.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                height: 19 / 13,
                                color: Color(0xFF667085),
                              ),
                            ),
                            const SizedBox(height: 16),
                            FilledButton(
                              onPressed: retry,
                              style: FilledButton.styleFrom(
                                backgroundColor: StayNestColors.tealBright,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text('Thử lại'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  final items = snapshot.data ?? [];
                  if (items.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF7F6),
                                border: Border.all(
                                  color: const Color(0xFFB2E3E1),
                                  width: 1.5,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: const FigmaSvg(
                                'assets/icons/no_availability_07.svg',
                                width: 28,
                                height: 28,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Không tìm thấy phòng phù hợp',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF121C2A),
                                fontSize: 16,
                                height: 24 / 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Thử đổi ngày nhận/trả phòng hoặc nới rộng khoảng giá để xem thêm lựa chọn tại ${draft.destinationName}.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 19 / 13,
                                color: Color(0xFF667085),
                              ),
                            ),
                            if (activeFilters > 0) ...[
                              const SizedBox(height: 16),
                              FilledButton.icon(
                                onPressed: () {
                                  setState(() {
                                    minPrice = null;
                                    maxPrice = null;
                                    propertyType = null;
                                    results = loadResults();
                                  });
                                },
                                icon: const FigmaSvg(
                                  'assets/icons/no_availability_10.svg',
                                  width: 14,
                                  height: 14,
                                ),
                                label: const Text('Xóa bộ lọc'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: StayNestColors.tealBright,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final item = items[index] as Map<String, dynamic>;
                      final price = '${item['min_price_vnd']}'.replaceAllMapped(
                        RegExp(r'\B(?=(\d{3})+(?!\d))'),
                        (_) => '.',
                      );
                      return _PropertyResultCard(
                        slug: '${item['slug']}',
                        name: '${item['name']}',
                        address: '${item['address']}',
                        image: 'assets/images/${item['image_path']}',
                        rating: item['rating'] == null
                            ? null
                            : '${item['rating']}',
                        amenities: (item['amenities'] as List? ?? [])
                            .map((value) => '$value')
                            .toList(),
                        price: '$priceđ',
                        badge: null,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleAction(String icon, {required VoidCallback onTap}) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(99),
    child: Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFFE6EEFF),
        shape: BoxShape.circle,
      ),
      child: FigmaSvg('assets/icons/$icon', width: 17, height: 17),
    ),
  );

  Widget _control(
    BuildContext context, {
    required String icon,
    required String label,
    String? count,
    String? path,
  }) => Expanded(
    child: InkWell(
      onTap: path == null ? null : () => openControl(path),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FigmaSvg('assets/icons/$icon', width: 15, height: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF172B4D),
                fontSize: 12,
                height: 18 / 12,
              ),
            ),
            if (count != null) ...[
              const SizedBox(width: 3),
              Container(
                width: 20,
                height: 20,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: StayNestColors.teal,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  count,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    height: 16 / 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class _AppliedChip extends StatelessWidget {
  const _AppliedChip({required this.label, required this.icon});
  final String label, icon;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(right: 8),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: const Color(0x1A006768),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Row(
      children: [
        FigmaSvg('assets/icons/$icon', width: 15, height: 11),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: StayNestColors.teal,
            fontSize: 12,
            height: 18 / 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

class _PropertyResultCard extends ConsumerWidget {
  const _PropertyResultCard({
    required this.slug,
    required this.name,
    required this.address,
    required this.image,
    required this.amenities,
    required this.price,
    this.rating,
    this.badge,
  });
  final String slug;
  final String name, address, image, price;
  final String? rating, badge;
  final List<String> amenities;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x14172B4D),
          blurRadius: 16,
          offset: Offset(0, 4),
        ),
      ],
    ),
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: () => context.push(
        slug == 'may-homestay'
            ? '/properties/may-homestay'
            : '/catalog/properties/$slug',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 262.5,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                FigmaRaster(image, fit: BoxFit.cover),
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0x66000000)],
                    ),
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: InkWell(
                    onTap: () async {
                      try {
                        await ref
                            .read(stayNestApiProvider)
                            .setFavorite(slug, true);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã lưu vào yêu thích.'),
                            ),
                          );
                        }
                      } catch (error) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text('$error')));
                        }
                      }
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xCCFFFFFF),
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: const FigmaSvg(
                        'assets/icons/search_list_10.svg',
                        width: 17,
                        height: 16,
                      ),
                    ),
                  ),
                ),
                if (badge != null)
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xE6FFFFFF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          color: Color(0xFF172B4D),
                          fontSize: 11,
                          height: 16 / 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const FigmaSvg(
                            'assets/icons/search_list_11.svg',
                            width: 10,
                            height: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            address,
                            style: const TextStyle(
                              color: Color(0xFF667085),
                              fontSize: 12,
                              height: 18 / 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (rating != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: StayNestColors.paleBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const FigmaSvg(
                              'assets/icons/search_list_12.svg',
                              width: 13,
                              height: 13,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              rating!,
                              style: const TextStyle(
                                color: StayNestColors.ink,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFF172B4D),
                    fontSize: 16,
                    height: 24 / 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: amenities
                      .map(
                        (label) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: StayNestColors.paleBlue,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            label,
                            style: const TextStyle(
                              color: Color(0xFF4C5E83),
                              fontSize: 12,
                              height: 18 / 12,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 12, 10, 8),
                  decoration: BoxDecoration(
                    color: const Color(0x66EFF3FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              price,
                              style: const TextStyle(
                                color: StayNestColors.teal,
                                fontSize: 16,
                                height: 24 / 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '/ đêm',
                              style: TextStyle(
                                color: Color(0xFF667085),
                                fontSize: 12,
                                height: 18 / 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 32,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0D000000),
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: const Row(
                          children: [
                            FigmaSvg(
                              'assets/icons/search_list_13.svg',
                              width: 13,
                              height: 11,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'So sánh',
                              style: TextStyle(
                                color: Color(0xFF172B4D),
                                fontSize: 12,
                                height: 18 / 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
