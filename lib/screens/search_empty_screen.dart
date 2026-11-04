import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design/tokens.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/figma_asset.dart';
import '../widgets/figma_status_bar.dart';

class SearchEmptyScreen extends StatelessWidget {
  const SearchEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F9FC),
    bottomNavigationBar: const SizedBox(
      height: 92,
      child: Align(
        alignment: Alignment.topCenter,
        child: StayNestBottomNavigation(selectedIndex: 1),
      ),
    ),
    body: Column(
      children: [
        const FigmaStatusBar(),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 13),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE4E7EC))),
          ),
          child: Row(
            children: [
              InkWell(
                onTap: () => context.pop(),
                child: Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F9FC),
                    border: Border.all(color: const Color(0xFFE4E7EC)),
                    shape: BoxShape.circle,
                  ),
                  child: const FigmaSvg(
                    'assets/icons/no_availability_01.svg',
                    width: 20,
                    height: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Hội An',
                          style: TextStyle(
                            color: Color(0xFF121C2A),
                            fontSize: 18,
                            height: 25.5 / 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        _CountPill(),
                      ],
                    ),
                    Text(
                      '14–16/11/2026 · 2 đêm · 2 người lớn · 1 phòng',
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
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF7F9FC),
                  border: Border.all(color: const Color(0xFFE4E7EC)),
                  shape: BoxShape.circle,
                ),
                child: const FigmaSvg(
                  'assets/icons/no_availability_02.svg',
                  width: 16,
                  height: 16,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 13),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE4E7EC))),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _ToolbarButton(
                    icon: 'no_availability_03.svg',
                    label: 'Lọc (3)',
                    selected: true,
                    onTap: () => context.push('/search/filters/price-property'),
                  ),
                  const SizedBox(width: 8),
                  _ToolbarButton(
                    icon: 'no_availability_04.svg',
                    label: 'Sắp xếp',
                    onTap: () => context.push('/search/sort'),
                  ),
                  const SizedBox(width: 8),
                  _ToolbarButton(
                    icon: 'no_availability_05.svg',
                    label: 'Bản đồ',
                    onTap: () => context.push('/search/map'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: const [
                    _RestrictiveChip(label: 'Dưới 500.000đ'),
                    SizedBox(width: 8),
                    _RestrictiveChip(label: 'Hồ bơi'),
                    SizedBox(width: 8),
                    _RestrictiveChip(label: 'Bếp'),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF7F6),
                    border: Border.all(
                      color: const Color(0xFFB2E3E1),
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const FigmaSvg(
                    'assets/icons/no_availability_07.svg',
                    width: 36,
                    height: 36,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Không tìm thấy phòng phù hợp',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF121C2A),
                    fontSize: 18,
                    height: 26 / 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Thử tăng ngân sách hoặc giảm bớt tiện nghi\nđể xem thêm lựa chọn chỗ ở tại Hội An.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 14,
                    height: 22 / 14,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SuggestionButton(
                      icon: 'no_availability_08.svg',
                      label: 'Nới ngân sách',
                      onTap: () =>
                          context.push('/search/filters/price-property'),
                    ),
                    const SizedBox(width: 10),
                    _SuggestionButton(
                      icon: 'no_availability_09.svg',
                      label: 'Bỏ tiện nghi',
                      onTap: () => context.push('/search/filters/amenities'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton.icon(
                    onPressed: () => context.go('/search/results'),
                    icon: const FigmaSvg(
                      'assets/icons/no_availability_10.svg',
                      width: 16,
                      height: 16,
                    ),
                    label: const Text(
                      'Xóa bộ lọc',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 22.5 / 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: FilledButton.styleFrom(
                      backgroundColor: StayNestColors.tealBright,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                SizedBox(
                  height: 44,
                  child: TextButton(
                    onPressed: () =>
                        context.push('/search/filters/price-property'),
                    child: const Text(
                      'Điều chỉnh lọc',
                      style: TextStyle(
                        color: Color(0xFF4C5E83),
                        fontSize: 14,
                        height: 21 / 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _CountPill extends StatelessWidget {
  const _CountPill();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: const Color(0xFFFEF3F2),
      borderRadius: BorderRadius.circular(99),
    ),
    child: const Text(
      '0 chỗ ở',
      style: TextStyle(
        color: Color(0xFFB42318),
        fontSize: 11,
        height: 16.5 / 11,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });
  final String icon, label;
  final VoidCallback onTap;
  final bool selected;
  @override
  Widget build(BuildContext context) => Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? StayNestColors.tealBright : const Color(0xFFF7F9FC),
          border: selected ? null : Border.all(color: const Color(0xFFE4E7EC)),
          borderRadius: BorderRadius.circular(8),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 1,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FigmaSvg('assets/icons/$icon', width: 14, height: 14),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xFF344054),
                fontSize: 12,
                height: 18 / 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _RestrictiveChip extends StatelessWidget {
  const _RestrictiveChip({required this.label});
  final String label;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
    decoration: BoxDecoration(
      color: const Color(0xFFEAF7F6),
      border: Border.all(color: const Color(0xFFB2E3E1)),
      borderRadius: BorderRadius.circular(99),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: StayNestColors.teal,
            fontSize: 12,
            height: 18 / 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.close, size: 14, color: Color(0xFF0F8B8D)),
      ],
    ),
  );
}

class _SuggestionButton extends StatelessWidget {
  const _SuggestionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });
  final String icon, label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(99),
    child: Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE4E7EC)),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        children: [
          FigmaSvg('assets/icons/$icon', width: 14, height: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF344054),
              fontSize: 13,
              height: 19.5 / 13,
            ),
          ),
        ],
      ),
    ),
  );
}
