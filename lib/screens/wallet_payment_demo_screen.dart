import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/figma_asset.dart';

class WalletPaymentDemoScreen extends StatelessWidget {
  const WalletPaymentDemoScreen({super.key});

  static const teal = Color(0xFF006768);
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);

  Widget asset(int index, double width, double height) => FigmaSvg(
    'assets/icons/wallet_payment_068_${index.toString().padLeft(2, '0')}.svg',
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
                    child: asset(7, 16, 16),
                  ),
                  const Text(
                    'Thanh Toán Bằng Ví',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ink,
                    ),
                  ),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: teal,
                    child: asset(8, 12, 12),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 54, 20, 24),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                      decoration: _box(),
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              const CircleAvatar(
                                radius: 40,
                                backgroundColor: Color(0xFFEAF7F6),
                              ),
                              Positioned(
                                top: 23,
                                left: 24,
                                child: asset(4, 32, 30),
                              ),
                              Positioned(
                                bottom: -1,
                                right: -1,
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Color(0xFF0ABC77),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Ví điện tử',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: ink,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Liên kết giao thức thanh toán không tiền mặt\nan toàn chuẩn StayNest Sandbox',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: muted,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F4F4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Color(0xFF0ABC77),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Expanded(
                                      child: Text(
                                        'Ví đã liên kết',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: ink,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 4,
                                      ),
                                      color: const Color(0xFFEAEFEE),
                                      child: const Text(
                                        'Sẵn sàng',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: muted,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 28, top: 4),
                                  child: Text(
                                    'Trạng thái mô phỏng dành riêng cho nguyên mẫu thử nghiệm (Figma Prototype).',
                                    style: TextStyle(
                                      fontSize: 12,
                                      height: 1.5,
                                      color: muted,
                                    ),
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
                      width: double.infinity,
                      decoration: _box(),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFB),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            child: Row(
                              children: [
                                asset(0, 16, 17),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    'Tóm tắt đặt phòng',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: ink,
                                    ),
                                  ),
                                ),
                                const Text(
                                  'Chưa thanh toán',
                                  style: TextStyle(fontSize: 12, color: muted),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                _row(
                                  'Chỗ ở',
                                  'Mây Homestay\nHội An, Quảng Nam',
                                ),
                                const SizedBox(height: 16),
                                _row('Loại phòng', 'Phòng Studio có bếp'),
                                const SizedBox(height: 16),
                                _row('Thời gian', '14–16/11/2026 (2 đêm)'),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Voucher áp dụng',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: muted,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEAF7F6),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: const Text(
                                        '◇ STAY100 (−100.000đ)',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: teal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(
                                  height: 32,
                                  color: Color(0xFFEAEFEE),
                                ),
                                const Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Số tiền cần thanh toán',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: muted,
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                            'Đã bao gồm thuế và phí dịch vụ',
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFF98A2B3),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      '1.800.000đ',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: teal,
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
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          asset(2, 17, 19),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Thao tác xác nhận chỉ mô phỏng giao diện, không trừ tiền thật. Mã giao dịch thử nghiệm sẽ được tạo ở bước kế tiếp.',
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.6,
                                color: Color(0xFF3D4949),
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
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              child: SizedBox(
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
                    'Xác nhận ví  →',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
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
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(color: Color(0x10172B4D), blurRadius: 8, offset: Offset(0, 4)),
    ],
  );

  Widget _row(String label, String value) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: Text(label, style: const TextStyle(fontSize: 14, color: muted)),
      ),
      Text(
        value,
        textAlign: TextAlign.right,
        style: const TextStyle(
          fontSize: 14,
          height: 1.5,
          fontWeight: FontWeight.w500,
          color: ink,
        ),
      ),
    ],
  );
}
