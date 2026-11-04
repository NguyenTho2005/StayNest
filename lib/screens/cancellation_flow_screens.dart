import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/bottom_navigation.dart';
import '../widgets/figma_asset.dart';

const _ink = Color(0xFF182230);
const _muted = Color(0xFF667085);
const _teal = Color(0xFF006768);
const _bg = Color(0xFFF7F9FC);

BoxDecoration _card() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(14),
  boxShadow: const [
    BoxShadow(color: Color(0x10172B4D), blurRadius: 8, offset: Offset(0, 4)),
  ],
);
Widget _header(BuildContext context, String title) => Container(
  height: 56,
  color: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 20),
  child: Row(
    children: [
      InkWell(
        onTap: () =>
            context.canPop() ? context.pop() : context.go('/trips/booking'),
        child: const Icon(Icons.arrow_back, size: 20, color: _ink),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _ink,
          ),
        ),
      ),
      const Icon(Icons.help_outline, color: _muted, size: 18),
      const SizedBox(width: 14),
      const CircleAvatar(
        radius: 16,
        backgroundColor: _teal,
        child: Icon(Icons.person_outline, color: Colors.white, size: 16),
      ),
    ],
  ),
);
Widget _row(String label, String value, {Color valueColor = _ink}) => Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Flexible(
      child: Text(label, style: const TextStyle(fontSize: 12, color: _muted)),
    ),
    Text(
      value,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: valueColor,
      ),
    ),
  ],
);
Widget _button(
  String label,
  VoidCallback? onPressed, {
  bool secondary = false,
}) => SizedBox(
  height: 50,
  width: double.infinity,
  child: ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: secondary ? Colors.white : _teal,
      disabledBackgroundColor: secondary ? Colors.white : _teal,
      foregroundColor: secondary ? _ink : Colors.white,
      disabledForegroundColor: secondary ? _ink : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
    ),
    child: Text(
      label,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    ),
  ),
);

class CancellationStartScreen extends StatelessWidget {
  const CancellationStartScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            _header(context, 'Chính Sách Huỷ Phòng'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBED),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 17,
                            backgroundColor: Color(0xFFFFEBCB),
                            child: Icon(
                              Icons.warning_amber,
                              size: 20,
                              color: Color(0xFFFF9900),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bạn muốn hủy đặt phòng?',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: _ink,
                                  ),
                                ),
                                Text(
                                  'Vui lòng kiểm tra thông tin đặt phòng và khoản hoàn tiền dự kiến trước khi tiếp tục.',
                                  style: TextStyle(
                                    fontSize: 13,
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
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'MÃ ĐẶT PHÒNG  SN-1024',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _ink,
                                  ),
                                ),
                              ),
                              Text(
                                '● Đã xác nhận',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF0ABC77),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(8),
                            color: const Color(0xFFF0F4F4),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: const FigmaRaster(
                                    'assets/images/scr_087_00.jpg',
                                    width: 68,
                                    height: 68,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Mây Homestay',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: _ink,
                                        ),
                                      ),
                                      Text(
                                        'Phòng Studio có bếp',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: _muted,
                                        ),
                                      ),
                                      Text(
                                        '⌖ Hội An, Quảng Nam',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: _teal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          _row('Khách lưu trú', 'Nguyễn An'),
                          const SizedBox(height: 16),
                          _row('Thời gian', '14/11/2026 – 16/11/2026'),
                          const SizedBox(height: 16),
                          _row('Số khách & phòng', '2 người lớn · 1 phòng'),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(10),
                            color: const Color(0xFFF0F4F4),
                            child: _row(
                              'Tổng thanh toán đã trả',
                              '1.800.000đ',
                              valueColor: _teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4F4),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            '◈ Chính sách hủy phòng',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _ink,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _policy(
                            'Hủy trước 18:00, 12/11/2026',
                            'Hoàn tiền 100% (1.800.000đ)',
                            const Color(0xFF00A86B),
                          ),
                          _policy(
                            'Sau 18:00 12/11 – Trước khi nhận phòng',
                            'Hoàn tiền 50% (900.000đ)',
                            _muted,
                          ),
                          _policy(
                            'Sau giờ nhận phòng (14/11/2026)',
                            'Không hoàn lại tiền',
                            _muted,
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            color: const Color(0xFFFFFBED),
                            child: const Text(
                              'ⓘ Yêu cầu hủy chỉ là thao tác mô phỏng trong bản prototype StayNest. Sau khi xác nhận hủy, trạng thái đặt phòng sẽ chuyển sang Đã hủy.',
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.5,
                                color: Color(0xFFFF9900),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Center(
                      child: Text(
                        'Tiếp tục bước tính toán hoàn tiền',
                        style: TextStyle(fontSize: 11, color: _muted),
                      ),
                    ),
                    const SizedBox(height: 6),
                    _button(
                      'Xem số tiền hoàn →',
                      () => context.push('/trips/booking/refund-estimate'),
                    ),
                    const SizedBox(height: 10),
                    _button(
                      'Quay lại chi tiết đặt phòng',
                      () => context.go('/trips/booking'),
                      secondary: true,
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

  Widget _policy(String title, String value, Color color) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: _ink,
          ),
        ),
        const SizedBox(height: 5),
        Text(value, style: TextStyle(fontSize: 12, color: color)),
      ],
    ),
  );
}

