import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/figma_asset.dart';

class RefundPolicyScreen extends StatelessWidget {
  const RefundPolicyScreen({super.key});
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
              height: 50,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go('/properties/may-homestay/policies'),
                    icon: const Icon(Icons.arrow_back, size: 19),
                  ),
                  const Expanded(
                    child: Text(
                      'Room Selection',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                  ),
                  const Icon(Icons.share_outlined, size: 17, color: muted),
                  const SizedBox(width: 12),
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
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '♧ Chính sách bảo vệ quyền lợi đặt phòng',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: teal,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                'THÔNG TIN CHUYẾN ĐI',
                                style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 0.5,
                                  color: muted,
                                ),
                              ),
                              Spacer(),
                              Text(
                                'Mã: SN-1024',
                                style: TextStyle(fontSize: 10, color: teal),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: const FigmaRaster(
                                  'assets/images/policy_trip_052.jpg',
                                  width: 52,
                                  height: 52,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mây Homestay - Hội An',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: ink,
                                      ),
                                    ),
                                    Text(
                                      'Phòng Studio có bếp (2 đêm)',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: muted,
                                      ),
                                    ),
                                    Text(
                                      '▣ Nhận phòng: 14:00 ngày 14/11/2026',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F9FC),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Text(
                                  'Tổng giá trị đơn:',
                                  style: TextStyle(fontSize: 11, color: muted),
                                ),
                                Spacer(),
                                Text(
                                  '1.800.000đ',
                                  style: TextStyle(
                                    fontSize: 14,
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
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.schedule, size: 19, color: teal),
                              SizedBox(width: 9),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Khung thời gian & mức hoàn tiền',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: ink,
                                      ),
                                    ),
                                    Text(
                                      'Tính theo múi giờ địa phương (GMT+7)',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _step(
                            const Color(0xFF10B981),
                            'Hoàn tiền 100% (1.800.000đ)',
                            'Trước 18:00, ngày 12/11/2026',
                            '(48 giờ trước nhận phòng)',
                            'Hủy miễn phí hoàn toàn. Số tiền 1.800.000đ sẽ được hoàn về phương thức thanh toán ban đầu trong 3-7 ngày làm việc.',
                            current: true,
                          ),
                          _step(
                            const Color(0xFFFF9C27),
                            'Hoàn tiền 50% (900.000đ)',
                            'Từ 18:01 ngày 12/11 đến trước 14:00 ngày 14/11/2026',
                            '',
                            'Phí hủy phòng là 50% tổng giá trị đơn đặt. Bạn sẽ nhận lại số tiền bảo lưu 900.000đ.',
                          ),
                          _step(
                            const Color(0xFFE54848),
                            'Không hoàn tiền (0đ)',
                            'Sau 14:00 ngày 14/11/2026',
                            '(hoặc không nhận phòng - No show)',
                            'Không hoàn lại tiền khi yêu cầu hủy gửi sau giờ nhận phòng quy định của homestay.',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '▣  Quy trình xử lý hoàn tiền',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: teal,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Tiền hoàn sẽ được chuyển về tài khoản ngân hàng hoặc thẻ thanh toán ban đầu trong vòng 3-7 ngày làm việc (giả định).',
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.5,
                              color: ink,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Mã hoàn tiền mô phỏng:  RF-1024',
                            style: TextStyle(fontSize: 10, color: muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _card(
                      const Row(
                        children: [
                          Icon(
                            Icons.support_agent_outlined,
                            size: 22,
                            color: muted,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cần trợ giúp hủy phòng?',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: ink,
                                  ),
                                ),
                                Text(
                                  'Đội ngũ StayNest sẵn sàng 24/7',
                                  style: TextStyle(fontSize: 10, color: muted),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'Liên hệ',
                            style: TextStyle(fontSize: 10, color: teal),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton.icon(
                        onPressed: () => context.canPop()
                            ? context.pop()
                            : context.go('/properties/may-homestay/policies'),
                        icon: const Icon(Icons.thumb_up_alt_outlined, size: 15),
                        label: const Text('Đã hiểu quy định'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Mọi điều kiện hủy phòng đều là dữ liệu minh họa cho bản prototype StayNest.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, height: 1.5, color: muted),
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

  Widget _card(Widget child) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: child,
  );
  Widget _step(
    Color color,
    String label,
    String when,
    String note,
    String detail, {
    bool current = false,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: CircleAvatar(
            radius: 8,
            backgroundColor: color.withValues(alpha: .18),
            child: CircleAvatar(radius: 4, backgroundColor: color),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  label,
                  style: TextStyle(fontSize: 10, color: color),
                ),
              ),
              const SizedBox(height: 7),
              Text(
                when,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: ink,
                ),
              ),
              if (note.isNotEmpty)
                Text(note, style: const TextStyle(fontSize: 10, color: muted)),
              const SizedBox(height: 9),
              Text(
                detail,
                style: const TextStyle(
                  fontSize: 11,
                  height: 1.55,
                  color: muted,
                ),
              ),
              if (current) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9FAF1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    '◉ Hiện tại bạn đang ở khung giờ này',
                    style: TextStyle(fontSize: 10, color: Color(0xFF00A56A)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    ),
  );
}
