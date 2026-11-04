import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/figma_asset.dart';

class FinalBookingCheckScreen extends StatelessWidget {
  const FinalBookingCheckScreen({super.key});
  static const teal = Color(0xFF006768);
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);

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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.white,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go('/booking/payment-success-demo'),
                    child: const Icon(Icons.arrow_back, size: 20, color: ink),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Kiểm Tra Đặt Phòng',
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
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Mã đơn: SN-1024',
                      style: TextStyle(fontSize: 11, color: muted),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: teal,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(height: 18),
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
                            backgroundColor: Colors.white,
                            child: Icon(Icons.verified, color: teal, size: 20),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Thông tin đặt phòng',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: ink,
                                  ),
                                ),
                                Text(
                                  '● Đã thanh toán',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF0ABC77),
                                  ),
                                ),
                                Text(
                                  'Bản tóm tắt giao dịch đã hoàn tất thành công. Vui lòng kiểm tra lại thông tin chi tiết và điều kiện lưu trú trước ngày khởi hành.',
                                  style: TextStyle(
                                    fontSize: 12,
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
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: const FigmaRaster(
                                  'assets/images/scr_080_00.jpg',
                                  width: 62,
                                  height: 62,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '⌂ HOMESTAY NGUYÊN CĂN',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFFAD6E3E),
                                      ),
                                    ),
                                    Text(
                                      'Mây Homestay',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: ink,
                                      ),
                                    ),
                                    Text(
                                      '⌖ Hội An, Quảng Nam',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: muted,
                                      ),
                                    ),
                                    Text(
                                      'Mã booking: SN-1024',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: teal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F4F4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                _row('Hạng phòng', 'Phòng Studio có bếp'),
                                const SizedBox(height: 12),
                                _row('Thời gian', '14/11/2026 – 16/11/2026'),
                                const SizedBox(height: 12),
                                _row('Số lượng khách', '2 người lớn · 1 phòng'),
                                const SizedBox(height: 12),
                                _row('Người đại diện', 'Nguyễn An'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '◷ Nhận phòng: 14:00 (14/11) · Trả phòng: 12:00 (16/11)',
                            style: TextStyle(fontSize: 11, color: muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '▤ Bảng kê chi phí thanh toán',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: ink,
                                ),
                              ),
                              Text(
                                'VND',
                                style: TextStyle(fontSize: 10, color: muted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _row('Tiền phòng (2 đêm)', '1.700.000đ'),
                          const SizedBox(height: 10),
                          _row('Thuế giá trị gia tăng (VAT 10%)', '170.000đ'),
                          const SizedBox(height: 10),
                          _row('Phí dịch vụ StayNest', '30.000đ'),
                          const SizedBox(height: 10),
                          _row('Voucher giảm giá (STAY100)', '−100.000đ'),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(12),
                            color: const Color(0xFFF0F4F4),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tổng thanh toán',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: ink,
                                      ),
                                    ),
                                    Text(
                                      'Thanh toán qua Thẻ quốc tế',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF0ABC77),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '1.800.000đ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: teal,
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
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Lưu ý về chính sách hủy',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: ink,
                            ),
                          ),
                          const Text(
                            'Chính sách hủy linh hoạt từ Chủ nhà',
                            style: TextStyle(fontSize: 11, color: muted),
                          ),
                          const SizedBox(height: 16),
                          _policy(
                            'Trước 12/11/2026 18:00',
                            'Hoàn 100%',
                            const Color(0xFF0ABC77),
                          ),
                          _policy(
                            'Từ 12/11 đến trước giờ nhận phòng',
                            'Hoàn 50%',
                            const Color(0xFFFF9900),
                          ),
                          _policy(
                            'Sau khi nhận phòng (14/11)',
                            'Không hoàn tiền',
                            muted,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Không áp dụng hoàn hủy sau mốc 14:00 ngày 14/11/2026.',
                            style: TextStyle(fontSize: 11, color: muted),
                          ),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () => context.push(
                              '/properties/may-homestay/policies/refund',
                            ),
                            child: const Text(
                              'Xem chi tiết chính sách hủy đầy đủ →',
                              style: TextStyle(fontSize: 12, color: teal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4F4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Bạn có thể theo dõi hướng dẫn nhận phòng, liên hệ chủ nhà và chỉnh sửa lịch trình trong mục Quản lý chuyến đi.',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.5,
                          color: muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => context.push('/trips'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Quản lý chuyến đi →'),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  BoxDecoration _card() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
    ],
  );
  Widget _row(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Flexible(
        child: Text(label, style: const TextStyle(fontSize: 11, color: muted)),
      ),
      Text(value, style: const TextStyle(fontSize: 11, color: ink)),
    ],
  );
  Widget _policy(String label, String status, Color color) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ink,
            ),
          ),
        ),
        Text(status, style: TextStyle(fontSize: 11, color: color)),
      ],
    ),
  );
}
