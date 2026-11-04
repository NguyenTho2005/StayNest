import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/figma_asset.dart';

class FavoriteSavedScreen extends StatelessWidget {
  const FavoriteSavedScreen({super.key});
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  static const teal = Color(0xFF006768);

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F9FC),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 56,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.canPop()
                            ? context.pop()
                            : context.go('/properties/may-homestay'),
                        icon: const Icon(Icons.arrow_back, size: 21),
                      ),
                      const Expanded(
                        child: Text(
                          'Chi Tiết Phòng Nghỉ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: ink,
                          ),
                        ),
                      ),
                      const CircleAvatar(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          height: 55,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(
                            children: [
                              Text(
                                'Mã phòng:  HN-5024',
                                style: TextStyle(fontSize: 12, color: muted),
                              ),
                              Spacer(),
                              Icon(
                                Icons.share_outlined,
                                size: 20,
                                color: muted,
                              ),
                              SizedBox(width: 25),
                              Icon(Icons.favorite, size: 20, color: teal),
                            ],
                          ),
                        ),
                        const FigmaRaster(
                          'assets/images/favorite_saved_053.jpg',
                          height: 250,
                          width: 390,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'HOMESTAY DI SẢN',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFFF8A65),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Mây Homestay & Nhà Cổ',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: ink,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '★ 4.8',
                                    style: TextStyle(fontSize: 13, color: teal),
                                  ),
                                ],
                              ),
                              const Text(
                                'Phường Cẩm Phô, Hội An, Quảng Nam',
                                style: TextStyle(fontSize: 12, color: muted),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: _feature(
                                      Icons.bed_outlined,
                                      '1 Giường\nKing',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _feature(
                                      Icons.balcony_outlined,
                                      'Ban công\nphố',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _feature(
                                      Icons.wifi,
                                      'Wifi tốc độ\ncao',
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _feature(
                                      Icons.breakfast_dining_outlined,
                                      'Bao ăn sáng',
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
            const Positioned.fill(child: ColoredBox(color: Color(0x64000000))),
            Positioned(
              left: 20,
              right: 20,
              bottom: 24,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundColor: Color(0xFFEAF7F6),
                          child: Icon(Icons.favorite, color: teal, size: 22),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Đã lưu vào yêu thích!',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: ink,
                                ),
                              ),
                              SizedBox(height: 7),
                              Text(
                                'Mây Homestay đã được thêm vào bộ sưu tập chuyến đi sắp tới của bạn.',
                                style: TextStyle(
                                  fontSize: 14,
                                  height: 1.65,
                                  color: muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => context.go('/properties/may-homestay'),
                          child: const Icon(
                            Icons.close,
                            color: muted,
                            size: 19,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F9FC),
                        borderRadius: BorderRadius.circular(9),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.folder_open_outlined,
                            color: teal,
                            size: 17,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Lưu trữ tại: Hội An mộc mạc (Mặc định)',
                            style: TextStyle(fontSize: 11, color: muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: TextButton(
                              onPressed: () =>
                                  context.go('/properties/may-homestay'),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFEAF7F6),
                                foregroundColor: teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Tiếp tục xem'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () => context.go('/favorites'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: teal,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Bộ sưu tập →'),
                            ),
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
      ),
    ),
  );

  Widget _feature(IconData icon, String text) => Container(
    height: 66,
    padding: const EdgeInsets.all(7),
    decoration: BoxDecoration(
      color: const Color(0xFFEAF0FE),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Icon(icon, size: 20, color: teal),
        const SizedBox(height: 4),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 10, color: ink),
        ),
      ],
    ),
  );
}
