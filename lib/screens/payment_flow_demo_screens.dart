import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/figma_asset.dart';

const _ink = Color(0xFF182230);
const _muted = Color(0xFF667085);
const _teal = Color(0xFF006768);
const _bg = Color(0xFFF7F9FC);

BoxDecoration _card() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  boxShadow: const [
    BoxShadow(color: Color(0x10172B4D), blurRadius: 8, offset: Offset(0, 4)),
  ],
);

Widget _head(
  BuildContext context,
  String title, {
  String back = '/booking/payment-method',
}) => Container(
  height: 56,
  padding: const EdgeInsets.symmetric(horizontal: 20),
  color: Colors.white,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      InkWell(
        onTap: () => context.canPop() ? context.pop() : context.go(back),
        child: const Icon(Icons.arrow_back, color: _ink, size: 20),
      ),
      Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: _ink,
        ),
      ),
      const CircleAvatar(
        radius: 16,
        backgroundColor: _teal,
        child: Icon(Icons.person_outline, color: Colors.white, size: 16),
      ),
    ],
  ),
);

Widget _line(String label, String value, {Color valueColor = _ink}) => Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(label, style: const TextStyle(fontSize: 14, color: _muted)),
    Text(value, style: TextStyle(fontSize: 14, color: valueColor)),
  ],
);

Widget _button(String text, {VoidCallback? onPressed, bool outline = false}) =>
    SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: outline ? Colors.white : _teal,
          disabledBackgroundColor: outline ? Colors.white : _teal,
          foregroundColor: outline ? _ink : Colors.white,
          disabledForegroundColor: outline ? _ink : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );

class PaymentConfirmationScreen extends StatefulWidget {
  const PaymentConfirmationScreen({super.key});
  @override
  State<PaymentConfirmationScreen> createState() =>
      _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  bool agreed = true;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            _head(context, 'Thanh Toán'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '⌂  Thông tin đặt phòng',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: _card(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: const FigmaRaster(
                                  'assets/images/scr_071_00.jpg',
                                  width: 72,
                                  height: 72,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Homestay cao cấp',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _teal,
                                      ),
                                    ),
                                    Text(
                                      'Mây Homestay',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: _ink,
                                      ),
                                    ),
                                    Text(
                                      '⌖ Hội An, Quảng Nam',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _muted,
                                      ),
                                    ),
                                    Text(
                                      'Phòng Studio có bếp',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _teal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 22, color: Color(0xFFEAEFEE)),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  color: const Color(0xFFF0F4F4),
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '▣ Thời gian',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: _muted,
                                        ),
                                      ),
                                      Text(
                                        '14/11 – 16/11/2026',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: _ink,
                                        ),
                                      ),
                                      Text(
                                        '2 đêm',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: _teal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  color: const Color(0xFFF0F4F4),
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '♧ Quy mô',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: _muted,
                                        ),
                                      ),
                                      Text(
                                        '2 người lớn',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: _ink,
                                        ),
                                      ),
                                      Text(
                                        '1 phòng',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: _muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'NGƯỜI ĐẠI DIỆN ĐẶT PHÒNG',
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: .5,
                              color: _muted,
                            ),
                          ),
                          const Text(
                            'Nguyễn An',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _ink,
                            ),
                          ),
                          const Text(
                            '0900 000 123 · an.demo@example.com',
                            style: TextStyle(fontSize: 11, color: _muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            '▣  Phương thức thanh toán',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _ink,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => context.push('/booking/payment-method'),
                          child: const Text(
                            'Đổi phương thức ›',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _teal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: _card(),
                      child: const Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Color(0xFFEAF7F6),
                            child: Icon(Icons.credit_card, color: _teal),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Thẻ quốc tế (demo) •••• 1111',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _ink,
                                  ),
                                ),
                                Text(
                                  'Visa / Mastercard · Đã liên kết',
                                  style: TextStyle(fontSize: 11, color: _muted),
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.lock_outline, color: _teal),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '▤  Chi tiết thanh toán',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: _card(),
                      child: Column(
                        children: [
                          _line('Tiền phòng · 2 đêm', '1.700.000đ'),
                          const SizedBox(height: 10),
                          _line('Thuế (VAT 10%)', '170.000đ'),
                          const SizedBox(height: 10),
                          _line('Phí dịch vụ StayNest', '30.000đ'),
                          const SizedBox(height: 10),
                          _line(
                            'Mã giảm giá  STAY100',
                            '−100.000đ',
                            valueColor: const Color(0xFF00A86B),
                          ),
                          const Divider(height: 20),
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: _ink,
                                      ),
                                    ),
                                    Text(
                                      'Đã bao gồm tất cả các loại thuế, phí',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: _muted,
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
                                  color: _teal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      height: 106,
                      padding: const EdgeInsets.all(8),
                      decoration: _card(),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: agreed,
                            activeColor: _teal,
                            onChanged: (value) =>
                                setState(() => agreed = value ?? false),
                          ),
                          const Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Text(
                                'Tôi đã đọc và đồng ý với các điều khoản giao dịch của StayNest và chính sách lưu trú của Mây Homestay.',
                                style: TextStyle(
                                  fontSize: 11,
                                  height: 1.5,
                                  color: _muted,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAEFEE),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'ⓘ Đây là bước xác nhận trong bản mô phỏng. Chưa phát sinh giao dịch thực tế.',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF3D4949),
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
              child: _button('♢ Thanh toán 1.800.000đ'),
            ),
          ],
        ),
      ),
    ),
  );
}

