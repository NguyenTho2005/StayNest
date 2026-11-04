import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/figma_asset.dart';

class LocationPermissionScreen extends StatelessWidget {
  const LocationPermissionScreen({super.key});
  static const teal = Color(0xFF006768);
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            Container(
              height: 62,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () =>
                        context.canPop() ? context.pop() : context.go('/'),
                    child: const Icon(Icons.arrow_back, color: ink, size: 20),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Quyền Truy Cập Vị Trí',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: ink,
                      ),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: teal,
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F7FB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          const Positioned.fill(
                            child: FigmaSvg(
                              'assets/icons/location_permission_021_04.svg',
                              width: 350,
                              height: 220,
                            ),
                          ),
                          const Center(
                            child: CircleAvatar(
                              radius: 88,
                              backgroundColor: Color(0x66EAF7F6),
                            ),
                          ),
                          const Center(
                            child: CircleAvatar(
                              radius: 64,
                              backgroundColor: Color(0xCCEAF7F6),
                            ),
                          ),
                          const Center(
                            child: CircleAvatar(
                              radius: 28,
                              backgroundColor: teal,
                              child: Icon(
                                Icons.location_on,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          const Positioned(
                            top: 26,
                            right: 18,
                            child: Chip(
                              label: Text(
                                '🛏 Cozy Nest',
                                style: TextStyle(fontSize: 12, color: ink),
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 26,
                            left: 25,
                            child: Chip(
                              label: Text(
                                '⭐ 4.9 • 350m',
                                style: TextStyle(fontSize: 12, color: ink),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Cho phép vị trí để tìm nơi lưu trú gần bạn',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'StayNest sử dụng vị trí của bạn để đề xuất khách sạn, homestay có phòng trống và khoảng cách chính xác nhất.',
                      style: TextStyle(fontSize: 14, height: 1.6, color: muted),
                    ),
                    const SizedBox(height: 22),
                    _benefit(
                      0,
                      'Gợi ý nơi ở gần bạn',
                      'Tìm phòng trống tức thì xung quanh vị trí hiện tại của bạn.',
                    ),
                    _benefit(
                      1,
                      'Tìm kiếm nhanh hơn',
                      'Tiết kiệm thời gian gõ tìm điểm đến khi đang trực tiếp di chuyển.',
                    ),
                    _benefit(
                      2,
                      'Xem khoảng cách thuận tiện',
                      'Biết chính xác khoảng cách thực tới bãi biển, phố cổ hoặc trung tâm.',
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F7FB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'ⓘ Bạn vẫn có thể tìm kiếm thủ công nếu không cấp quyền vị trí.',
                        style: TextStyle(fontSize: 12, color: muted),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: teal,
                        disabledBackgroundColor: teal,
                        disabledForegroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        '◎ Cho phép vị trí',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: TextButton(
                      onPressed: () => context.go('/search'),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFEEF2FD),
                        foregroundColor: ink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Tự chọn điểm đến',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
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
  );

  Widget _benefit(int index, String title, String subtitle) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: const Color(0xFFEAF7F6),
          child: FigmaSvg(
            'assets/icons/location_permission_021_${index.toString().padLeft(2, '0')}.svg',
            width: index == 0 ? 15 : 16.667,
            height: index == 2
                ? 10
                : index == 0
                ? 15
                : 16.667,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ink,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, height: 1.5, color: muted),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
