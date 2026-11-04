import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/figma_asset.dart';

class ComparePriceScreen extends StatelessWidget {
  const ComparePriceScreen({super.key});
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
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go('/favorites/compare'),
                    icon: const Icon(Icons.arrow_back, size: 19),
                  ),
                  const Expanded(
                    child: Text(
                      'So Sánh Chi Tiết Giá Phòng',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 15,
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
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _card(
                      const Row(
                        children: [
                          FigmaSvg(
                            'assets/icons/compare_price_058_01.svg',
                            width: 15,
                            height: 16.667,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Chuyến đi Hội An • Tạm tính 2 đêm',
                                  style: TextStyle(fontSize: 11, color: teal),
                                ),
                                Text(
                                  '14/11 – 16/11/2026 • 2 khách, 1 phòng',
                                  style: TextStyle(fontSize: 12, color: ink),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            children: [
                              Text(
                                '♧ Tiết kiệm 260.000đ',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF00A86B),
                                ),
                              ),
                              Spacer(),
                              Text(
                                'Lựa chọn tối ưu',
                                style: TextStyle(fontSize: 10, color: muted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _hotel(
                            'assets/images/compare_price_058_01.jpg',
                            'Mây Homestay',
                            'Phòng Studio có bếp riêng',
                            '1.700.000đ',
                            '850.000đ × 2 đêm',
                            teal,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF7F6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '♧  Miễn phí mượn xe đạp dạo phố cổ',
                                  style: TextStyle(fontSize: 11, color: ink),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '♧  Trà & cà phê địa phương tự pha tại phòng',
                                  style: TextStyle(fontSize: 11, color: ink),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  '◉  Wi-Fi tốc độ cao 100Mbps',
                                  style: TextStyle(fontSize: 11, color: ink),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '* Chưa bao gồm thuế VAT & phí dịch vụ sàn StayNest',
                            style: TextStyle(
                              fontSize: 10,
                              fontStyle: FontStyle.italic,
                              color: muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            children: [
                              Text(
                                'Lựa chọn thay thế',
                                style: TextStyle(fontSize: 10, color: muted),
                              ),
                              Spacer(),
                              Text(
                                '+260.000đ',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFFFF9C27),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _hotel(
                            'assets/images/compare_price_058_02.jpg',
                            'An Villa',
                            'Phòng Deluxe Sân Vườn',
                            '1.960.000đ',
                            '980.000đ × 2 đêm',
                            ink,
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF0FE),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '♧  Bao gồm bữa sáng nhẹ món Việt',
                                  style: TextStyle(fontSize: 11, color: ink),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '♧  Sử dụng hồ bơi chung sân vườn',
                                  style: TextStyle(fontSize: 11, color: ink),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Chênh lệch cao hơn +260.000đ so với Mây Homestay',
                            style: TextStyle(fontSize: 10, color: muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Row(
                      children: [
                        Text(
                          'So sánh quyền lợi cốt lõi',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ink,
                          ),
                        ),
                        Spacer(),
                        Text(
                          'Bảng tóm tắt',
                          style: TextStyle(fontSize: 10, color: teal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Table(
                        columnWidths: const {
                          0: FlexColumnWidth(1.1),
                          1: FlexColumnWidth(1.1),
                          2: FlexColumnWidth(1),
                        },
                        children: [
                          _row(
                            'Tiêu chí',
                            'Mây Homestay',
                            'An Villa',
                            const Color(0xFFEAF0FE),
                            true,
                          ),
                          _row(
                            'Giá mỗi đêm',
                            '850.000đ',
                            '980.000đ',
                            Colors.white,
                            false,
                          ),
                          _row(
                            'Bếp nấu ăn',
                            'Bếp riêng phòng',
                            'Bếp chung vườn',
                            const Color(0xFFF7F9FC),
                            false,
                          ),
                          _row(
                            'Đặc quyền',
                            'Xe đạp phố cổ',
                            'Hồ bơi ngoài trời',
                            Colors.white,
                            false,
                          ),
                          _row(
                            'Đánh giá khách',
                            '⭐ 4.9 (128)',
                            '⭐ 4.7 (94)',
                            const Color(0xFFF7F9FC),
                            false,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'ⓘ  Mức giá so sánh tính trên giá phòng gốc trước khi áp dụng mã giảm giá và thuế phí tại bước thanh toán.',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.5,
                          color: teal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => context.go('/properties/may-homestay/rooms'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Chọn Mây Homestay (Tiết kiệm hơn)  →',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _card(Widget child) => Container(
    padding: const EdgeInsets.all(11),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );
  Widget _hotel(
    String image,
    String name,
    String subtitle,
    String price,
    String calculation,
    Color priceColor,
  ) => Row(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: FigmaRaster(image, width: 72, height: 72),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ink,
              ),
            ),
            Text(subtitle, style: const TextStyle(fontSize: 10, color: muted)),
            const SizedBox(height: 7),
            Text(
              '$price / 2 đêm',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: priceColor,
              ),
            ),
            Text(
              calculation,
              style: const TextStyle(fontSize: 10, color: muted),
            ),
          ],
        ),
      ),
    ],
  );
  TableRow _row(
    String first,
    String second,
    String third,
    Color color,
    bool heading,
  ) => TableRow(
    decoration: BoxDecoration(color: color),
    children: [
      for (final item in [first, second, third])
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 12),
          child: Text(
            item,
            style: TextStyle(
              fontSize: heading ? 10 : 11,
              color: heading ? teal : ink,
              fontWeight: heading ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
    ],
  );
}
