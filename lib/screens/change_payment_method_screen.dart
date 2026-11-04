import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChangePaymentMethodScreen extends StatefulWidget {
  const ChangePaymentMethodScreen({super.key});
  @override
  State<ChangePaymentMethodScreen> createState() =>
      _ChangePaymentMethodScreenState();
}

class _ChangePaymentMethodScreenState extends State<ChangePaymentMethodScreen> {
  static const teal = Color(0xFF006768);
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  int selected = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFE2E8EC),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  color: Colors.white,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => context.canPop()
                            ? context.pop()
                            : context.go('/booking/payment-confirmation'),
                        child: const Icon(Icons.arrow_back, color: ink),
                      ),
                      const Spacer(),
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
                const Padding(
                  padding: EdgeInsets.all(36),
                  child: Column(
                    children: [
                      Text(
                        'HOMESTAY CAO CẤP',
                        style: TextStyle(fontSize: 11, color: teal),
                      ),
                      Text(
                        'An Nam Studio & Balcony',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: ink,
                        ),
                      ),
                      Text(
                        'Hoàn Kiếm, Hà Nội',
                        style: TextStyle(fontSize: 13, color: muted),
                      ),
                      SizedBox(height: 28),
                      Text(
                        'Tổng thanh toán                         1.800.000đ',
                        style: TextStyle(fontSize: 14, color: muted),
                      ),
                      SizedBox(height: 40),
                      Text(
                        'Phương thức hiện tại\nVí điện tử',
                        style: TextStyle(fontSize: 14, color: muted),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned.fill(child: Container(color: const Color(0x770F2740))),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: const Color(0xFFDDE2E2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Đổi phương thức thanh toán',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: ink,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () => context.canPop()
                                ? context.pop()
                                : context.go('/booking/payment-confirmation'),
                            icon: const Icon(Icons.close, color: muted),
                          ),
                        ],
                      ),
                      const Text(
                        'Chọn cách thanh toán phù hợp với bạn',
                        style: TextStyle(fontSize: 12, color: muted),
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F4F4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '▣ Số tiền cần thanh toán',
                              style: TextStyle(fontSize: 12, color: muted),
                            ),
                            Text(
                              '1.800.000đ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _option(
                        0,
                        Icons.account_balance_wallet_outlined,
                        'Ví điện tử',
                        'Thanh toán bằng ví trong bản mô phỏng',
                      ),
                      const SizedBox(height: 10),
                      _option(
                        1,
                        Icons.account_balance_outlined,
                        'Thẻ ngân hàng',
                        'Sử dụng thông tin thẻ giả lập',
                      ),
                      const SizedBox(height: 10),
                      _option(
                        2,
                        Icons.credit_card_outlined,
                        'Thẻ quốc tế',
                        'Thông tin thẻ demo Visa/Mastercard',
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F4F4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'ⓘ Chỗ ở này yêu cầu thanh toán trực tuyến để bảo lưu lịch hẹn.',
                          style: TextStyle(fontSize: 11, color: muted),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () => context.canPop()
                              ? context.pop()
                              : context.go('/booking/payment-confirmation'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: teal,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Lưu thay đổi ✓',
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
            ),
          ],
        ),
      ),
    ),
  );

  Widget _option(
    int index,
    IconData icon,
    String title,
    String subtitle,
  ) => InkWell(
    onTap: () => setState(() => selected = index),
    child: Container(
      constraints: BoxConstraints(
        minHeight: switch (index) {
          0 => 100,
          1 => 80,
          _ => 93,
        },
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected == index ? const Color(0xFFEAF7F6) : Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: selected == index
                ? Colors.white
                : const Color(0xFFEAEFEE),
            child: Icon(
              icon,
              color: selected == index ? teal : muted,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ink,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: muted),
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: 11,
            backgroundColor: selected == index ? teal : const Color(0xFFEAEFEE),
            child: selected == index
                ? const CircleAvatar(radius: 5, backgroundColor: Colors.white)
                : null,
          ),
        ],
      ),
    ),
  );
}
