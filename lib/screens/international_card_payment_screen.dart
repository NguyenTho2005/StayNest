import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/figma_asset.dart';

class InternationalCardPaymentScreen extends StatelessWidget {
  const InternationalCardPaymentScreen({super.key});
  static const teal = Color(0xFF006768);
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);

  Widget asset(int index, double width, double height) => FigmaSvg(
    'assets/icons/international_payment_070_${index.toString().padLeft(2, '0')}.svg',
    width: width,
    height: height,
  );

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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go('/booking/payment-method'),
                    child: const Icon(Icons.arrow_back, size: 20, color: ink),
                  ),
                  const Text(
                    'Thanh Toán Thẻ Quốc Tế',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ink,
                    ),
                  ),
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: teal,
                    child: Icon(
                      Icons.person_outline,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 16, 28, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(radius: 4, backgroundColor: teal),
                        SizedBox(width: 4),
                        Text(
                          'Cổng thanh toán bảo mật',
                          style: TextStyle(fontSize: 12, color: muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: _box(),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Homestay Hội An',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: teal,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Mây Homestay',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: ink,
                                      ),
                                    ),
                                    Text(
                                      'Phòng Studio có bếp',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: const FigmaRaster(
                                  'assets/images/international_payment_070.jpg',
                                  width: 64,
                                  height: 64,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F4F4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  color: teal,
                                  size: 14,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '14–16/11/2026',
                                  style: TextStyle(fontSize: 12, color: muted),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.people_outline,
                                  color: teal,
                                  size: 16,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '2 đêm · 2 khách',
                                  style: TextStyle(fontSize: 12, color: muted),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Cần thanh toán',
                                style: TextStyle(fontSize: 14, color: muted),
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
                    const SizedBox(height: 18),
                    const Text(
                      'Chọn thẻ thanh toán',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                    const Text(
                      'Thẻ quốc tế đã lưu trong phiên thử nghiệm',
                      style: TextStyle(fontSize: 12, color: muted),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 175,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF00716E),
                            Color(0xFF006768),
                            Color(0xFF0E8883),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33006768),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.sim_card,
                                color: Color(0xFFF6D979),
                                size: 26,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'THẺ DEMO',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                              Spacer(),
                              Text(
                                'VISA  🟠',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Text(
                            '••••  ••••  ••••  1111',
                            style: TextStyle(
                              fontSize: 18,
                              letterSpacing: 2,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CHỦ THẺ',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFFACD8D6),
                                    ),
                                  ),
                                  Text(
                                    'NGUYEN AN',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'HẾT HẠN',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFFACD8D6),
                                    ),
                                  ),
                                  Text(
                                    '12/28',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: _box(),
                      child: const Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xFFEAF7F6),
                            child: Icon(
                              Icons.credit_card,
                              color: teal,
                              size: 18,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Visa / Mastercard  Mặc định',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: ink,
                                  ),
                                ),
                                Text(
                                  'NGUYEN AN · •••• 1111 (12/28)',
                                  style: TextStyle(fontSize: 11, color: muted),
                                ),
                              ],
                            ),
                          ),
                          CircleAvatar(
                            radius: 10,
                            backgroundColor: teal,
                            child: CircleAvatar(
                              radius: 4,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: _box(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Chi tiết thanh toán',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: ink,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _row('Số tiền đặt phòng', '1.800.000đ'),
                          const SizedBox(height: 12),
                          _row('Phí thanh toán   Miễn phí', '0đ'),
                          const Divider(height: 30, color: Color(0xFFEAEFEE)),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tổng thanh toán',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: ink,
                                      ),
                                    ),
                                    Text(
                                      'Đã bao gồm thuế & phí dịch vụ',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '1.800.000đ',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: teal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline, color: teal, size: 17),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Thông tin thẻ và giao dịch chỉ mang tính minh họa nguyên mẫu. Không phát sinh trừ tiền thật trên tài khoản của bạn.',
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.6,
                                color: teal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: teal,
                          disabledBackgroundColor: teal,
                          disabledForegroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Tiếp tục',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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

  BoxDecoration _box() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: const [
      BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
    ],
  );
  Widget _row(String label, String value) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(fontSize: 14, color: muted)),
      Text(value, style: const TextStyle(fontSize: 14, color: ink)),
    ],
  );
}
