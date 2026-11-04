import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/staynest_api.dart';
import '../design/tokens.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/figma_asset.dart';

class DestinationDetailScreen extends ConsumerStatefulWidget {
  const DestinationDetailScreen({super.key});

  @override
  ConsumerState<DestinationDetailScreen> createState() =>
      _DestinationDetailScreenState();
}

class _DestinationDetailScreenState
    extends ConsumerState<DestinationDetailScreen> {
  String area = 'Mỹ Khê';
  static const shadow = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 6,
    offset: Offset(0, 4),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: StayNestColors.canvas,
    bottomNavigationBar: const StayNestBottomNavigation(selectedIndex: 0),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go('/destinations'),
                    child: const SizedBox(
                      width: 40,
                      height: 44,
                      child: Center(
                        child: FigmaSvg(
                          'assets/icons/destination_detail_01.svg',
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 60),
                      child: Text(
                        'Đà Nẵng',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          height: 26 / 20,
                          letterSpacing: -0.5,
                          fontWeight: FontWeight.w600,
                          color: StayNestColors.ink,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: const FigmaRaster(
                        'assets/images/destination_detail_1.jpg',
                        width: double.infinity,
                        height: 196.88,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 16,
                          decoration: BoxDecoration(
                            color: StayNestColors.teal,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Khám phá Đà Nẵng',
                          style: TextStyle(
                            fontSize: 20,
                            height: 26 / 20,
                            fontWeight: FontWeight.w600,
                            color: StayNestColors.ink,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Thành phố biển sôi động với bờ cát trắng mịn, bán đảo xanh mát và nhịp sống nghỉ dưỡng hài hòa bên bờ đại dương.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 22.75 / 14,
                        color: Color(0xFF4C5E83),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0D000000),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _summary(
                            'destination_detail_02.svg',
                            13.5,
                            15,
                            'Thời gian lưu trú',
                            '14–16/11/2026 · 2 đêm',
                            () => context.push('/search/dates'),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Divider(height: 1, color: Color(0xFFE6EEFF)),
                          ),
                          _summary(
                            'destination_detail_03.svg',
                            16.5,
                            12,
                            'Số lượng khách',
                            '2 người lớn · 1 phòng',
                            () => context.push('/search/guests'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      children: [
                        Text(
                          'Khu vực bạn muốn ở',
                          style: TextStyle(
                            fontSize: 16,
                            height: 24 / 16,
                            fontWeight: FontWeight.w600,
                            color: StayNestColors.ink,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '3 khu vực nổi bật',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF4C5E83),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: ['Mỹ Khê', 'Ngũ Hành Sơn', 'Sơn Trà']
                            .map(
                              (item) => Padding(
                                padding: const EdgeInsets.only(
                                  right: 8,
                                  bottom: 4,
                                ),
                                child: InkWell(
                                  onTap: () => setState(() => area = item),
                                  borderRadius: BorderRadius.circular(999),
                                  child: Container(
                                    height: 36,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      color: area == item
                                          ? const Color(0xFFEFF3FF)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Row(
                                      children: [
                                        if (area == item) ...[
                                          const FigmaSvg(
                                            'assets/icons/destination_detail_04.svg',
                                            width: 12,
                                            height: 15,
                                          ),
                                          const SizedBox(width: 6),
                                        ],
                                        Text(
                                          item,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: area == item
                                                ? StayNestColors.teal
                                                : const Color(0xFF4C5E83),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Gợi ý chỗ ở',
                      style: TextStyle(
                        fontSize: 16,
                        height: 24 / 16,
                        fontWeight: FontWeight.w600,
                        color: StayNestColors.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: () =>
                          context.push('/catalog/properties/ocean-pearl-hotel'),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [shadow],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                const FigmaRaster(
                                  'assets/images/destination_detail_2.jpg',
                                  width: double.infinity,
                                  height: 218.75,
                                ),
                                Positioned(
                                  right: 12,
                                  top: 12,
                                  child: InkWell(
                                    onTap: () async {
                                      try {
                                        await ref
                                            .read(
                                              favoriteControllerProvider
                                                  .notifier,
                                            )
                                            .toggle('ocean-pearl-hotel');
                                      } catch (e) {
                                        if (!context.mounted) return;
                                        if (e is StayNestApiException &&
                                            e.status == 401) {
                                          context.push('/login');
                                          return;
                                        }
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                              SnackBar(
                                                content: Text('$e'),
                                              ),
                                            );
                                      }
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: ref
                                                .watch(
                                                  favoriteControllerProvider,
                                                )
                                                .isFavorite(
                                                  'ocean-pearl-hotel',
                                                )
                                            ? const Icon(
                                                Icons.favorite,
                                                color: StayNestColors.teal,
                                                size: 20,
                                              )
                                            : const FigmaSvg(
                                                'assets/icons/destination_detail_05.svg',
                                                width: 16.667,
                                                height: 15.292,
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Ocean Pearl Hotel',
                                    style: TextStyle(
                                      fontSize: 16,
                                      height: 1.5,
                                      fontWeight: FontWeight.w600,
                                      color: StayNestColors.ink,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Row(
                                    children: [
                                      FigmaSvg(
                                        'assets/icons/destination_detail_06.svg',
                                        width: 8.75,
                                        height: 12.5,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        'Đà Nẵng · Gần biển Mỹ Khê',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF4C5E83),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const Text(
                                        '1.250.000đ',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: StayNestColors.teal,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      const Text(
                                        '/ đêm',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF4C5E83),
                                        ),
                                      ),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () => context.push(
                                          '/catalog/properties/ocean-pearl-hotel',
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Xem chi tiết',
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            SizedBox(width: 4),
                                            FigmaSvg(
                                              'assets/icons/destination_detail_07.svg',
                                              width: 10.667,
                                              height: 10.667,
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
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: () =>
                            context.push('/destinations/da-nang/hotels'),
                        style: FilledButton.styleFrom(
                          backgroundColor: StayNestColors.teal,
                          disabledBackgroundColor: StayNestColors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Xem phòng tại Đà Nẵng',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            FigmaSvg(
                              'assets/icons/destination_detail_08.svg',
                              width: 15,
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _summary(
    String icon,
    double width,
    double height,
    String label,
    String value,
    VoidCallback onTap,
  ) => Row(
    children: [
      Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFE6EEFF),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: FigmaSvg('assets/icons/$icon', width: width, height: height),
        ),
      ),
      const SizedBox(width: 10),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              height: 16 / 11,
              fontWeight: FontWeight.w500,
              color: Color(0xFF4C5E83),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              height: 22 / 14,
              fontWeight: FontWeight.w600,
              color: StayNestColors.ink,
            ),
          ),
        ],
      ),
      const Spacer(),
      InkWell(
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.all(4),
          child: Text(
            'Đổi',
            style: TextStyle(fontSize: 12, color: StayNestColors.teal),
          ),
        ),
      ),
    ],
  );
}
