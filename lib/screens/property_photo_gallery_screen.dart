import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design/tokens.dart';
import '../widgets/figma_asset.dart';

class PropertyPhotoGalleryScreen extends StatefulWidget {
  const PropertyPhotoGalleryScreen({super.key});

  @override
  State<PropertyPhotoGalleryScreen> createState() =>
      _PropertyPhotoGalleryScreenState();
}

class _PropertyPhotoGalleryScreenState
    extends State<PropertyPhotoGalleryScreen> {
  String selectedCategory = 'Tất cả';
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  static const background = Color(0xFFF7F9FC);
  static const cards = [
    (
      'gallery_02.jpg',
      'Phòng ngủ',
      'Phòng ngủ Studio King',
      'Giường nệm linen, đèn mây tre',
    ),
    (
      'gallery_03.jpg',
      'Bếp riêng',
      'Khu bếp riêng tiện nghi',
      'Bếp từ, kệ gỗ & ấm trà gốm',
    ),
    (
      'gallery_04.jpg',
      'Góc chi tiết',
      'Gạch bông & bàn trà',
      'Họa tiết thủ công bản địa',
    ),
    (
      'gallery_05.jpg',
      'Sân vườn',
      'Sân vườn nhiệt đới',
      'Xanh mát ngập nắng chiều',
    ),
    (
      'gallery_06.jpg',
      'Phòng ngủ',
      'Góc đọc sách yên tĩnh',
      'Đôn cói & đệm ngồi thảnh thơi',
    ),
    (
      'gallery_07.jpg',
      'Phòng tắm',
      'Phòng tắm riêng biệt',
      'Gạch gốm mộc & vòi đồng',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final visible = selectedCategory == 'Tất cả'
        ? cards.asMap().entries.toList()
        : cards
              .asMap()
              .entries
              .where((entry) => entry.value.$2 == selectedCategory)
              .toList();
    return Scaffold(
      backgroundColor: background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390),
          child: Column(
            children: [
              Container(
                height: 56,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 8,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => context.canPop()
                          ? context.pop()
                          : context.go('/properties/may-homestay'),
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: Center(
                          child: FigmaSvg(
                            'assets/icons/gallery_16.svg',
                            width: 16,
                            height: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Expanded(
                      child: Text(
                        'Bộ Sưu Tập Ảnh Mây Homestay',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: StayNestColors.ink,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 44,
                      height: 44,
                      child: Center(
                        child: FigmaSvg(
                          'assets/icons/gallery_17.svg',
                          width: 15,
                          height: 16.667,
                        ),
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: StayNestColors.teal,
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: FigmaSvg(
                          'assets/icons/gallery_18.svg',
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                      child: Row(
                        children: [
                          const FigmaSvg(
                            'assets/icons/gallery_08.svg',
                            width: 15,
                            height: 15,
                          ),
                          const SizedBox(width: 4),
                          const Expanded(
                            child: Text(
                              'An Nhiên Villa • Hội An',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: ink,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              '1/8 ảnh',
                              style: TextStyle(fontSize: 12, color: muted),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 44,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        children:
                            const [
                                  ('Tất cả', '8'),
                                  ('Phòng ngủ', '2'),
                                  ('Bếp riêng', '2'),
                                  ('Phòng tắm', '1'),
                                  ('Không gian chung', '3'),
                                ]
                                .map((entry) => entry)
                                .toList()
                                .map((entry) => _chip(entry.$1, entry.$2))
                                .toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => context.push(
                              '/properties/may-homestay/gallery/photo/1',
                            ),
                            borderRadius: BorderRadius.circular(16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: [
                                  const FigmaRaster(
                                    'assets/images/gallery_01.jpg',
                                    width: double.infinity,
                                    height: 205.88,
                                  ),
                                  Positioned.fill(
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            const Color(0x1A000000),
                                            Colors.transparent,
                                            const Color(0xB3121C2A),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xE6FFFFFF),
                                        borderRadius: BorderRadius.circular(
                                          999,
                                        ),
                                      ),
                                      child: const Row(
                                        children: [
                                          FigmaSvg(
                                            'assets/icons/gallery_09.svg',
                                            width: 13.333,
                                            height: 12.667,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Nổi bật',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: ink,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 12,
                                    left: 12,
                                    right: 12,
                                    child: Row(
                                      children: [
                                        const FigmaSvg(
                                          'assets/icons/gallery_10.svg',
                                          width: 15,
                                          height: 15,
                                        ),
                                        const SizedBox(width: 8),
                                        const Expanded(
                                          child: Text(
                                            'Không gian ngoài trời & ban công',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: const BoxDecoration(
                                            color: Color(0xCCFFFFFF),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Center(
                                            child: FigmaSvg(
                                              'assets/icons/gallery_11.svg',
                                              width: 13.5,
                                              height: 13.5,
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
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () => context.push(
                              '/properties/may-homestay/gallery/photo/2',
                            ),
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEFF3FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                children: [
                                  FigmaSvg(
                                    'assets/icons/gallery_12.svg',
                                    width: 12.994,
                                    height: 15.75,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Chạm vào ảnh để mở trình xem toàn màn hình (SCR-043)',
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 18 / 12,
                                        fontWeight: FontWeight.w500,
                                        color: StayNestColors.body,
                                      ),
                                    ),
                                  ),
                                  FigmaSvg(
                                    'assets/icons/gallery_13.svg',
                                    width: 5.55,
                                    height: 9,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          for (
                            int row = 0;
                            row < (visible.length + 1) ~/ 2;
                            row++
                          ) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _photo(
                                    visible[row * 2].key,
                                    visible[row * 2].value,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: row * 2 + 1 < visible.length
                                      ? _photo(
                                          visible[row * 2 + 1].key,
                                          visible[row * 2 + 1].value,
                                        )
                                      : const SizedBox(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FigmaSvg(
                                  'assets/icons/gallery_15.svg',
                                  width: 18,
                                  height: 18,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hình ảnh xác thực bởi StayNest',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: ink,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Toàn bộ 8 ảnh được chụp thực tế tại An Nhiên Villa, cam kết đúng 100% không gian khi nhận phòng.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          height: 18 / 12,
                                          color: muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                        ],
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
  }

  Widget _chip(String label, String count) {
    final active = selectedCategory == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => selectedCategory = label),
        borderRadius: BorderRadius.circular(999),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: active ? StayNestColors.teal : Colors.white,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: active ? Colors.white : muted,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0x33FFFFFF)
                      : const Color(0xFFEFF3FF),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  count,
                  style: TextStyle(
                    fontSize: 11,
                    color: active ? Colors.white : muted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _photo(int index, (String, String, String, String) card) => InkWell(
    onTap: () =>
        context.push('/properties/may-homestay/gallery/photo/${index + 2}'),
    borderRadius: BorderRadius.circular(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              FigmaRaster(
                'assets/images/${card.$1}',
                width: double.infinity,
                height: 132.75,
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    color: Color(0xCCFFFFFF),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: FigmaSvg(
                      'assets/icons/gallery_14.svg',
                      width: 12,
                      height: 12,
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xE6FFFFFF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    card.$2,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: ink,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            card.$3,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              height: 20 / 14,
              fontWeight: FontWeight.w600,
              color: ink,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            card.$4,
            maxLines: 2,
            style: const TextStyle(fontSize: 12, height: 18 / 12, color: muted),
          ),
        ),
      ],
    ),
  );
}
