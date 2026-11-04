import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/figma_asset.dart';

class CompareTableScreen extends StatelessWidget {
  const CompareTableScreen({super.key});
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
              height: 48,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go('/favorites/compare/select'),
                    icon: const Icon(Icons.arrow_back, size: 19),
                  ),
                  const Expanded(
                    child: Text(
                      'Bảng So Sánh Chỗ Ở',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 11,
                    backgroundColor: teal,
                    child: Icon(
                      Icons.person_outline,
                      size: 13,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            '▣ Hội An • 14 - 16/11/2026 (2 đêm, 2 khách)',
                            style: TextStyle(fontSize: 10, color: teal),
                          ),
                        ),
                        Text(
                          'Đổi',
                          style: TextStyle(fontSize: 10, color: teal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _property(
                            'assets/images/compare_table_057_01.jpg',
                            'Mây Homestay',
                            '4.8 (128)',
                            '850.000đ',
                            true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _property(
                            'assets/images/compare_table_057_02.jpg',
                            'An Villa',
                            '4.7 (86)',
                            '980.000đ',
                            false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF0FE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '♧  Mây Homestay tiết kiệm hơn 260.000đ cho 2 đêm. Vị trí gần phố cổ hơn 1.6km, chính sách hủy 100% linh hoạt.',
                        style: TextStyle(
                          fontSize: 10,
                          height: 1.5,
                          color: muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Row(
                      children: [
                        Text(
                          'Đối chiếu chi tiết',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: ink,
                          ),
                        ),
                        Spacer(),
                        Text(
                          '5 hạng mục chính',
                          style: TextStyle(fontSize: 9, color: muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    _compare(
                      'KHÔNG GIAN & KIẾN TRÚC',
                      'Homestay nguyên căn',
                      'Phục dựng gỗ & gạch bông mộc mạc, yên tĩnh tuyệt đối.',
                      'Boutique Villa',
                      'Nghỉ dưỡng phong cách mở, hồ bơi sinh thái chung.',
                    ),
                    _compare(
                      'TIỆN NGHI BẾP NẤU',
                      'Bếp riêng trong phòng',
                      'Đầy đủ gia vị cơ bản, tủ lạnh lớn, ấm đun & bếp từ cao cấp.',
                      'Bếp chung ngoài trời',
                      'Sử dụng chung tại sảnh vườn, cần dọn dẹp sau khi nấu.',
                    ),
                    _compare(
                      'TỐC ĐỘ INTERNET',
                      '100 Mbps',
                      'Băng thông riêng, bàn làm việc gỗ tự nhiên rộng rãi. Miễn phí',
                      '50 Mbps',
                      'Đường truyền ổn định, sóng mạnh nhất ở khu vực sảnh.',
                    ),
                    _compare(
                      'VỊ TRÍ & DI CHUYỂN',
                      '1.2 km • 5 phút xe máy',
                      'Có xe đạp mây miễn phí đạp vào phố cổ chùa Cầu.',
                      '2.8 km • 10 phút xe máy',
                      'Gần làng rau Trà Quế thanh bình, xa trung tâm hơn.',
                    ),
                    _compare(
                      'CHÍNH SÁCH HỦY LINH HOẠT',
                      'Hoàn tiền 100%',
                      'Hủy miễn phí trước 18:00 ngày 12/11/2026 không tính phí.',
                      'Tính phí 50%',
                      'Thu 50% tổng đơn nếu hủy trước 3 ngày nhận phòng.',
                    ),
                    InkWell(
                      onTap: () => context.push('/favorites/compare/prices'),
                      child: Container(
                        margin: const EdgeInsets.only(top: 3),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 18,
                              color: teal,
                            ),
                            SizedBox(width: 9),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Xem phân tích chi tiết giá 2 đêm',
                                    style: TextStyle(fontSize: 11, color: ink),
                                  ),
                                  Text(
                                    'Bao gồm thuế phí dịch vụ, dọn dẹp & ăn sáng',
                                    style: TextStyle(fontSize: 9, color: muted),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward, color: muted, size: 14),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '♧  88% du khách Hội An chọn homestay có bếp riêng để thưởng trà địa phương',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 9, color: muted),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 9, 20, 9),
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () =>
                          context.go('/properties/may-homestay/rooms'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: const Text(
                        'Tiếp tục với Mây Homestay  →',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Đã chọn: Mây Homestay (1.700.000đ / 2 đêm)    Đổi sang An Villa',
                    style: TextStyle(fontSize: 9, color: muted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _property(
    String image,
    String name,
    String rating,
    String price,
    bool selected,
  ) => Container(
    padding: const EdgeInsets.all(7),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: selected ? Border.all(color: teal, width: 2) : null,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: FigmaRaster(image, width: 148, height: 82),
        ),
        const SizedBox(height: 7),
        Text(
          name,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: ink,
          ),
        ),
        Text('⭐ $rating', style: const TextStyle(fontSize: 9, color: muted)),
        const SizedBox(height: 6),
        const Text('Chỉ từ', style: TextStyle(fontSize: 9, color: muted)),
        Text(
          '$price/đêm',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: teal,
          ),
        ),
      ],
    ),
  );

  Widget _compare(
    String title,
    String leftTitle,
    String leftDetail,
    String rightTitle,
    String rightDetail,
  ) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(11),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 10, color: muted)),
        const SizedBox(height: 7),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _cell(
                leftTitle,
                leftDetail,
                const Color(0xFFEAF7F6),
                teal,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _cell(
                rightTitle,
                rightDetail,
                const Color(0xFFEAF0FE),
                ink,
              ),
            ),
          ],
        ),
      ],
    ),
  );
  Widget _cell(String title, String detail, Color color, Color titleColor) =>
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: titleColor,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              detail,
              style: const TextStyle(fontSize: 9, height: 1.45, color: muted),
            ),
          ],
        ),
      );
}
