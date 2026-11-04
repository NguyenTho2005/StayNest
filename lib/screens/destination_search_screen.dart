import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/staynest_api.dart';
import '../design/tokens.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/figma_asset.dart';
import '../widgets/figma_status_bar.dart';

class DestinationSearchScreen extends ConsumerStatefulWidget {
  const DestinationSearchScreen({super.key});

  @override
  ConsumerState<DestinationSearchScreen> createState() =>
      _DestinationSearchScreenState();
}

class _DestinationSearchScreenState
    extends ConsumerState<DestinationSearchScreen> {
  final _destinationController = TextEditingController(text: 'Hội An');
  bool _showRecentSearch = true;

  @override
  void initState() {
    super.initState();
    _destinationController.text = ref
        .read(bookingDraftProvider)
        .destinationName;
  }

  void selectDestination(String name) {
    final draft = ref.read(bookingDraftProvider);
    if (name == 'Đà Nẵng') {
      draft.destinationSlug = 'da-nang';
    } else if (name == 'Đà Lạt') {
      draft.destinationSlug = 'da-lat';
    } else {
      draft.destinationSlug = 'hoi-an';
    }
    _destinationController.text = name;
    setState(() {});
  }

  Future<void> openPicker(String path) async {
    await context.push(path);
    if (mounted) setState(() {});
  }

  void search() {
    final name = _destinationController.text.trim().toLowerCase();
    if (name.contains('hội an') || name.contains('hoi an')) {
      ref.read(bookingDraftProvider).destinationSlug = 'hoi-an';
    } else if (name.contains('đà nẵng') || name.contains('da nang')) {
      ref.read(bookingDraftProvider).destinationSlug = 'da-nang';
    } else if (name.contains('đà lạt') ||
        name.contains('da lat') ||
        name.contains('dalat')) {
      ref.read(bookingDraftProvider).destinationSlug = 'da-lat';
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn điểm đến: Hội An, Đà Nẵng hoặc Đà Lạt.'),
        ),
      );
      return;
    }
    context.push('/search/results');
  }

  @override
  void dispose() {
    _destinationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: StayNestColors.canvas,
    bottomNavigationBar: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => openPicker('/search/dates'),
                      icon: const Icon(Icons.calendar_month_outlined),
                      label: Text(
                        '${ref.read(bookingDraftProvider).checkIn.day}/${ref.read(bookingDraftProvider).checkIn.month}–${ref.read(bookingDraftProvider).checkOut.day}/${ref.read(bookingDraftProvider).checkOut.month}',
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => openPicker('/search/guests'),
                      icon: const Icon(Icons.people_outline),
                      label: Text(
                        '${ref.read(bookingDraftProvider).adults} khách · ${ref.read(bookingDraftProvider).roomCount} phòng',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: search,
                  child: const Text('Tìm chỗ ở'),
                ),
              ),
            ],
          ),
        ),
        const StayNestBottomNavigation(selectedIndex: 1),
      ],
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            const FigmaStatusBar(),
            SizedBox(
              height: 48,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => context.go('/'),
                      borderRadius: BorderRadius.circular(24),
                      child: const SizedBox(
                        width: 36,
                        height: 44,
                        child: Center(
                          child: FigmaSvg(
                            'assets/icons/search_09.svg',
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Bạn muốn đi đâu?',
                      style: TextStyle(
                        fontSize: 24,
                        height: 30 / 24,
                        fontWeight: FontWeight.w600,
                        color: StayNestColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Điểm đến',
                      style: TextStyle(
                        fontSize: 12,
                        height: 18 / 12,
                        fontWeight: FontWeight.w500,
                        color: StayNestColors.body,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 52,
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
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          const FigmaSvg(
                            'assets/icons/search_07.svg',
                            width: 16.5,
                            height: 16.5,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _destinationController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isCollapsed: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                height: 20 / 14,
                                fontWeight: FontWeight.w600,
                                color: StayNestColors.ink,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: _destinationController.clear,
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: FigmaSvg(
                                'assets/icons/search_02.svg',
                                width: 10.5,
                                height: 10.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Gợi ý địa điểm',
                            style: TextStyle(
                              fontSize: 16,
                              height: 22 / 16,
                              fontWeight: FontWeight.w600,
                              color: StayNestColors.ink,
                            ),
                          ),
                        ),
                        const FigmaSvg(
                          'assets/icons/search_01.svg',
                          width: 15,
                          height: 15,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Gần bạn',
                          style: TextStyle(
                            fontSize: 12,
                            height: 18 / 12,
                            fontWeight: FontWeight.w500,
                            color: StayNestColors.teal,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: StayNestColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0A172B4D),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          _DestinationSuggestion(
                            icon: 'assets/icons/search_04.svg',
                            title: 'Hội An',
                            subtitle: 'Quảng Nam · Điểm đến di sản',
                            selected: true,
                            onTap: () => selectDestination('Hội An'),
                          ),
                          _DestinationSuggestion(
                            icon: 'assets/icons/search_06.svg',
                            title: 'Đà Nẵng',
                            subtitle: 'Thành phố biển · Điểm đến biển phổ biến',
                            onTap: () => selectDestination('Đà Nẵng'),
                          ),
                          _DestinationSuggestion(
                            icon: 'assets/icons/search_06.svg',
                            title: 'Đà Lạt',
                            subtitle: 'Thành phố sương mù, cao nguyên mát mẻ',
                            onTap: () => selectDestination('Đà Lạt'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Tìm kiếm gần đây',
                            style: TextStyle(
                              fontSize: 16,
                              height: 22 / 16,
                              fontWeight: FontWeight.w600,
                              color: StayNestColors.ink,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () =>
                              setState(() => _showRecentSearch = false),
                          child: const Text(
                            'Xóa lịch sử',
                            style: TextStyle(
                              fontSize: 12,
                              height: 18 / 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF4C5E83),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_showRecentSearch) ...[
                      const SizedBox(height: 12),
                      Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: StayNestColors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0A172B4D),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE1EAFE),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: FigmaSvg(
                                  'assets/icons/search_08.svg',
                                  width: 18,
                                  height: 18,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Hội An',
                                        style: TextStyle(
                                          fontSize: 14,
                                          height: 20 / 14,
                                          fontWeight: FontWeight.w600,
                                          color: StayNestColors.ink,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      _RecentBadge(),
                                    ],
                                  ),
                                  Text(
                                    '14–16/11/2026 · 2 người lớn · 1 phòng',
                                    maxLines: 2,
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
                            InkWell(
                              onTap: () =>
                                  setState(() => _showRecentSearch = false),
                              child: const FigmaSvg(
                                'assets/icons/search_02.svg',
                                width: 10.5,
                                height: 10.5,
                              ),
                            ),
                          ],
                        ),
                      ),
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

class _DestinationSuggestion extends StatelessWidget {
  const _DestinationSuggestion({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.selected = false,
  });
  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      height: 59,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE6EEFF), width: .8)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFFD9F7F5)
                  : const Color(0xFFE6EEFF),
              shape: BoxShape.circle,
            ),
            child: Center(child: FigmaSvg(icon, width: 16.667, height: 16.667)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 20 / 14,
                    fontWeight: FontWeight.w600,
                    color: StayNestColors.ink,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
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
            'assets/icons/search_05.svg',
            width: 6.167,
            height: 10,
          ),
        ],
      ),
    ),
  );
}

class _RecentBadge extends StatelessWidget {
  const _RecentBadge();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: const Color(0xFFE1EAFE),
      borderRadius: BorderRadius.circular(9999),
    ),
    child: const Text(
      'Lưu gần nhất',
      style: TextStyle(fontSize: 10, height: 14 / 10, color: Color(0xFF4C5E83)),
    ),
  );
}
