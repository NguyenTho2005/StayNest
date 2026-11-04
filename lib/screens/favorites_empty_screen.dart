import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/bottom_navigation.dart';
import '../widgets/figma_asset.dart';

class FavoritesEmptyScreen extends StatelessWidget {
  const FavoritesEmptyScreen({super.key});
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  static const teal = Color(0xFF006768);

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F9FC),
    bottomNavigationBar: const StayNestBottomNavigation(selectedIndex: 2),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            Container(
              height: 56,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Yêu Thích',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                  ),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: teal,
                    child: Icon(
                      Icons.person_outline,
                      size: 17,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 0, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          Text(
                            'Bộ sưu tập cá nhân · ',
                            style: TextStyle(fontSize: 12, color: muted),
                          ),
                          Text(
                            '0 địa điểm',
                            style: TextStyle(fontSize: 12, color: teal),
                          ),
                          Spacer(),
                          Text(
                            'ⓘ Trợ giúp',
                            style: TextStyle(fontSize: 11, color: muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 34),
                    Center(
                      child: Container(
                        width: 114,
                        height: 114,
                        decoration: const BoxDecoration(
                          color: Color(0xFFEAF7F6),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: FigmaSvg(
                            'assets/icons/favorite_empty_055_heart.svg',
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        '🛏 StayNest',
                        style: TextStyle(
                          fontSize: 10,
                          color: ink,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        'Bạn chưa lưu chỗ ở nào',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF8D9AA1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Text(
                        'Chạm vào biểu tượng trái tim trên các homestay hoặc khách sạn bạn yêu thích để dễ dàng xem lại và so sánh giá bất cứ lúc nào.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.6,
                          color: Color(0xFF8290A7),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: () => context.go('/'),
                          icon: const Icon(Icons.explore_outlined, size: 18),
                          label: const Text('Khám phá ngay'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: teal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              '🔥 Gợi ý dành riêng cho bạn',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ink,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => context.go('/recommendations'),
                            child: const Text(
                              'Xem tất cả',
                              style: TextStyle(fontSize: 11, color: teal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 176,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _recommendation(
                            'assets/images/favorite_empty_055_01.jpg',
                            'Đà Lạt',
                            'Thung Lũng Thông Cabin',
                            '680.000đ',
                            '4.92',
                          ),
                          _recommendation(
                            'assets/images/favorite_empty_055_02.jpg',
                            'Hội An',
                            'An Bang Sanctuary Villa',
                            '1.150.000đ',
                            '4.88',
                          ),
                          _recommendation(
                            'assets/images/favorite_empty_055_03.jpg',
                            'Phú Quốc',
                            'Mây Beachside Ecolodge',
                            '1.420.000đ',
                            '4.95',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: const Border(
                            left: BorderSide(color: teal, width: 3),
                          ),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.compare_arrows, color: teal, size: 22),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mẹo so sánh thông minh',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: ink,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Lưu từ 2 chỗ ở trở lên để tự động mở khóa bảng so sánh trực quan theo mức giá, vị trí và tiện nghi đi kèm.',
                                    style: TextStyle(
                                      fontSize: 11,
                                      height: 1.5,
                                      color: muted,
                                    ),
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
            ),
          ],
        ),
      ),
    ),
  );

  Widget _recommendation(
    String image,
    String place,
    String title,
    String price,
    String rating,
  ) => Container(
    width: 220,
    margin: const EdgeInsets.only(right: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Stack(
            children: [
              FigmaRaster(image, width: 220, height: 112),
              Positioned(
                left: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xBB182230),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    place,
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: ink),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
          child: Row(
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: teal,
                ),
              ),
              const Text('/đêm', style: TextStyle(fontSize: 9, color: muted)),
              const Spacer(),
              Text(
                '⭐$rating',
                style: const TextStyle(fontSize: 9, color: muted),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
