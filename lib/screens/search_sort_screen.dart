import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design/tokens.dart';
import '../widgets/figma_asset.dart';
import '../widgets/figma_status_bar.dart';

class SearchSortScreen extends StatefulWidget {
  const SearchSortScreen({super.key});

  @override
  State<SearchSortScreen> createState() => _SearchSortScreenState();
}

class _SearchSortScreenState extends State<SearchSortScreen> {
  String selected = 'Phù hợp nhất';
  static const options = [
    'Phù hợp nhất',
    'Giá thấp nhất',
    'Đánh giá cao nhất',
    'Khoảng cách',
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: StayNestColors.canvas,
    body: Stack(
      children: [
        Column(
          children: [
            const FigmaStatusBar(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 2, 20, 8),
              child: Row(
                children: [
                  _circleButton('sort_results_01.svg'),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: _surface(radius: 12),
                      child: Row(
                        children: [
                          const FigmaSvg(
                            'assets/icons/sort_results_02.svg',
                            width: 15,
                            height: 18,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hội An',
                                  style: TextStyle(
                                    color: Color(0xFF121C2A),
                                    fontSize: 14,
                                    height: 17.5 / 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '14–16/11/2026 · 2 đêm · 2 người lớn · 1 phòng',
                                  style: TextStyle(
                                    color: Color(0xFF667085),
                                    fontSize: 10,
                                    height: 13.75 / 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const FigmaSvg(
                            'assets/icons/sort_results_03.svg',
                            width: 14,
                            height: 14,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  _chip(icon: 'sort_results_04.svg', label: 'Lọc (3)'),
                  const SizedBox(width: 8),
                  _chip(
                    icon: 'sort_results_05.svg',
                    label: 'Sắp xếp',
                    selected: true,
                  ),
                  const SizedBox(width: 8),
                  _chip(icon: 'sort_results_06.svg', label: 'Bản đồ'),
                ],
              ),
            ),
            SizedBox(
              height: 40,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                scrollDirection: Axis.horizontal,
                children: ['Wi-Fi', 'Bếp', 'Điều hòa', 'Hồ bơi']
                    .map(
                      (label) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            label,
                            style: const TextStyle(
                              color: Color(0xFF3D4949),
                              fontSize: 12,
                              height: 22 / 12,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '3 chỗ ở minh họa',
                  style: TextStyle(
                    color: Color(0xFF172B4D),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: _surface(radius: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: const FigmaRaster(
                            'assets/images/sort_results_property.jpg',
                            width: double.infinity,
                            height: 144,
                          ),
                        ),
                        Positioned(
                          left: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xE6FFFFFF),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: const Row(
                              children: [
                                FigmaSvg(
                                  'assets/icons/sort_results_07.svg',
                                  width: 9,
                                  height: 10,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Phổ biến nhất',
                                  style: TextStyle(
                                    color: Color(0xFF172B4D),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              color: Color(0xCCFFFFFF),
                              shape: BoxShape.circle,
                            ),
                            child: const FigmaSvg(
                              'assets/icons/sort_results_08.svg',
                              width: 15,
                              height: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Hội An, Quảng Nam',
                            style: TextStyle(
                              color: Color(0xFF667085),
                              fontSize: 12,
                              height: 18 / 12,
                            ),
                          ),
                        ),
                        const FigmaSvg(
                          'assets/icons/sort_results_09.svg',
                          width: 14,
                          height: 12,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '4,8',
                          style: TextStyle(
                            color: Color(0xFF172B4D),
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          '(94)',
                          style: TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const Text(
                      'Mây Homestay',
                      style: TextStyle(
                        color: Color(0xFF172B4D),
                        fontSize: 16,
                        height: 24 / 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      children: ['Bếp riêng', 'Wi-Fi', 'Điều hòa']
                          .map(
                            (e) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF3FF),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                e,
                                style: const TextStyle(
                                  color: Color(0xFF4C5E83),
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '850.000đ',
                          style: TextStyle(
                            color: Color(0xFF006768),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '/ đêm',
                          style: TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const Positioned.fill(child: ColoredBox(color: Color(0x66172B4D))),
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            top: false,
            child: Container(
              width: 390,
              padding: const EdgeInsets.only(bottom: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x2E172B4D),
                    blurRadius: 12,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 12, 0, 6),
                    child: SizedBox(
                      width: 40,
                      height: 4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFFD9E3F6),
                          borderRadius: BorderRadius.all(Radius.circular(99)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Sắp xếp theo',
                            style: TextStyle(
                              color: Color(0xFF121C2A),
                              fontSize: 18,
                              height: 26 / 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => context.pop(),
                          child: const SizedBox(
                            width: 36,
                            height: 36,
                            child: Center(
                              child: FigmaSvg(
                                'assets/icons/sort_results_10.svg',
                                width: 13,
                                height: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 4,
                    ),
                    child: Column(
                      children: options
                          .map(
                            (option) => _SortOption(
                              label: option,
                              selected: selected == option,
                              onTap: () => setState(() => selected = option),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: FilledButton(
                        onPressed: () => context.pop(selected),
                        style: FilledButton.styleFrom(
                          backgroundColor: StayNestColors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Áp dụng',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4),
                            FigmaSvg(
                              'assets/icons/sort_results_12.svg',
                              width: 12,
                              height: 12,
                            ),
                          ],
                        ),
                      ),
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

  Widget _circleButton(String icon) => Container(
    width: 36,
    height: 36,
    alignment: Alignment.center,
    decoration: _surface(radius: 999),
    child: FigmaSvg('assets/icons/$icon', width: 14, height: 14),
  );

  Widget _chip({
    required String icon,
    required String label,
    bool selected = false,
  }) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      color: selected ? const Color(0x4D8FF3F4) : Colors.white,
      border: selected ? Border.all(color: const Color(0x4D006768)) : null,
      borderRadius: BorderRadius.circular(999),
      boxShadow: selected
          ? null
          : const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 1,
                offset: Offset(0, 1),
              ),
            ],
    ),
    child: Row(
      children: [
        FigmaSvg('assets/icons/$icon', width: 12, height: 12),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF172B4D),
            fontSize: 12,
            height: 22 / 12,
          ),
        ),
      ],
    ),
  );
}

class _SortOption extends StatelessWidget {
  const _SortOption({
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
    child: Container(
      height: 50,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0x99E6EEFF))),
      ),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0x408FF3F4)
                  : const Color(0x99DFE9FC),
              shape: BoxShape.circle,
            ),
            child: selected
                ? Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: StayNestColors.teal,
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: const Color(0xFF121C2A),
                fontSize: 14,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          if (selected)
            const FigmaSvg(
              'assets/icons/sort_results_11.svg',
              width: 18,
              height: 18,
            ),
        ],
      ),
    ),
  );
}

BoxDecoration _surface({required double radius}) => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(radius),
  boxShadow: const [
    BoxShadow(color: Color(0x0D000000), blurRadius: 1, offset: Offset(0, 1)),
  ],
);
