import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/bottom_navigation.dart';
import '../widgets/figma_asset.dart';
import '../widgets/figma_status_bar.dart';

class SearchLoadingScreen extends StatelessWidget {
  const SearchLoadingScreen({super.key});

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
                    'assets/icons/loading_results_01.svg',
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
                        _LoadingPill(),
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
                  'assets/icons/loading_results_02.svg',
                  width: 16,
                  height: 16,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 11),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Color(0xFFE4E7EC))),
          ),
          child: Row(
            children: [
              const _LoadingToolbar(
                label: 'Lọc (3)',
                icon: 'loading_results_03.svg',
              ),
              const SizedBox(width: 8),
              const _LoadingToolbar(
                label: 'Sắp xếp',
                icon: 'loading_results_04.svg',
              ),
              const SizedBox(width: 8),
              const _LoadingToolbar(
                label: 'Bản đồ',
                icon: 'loading_results_05.svg',
              ),
            ],
          ),
        ),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          color: Colors.white,
          child: const Row(
            children: [
              FigmaSvg(
                'assets/icons/loading_results_06.svg',
                width: 16,
                height: 16,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Đang tìm chỗ ở phù hợp…',
                  style: TextStyle(
                    color: Color(0xFF344054),
                    fontSize: 13,
                    height: 19.5 / 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                'Vui lòng đợi giây lát',
                style: TextStyle(
                  color: Color(0xFF98A2B3),
                  fontSize: 12,
                  height: 18 / 12,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
            children: const [
              _SkeletonCard(
                titleWidth: 120,
                locationWidth: 86,
                priceWidth: 80,
                chipWidths: [48, 48],
              ),
              SizedBox(height: 12),
              _SkeletonCard(
                titleWidth: 112,
                locationWidth: 78,
                priceWidth: 96,
                chipWidths: [56, 48],
              ),
              SizedBox(height: 12),
              _SkeletonCard(
                titleWidth: 126,
                locationWidth: 86,
                priceWidth: 80,
                chipWidths: [48, 64],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _LoadingPill extends StatelessWidget {
  const _LoadingPill();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: const Color(0xFFEAF7F6),
      borderRadius: BorderRadius.circular(99),
    ),
    child: const Text(
      'Đang tải',
      style: TextStyle(
        color: Color(0xFF0F8B8D),
        fontSize: 11,
        height: 16.5 / 11,
        fontWeight: FontWeight.w600,
      ),
    ),
  );
}

class _LoadingToolbar extends StatelessWidget {
  const _LoadingToolbar({required this.label, required this.icon});
  final String label, icon;
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FC),
        border: Border.all(color: const Color(0xFFE4E7EC)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FigmaSvg('assets/icons/$icon', width: 14, height: 14),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF667085),
              fontSize: 12,
              height: 18 / 12,
            ),
          ),
        ],
      ),
    ),
  );
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({
    required this.titleWidth,
    required this.locationWidth,
    required this.priceWidth,
    required this.chipWidths,
  });
  final double titleWidth, locationWidth, priceWidth;
  final List<double> chipWidths;
  @override
  Widget build(BuildContext context) => Container(
    height: 124,
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: const Color(0xFFE4E7EC)),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E8F0),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: titleWidth,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: locationWidth,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: chipWidths
                        .map(
                          (w) => Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Container(
                              width: w,
                              height: 20,
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF7F6),
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: priceWidth,
                    height: 16,
                    decoration: BoxDecoration(
                      color: const Color(0xFFCBD5E1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 12,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(4),
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
