import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/staynest_api.dart';

import '../widgets/figma_asset.dart';

class CouponListScreen extends ConsumerStatefulWidget {
  const CouponListScreen({super.key});
  @override
  ConsumerState<CouponListScreen> createState() => _CouponListScreenState();
}

class _CouponListScreenState extends ConsumerState<CouponListScreen> {
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  static const teal = Color(0xFF006768);
  bool available = true;
  bool codeAvailable = false;
  bool selected = true;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      try {
        final codes = await ref.read(stayNestApiProvider).vouchers();
        if (!mounted) return;
        setState(() {
          codeAvailable = codes.any((item) => item['code'] == 'STAY100');
          loading = false;
        });
      } catch (caught) {
        if (mounted) {
          setState(() {
            error = '$caught';
            loading = false;
          });
        }
      }
    });
  }

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
                        : context.go('/booking/price'),
                    icon: const Icon(Icons.arrow_back, size: 20),
                  ),
                  const Expanded(
                    child: Text(
                      'Danh Sách Mã Giảm Giá',
                      textAlign: TextAlign.center,
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _card(
                      Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF7F6),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: const Center(
                              child: FigmaSvg(
                                'assets/icons/coupon_065_01.svg',
                                width: 18,
                                height: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mây Homestay • ${ref.read(bookingDraftProvider).selectedRoomName}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: ink,
                                  ),
                                ),
                                Text(
                                  '${ref.read(bookingDraftProvider).checkInIso} – ${ref.read(bookingDraftProvider).checkOutIso} (${ref.read(bookingDraftProvider).nights} đêm)',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Tạm tính',
                                style: TextStyle(fontSize: 10, color: muted),
                              ),
                              Text(
                                '1.900.000đ',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: teal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    _card(
                      const Row(
                        children: [
                          Icon(Icons.sell_outlined, size: 18, color: muted),
                          SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              'STAY100',
                              style: TextStyle(fontSize: 13, color: ink),
                            ),
                          ),
                          Text(
                            'Đổi mã',
                            style: TextStyle(fontSize: 11, color: teal),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        _tab('● Có thể dùng (1)', true),
                        const SizedBox(width: 8),
                        _tab('Đã hết hạn (0)', false),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (available) ...[
                      InkWell(
                        onTap: () => setState(() => selected = !selected),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(15, 18, 15, 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: const Border(
                              top: BorderSide(color: teal, width: 5),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEAF7F6),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.confirmation_number_outlined,
                                      color: teal,
                                      size: 23,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'STAY100   GIẢM TRỰC TIẾP',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: ink,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Giảm 100.000đ',
                                          style: TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.w700,
                                            color: teal,
                                          ),
                                        ),
                                        Text(
                                          'Áp dụng cho đơn từ 1.500.000đ',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: muted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    selected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_unchecked,
                                    color: teal,
                                    size: 24,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              const Divider(color: Color(0xFFDDE3E7)),
                              const SizedBox(height: 24),
                              const Row(
                                children: [
                                  Text(
                                    '✿ Đủ điều kiện áp dụng',
                                    style: TextStyle(fontSize: 11, color: teal),
                                  ),
                                  Spacer(),
                                  Text(
                                    'HSD: 30/11/2026',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: muted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'ⓘ Mã giảm giá chỉ áp dụng theo điều kiện của chương trình. Ưu đãi sẽ được tự động trừ vào tổng thanh toán.',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.5,
                          color: muted,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _card(
                        const Row(
                          children: [
                            CircleAvatar(
                              radius: 19,
                              backgroundColor: Color(0xFFEAF0FE),
                              child: Icon(
                                Icons.notifications_active_outlined,
                                color: teal,
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Săn thêm mã ưu đãi?',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: ink,
                                    ),
                                  ),
                                  Text(
                                    'Theo dõi homestay để nhận voucher độc quyền mỗi tuần.',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(Icons.chevron_right, color: muted),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tiết kiệm được',
                              style: TextStyle(fontSize: 10, color: muted),
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
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Còn lại',
                            style: TextStyle(fontSize: 10, color: muted),
                          ),
                          Text(
                            '1.800.000đ',
                            style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                              color: ink,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (loading) const Center(child: CircularProgressIndicator()),
                  if (error != null)
                    Text(error!, style: const TextStyle(color: Colors.red)),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed:
                          loading ||
                              error != null ||
                              (selected && !codeAvailable)
                          ? null
                          : () {
                              final draft = ref.read(bookingDraftProvider);
                              draft.promotionCode = selected ? 'STAY100' : null;
                              draft.idempotencyKey = null;
                              draft.booking = null;
                              context.pop();
                            },
                      icon: const Icon(Icons.check),
                      label: const Text('Áp dụng'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: teal,
                        disabledBackgroundColor: const Color(0xFF9AA9A9),
                        disabledForegroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
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

  Widget _card(Widget child) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );
  Widget _tab(String label, bool target) => InkWell(
    onTap: () => setState(() => available = target),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: available == target
            ? const Color(0xFFEAF7F6)
            : const Color(0xFFEAF0F2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: available == target ? teal : muted,
        ),
      ),
    ),
  );
}