class PaymentProcessingScreen extends StatelessWidget {
  const PaymentProcessingScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            _head(context, 'Đang Xử Lý Thanh Toán'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 16, 28, 32),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            '🟠 CỔNG THANH TOÁN BẢO MẬT 256-BIT',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _muted,
                            ),
                          ),
                        ),
                        Text(
                          '♙ SSL\nEncrypted',
                          style: TextStyle(fontSize: 11, color: _teal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 38),
                    const CircleAvatar(
                      radius: 54,
                      backgroundColor: Color(0xFFEAF7F6),
                      child: CircleAvatar(
                        radius: 46,
                        backgroundColor: _teal,
                        child: CircleAvatar(
                          radius: 34,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.verified_user,
                            color: _teal,
                            size: 34,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Đang xác nhận thanh toán',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Vui lòng chờ trong giây lát khi hệ thống mô phỏng quá trình xác nhận giao dịch an toàn.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: _muted,
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      '↻  Chuẩn bị thông tin xác nhận giao dịch...',
                      style: TextStyle(fontSize: 12, color: _ink),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4F4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.hourglass_empty, color: Color(0xFFFFA54F)),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lưu ý quan trọng',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _ink,
                                  ),
                                ),
                                Text(
                                  'Vui lòng không đóng ứng dụng hoặc tải lại trang trong khi hệ thống đang xử lý giao dịch để tránh gián đoạn.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 1.5,
                                    color: _muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: _card(),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Mã đặt phòng: SN-1024',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _teal,
                                ),
                              ),
                              Text(
                                '● Đang xử lý · DEMO',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFB65A20),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: const FigmaRaster(
                                  'assets/images/scr_072_00.jpg',
                                  width: 56,
                                  height: 56,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mây Homestay',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _ink,
                                    ),
                                  ),
                                  Text(
                                    'Phòng Studio có bếp · Tầng 3',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _muted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _line('Thời gian lưu trú', '14–16/11/2026 (2 đêm)'),
                          const SizedBox(height: 10),
                          _line('Phương thức', 'VISA •••• 8826'),
                          const SizedBox(height: 10),
                          _line('Thời gian bắt đầu', 'Hôm nay, 14:32'),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(14),
                            color: const Color(0xFFF0F4F4),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tổng thanh toán',
                                  style: TextStyle(fontSize: 14, color: _muted),
                                ),
                                Text(
                                  '1.800.000 đ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: _teal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '♢ Bảo mật PCI DSS      ·      Mã hoá Tokenized      ·      Hỗ trợ 24/7',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: _muted),
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
}

