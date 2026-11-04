import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/staynest_api.dart';

class GuestInformationScreen extends ConsumerStatefulWidget {
  const GuestInformationScreen({super.key});
  @override
  ConsumerState<GuestInformationScreen> createState() =>
      _GuestInformationScreenState();
}

class _GuestInformationScreenState
    extends ConsumerState<GuestInformationScreen> {
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  static const teal = Color(0xFF006768);
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final draft = ref.read(bookingDraftProvider);
      name.text = draft.guestName;
      email.text = draft.guestEmail;
      phone.text = draft.guestPhone;
      if (name.text.isEmpty) {
        try {
          final user = await ref.read(stayNestApiProvider).getMe();
          if (!mounted) return;
          name.text = '${user['full_name'] ?? ''}';
          email.text = '${user['email'] ?? ''}';
          phone.text = '${user['phone'] ?? ''}';
          draft.prefillGuestFromUser(user);
        } catch (_) {
          // Guests can enter contact details before signing in.
        }
      }
    });
  }

  void continueBooking() {
    if (name.text.trim().isEmpty ||
        !email.text.contains('@') ||
        phone.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng nhập đầy đủ họ tên, email và số điện thoại hợp lệ.',
          ),
        ),
      );
      return;
    }
    final draft = ref.read(bookingDraftProvider);
    draft.guestName = name.text.trim();
    draft.guestEmail = email.text.trim();
    draft.guestPhone = phone.text.trim();
    draft.idempotencyKey = null;
    draft.booking = null;
    context.push('/booking/requests');
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F9F9),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            Container(
              height: 56,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go('/booking/start'),
                    icon: const Icon(Icons.arrow_back, size: 20),
                  ),
                  const Expanded(
                    child: Text(
                      'Thông tin khách lưu trú',
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
                      size: 17,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
              color: Colors.white,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BƯỚC 2/4: THÔNG TIN KHÁCH LƯU TRÚ',
                    style: TextStyle(fontSize: 10, color: teal),
                  ),
                  SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: .5,
                    minHeight: 5,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: teal,
                    backgroundColor: Color(0xFFE7ECEC),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '● Chi tiết khách lưu trú',
                      style: TextStyle(fontSize: 12, color: muted),
                    ),
                    const SizedBox(height: 16),
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '● Đặt cho chính tôi',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: teal,
                                  ),
                                ),
                              ),
                              Text(
                                'Tài khoản StayNest',
                                style: TextStyle(fontSize: 11, color: muted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F8F8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '♧ Vui lòng kiểm tra thông tin người lưu trú để hoàn tất đặt phòng. Tên trên giấy tờ tùy thân cần trùng khớp khi làm thủ tục nhận phòng tại Mây Homestay.',
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.65,
                                color: muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F9F9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Thông tin người liên hệ chính',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ink,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _field(
                            'Họ và tên *',
                            'Theo CCCD / Hộ chiếu',
                            name,
                            Icons.person_outline,
                          ),
                          _field(
                            'Email nhận xác nhận *',
                            '',
                            email,
                            Icons.mail_outline,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Text(
                              'ⓘ Mã đặt phòng và biên nhận demo sẽ hiển thị sau khi xác nhận thanh toán mô phỏng.',
                              style: TextStyle(fontSize: 10, color: muted),
                            ),
                          ),
                          _field(
                            'Số điện thoại *',
                            '',
                            phone,
                            Icons.phone_outlined,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline, color: teal, size: 22),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ghi chú nguyên mẫu',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: teal,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Thông tin này được dùng trong bản mô phỏng xác nhận đặt phòng (Figma Prototype). Không yêu cầu dữ liệu thực tế.',
                                  style: TextStyle(
                                    fontSize: 11,
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
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tiền phòng tạm tính',
                          style: TextStyle(fontSize: 10, color: muted),
                        ),
                        Text(
                          '${ref.read(bookingDraftProvider).roomSubtotalLabel} / ${ref.read(bookingDraftProvider).nights} đêm',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 148,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: continueBooking,
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: teal,
                        disabledForegroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: const Text('Tiếp tục →'),
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

  Widget _card(Widget child) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: child,
  );
  Widget _field(
    String label,
    String hint,
    TextEditingController controller,
    IconData icon,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: ink,
              ),
            ),
            const Spacer(),
            Text(hint, style: const TextStyle(fontSize: 10, color: muted)),
          ],
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 14, color: ink),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 17, color: muted),
            suffixIcon: const Icon(
              Icons.check_circle,
              size: 17,
              color: Color(0xFF12B76A),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    ),
  );
}
