import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/staynest_api.dart';

import '../widgets/figma_asset.dart';

class PaymentMethodScreen extends ConsumerStatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  ConsumerState<PaymentMethodScreen> createState() =>
      _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen> {
  static const teal = Color(0xFF006768);
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  int selected = 0;
  bool busy = false;
  String vnd(Object? amount) =>
      '${NumberFormat.decimalPattern('vi').format(num.tryParse('$amount') ?? 0)}đ';

  Future<void> confirmDemoPayment() async {
    final draft = ref.read(bookingDraftProvider);
    final id = draft.booking?['id'];
    if (id is! int || busy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng tạo đơn đặt phòng trước khi thanh toán mô phỏng.',
          ),
        ),
      );
      return;
    }
    setState(() => busy = true);
    try {
      await ref
          .read(stayNestApiProvider)
          .demoPayment(
            id,
            ['EWALLET', 'DOMESTIC_CARD', 'INTERNATIONAL_CARD'][selected],
          );
      ref.invalidate(myBookingsProvider);
      if (mounted) context.go('/booking/payment-success-live/$id');
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$error')));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Widget svg(int index, double width, double height) => FigmaSvg(
    'assets/icons/payment_method_067_${index.toString().padLeft(2, '0')}.svg',
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
                        : context.go('/booking/price'),
                    child: SizedBox(width: 32, child: svg(12, 16, 16)),
                  ),
                  const Text(
                    'Phương Thức Thanh Toán',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: ink,
                    ),
                  ),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: teal,
                    child: svg(13, 12, 12),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 19, 20, 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: const LinearProgressIndicator(
                  value: .66,
                  minHeight: 6,
                  color: teal,
                  backgroundColor: Color(0xFFEAEFEE),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _summary(),
                    const SizedBox(height: 16),
                    const Text(
                      'Chọn phương thức thanh toán',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Vui lòng chọn hình thức thuận tiện nhất cho kỳ lưu trú',
                      style: TextStyle(fontSize: 12, color: muted),
                    ),
                    const SizedBox(height: 16),
                    _option(
                      0,
                      4,
                      'Ví điện tử',
                      'Thanh toán bằng ví trong bản mô phỏng',
                      recommended: true,
                    ),
                    const SizedBox(height: 12),
                    _option(
                      1,
                      5,
                      'Thẻ ngân hàng',
                      'Sử dụng thông tin thẻ giả lập',
                    ),
                    const SizedBox(height: 12),
                    _option(
                      2,
                      6,
                      'Thẻ quốc tế',
                      'Visa / Mastercard — thông tin minh họa',
                      badges: true,
                    ),
                    const SizedBox(height: 12),
                    _option(
                      3,
                      7,
                      'Thanh toán tại nơi ở',
                      'Chưa khả dụng cho đặt phòng demo này',
                      disabled: true,
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
                          svg(10, 17, 17),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text(
                              'Đây là giao diện mô phỏng. Chưa phát sinh giao dịch thực tế trên tài khoản của bạn.',
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
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              color: Colors.white,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TỔNG THANH TOÁN',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: .55,
                          color: muted,
                        ),
                      ),
                      Text(
                        vnd(
                          ref.read(bookingDraftProvider).booking?['total_vnd'],
                        ),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: teal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: busy ? null : confirmDemoPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: teal,
                          disabledBackgroundColor: teal,
                          foregroundColor: Colors.white,
                          disabledForegroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          busy ? 'Đang xác nhận…' : 'Xác nhận mô phỏng →',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
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

  Widget _summary() => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x10172B4D),
          blurRadius: 8,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      svg(1, 17, 15),
                      const SizedBox(width: 4),
                      Text(
                        ref.read(bookingDraftProvider).propertyName.isNotEmpty
                            ? ref.read(bookingDraftProvider).propertyName
                            : 'Mây Homestay',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ink,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    ref.read(bookingDraftProvider).selectedRoomName,
                    style: const TextStyle(fontSize: 12, color: muted),
                  ),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FigmaRaster(
                ref
                        .read(bookingDraftProvider)
                        .selectedRoomName
                        .contains('Garden')
                    ? 'assets/images/room_garden_049.jpg'
                    : 'assets/images/payment_method_067.jpg',
                width: 56,
                height: 56,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F4),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  svg(2, 12, 13),
                  const SizedBox(width: 4),
                  Text(
                    '${ref.read(bookingDraftProvider).checkInIso} – ${ref.read(bookingDraftProvider).checkOutIso} · ${ref.read(bookingDraftProvider).quote?['nights'] ?? '—'} đêm',
                    style: const TextStyle(fontSize: 12, color: muted),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  svg(3, 14, 10),
                  const SizedBox(width: 4),
                  Text(
                    '${ref.read(bookingDraftProvider).adults} người lớn · ${ref.read(bookingDraftProvider).roomCount} phòng',
                    style: const TextStyle(fontSize: 12, color: muted),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Số tiền thanh toán',
              style: TextStyle(fontSize: 14, color: muted),
            ),
            Text(
              vnd(ref.read(bookingDraftProvider).booking?['total_vnd']),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: teal,
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _option(
    int index,
    int asset,
    String title,
    String subtitle, {
    bool recommended = false,
    bool badges = false,
    bool disabled = false,
  }) {
    final active = selected == index;
    return Opacity(
      opacity: disabled ? .5 : 1,
      child: InkWell(
        onTap: disabled ? null : () => setState(() => selected = index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: disabled ? const Color(0xFFF0F4F4) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: disabled
                ? null
                : const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: active
                    ? const Color(0xFFE6F2F1)
                    : const Color(0xFFEAEFEE),
                child: svg(asset, 19, 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: disabled ? const Color(0xFF98A2B3) : ink,
                            ),
                          ),
                        ),
                        if (recommended) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: teal,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'KHUYÊN DÙNG',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                        if (badges) ...[
                          const SizedBox(width: 4),
                          const Text(
                            'VISA  MC',
                            style: TextStyle(fontSize: 10, color: muted),
                          ),
                        ],
                        if (disabled) ...[
                          const SizedBox(width: 3),
                          svg(8, 9, 12),
                        ],
                      ],
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: disabled ? const Color(0xFF98A2B3) : muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: active ? teal : const Color(0xFFEAEFEE),
                  shape: BoxShape.circle,
                ),
                child: active
                    ? const Center(
                        child: CircleAvatar(
                          radius: 4,
                          backgroundColor: Colors.white,
                        ),
                      )
                    : disabled
                    ? svg(9, 12, 12)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
