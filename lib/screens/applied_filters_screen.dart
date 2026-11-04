import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design/tokens.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/figma_asset.dart';

class AppliedFiltersScreen extends StatefulWidget {
  const AppliedFiltersScreen({super.key});
  @override
  State<AppliedFiltersScreen> createState() => _AppliedFiltersScreenState();
}

class _AppliedFiltersScreenState extends State<AppliedFiltersScreen> {
  final Set<String> amenities = {'Wi-Fi', 'Bếp', 'Điều hòa'};
  final Set<int> saved = {};

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: StayNestColors.canvas,
    bottomNavigationBar: const StayNestBottomNavigation(selectedIndex: 1),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF3FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => context.canPop()
                          ? context.pop()
                          : context.go('/search/results'),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: StayNestColors.canvas,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: FigmaSvg(
                            'assets/icons/applied_filters_01.svg',
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
                          Row(
                            children: [
                              Text(
                                'Hội An',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: StayNestColors.ink,
                                ),
                              ),
                              SizedBox(width: 4),
                              CircleAvatar(
                                radius: 3,
                                backgroundColor: StayNestColors.teal,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '3 chỗ nghỉ',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: StayNestColors.teal,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1),
                          Text(
                            '14–16/11/2026 · 2 đêm · 2 người lớn · 1 phòng',
                            style: TextStyle(
                              fontSize: 12,
                              height: 16.5 / 12,
                              color: Color(0xFF4C5E83),
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () =>
                          context.push('/search/filters/price-property'),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: StayNestColors.canvas,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: FigmaSvg(
                            'assets/icons/applied_filters_02.svg',
                            width: 15,
                            height: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF3FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const FigmaSvg(
                          'assets/icons/applied_filters_03.svg',
                          width: 13.368,
                          height: 13.333,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Bộ lọc đang áp dụng',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: StayNestColors.ink,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () =>
                              context.push('/search/filters/price-property'),
                          child: const Text(
                            'Chỉnh bộ lọc ›',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: StayNestColors.teal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        FigmaSvg(
                          'assets/icons/applied_filters_05.svg',
                          width: 16.5,
                          height: 12,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Khoảng giá:  500.000 – 1.500.000đ / đêm',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: StayNestColors.ink,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: [
                        if (amenities.contains('Wi-Fi'))
                          _tag('Wi-Fi', 'applied_filters_06.svg', 16, 11.333),
                        if (amenities.contains('Bếp'))
                          _tag('Bếp', 'applied_filters_08.svg', 14.2, 11.333),
                        if (amenities.contains('Điều hòa'))
                          _tag(
                            'Điều hòa',
                            'applied_filters_09.svg',
                            13.333,
                            13.333,
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: () =>
                            context.push('/properties/may-homestay'),
                        style: FilledButton.styleFrom(
                          disabledBackgroundColor: StayNestColors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Xem Mây Homestay',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 4),
                            FigmaSvg(
                              'assets/icons/applied_filters_10.svg',
                              width: 13.333,
                              height: 13.333,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Row(
                children: [
                  const Text(
                    'Kết quả phù hợp nhất',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: StayNestColors.ink,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDFE9FC),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      '3 nơi nghỉ',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4C5E83),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Hội An',
                    style: TextStyle(fontSize: 12, color: Color(0xFF4C5E83)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: Column(
                children: [
                  _stay(
                    0,
                    'Mây Homestay',
                    'Cẩm Hà, Hội An',
                    '850.000đ',
                    'applied_filters_1.jpg',
                    rating: '4.8',
                  ),
                  const SizedBox(height: 12),
                  _stay(
                    1,
                    'An Villa',
                    'Cẩm Thanh, Hội An',
                    '980.000đ',
                    'applied_filters_2.jpg',
                  ),
                  const SizedBox(height: 12),
                  _stay(
                    2,
                    'Riverside Home',
                    'Cẩm Nam, Hội An',
                    '1.100.000đ',
                    'applied_filters_3.jpg',
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF3FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Dữ liệu chỗ ở và giá chỉ dùng để minh họa.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Color(0xFF4C5E83)),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _tag(String label, String icon, double width, double height) =>
      InkWell(
        onTap: () => setState(() => amenities.remove(label)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: StayNestColors.canvas,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              FigmaSvg('assets/icons/$icon', width: width, height: height),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: StayNestColors.teal,
                ),
              ),
              const SizedBox(width: 6),
              const FigmaSvg(
                'assets/icons/applied_filters_07.svg',
                width: 8.167,
                height: 8.167,
              ),
            ],
          ),
        ),
      );

  Widget _stay(
    int index,
    String name,
    String location,
    String price,
    String image, {
    String? rating,
  }) => Container(
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: StayNestColors.canvas,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            FigmaRaster(
              'assets/images/$image',
              width: double.infinity,
              height: 218.75,
            ),
            Positioned(
              right: 8,
              top: 8,
              child: InkWell(
                onTap: () => setState(
                  () => saved.contains(index)
                      ? saved.remove(index)
                      : saved.add(index),
                ),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xD9F8F9FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: FigmaSvg(
                      'assets/icons/applied_filters_11.svg',
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
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          location,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF4C5E83),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: StayNestColors.ink,
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
                        color: const Color(0xFFEFF3FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const FigmaSvg(
                            'assets/icons/applied_filters_12.svg',
                            width: 13.333,
                            height: 12.667,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating,
                            style: const TextStyle(
                              fontSize: 12,
                              color: StayNestColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _amenity('Wi-Fi', 'applied_filters_13.svg', 14, 9.917),
                  const SizedBox(width: 6),
                  _amenity('Bếp', 'applied_filters_14.svg', 12.425, 9.917),
                  const SizedBox(width: 6),
                  _amenity(
                    'Điều hòa',
                    'applied_filters_15.svg',
                    11.667,
                    11.667,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: StayNestColors.teal,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '/ đêm',
                    style: TextStyle(fontSize: 12, color: Color(0xFF4C5E83)),
                  ),
                  const Spacer(),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: index == 0
                          ? const Color(0xFF008284)
                          : const Color(0xFFE6EEFF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Chi tiết',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: index == 0
                                ? const Color(0xFFF3FFFE)
                                : StayNestColors.ink,
                          ),
                        ),
                        const SizedBox(width: 4),
                        FigmaSvg(
                          index == 0
                              ? 'assets/icons/applied_filters_16.svg'
                              : 'assets/icons/applied_filters_17.svg',
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

  Widget _amenity(String name, String icon, double width, double height) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFE6EEFF),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            FigmaSvg('assets/icons/$icon', width: width, height: height),
            const SizedBox(width: 4),
            Text(
              name,
              style: const TextStyle(fontSize: 12, color: StayNestColors.body),
            ),
          ],
        ),
      );
}