class PaymentFailureScreen extends StatelessWidget {
  const PaymentFailureScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 76, 20, 30),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 46,
                backgroundColor: Color(0xFFFFE9E7),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.error, color: Color(0xFFD92D20), size: 32),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                '● Chưa hoàn tất',
                style: TextStyle(fontSize: 12, color: Color(0xFFD92D20)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Giao dịch chưa hoàn tất',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Kết nối bị gián đoạn trong quá trình mô phỏng thanh toán. Vui lòng thử lại hoặc chọn phương thức thanh toán khác.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.5, color: _ink),
              ),
              const SizedBox(height: 36),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4F4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: _teal),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bạn cần làm gì tiếp theo?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _ink,
                            ),
                          ),
                          Text(
                            'Bạn có thể thử lại thao tác xác nhận hoặc quay lại để đổi phương thức thanh toán.',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.3,
                              color: _muted,
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
                decoration: _card(),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            '▤ THÔNG TIN YÊU CẦU ĐẶT PHÒNG',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF3D4949),
                            ),
                          ),
                        ),
                        Text(
                          'Chờ thử lại',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFFE38B16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: const FigmaRaster(
                            'assets/images/scr_073_00.jpg',
                            width: 64,
                            height: 64,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mây Homestay',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _ink,
                                ),
                              ),
                              Text(
                                'Phòng Studio có bếp',
                                style: TextStyle(fontSize: 14, color: _muted),
                              ),
                              Text(
                                '▣ 14–16/11/2026 (2 đêm)',
                                style: TextStyle(fontSize: 11, color: _muted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: const Color(0xFFF0F4F4),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Số tiền cần thanh toán',
                            style: TextStyle(fontSize: 14, color: _ink),
                          ),
                          Text(
                            '1.800.000đ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFD92D20),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _button('⟳ Thử lại'),
              const SizedBox(height: 12),
              _button(
                '▣ Đổi phương thức',
                onPressed: () => context.push('/booking/payment-method'),
                outline: true,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 42, 20, 64),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFFEAF7F6),
                child: CircleAvatar(
                  radius: 21,
                  backgroundColor: _teal,
                  child: Icon(Icons.check, color: Colors.white, size: 24),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                '● Đã hoàn tất',
                style: TextStyle(fontSize: 11, color: _teal),
              ),
              const SizedBox(height: 4),
              const Text(
                'Đặt phòng thành công!',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Thanh toán đã hoàn tất. Thông tin đặt phòng của bạn được tổng hợp bên dưới.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, height: 1.5, color: _ink),
              ),
              const SizedBox(height: 18),
              Container(
                decoration: _card(),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    Stack(
                      children: [
                        const FigmaRaster(
                          'assets/images/scr_074_00.jpg',
                          width: double.infinity,
                          height: 94,
                        ),
                        Positioned(
                          bottom: 8,
                          left: 12,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'HOMESTAY & VILLA',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: Colors.white,
                                ),
                              ),
                              const Text(
                                'Mây Homestay',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
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
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            color: const Color(0xFFF0F4F4),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mã đặt phòng',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: _muted,
                                      ),
                                    ),
                                    Text(
                                      'SN-1024',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: _teal,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '▣ Sao chép',
                                  style: TextStyle(fontSize: 11, color: _teal),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          _detail('Loại phòng', 'Phòng Studio có bếp'),
                          _detail('Địa điểm', 'Hội An, Quảng Nam'),
                          _detail(
                            'Thời gian lưu trú',
                            '14/11/2026 – 16/11/2026 (2 đêm)',
                          ),
                          _detail('Số lượng khách', '2 người lớn · 1 phòng'),
                          _detail('Người đại diện đặt phòng', 'Nguyễn An'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: _card(),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Tóm tắt thanh toán',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _ink,
                          ),
                        ),
                        Text(
                          '● Đã thanh toán',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFF00A86B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _line('STAY100', '−100.000đ', valueColor: _teal),
                    const SizedBox(height: 16),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tổng số tiền đã trả',
                              style: TextStyle(fontSize: 11, color: _muted),
                            ),
                            Text(
                              'Đã bao gồm thuế & phí dịch vụ',
                              style: TextStyle(fontSize: 9, color: _muted),
                            ),
                          ],
                        ),
                        Text(
                          '1.800.000đ',
                          style: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            color: _ink,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () => context.push('/booking/receipt-demo'),
                        child: const Text(
                          '▤ Xem biên nhận điện tử',
                          style: TextStyle(fontSize: 11, color: _teal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(10),
                color: const Color(0xFFF0F4F4),
                child: const Text(
                  'Bạn có thể xem lại thông tin và quản lý chuyến đi bất cứ lúc nào trong mục Chuyến đi.',
                  style: TextStyle(
                    fontSize: 11,
                    height: 1.5,
                    color: Color(0xFF3D4949),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _button(
                'Xem đặt phòng →',
                onPressed: () => context.push('/trips'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text(
                  '⌂ Trở về trang chủ',
                  style: TextStyle(color: _muted),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _detail(String title, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 11,
          backgroundColor: Color(0xFFEAEFEE),
          child: Icon(Icons.check, size: 10, color: _muted),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 10, color: _muted)),
              Text(value, style: const TextStyle(fontSize: 12, color: _ink)),
            ],
          ),
        ),
      ],
    ),
  );
}