class RefundEstimateScreen extends StatelessWidget {
  const RefundEstimateScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            _header(context, 'Chính Sách Huỷ Phòng'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(26, 14, 26, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Mã đặt phòng  SN-1024',
                            style: TextStyle(fontSize: 12, color: _muted),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Mây Homestay · Phòng Studio có bếp',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: _ink,
                                  ),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: const FigmaRaster(
                                  'assets/images/scr_088_00.jpg',
                                  width: 42,
                                  height: 42,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            color: const Color(0xFFF0F4F4),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '▣ 14/11/2026 – 16/11/2026',
                                    style: TextStyle(fontSize: 11, color: _muted),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Đã thanh toán\n1.800.000đ',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(fontSize: 11, color: _ink),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Điều kiện hoàn tiền',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: _ink,
                                  ),
                                ),
                              ),
                              Text(
                                'Chính sách linh hoạt',
                                style: TextStyle(fontSize: 10, color: _muted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _stage(
                            'Trước 12/11/2026, 18:00',
                            'Hoàn 100%',
                            '1.800.000đ',
                            selected: true,
                          ),
                          const SizedBox(height: 12),
                          _stage(
                            'Sau 12/11/2026, 18:00',
                            'Hoàn 50%',
                            '900.000đ',
                          ),
                          const SizedBox(height: 12),
                          _stage(
                            'Sau khi nhận phòng',
                            '0% — Không hoàn tiền',
                            '0đ',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'TRƯỜNG HỢP MINH HỌA HIỆN TẠI',
                            style: TextStyle(fontSize: 11, color: _teal),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            '◉ Bạn đang ở trước hạn · Hoàn 100%',
                            style: TextStyle(fontSize: 12, color: _teal),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Số tiền dự kiến được hoàn:',
                            style: TextStyle(fontSize: 12, color: _muted),
                          ),
                          const Text(
                            '1.800.000đ  (Toàn phần)',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: _teal,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            '◷ Thời gian xử lý hoàn tiền dự kiến: 3–7 ngày làm việc.',
                            style: TextStyle(fontSize: 12, color: _muted),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Khoản hoàn tiền trên là số tiền ước tính trong prototype. Không phải xác nhận hoàn tiền thực tế.',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: _muted,
                            ),
                          ),
                          const SizedBox(height: 18),
                          InkWell(
                            onTap: () =>
                                context.push('/booking/transaction-terms'),
                            child: const Text(
                              'Xem đầy đủ chính sách hủy →',
                              style: TextStyle(fontSize: 12, color: _teal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    _button(
                      'Tiếp tục hủy →',
                      () => context.push('/trips/booking/cancel/reason'),
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

  Widget _stage(
    String title,
    String label,
    String amount, {
    bool selected = false,
  }) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: selected ? const Color(0xFFEAF7F6) : const Color(0xFFF0F4F4),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 12, color: selected ? _teal : _muted),
        ),
        const SizedBox(height: 9),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 14, color: selected ? _teal : _ink),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              amount,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: selected ? _teal : _muted,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class CancellationReasonScreen extends StatefulWidget {
  const CancellationReasonScreen({super.key});
  @override
  State<CancellationReasonScreen> createState() =>
      _CancellationReasonScreenState();
}

class _CancellationReasonScreenState extends State<CancellationReasonScreen> {
  int reason = 0;
  bool agreed = true;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFFFF4F4),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            _header(context, 'Xác Nhận Huỷ Phòng'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(26, 14, 26, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: _card(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Mây Homestay',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: _ink,
                                ),
                              ),
                              Text(
                                'SN-1024',
                                style: TextStyle(fontSize: 11, color: _teal),
                              ),
                            ],
                          ),
                          const Text(
                            'Phòng Studio có bếp',
                            style: TextStyle(fontSize: 12, color: _muted),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            '▣ 14–16/11/2026 (2 đêm)',
                            style: TextStyle(fontSize: 11, color: _muted),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            color: const Color(0xFFF0F4F4),
                            child: _row(
                              'Hoàn dự kiến:',
                              '1.800.000đ  100%',
                              valueColor: _teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Vì sao bạn muốn hủy?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Lựa chọn của bạn giúp Mây Homestay và StayNest nâng cao dịch vụ.',
                      style: TextStyle(fontSize: 12, color: _muted),
                    ),
                    const SizedBox(height: 14),
                    _option(0, Icons.event_busy, 'Thay đổi lịch trình'),
                    _option(1, Icons.swap_horiz, 'Tìm được chỗ khác'),
                    _option(2, Icons.person_off_outlined, 'Vấn đề cá nhân'),
                    _option(3, Icons.more_horiz, 'Khác'),
                    const SizedBox(height: 16),
                    const Text(
                      'Thông tin bổ sung (không bắt buộc)',
                      style: TextStyle(fontSize: 12, color: _muted),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 108,
                      padding: const EdgeInsets.all(12),
                      decoration: _card(),
                      child: const TextField(
                        maxLength: 250,
                        maxLines: 4,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Chia sẻ thêm nếu bạn muốn…',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF98A2B3),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: _card(),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () => setState(() => agreed = !agreed),
                            child: Row(
                              children: [
                                Icon(
                                  agreed
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  color: _teal,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    'Tôi đã đọc và hiểu chính sách hủy và hoàn tiền',
                                    style: TextStyle(fontSize: 13, color: _ink),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            color: const Color(0xFFF0F4F4),
                            child: const Text(
                              'Trường hợp minh họa hiện tại đủ điều kiện hoàn 100%, tương đương 1.800.000đ. Thời gian xử lý hoàn tiền dự kiến 3–7 ngày làm việc.',
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.5,
                                color: _muted,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: () =>
                                context.push('/booking/transaction-terms'),
                            child: const Text(
                              'Xem chi tiết chính sách hủy →',
                              style: TextStyle(fontSize: 12, color: _teal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _button(
                      'Xác nhận hủy →',
                      () => context.push('/trips/booking/cancel/success-demo'),
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

  Widget _option(int index, IconData icon, String title) => InkWell(
    onTap: () => setState(() => reason = index),
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: _card(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: const Color(0xFFEAF7F6),
            child: Icon(icon, color: _teal, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _ink,
              ),
            ),
          ),
          CircleAvatar(
            radius: 10,
            backgroundColor: reason == index ? _teal : const Color(0xFFEAEFEE),
            child: reason == index
                ? const CircleAvatar(radius: 4, backgroundColor: Colors.white)
                : null,
          ),
        ],
      ),
    ),
  );
}

class CancellationSuccessScreen extends StatelessWidget {
  const CancellationSuccessScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(18, 66, 18, 26),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundColor: Color(0xFFEAF7F6),
                child: CircleAvatar(
                  radius: 24,
                  backgroundColor: _teal,
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '● Đã hủy',
                style: TextStyle(fontSize: 12, color: Color(0xFFD92D20)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Đã hủy đặt phòng',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Yêu cầu hủy đặt phòng đã được ghi nhận trong bản mô phỏng. Bạn có thể theo dõi trạng thái hoàn tiền ở bước tiếp theo.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, height: 1.5, color: _muted),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: _card(),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Khoản hoàn tiền dự kiến',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _ink,
                            ),
                          ),
                        ),
                        Text(
                          '● Đang xử lý',
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFFFF9900),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      color: const Color(0xFFEAF7F6),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tổng số tiền hoàn (100%)',
                            style: TextStyle(fontSize: 11, color: _muted),
                          ),
                          Text(
                            '1.800.000đ',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: _teal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _row('Lý do hủy', 'Hủy trước hạn (minh họa)'),
                    const SizedBox(height: 10),
                    _row('Thời gian xử lý', '3–7 ngày làm việc'),
                    const SizedBox(height: 10),
                    _row('Phương thức nhận', 'Thẻ ban đầu'),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(10),
                      color: const Color(0xFFF0F4F4),
                      child: const Text(
                        'Khoản hoàn tiền chưa được xác nhận là đã về tài khoản. Thông tin này là trạng thái minh họa của prototype.',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.5,
                          color: _muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: _card(),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'Chi tiết đặt phòng đã hủy',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _ink,
                            ),
                          ),
                        ),
                        Text(
                          'Đã hủy',
                          style: TextStyle(fontSize: 11, color: _muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: const FigmaRaster(
                            'assets/images/scr_090_00.jpg',
                            width: 62,
                            height: 62,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mây Homestay',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: _ink,
                                ),
                              ),
                              Text(
                                'Phòng Studio có bếp nhỏ',
                                style: TextStyle(fontSize: 12, color: _muted),
                              ),
                              Text(
                                '★ 4.92  Hội An, Quảng Nam',
                                style: TextStyle(fontSize: 11, color: _muted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _row('Mã đặt phòng', 'SN-1024'),
                    const SizedBox(height: 8),
                    _row('Thời gian lưu trú', '14/11/2026 – 16/11/2026'),
                    const SizedBox(height: 8),
                    _row('Người đặt phòng', 'Nguyễn An'),
                    const SizedBox(height: 8),
                    _row('Số tiền đã thanh toán', '1.800.000đ'),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: _card(),
                child: const Row(
                  children: [
                    Icon(Icons.support_agent, color: _teal),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Cần hỗ trợ về hoàn tiền?\nĐội ngũ chăm sóc khách hàng 24/7',
                        style: TextStyle(fontSize: 11, color: _ink),
                      ),
                    ),
                    Text(
                      'Liên hệ',
                      style: TextStyle(fontSize: 12, color: _teal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _button(
                '◷ Danh sách đơn đã hủy',
                () => context.push('/trips/cancelled-demo'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class CancelledTripsScreen extends StatelessWidget {
  const CancelledTripsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            Container(
              height: 56,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: const Row(
                children: [
                  Icon(Icons.luggage_outlined, color: _teal),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Đơn Đã Hủy',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                      ),
                    ),
                  ),
                  Icon(Icons.notifications_none, size: 20),
                  SizedBox(width: 12),
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: _teal,
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 50,
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Sắp tới',
                    style: TextStyle(fontSize: 14, color: _muted),
                  ),
                  Text(
                    'Đã hoàn thành',
                    style: TextStyle(fontSize: 14, color: _muted),
                  ),
                  Text(
                    'Đã hủy  1',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _teal,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(30, 16, 30, 20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'ⓘ Đơn phòng của bạn đã hủy thành công. StayNest luôn đồng hành và bảo vệ trọn vẹn quyền lợi hoàn tiền của bạn.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.4,
                          color: _ink,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: _card(),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Mã đặt phòng:  SN-1024',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _ink,
                                ),
                              ),
                              Text(
                                '● Đã hủy',
                                style: TextStyle(fontSize: 11, color: _muted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: const FigmaRaster(
                                  'assets/images/scr_091_00.jpg',
                                  width: 90,
                                  height: 90,
                                ),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '⌖ Hội An, Quảng Nam',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _muted,
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
                                      'Phòng Studio có bếp',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _muted,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      '▣ 14/11 – 16/11/2026 · 2 đêm',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _row('Đã thanh toán ban đầu:', '1.800.000đ'),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(14),
                            color: const Color(0xFFEAF7F6),
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Tiền hoàn dự kiến',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _ink,
                                      ),
                                    ),
                                    Text(
                                      '● Đang hoàn tiền',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFFFF9900),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Text(
                                  '1.800.000đ',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: _teal,
                                  ),
                                ),
                                Text(
                                  '100% GIÁ TRỊ PHÒNG',
                                  style: TextStyle(fontSize: 10, color: _muted),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Khoản hoàn tiền đang được xử lý trong bản mô phỏng.',
                                  style: TextStyle(fontSize: 11, color: _muted),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _button(
                            'Chi tiết hoàn tiền →',
                            () => context.push('/trips/refund-tracking-demo'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: const Row(
                        children: [
                          Icon(Icons.support_agent, color: _teal),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Cần hỗ trợ về đơn đã hủy?\nĐội ngũ StayNest sẵn sàng 24/7',
                              style: TextStyle(fontSize: 12, color: _ink),
                            ),
                          ),
                          Text(
                            'Liên hệ',
                            style: TextStyle(fontSize: 12, color: _teal),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      color: const Color(0xFFF0F4F4),
                      child: const Text(
                        'Chính sách hủy minh bạch\nMọi giao dịch hoàn tiền tuân thủ quy chuẩn bảo mật giao dịch ngân hàng và được hoàn về đúng phương thức thanh toán gốc của bạn.',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.5,
                          color: _muted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const StayNestBottomNavigation(selectedIndex: 3),
          ],
        ),
      ),
    ),
  );
}
