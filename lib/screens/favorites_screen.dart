import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/staynest_api.dart';
import '../design/tokens.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/figma_asset.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final favoritesState = ref.watch(myFavoritesProvider);
    final items = favoritesState.value ?? [];
    final hoiAn = items
        .where((item) => '${item['address']}'.contains('Hội An'))
        .length;
    final daNang = items
        .where((item) => '${item['address']}'.contains('Đà Nẵng'))
        .length;
    return Scaffold(
      backgroundColor: StayNestColors.canvas,
      bottomNavigationBar: const StayNestBottomNavigation(selectedIndex: 2),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390),
          child: Column(
            children: [
              SizedBox(
                height: 52,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Yêu Thích',
                          style: TextStyle(
                            fontSize: 14,
                            height: 20 / 14,
                            fontWeight: FontWeight.w600,
                            color: StayNestColors.ink,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => context.go('/account'),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: StayNestColors.teal,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: FigmaSvg(
                              'assets/icons/favorites_03.svg',
                              width: 15,
                              height: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Yêu thích của bạn',
                                  style: TextStyle(
                                    fontSize: 20,
                                    height: 26 / 20,
                                    fontWeight: FontWeight.w600,
                                    color: StayNestColors.ink,
                                  ),
                                ),
                                Text(
                                  '${items.length} chỗ ở đã được lưu',
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 18 / 12,
                                    color: StayNestColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 88,
                            height: 38,
                            decoration: BoxDecoration(
                              color: StayNestColors.paleTeal,
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FigmaSvg(
                                  'assets/icons/favorites_04.svg',
                                  width: 16.667,
                                  height: 15.833,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'So sánh\n(${items.length})',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 10,
                                    height: 12 / 10,
                                    fontWeight: FontWeight.w500,
                                    color: StayNestColors.teal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 36,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _FilterChip(
                              label: 'Tất cả (${items.length})',
                              selected: _filter == 0,
                              onTap: () => setState(() => _filter = 0),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: 'Hội An ($hoiAn)',
                              selected: _filter == 1,
                              onTap: () => setState(() => _filter = 1),
                            ),
                            const SizedBox(width: 8),
                            _FilterChip(
                              label: 'Đà Nẵng ($daNang)',
                              selected: _filter == 2,
                              onTap: () => setState(() => _filter = 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 62,
                        decoration: BoxDecoration(
                          color: StayNestColors.paleTeal,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: StayNestColors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: FigmaSvg(
                                  'assets/icons/favorites_04.svg',
                                  width: 16.667,
                                  height: 15.833,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Đang phân vân chọn phòng?',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 11,
                                      height: 16 / 11,
                                      fontWeight: FontWeight.w600,
                                      color: StayNestColors.ink,
                                    ),
                                  ),
                                  Text(
                                    'Xem so sánh giá, vị trí và tiện ích',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 10,
                                      height: 14 / 10,
                                      color: StayNestColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () =>
                                  context.push('/favorites/compare/select'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 7,
                                ),
                                decoration: BoxDecoration(
                                  color: StayNestColors.teal,
                                  borderRadius: BorderRadius.circular(9999),
                                ),
                                child: const Text(
                                  'So sánh ngay',
                                  style: TextStyle(
                                    fontSize: 10,
                                    height: 14 / 10,
                                    fontWeight: FontWeight.w600,
                                    color: StayNestColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (favoritesState.isLoading)
                        const Center(child: CircularProgressIndicator()),
                      if (favoritesState.hasError)
                        Center(
                          child: TextButton(
                            onPressed: () =>
                                ref.invalidate(myFavoritesProvider),
                            child: const Text(
                              'Không tải được yêu thích. Thử lại',
                            ),
                          ),
                        ),
                      if (!favoritesState.isLoading &&
                          !favoritesState.hasError &&
                          items.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(child: Text('Bạn chưa lưu chỗ ở nào.')),
                        ),
                      for (final item in items)
                        if (_filter == 0 ||
                            (_filter == 1 &&
                                '${item['address']}'.contains('Hội An')) ||
                            (_filter == 2 &&
                                '${item['address']}'.contains('Đà Nẵng'))) ...[
                          _FavoritePropertyCard(
                            slug: '${item['slug']}',
                            onRemove: () async {
                              await ref
                                  .read(stayNestApiProvider)
                                  .setFavorite('${item['slug']}', false);
                              ref.invalidate(myFavoritesProvider);
                            },
                            image: 'assets/images/${item['image_path']}',
                            destination: '${item['address']}'.split(',').first,
                            name: '${item['name']}',
                            location: '${item['address']}',
                            rating: item['rating'] == null
                                ? '—'
                                : '${item['rating']}',
                            reviews: '${item['review_count'] ?? 0}',
                            dates: 'Chọn ngày khi đặt phòng',
                            price:
                                '${'${item['min_price_vnd']}'.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.')}đ',
                          ),
                          const SizedBox(height: 12),
                        ],
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
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(9999),
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: selected ? StayNestColors.teal : StayNestColors.white,
        border: selected ? null : Border.all(color: const Color(0xFFE6EAF2)),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          height: 16 / 11,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          color: selected ? StayNestColors.white : const Color(0xFF667085),
        ),
      ),
    ),
  );
}

class _FavoritePropertyCard extends StatelessWidget {
  const _FavoritePropertyCard({
    required this.slug,
    required this.onRemove,
    required this.image,
    required this.destination,
    required this.name,
    required this.location,
    required this.rating,
    required this.reviews,
    required this.dates,
    required this.price,
  });
  final String slug;
  final VoidCallback onRemove;
  final String image;
  final String destination;
  final String name;
  final String location;
  final String rating;
  final String reviews;
  final String dates;
  final String price;

  @override
  Widget build(BuildContext context) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: StayNestColors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0A172B4D),
          blurRadius: 12,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 1.75,
          child: Stack(
            fit: StackFit.expand,
            children: [
              FigmaRaster(image),
              Positioned(
                left: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xBF273140),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const FigmaSvg(
                        'assets/icons/favorites_06.svg',
                        width: 16.667,
                        height: 15.292,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        destination,
                        style: const TextStyle(
                          fontSize: 10,
                          height: 14 / 10,
                          color: StayNestColors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: InkWell(
                  onTap: onRemove,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: StayNestColors.white.withValues(alpha: .94),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: FigmaSvg(
                        'assets/icons/favorites_07.svg',
                        width: 11.25,
                        height: 11.25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 20 / 14,
                        fontWeight: FontWeight.w600,
                        color: StayNestColors.ink,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: StayNestColors.paleBlue,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Row(
                      children: [
                        const FigmaSvg(
                          'assets/icons/favorites_05.svg',
                          width: 9.333,
                          height: 11.667,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          rating,
                          style: const TextStyle(
                            fontSize: 10,
                            height: 14 / 10,
                            color: StayNestColors.ink,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '($reviews)',
                          style: const TextStyle(
                            fontSize: 9,
                            height: 12 / 9,
                            color: StayNestColors.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  const FigmaSvg(
                    'assets/icons/favorites_06.svg',
                    width: 12,
                    height: 11,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        height: 14 / 10,
                        color: StayNestColors.muted,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F9FC),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const FigmaSvg(
                      'assets/icons/favorites_08.svg',
                      width: 11.667,
                      height: 11.083,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        dates,
                        style: const TextStyle(
                          fontSize: 10,
                          height: 14 / 10,
                          color: StayNestColors.ink,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: StayNestColors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Text(
                        '2 đêm',
                        style: TextStyle(
                          fontSize: 9,
                          height: 12 / 9,
                          color: StayNestColors.muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Giá mỗi đêm từ',
                          style: TextStyle(
                            fontSize: 10,
                            height: 14 / 10,
                            color: StayNestColors.muted,
                          ),
                        ),
                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 14,
                            height: 20 / 14,
                            fontWeight: FontWeight.w700,
                            color: StayNestColors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => context.push('/properties/$slug'),
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: FigmaSvg(
                          'assets/icons/favorites_12.svg',
                          width: 10.5,
                          height: 10.515,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: StayNestColors.teal,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'Xem phòng',
                          style: TextStyle(
                            fontSize: 12,
                            height: 18 / 12,
                            fontWeight: FontWeight.w600,
                            color: StayNestColors.white,
                          ),
                        ),
                        SizedBox(width: 6),
                        FigmaSvg(
                          'assets/icons/favorites_13.svg',
                          width: 12,
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
