import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TransactionTermsScreen extends StatefulWidget {
  const TransactionTermsScreen({super.key});
  @override
  State<TransactionTermsScreen> createState() => _TransactionTermsScreenState();
}

class _TransactionTermsScreenState extends State<TransactionTermsScreen> {
  static const teal = Color(0xFF006768);
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  final expanded = <int>{0};

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
                        : context.go('/booking/payment-confirmation'),
                    child: const Icon(Icons.arrow_back, size: 20, color: ink),
                  ),
                  const Text(
                    'Điều Khoản Giao Dịch',
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
                padding: const EdgeInsets.fromLTRB(28, 20, 28, 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '⬟ BẢO MẬT & MINH BẠCH',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: teal,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Vui lòng đọc các điều khoản dưới đây trước khi hoàn tất bước xác nhận thanh toán.',
                      style: TextStyle(fontSize: 14, height: 1.5, color: muted),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Color(0xFFD5EDEC),
                            child: Icon(
                              Icons.info_outline,
                              size: 18,
                              color: teal,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lưu ý trải nghiệm',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: ink,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Nội dung điều khoản trong ứng dụng này phục vụ mục đích minh họa giao diện.',
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
                    const SizedBox(height: 16),
                    _tile(
                      0,
                      Icons.payments_outlined,
                      'Chính sách thanh toán',
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Giao diện nhằm mục đích mô phỏng luồng xác nhận thanh toán an toàn và minh bạch theo chuẩn dịch vụ StayNest.',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.55,
                              color: muted,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F4F4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Số tiền giao dịch thử nghiệm',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: muted,
                                      ),
                                    ),
                                    Text(
                                      '1.800.000đ',
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w700,
                                        color: teal,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '♙ Mã hóa SSL',
                                  style: TextStyle(fontSize: 12, color: teal),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Ghi chú: Nguyên mẫu Figma Prototype không xử lý giao dịch tài chính thật. Không có khoản tiền nào bị trừ khỏi tài khoản thực tế.',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _tile(
                      1,
                      Icons.event_busy_outlined,
                      'Chính sách hủy',
                      const Text(
                        'Điều kiện hủy hiển thị theo chính sách của chỗ ở và thời điểm nhận phòng.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _tile(
                      2,
                      Icons.currency_exchange,
                      'Chính sách hoàn tiền',
                      const Text(
                        'Mức hoàn tiền được trình bày tại màn chi tiết chính sách hủy và hoàn tiền.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _tile(
                      3,
                      Icons.shield_outlined,
                      'Dữ liệu cá nhân',
                      const Text(
                        'Dữ liệu trong nguyên mẫu chỉ dùng để minh họa giao diện.',
                        style: TextStyle(
                          fontSize: 13,
                          height: 1.5,
                          color: muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        '♢  Cam kết dịch vụ StayNest Vietnam',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF98A2B3),
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

  Widget _tile(int index, IconData icon, String title, Widget body) =>
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          children: [
            InkWell(
              onTap: () => setState(
                () => expanded.contains(index)
                    ? expanded.remove(index)
                    : expanded.add(index),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFEAF2F1),
                    child: Icon(icon, size: 20, color: teal),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                  ),
                  Icon(
                    expanded.contains(index)
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: muted,
                  ),
                ],
              ),
            ),
            if (expanded.contains(index)) ...[const SizedBox(height: 18), body],
          ],
        ),
      );
}
