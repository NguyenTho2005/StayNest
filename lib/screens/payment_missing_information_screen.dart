import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/figma_asset.dart';

class PaymentMissingInformationScreen extends StatelessWidget {
  const PaymentMissingInformationScreen({super.key});
  static const teal = Color(0xFF006768);
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7FAFA),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 36),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xFFFBEFD9),
                child: CircleAvatar(
                  radius: 32,
                  backgroundColor: Color(0xFFFCE4BB),
                  child: Icon(Icons.error, color: Color(0xFFFF9900), size: 31),
                ),
              ),
              const SizedBox(height: 22),
              const Text(
                'Chưa thể tiếp tục thanh toán',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: ink,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Vui lòng kiểm tra và hoàn thiện các thông tin bắt buộc trước khi tiếp tục.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.5, color: muted),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: _card(),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.assignment_late_outlined,
                          color: Color(0xFFFF9900),
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Thông tin cần kiểm tra',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: ink,
                            ),
                          ),
                        ),
                        Text(
                          '2 lỗi cần xử lý',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFD92D20),
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 28),
                    _issue(
                      Icons.phone_android,
                      'Thiếu số điện thoại liên hệ',
                      'Vui lòng bổ sung số điện thoại của người lưu trú.',
                      'Bổ sung thông tin',
                      () => context.push('/booking/guests'),
                    ),
                    const SizedBox(height: 12),
                    _issue(
                      Icons.gavel_outlined,
                      'Chưa đồng ý điều khoản giao dịch',
                      'Vui lòng đọc và xác nhận đồng ý với các điều khoản trước khi thanh toán.',
                      'Kiểm tra điều khoản',
                      () => context.push('/booking/transaction-terms'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: _card(),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: Color(0xFF0ABC77),
                        ),
                        SizedBox(width: 7),
                        Expanded(
                          child: Text(
                            'Phòng đang được giữ chỗ trong 10:00',
                            style: TextStyle(fontSize: 12, color: muted),
                          ),
                        ),
                        Text(
                          'Tạm giữ',
                          style: TextStyle(fontSize: 11, color: teal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: const FigmaRaster(
                            'assets/images/scr_078_00.jpg',
                            width: 64,
                            height: 64,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mây Homestay ⭐ 4.9',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: ink,
                                ),
                              ),
                              Text(
                                'Studio có bếp · 14–16/11/2026',
                                style: TextStyle(fontSize: 12, color: muted),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Cần thanh toán:',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: muted,
                                    ),
                                  ),
                                  Spacer(),
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F4F4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'ⓘ Hệ thống đang mô phỏng bước kiểm tra dữ liệu bắt buộc của quy trình đặt phòng.',
                  style: TextStyle(fontSize: 12, color: muted),
                ),
              ),
              const SizedBox(height: 50),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text(
                  '⌂ Trở về trang chủ',
                  style: TextStyle(fontSize: 16, color: muted),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  BoxDecoration _card() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: const [
      BoxShadow(color: Color(0x10172B4D), blurRadius: 12, offset: Offset(0, 4)),
    ],
  );

  Widget _issue(
    IconData icon,
    String title,
    String subtitle,
    String action,
    VoidCallback onTap,
  ) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFF0F4F4),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: Icon(icon, color: ink, size: 20),
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
                    style: const TextStyle(
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
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: onTap,
            child: Text(
              '$action →',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: teal,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
