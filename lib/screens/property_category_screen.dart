import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design/tokens.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/figma_asset.dart';

class PropertyCategoryScreen extends StatelessWidget {
  const PropertyCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: StayNestColors.canvas,
    bottomNavigationBar: const StayNestBottomNavigation(selectedIndex: 0),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go('/destinations'),
                    child: const SizedBox(
                      width: 44,
                      height: 44,
                      child: Center(
                        child: FigmaSvg(
                          'assets/icons/property_category_01.svg',
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Loại hình lưu trú',
                    style: TextStyle(
                      fontSize: 20,
                      height: 26 / 20,
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.w600,
                      color: StayNestColors.ink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Padding(
                padding: EdgeInsets.only(left: 2),
                child: Text(
                  'Chọn không gian phù hợp với chuyến đi của bạn',
                  style: TextStyle(
                    fontSize: 14,
                    height: 22 / 14,
                    color: Color(0xFF4C5E83),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _CategoryCard(
                      image: 'property_category_1.jpg',
                      icon: 'property_category_02.svg',
                      iconSize: const Size(13.333, 10.667),
                      title: 'Homestay',
                      description: 'Không gian gần gũi, đậm nét địa phương',
                      onTap: () => context.go('/search/results'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CategoryCard(
                      image: 'property_category_2.jpg',
                      icon: 'property_category_04.svg',
                      iconSize: const Size(12, 12),
                      title: 'Khách sạn',
                      description: 'Lưu trú tiện nghi cho nhiều nhu cầu',
                      onTap: () => context.go('/destinations/da-nang/hotels'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _CategoryCard(
                      image: 'property_category_3.jpg',
                      icon: 'property_category_05.svg',
                      iconSize: const Size(10.667, 13.333),
                      title: 'Căn hộ',
                      description: 'Không gian riêng cho kỳ nghỉ linh hoạt',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _CategoryCard(
                      image: 'property_category_4.jpg',
                      icon: 'property_category_06.svg',
                      iconSize: const Size(13.333, 12),
                      title: 'Resort',
                      description: 'Nghỉ dưỡng trong không gian thư thái',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.image,
    required this.icon,
    required this.iconSize,
    required this.title,
    required this.description,
    this.onTap,
  });
  final String image, icon, title, description;
  final Size iconSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0F172B4D),
          blurRadius: 16,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  FigmaRaster(
                    'assets/images/$image',
                    width: double.infinity,
                    height: 108.75,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xCCFFFFFF),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: FigmaSvg(
                          'assets/icons/$icon',
                          width: iconSize.width,
                          height: iconSize.height,
                        ),
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
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                      color: StayNestColors.ink,
                    ),
                  ),
                ),
                const FigmaSvg(
                  'assets/icons/property_category_03.svg',
                  width: 4.933,
                  height: 8,
                ),
              ],
            ),
            const SizedBox(height: 2),
            SizedBox(
              height: 30,
              child: Text(
                description,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 12,
                  height: 15 / 12,
                  color: Color(0xFF4C5E83),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
