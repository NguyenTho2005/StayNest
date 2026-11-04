import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design/tokens.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/figma_asset.dart';

class DestinationHotelsScreen extends StatefulWidget {
  const DestinationHotelsScreen({super.key});
  @override
  State<DestinationHotelsScreen> createState() =>
      _DestinationHotelsScreenState();
}

class _DestinationHotelsScreenState extends State<DestinationHotelsScreen> {
  final Set<String> filters = {};
  bool saved = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: StayNestColors.canvas,
    bottomNavigationBar: const StayNestBottomNavigation(selectedIndex: 1),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
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
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => context.canPop()
                              ? context.pop()
                              : context.go('/destinations/da-nang'),
                          child: const SizedBox(
                            width: 44,
                            height: 44,
                            child: Center(
                              child: FigmaSvg(
                                'assets/icons/destination_hotels_01.svg',
                                width: 16,
                                height: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Đà Nẵng',
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  fontWeight: FontWeight.w600,
                                  color: StayNestColors.ink,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                '14–16/11/2026 · 2 đêm · 2 người lớn · 1 phòng',
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 12,
                                  height: 1.5,
                                  color: Color(0xFF4C5E83),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => context.push('/search/dates'),
                          child: const SizedBox(
                            width: 32,
                            height: 32,
                            child: Center(
                              child: FigmaSvg(
                                'assets/icons/destination_hotels_02.svg',
                                width: 15,
                                height: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _action(
                        'destination_hotels_03.svg',
                        13.5,
                        13.5,
                        'Lọc',
                        () => context.push('/search/filters/price-property'),
                      ),
                      const SizedBox(width: 8),
                      _action(
                        'destination_hotels_04.svg',
                        12,
                        15,
                        'Sắp\nxếp',
                        () => context.push('/search/sort'),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: ['Gần biển', 'Hồ bơi', 'Bữa sáng']
                                .map(
                                  (label) => Padding(
                                    padding: const EdgeInsets.only(right: 4),
                                    child: InkWell(
                                      onTap: () => setState(
                                        () => filters.contains(label)
                                            ? filters.remove(label)
                                            : filters.add(label),
                                      ),
                                      borderRadius: BorderRadius.circular(999),
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        decoration: BoxDecoration(
                                          color: filters.contains(label)
                                              ? const Color(0xFFE6EEFF)
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            999,
                                          ),
                                        ),
                                        child: Text(
                                          label,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: filters.contains(label)
                                                ? StayNestColors.teal
                                                : const Color(0xFF4C5E83),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: [
                  Row(
                    children: [
                      const Text(
                        '1 chỗ ở minh họa',
                        style: TextStyle(
                          fontSize: 14,
                          height: 22 / 14,
                          fontWeight: FontWeight.w600,
                          color: StayNestColors.ink,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6EEFF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Đà Nẵng',
                          style: TextStyle(
                            fontSize: 11,
                            color: StayNestColors.teal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Dữ liệu chỗ ở và giá chỉ dùng để minh họa',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.5,
                      color: Color(0xFF4C5E83),
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () =>
                        context.push('/catalog/properties/ocean-pearl-hotel'),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x1A000000),
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Stack(
                              children: [
                                const FigmaRaster(
                                  'assets/images/destination_hotels_ocean.jpg',
                                  width: double.infinity,
                                  height: 208.75,
                                ),
                                Positioned(
                                  right: 8,
                                  top: 8,
                                  child: InkWell(
                                    onTap: () => setState(() => saved = !saved),
                                    child: Container(
                                      width: 44,
                                      height: 44,
                                      decoration: const BoxDecoration(
                                        color: Color(0xD9FFFFFF),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: FigmaSvg(
                                          'assets/icons/destination_hotels_05.svg',
                                          width: 18.333,
                                          height: 16.821,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
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
                                      'assets/icons/destination_hotels_06.svg',
                                      width: 10,
                                      height: 12.5,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Đà Nẵng',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF4C5E83),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Giá mỗi đêm từ',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFF4C5E83),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  '1.250.000₫',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    height: 26 / 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: StayNestColors.teal,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                '/ đêm',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF4C5E83),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      height: 44,
                                      child: FilledButton(
                                        onPressed: () => context.push(
                                          '/catalog/properties/ocean-pearl-hotel',
                                        ),
                                        style: FilledButton.styleFrom(
                                          backgroundColor: StayNestColors.teal,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Xem chi tiết',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            FigmaSvg(
                                              'assets/icons/destination_hotels_07.svg',
                                              width: 12,
                                              height: 12,
                                            ),
                                          ],
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
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _action(
    String icon,
    double width,
    double height,
    String label,
    VoidCallback onTap,
  ) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          FigmaSvg('assets/icons/$icon', width: width, height: height),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              height: 1.5,
              fontWeight: FontWeight.w500,
              color: StayNestColors.ink,
            ),
          ),
        ],
      ),
    ),
  );
}
