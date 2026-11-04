import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/figma_asset.dart';

class RoomDetailScreen extends StatelessWidget {
  const RoomDetailScreen({super.key});
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  static const teal = Color(0xFF006768);

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F9FC),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
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
                        : context.go('/properties/may-homestay/rooms'),
                    icon: const Icon(Icons.arrow_back, size: 20),
                  ),
                  const Expanded(
                    child: Text(
                      'Homestay Detail',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                  ),
                  const Icon(Icons.share_outlined, size: 18, color: muted),
                  const SizedBox(width: 12),
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
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          FigmaRaster(
                            'assets/images/room_studio_detail_050.jpg',
                            width: 350,
                            height: 178,
                          ),
                          Positioned(
                            right: 12,
                            top: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xAA182230),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '▣  1/5',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const Positioned(
                            bottom: 9,
                            left: 145,
                            child: Text(
                              '● ● ● ● ●',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _card(
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(child: _fact(1, 'Diện tích', '28 m²')),
                              Expanded(
                                child: _fact(2, 'Sức chứa', '2 người lớn'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _fact(
                                  3,
                                  'Giường ngủ',
                                  '1 Queen (đôi lớn)',
                                ),
                              ),
                              Expanded(
                                child: _fact(4, 'Tầm nhìn', 'Ngõ yên tĩnh'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                'Tiện nghi phòng nổi bật',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: ink,
                                ),
                              ),
                              Spacer(),
                              Text(
                                'Đặc quyền',
                                style: TextStyle(fontSize: 11, color: teal),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _featureRow(
                            'Bếp riêng đầy đủ\ngia vị & bếp từ',
                            'Tủ lạnh mini dung\ntích 90L',
                            6,
                            7,
                          ),
                          const SizedBox(height: 8),
                          _featureRow(
                            'Điều hòa 2 chiều\nInverter êm ái',
                            'Wi-Fi tốc độ cao\n100 Mbps',
                            8,
                            9,
                          ),
                          const SizedBox(height: 8),
                          _featureRow(
                            'Bàn làm việc đan\nmây tre mộc',
                            'Máy sấy tóc & bàn\nlà hơi nước',
                            10,
                            11,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.schedule, color: teal, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Quy định giờ giấc & nhận phòng',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: ink,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F9FC),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nhận phòng:  từ 14:00  •  Trả phòng:  trước 12:00',
                                  style: TextStyle(fontSize: 11, color: muted),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Hỗ trợ tự nhận phòng với khóa thông minh (Smart Lock) và hỗ trợ gửi hành lý miễn phí tại sảnh lễ tân.',
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
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                color: Color(0xFF00B879),
                                size: 19,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Hủy miễn phí trước 18:00 ngày 12/11/2026 (hoàn 100%)',
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.5,
                                    color: ink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Padding(
                            padding: EdgeInsets.only(left: 27),
                            child: Text(
                              'Sau thời gian này, phí hủy là 50% tổng giá trị đặt phòng.',
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.5,
                                color: muted,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          InkWell(
                            onTap: () => context.push(
                              '/properties/may-homestay/policies',
                            ),
                            child: const Text(
                              'Xem chính sách hủy chi tiết  →',
                              style: TextStyle(
                                fontSize: 12,
                                color: teal,
                                fontWeight: FontWeight.w600,
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              color: Colors.white,
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '850.000đ / đêm',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: teal,
                          ),
                        ),
                        Text(
                          'Tổng 2 đêm: 1.700.000đ',
                          style: TextStyle(fontSize: 10, color: muted),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 144,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => context.push('/booking/summary'),
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: teal,
                        disabledForegroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Chọn phòng này',
                        style: TextStyle(fontSize: 12),
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

  Widget _card(Widget child) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: child,
  );
  Widget _fact(int index, String label, String value) => Row(
    children: [
      Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF7F6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FigmaSvg(
          'assets/icons/room_050_${index.toString().padLeft(2, '0')}.svg',
          width: switch (index) {
            1 => 11.667,
            2 || 4 => 16.667,
            _ => 18.333,
          },
          height: switch (index) {
            1 => 11.667,
            2 || 3 => 13.333,
            _ => 11.667,
          },
        ),
      ),
      const SizedBox(width: 8),
      Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10, color: muted)),
            Text(
              value,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: ink,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ],
  );
  Widget _featureRow(String a, String b, int ai, int bi) => Row(
    children: [
      Expanded(child: _feature(a, ai)),
      const SizedBox(width: 8),
      Expanded(child: _feature(b, bi)),
    ],
  );
  Widget _feature(String value, int index) => Container(
    height: 43,
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: const Color(0xFFF7F9FC),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      children: [
        FigmaSvg(
          'assets/icons/room_050_${index.toString().padLeft(2, '0')}.svg',
          width: switch (index) {
            6 => 17.75,
            7 => 13.333,
            9 => 20,
            _ => 16.667,
          },
          height: switch (index) {
            6 || 9 => 16.167,
            7 || 8 => 18.667,
            _ => 12,
          },
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 10, height: 1.25, color: ink),
          ),
        ),
      ],
    ),
  );
}
