import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/figma_asset.dart';

class DomesticCardPaymentScreen extends StatefulWidget {
  const DomesticCardPaymentScreen({super.key});

  @override
  State<DomesticCardPaymentScreen> createState() =>
      _DomesticCardPaymentScreenState();
}

class _DomesticCardPaymentScreenState extends State<DomesticCardPaymentScreen> {
  static const teal = Color(0xFF006768);
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  bool saveCard = false;
  bool showCvv = false;

  Widget icon(int index, double width, double height) => FigmaSvg(
    'assets/icons/card_payment_069_${index.toString().padLeft(2, '0')}.svg',
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
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    'Thanh Toán Thẻ Ngân Hàng',
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
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: Color(0xFF0ABC77),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Cổng thanh toán nội địa & quốc tế',
                          style: TextStyle(fontSize: 12, color: muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: _box(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      '⌂ HOMESTAY HỘI AN',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        color: teal,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Mây Homestay',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: ink,
                                      ),
                                    ),
                                    const Text(
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
                                  'assets/images/card_payment_069.jpg',
                                  width: 54,
                                  height: 54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F4F4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_outlined,
                                      size: 13,
                                      color: muted,
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '14–16/11/2026',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: muted,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '2 đêm · 2 khách',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: muted,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.bed_outlined,
                                      size: 14,
                                      color: muted,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Chi tiết phòng',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: muted,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      '1 phòng nguyên căn',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Tổng thanh toán',
                                style: TextStyle(fontSize: 12, color: muted),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '1.800.000đ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: teal,
                                    ),
                                  ),
                                  Text(
                                    'Đã gồm VAT & phí',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: muted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Thông tin thẻ ngân hàng',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: ink,
                            ),
                          ),
                        ),
                        Text(
                          '♢ Dữ liệu thẻ giả lập',
                          style: TextStyle(fontSize: 11, color: teal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _cardBrand('VISA', const Color(0xFF4C5E83)),
                        const SizedBox(width: 8),
                        _cardBrand('Mastercard', const Color(0xFFFF694A)),
                        const SizedBox(width: 8),
                        _cardBrand('Napas', teal),
                        const SizedBox(width: 8),
                        _cardBrand('JCB', const Color(0xFF4C5E83)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _label('Số thẻ *', trailing: 'Visa Debit'),
                    _field(
                      '4111 •••• •••• 1111',
                      Icons.credit_card_outlined,
                      end: const Icon(
                        Icons.check_circle,
                        color: Color(0xFF0ABC77),
                        size: 18,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('Ngày hết hạn *'),
                              _field('12/28', Icons.calendar_today_outlined),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _label('CVV *', trailing: 'ⓘ'),
                              _field(
                                showCvv ? '888' : '8 8 8',
                                Icons.lock_outline,
                                end: InkWell(
                                  onTap: () =>
                                      setState(() => showCvv = !showCvv),
                                  child: const Icon(
                                    Icons.visibility_off_outlined,
                                    size: 18,
                                    color: muted,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _label('Tên chủ thẻ'),
                    _field('NGUYEN VAN A', Icons.badge_outlined),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => setState(() => saveCard = !saveCard),
                      child: Row(
                        children: [
                          Container(
                            width: 18,
                            height: 18,
                            decoration: BoxDecoration(
                              color: saveCard ? teal : Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: saveCard
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Lưu thẻ cho lần thanh toán sau',
                            style: TextStyle(fontSize: 14, color: ink),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info, color: teal, size: 18),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Thông tin thẻ trên màn hình này chỉ phục vụ mô phỏng giao diện Figma Prototype, không trừ tiền thật.',
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
                    const SizedBox(height: 16),
                    const Center(
                      child: Text(
                        '♙ Bảo mật SSL 256-bit       ·       ◈ PCI-DSS Compliant',
                        style: TextStyle(fontSize: 11, color: muted),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Số tiền cần thanh toán',
                            style: TextStyle(fontSize: 12, color: muted),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Hình thức',
                            style: TextStyle(fontSize: 11, color: muted),
                          ),
                          Text(
                            'Thẻ nội địa / QT',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: ink,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
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

  Widget _cardBrand(String label, Color color) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xFFF0F4F4),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      label,
      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color),
    ),
  );

  Widget _label(String text, {String? trailing}) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ink,
            ),
          ),
        ),
        if (trailing != null)
          Text(trailing, style: const TextStyle(fontSize: 11, color: muted)),
      ],
    ),
  );

  Widget _field(String value, IconData leading, {Widget? end}) => Container(
    height: 52,
    padding: const EdgeInsets.symmetric(horizontal: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0D000000),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: Row(
      children: [
        Icon(leading, size: 18, color: muted),
        const SizedBox(width: 10),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 14, color: ink)),
        ),
        ?end,
      ],
    ),
  );
}
