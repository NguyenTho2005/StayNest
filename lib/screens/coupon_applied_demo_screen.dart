import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/figma_asset.dart';

class CouponAppliedDemoScreen extends StatelessWidget {
  const CouponAppliedDemoScreen({super.key});
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
                        : context.go('/booking/coupons'),
                    icon: const Icon(Icons.arrow_back, size: 20),
                  ),
                  const Expanded(
                    child: Text(
                      'Giảm Giá Áp Dụng Thành Công',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
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
                      size: 17,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '●  Đã áp dụng mã STAY100 thành công',
                        style: TextStyle(fontSize: 11, color: teal),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Center(
                      child: CircleAvatar(
                        radius: 29,
                        backgroundColor: Color(0xFFEAF7F6),
                        child: FigmaSvg(
                          'assets/icons/coupon_demo_066_03.svg',
                          width: 26.667,
                          height: 26.667,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Áp dụng mã thành công!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Khoản giảm trừ của mã ưu đãi đã được tính vào chi tiết thanh toán bên dưới.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, height: 1.5, color: muted),
                    ),
                    const SizedBox(height: 23),
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Color(0xFFEAF7F6),
                                child: Icon(
                                  Icons.confirmation_number_outlined,
                                  color: teal,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'STAY100   Đã áp dụng',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: ink,
                                      ),
                                    ),
                                    Text(
                                      'Giảm giá phòng tiêu chuẩn',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '−100.000đ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: teal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F4F4),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: const Text(
                              'ⓘ  Ưu đãi đã được trừ trực tiếp vào tổng thanh toán của bạn.',
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
                    const SizedBox(height: 20),
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Chi tiết thanh toán',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: ink,
                                  ),
                                ),
                              ),
                              Text(
                                '1 đêm • 2 khách',
                                style: TextStyle(fontSize: 10, color: muted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          _row('Tiền phòng', '1.700.000đ'),
                          _row('Thuế (VAT 10%)', '170.000đ'),
                          _row('Phí dịch vụ', '30.000đ'),
                          _row('♧ Mã STAY100', '−100.000đ', teal),
                          const Divider(height: 22, color: Color(0xFFEAF0FE)),
                          const Row(
                            children: [
                              Expanded(
                                child: Column(
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
                                      'Đã bao gồm tất cả các thuế, phí',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: muted,
                                      ),
                                    ),
                                  ],
                                ),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      '♧  Đảm bảo giá tốt nhất & thanh toán an toàn',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 10, color: muted),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          disabledBackgroundColor: teal,
                          disabledForegroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        child: const Text('Tiếp tục đặt phòng  →'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => context.go('/booking/coupons'),
                      child: const Text(
                        '♜ Gỡ mã giảm giá',
                        style: TextStyle(fontSize: 12, color: Colors.red),
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

  Widget _card(Widget child) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );
  Widget _row(String label, String price, [Color color = ink]) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: TextStyle(fontSize: 13, color: color)),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    ),
  );
}
