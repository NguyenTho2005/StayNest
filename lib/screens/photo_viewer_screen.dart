import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/figma_asset.dart';

class PhotoViewerScreen extends StatefulWidget {
  const PhotoViewerScreen({super.key, required this.initialIndex});
  final int initialIndex;
  @override
  State<PhotoViewerScreen> createState() => _PhotoViewerScreenState();
}

class _PhotoViewerScreenState extends State<PhotoViewerScreen> {
  late int index = widget.initialIndex.clamp(1, 7);
  static const images = [
    'gallery_01.jpg',
    'photo_viewer_01.jpg',
    'gallery_03.jpg',
    'gallery_04.jpg',
    'gallery_05.jpg',
    'gallery_06.jpg',
    'gallery_07.jpg',
  ];
  static const captions = [
    'Không gian ngoài trời & ban công',
    'Phòng ngủ Studio – Giường Queen & đèn mây tre thủ công',
    'Khu bếp riêng tiện nghi',
    'Gạch bông & bàn trà',
    'Sân vườn nhiệt đới',
    'Góc đọc sách yên tĩnh',
    'Phòng tắm riêng biệt',
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFF0A111E),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onHorizontalDragEnd: (details) {
                  final velocity = details.primaryVelocity ?? 0;
                  if (velocity < -100 && index < images.length) {
                    setState(() => index++);
                  }
                  if (velocity > 100 && index > 1) setState(() => index--);
                },
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: InteractiveViewer(
                      minScale: 1,
                      maxScale: 4,
                      child: FigmaRaster(
                        'assets/images/${images[index - 1]}',
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 20,
              right: 20,
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => context.canPop()
                          ? context.pop()
                          : context.go('/properties/may-homestay/gallery'),
                      child: const _ViewerAction(
                        'photo_viewer_02.svg',
                        12.833,
                        12.833,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 7,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x4D000000),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '$index/8',
                        style: const TextStyle(
                          fontSize: 12,
                          letterSpacing: 0.6,
                          color: Color(0xE6FFFFFF),
                        ),
                      ),
                    ),
                    const Spacer(),
                    const _ViewerAction('photo_viewer_03.svg', 13.333, 13.333),
                    const SizedBox(width: 8),
                    const _ViewerAction('photo_viewer_04.svg', 15, 16.667),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x000A111E),
                      Color(0xCC0A111E),
                      Color(0xFF0A111E),
                    ],
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      captions[index - 1],
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 24 / 16,
                        letterSpacing: -0.4,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FigmaSvg(
                          'assets/icons/photo_viewer_05.svg',
                          width: 12.833,
                          height: 12.833,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Chụm/mở để phóng to • Vuốt để chuyển ảnh',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF98A2B3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        8,
                        (dot) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Container(
                            width: dot == index - 1 ? 24 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: dot == index - 1
                                  ? Colors.white
                                  : const Color(0x4DFFFFFF),
                              borderRadius: BorderRadius.circular(999),
                            ),
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
      ),
    ),
  );
}

class _ViewerAction extends StatelessWidget {
  const _ViewerAction(this.icon, this.width, this.height);
  final String icon;
  final double width, height;
  @override
  Widget build(BuildContext context) => Container(
    width: 40,
    height: 40,
    decoration: const BoxDecoration(
      color: Color(0x66000000),
      shape: BoxShape.circle,
    ),
    child: Center(
      child: FigmaSvg('assets/icons/$icon', width: width, height: height),
    ),
  );
}