class PaymentReceiptScreen extends StatelessWidget {
  const PaymentReceiptScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            _head(
              context,
              'Xác Nhận Thanh Toán',
              back: '/booking/payment-success-demo',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 12, 28, 20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
                      decoration: _card(),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 23,
                            backgroundColor: Color(0xFFEAF7F6),
                            child: Icon(Icons.verified, color: _teal, size: 24),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'STAYNEST VIETNAM',
                            style: TextStyle(
                              fontSize: 11,
                              letterSpacing: 1.5,
                              color: _muted,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'BIÊN NHẬN THANH TOÁN',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: _ink,
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '● Đã thanh toán',
                            style: TextStyle(fontSize: 11, color: _teal),
                          ),
                          const SizedBox(height: 26),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Mã đặt phòng',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _muted,
                                    ),
                                  ),
                                  Text(
                                    'SN-1024',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _ink,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Ngày thanh toán',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _muted,
                                    ),
                                  ),
                                  Text(
                                    '22/10/2026',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: _ink,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(height: 54, color: Color(0xFFEAEFEE)),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F4F4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: const FigmaRaster(
                                    'assets/images/scr_075_00.jpg',
                                    width: 54,
                                    height: 54,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mây Homestay',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: _ink,
                                      ),
                                    ),
                                    Text(
                                      'Phòng Studio có bếp',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: _muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Khách đặt phòng',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _muted,
                                    ),
                                  ),
                                  Text(
                                    'Nguyễn An',
                                    style: TextStyle(fontSize: 14, color: _ink),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Phương thức',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _muted,
                                    ),
                                  ),
                                  Text(
                                    'Ví điện tử',
                                    style: TextStyle(fontSize: 14, color: _ink),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Thời gian lưu trú',
                                  style: TextStyle(fontSize: 12, color: _muted),
                                ),
                                Text(
                                  '14/11/2026 – 16/11/2026 (2 đêm, 2 khách)',
                                  style: TextStyle(fontSize: 14, color: _ink),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 30),
                          _line('Tiền phòng · 2 đêm', '1.700.000đ'),
                          const SizedBox(height: 12),
                          _line('Thuế (VAT 10%)', '170.000đ'),
                          const SizedBox(height: 12),
                          _line('Phí dịch vụ', '30.000đ'),
                          const SizedBox(height: 12),
                          _line(
                            'Mã giảm giá STAY100',
                            '−100.000đ',
                            valueColor: const Color(0xFFFF6B4A),
                          ),
                          const Divider(height: 36),
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
                                        color: _ink,
                                      ),
                                    ),
                                    Text(
                                      'Đã bao gồm tất cả các khoản phí',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: _muted,
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
                                  color: _teal,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          Container(
                            height: 54,
                            width: double.infinity,
                            alignment: Alignment.center,
                            color: const Color(0xFFF0F4F4),
                            child: const FigmaSvg(
                              'assets/icons/scr_075_02.svg',
                              width: 192,
                              height: 40,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'SN1024-VN-2026',
                            style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 1,
                              color: _muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Biên nhận được tạo tự động cho nguyên mẫu thử nghiệm Figma Prototype StayNest.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.5,
                        color: _muted,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _button('⇩ Lưu ảnh biên nhận', outline: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
