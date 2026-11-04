import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/bottom_navigation.dart';
import '../widgets/figma_asset.dart';

class PostPaymentGuideScreen extends StatefulWidget {
  const PostPaymentGuideScreen({super.key});
  @override
  State<PostPaymentGuideScreen> createState() => _PostPaymentGuideScreenState();
}

class _PostPaymentGuideScreenState extends State<PostPaymentGuideScreen> {
  static const teal = Color(0xFF006768);
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  final checks = <int>{0, 1};

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F9FC),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            Container(
              height: 68,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chuyến đi',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ink,
                    ),
                  ),
                  Icon(Icons.notifications_none, size: 18),
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: teal,
                    child: Icon(
                      Icons.person_outline,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 48,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => context.go('/trips'),
                    child: const Icon(Icons.arrow_back, size: 20),
                  ),
                  const Spacer(),
                  const Text(
                    'Chuyến đi trước',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ink,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 20),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: teal,
                            child: Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '● Thanh toán hoàn tất',
                                  style: TextStyle(fontSize: 11, color: teal),
                                ),
                                Text(
                                  'Mọi thứ đã sẵn sàng cho kỳ nghỉ của bạn!',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: ink,
                                  ),
                                ),
                                Text(
                                  'StayNest đồng hành để bạn có kỳ lưu trú trọn vẹn và an tâm nhất.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 1.4,
                                    color: muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: _box(),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              const FigmaRaster(
                                'assets/images/scr_076_00.jpg',
                                width: double.infinity,
                                height: 148,
                              ),
                              Positioned(
                                bottom: 10,
                                left: 12,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'MÃ ĐẶT PHÒNG: SN-1024',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Text(
                                      'Mây Homestay',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Text(
                                  '▣ Phòng Studio có bếp',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: ink,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _gray(
                                        'Thời gian lưu trú',
                                        '14–16/11/2026',
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: _gray(
                                        'Khách & Phòng',
                                        '2 người lớn · 1 phòng',
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
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _box(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Lịch nhận & trả phòng',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ink,
                                ),
                              ),
                              Text(
                                '◷ 2 đêm',
                                style: TextStyle(fontSize: 11, color: teal),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _gray('Nhận phòng', '14:00\n14/11/2026'),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _gray('Trả phòng', '12:00\n16/11/2026'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _box(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Chuẩn bị cho chuyến đi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: ink,
                            ),
                          ),
                          const Text(
                            'Checklist hành trang giúp bạn check-in nhanh',
                            style: TextStyle(fontSize: 12, color: muted),
                          ),
                          const SizedBox(height: 10),
                          _check(
                            0,
                            'Chuẩn bị giấy tờ tùy thân (CCCD/Hộ chiếu)',
                          ),
                          _check(1, 'Kiểm tra lại ngày nhận và trả phòng'),
                          _check(2, 'Lưu thông tin đặt phòng để tiện tra cứu'),
                          _check(
                            3,
                            'Liên hệ chỗ ở nếu cần xác nhận yêu cầu đặc biệt',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _box(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Vị trí chỗ ở',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: ink,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 122,
                            decoration: BoxDecoration(
                              color: const Color(0xFFC8C9D7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: teal,
                                child: Icon(
                                  Icons.location_on,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '⌖ Hội An, Quảng Nam',
                                style: TextStyle(fontSize: 12, color: ink),
                              ),
                              Text(
                                'Xem trên bản đồ ›',
                                style: TextStyle(fontSize: 11, color: teal),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _box(),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Liên hệ chỗ ở',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: ink,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.phone_outlined, color: teal, size: 18),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'HOTLINE CHỖ Ở\n0900 000 000 · DEMO',
                                  style: TextStyle(fontSize: 12, color: ink),
                                ),
                              ),
                              Text(
                                'Gọi ngay',
                                style: TextStyle(fontSize: 12, color: teal),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Thông tin liên hệ minh họa trong prototype. Đây là số hotline demo của homestay.',
                            style: TextStyle(fontSize: 11, color: muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4F4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Hãy kiểm tra thông tin đặt phòng trước ngày khởi hành. Các thông tin liên hệ và tiện ích trên màn hình này là dữ liệu minh họa.',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.5,
                          color: muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => context.push('/trips'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('▣ Xem đặt phòng'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        'ⓘ Trợ giúp & Hỗ trợ',
                        style: TextStyle(fontSize: 12, color: teal),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const StayNestBottomNavigation(selectedIndex: 3),
          ],
        ),
      ),
    ),
  );

  BoxDecoration _box() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(color: Color(0x0D000000), blurRadius: 3, offset: Offset(0, 1)),
    ],
  );
  Widget _gray(String label, String value) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFFF0F4F4),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: muted)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: ink,
          ),
        ),
      ],
    ),
  );
  Widget _check(int index, String text) => InkWell(
    onTap: () => setState(
      () => checks.contains(index) ? checks.remove(index) : checks.add(index),
    ),
    child: Container(
      margin: const EdgeInsets.only(top: 6),
      padding: const EdgeInsets.all(8),
      color: const Color(0xFFF7F9FC),
      child: Row(
        children: [
          Icon(
            checks.contains(index)
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            size: 20,
            color: checks.contains(index) ? teal : muted,
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 12, color: ink)),
          ),
        ],
      ),
    ),
  );
}
