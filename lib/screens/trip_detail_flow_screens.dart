import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/bottom_navigation.dart';
import '../widgets/figma_asset.dart';

const _teal = Color(0xFF006768);
const _ink = Color(0xFF182230);
const _muted = Color(0xFF667085);
const _bg = Color(0xFFF7F9FC);

BoxDecoration _card() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  boxShadow: const [
    BoxShadow(color: Color(0x0D000000), blurRadius: 3, offset: Offset(0, 1)),
  ],
);
Widget _row(String label, String value) => Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(label, style: const TextStyle(fontSize: 12, color: _muted)),
    Text(value, style: const TextStyle(fontSize: 12, color: _ink)),
  ],
);
Widget _button(String title, VoidCallback? onPressed) => SizedBox(
  width: double.infinity,
  height: 48,
  child: ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: _teal,
      disabledBackgroundColor: _teal,
      foregroundColor: Colors.white,
      disabledForegroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    child: Text(
      title,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  ),
);
Widget _tripTop(BuildContext context, String title, {String? status}) => Column(
  children: [
    Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: Colors.white,
      child: Row(
        children: [
          const CircleAvatar(
            radius: 14,
            backgroundColor: Color(0xFFEAF7F6),
            child: Icon(Icons.luggage_outlined, size: 16, color: _teal),
          ),
          const SizedBox(width: 8),
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
          const Icon(Icons.notifications_none, size: 18),
          const SizedBox(width: 14),
          const CircleAvatar(
            radius: 14,
            backgroundColor: _teal,
            child: Icon(Icons.person_outline, size: 14, color: Colors.white),
          ),
        ],
      ),
    ),
    Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          InkWell(
            onTap: () =>
                context.canPop() ? context.pop() : context.go('/trips'),
            child: const Icon(Icons.arrow_back, size: 18, color: _ink),
          ),
          const Spacer(),
          if (status != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F4),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                status,
                style: const TextStyle(fontSize: 11, color: _muted),
              ),
            ),
          if (status == null)
            const Text(
              'Chi tiết đặt phòng',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _ink,
              ),
            ),
          const Spacer(),
          if (status == null)
            const Icon(Icons.share_outlined, size: 16, color: _ink),
        ],
      ),
    ),
  ],
);

class BookingDetailScreen extends StatelessWidget {
  const BookingDetailScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            _tripTop(context, 'Chuyen Di'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 12, 18, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: _card(),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '● Đã xác nhận',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF0ABC77),
                                ),
                              ),
                              Spacer(),
                              Text(
                                'MÃ: SN-1024',
                                style: TextStyle(fontSize: 10, color: _muted),
                              ),
                            ],
                          ),
                          Text(
                            '● Đã thanh toán',
                            style: TextStyle(fontSize: 11, color: _teal),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Chuyến đi đã sẵn sàng!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _ink,
                            ),
                          ),
                          Text(
                            'Chủ nhà đã giữ chỗ và chuẩn bị đón bạn tại Hội An.',
                            style: TextStyle(fontSize: 12, color: _muted),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: _card(),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: const FigmaRaster(
                              'assets/images/scr_082_00.jpg',
                              width: 82,
                              height: 82,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '★ 4.92',
                                  style: TextStyle(fontSize: 11, color: _teal),
                                ),
                                Text(
                                  'HOMESTAY TIÊU CHUẨN',
                                  style: TextStyle(fontSize: 10, color: _teal),
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
                                  'Phòng Studio có bếp riêng',
                                  style: TextStyle(fontSize: 12, color: _muted),
                                ),
                                Text(
                                  '⌖ Hội An, Quảng Nam',
                                  style: TextStyle(fontSize: 11, color: _muted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '▣ Lịch trình lưu trú',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _ink,
                                ),
                              ),
                              Text(
                                '2 đêm',
                                style: TextStyle(fontSize: 11, color: _muted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _date(
                                  'Nhận phòng',
                                  '14:00',
                                  '14/11/2026',
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _date(
                                  'Trả phòng',
                                  '12:00',
                                  '16/11/2026',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _row('Số lượng khách', '2 người lớn · 1 phòng'),
                          const Divider(height: 24),
                          const Text(
                            'THÔNG TIN NGƯỜI ĐẶT',
                            style: TextStyle(fontSize: 11, color: _muted),
                          ),
                          const SizedBox(height: 8),
                          _row('Họ và tên', 'Nguyễn An'),
                          const SizedBox(height: 6),
                          _row('Email', 'an.demo@example.com'),
                          const SizedBox(height: 6),
                          _row('Số điện thoại', '0900 000 123'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '▣ Chi tiết thanh toán',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _ink,
                                ),
                              ),
                              Text(
                                'ĐÃ HOÀN TẤT',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF0ABC77),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _row('Tiền phòng (2 đêm)', '1.700.000đ'),
                          const SizedBox(height: 8),
                          _row('Thuế (VAT 10%)', '170.000đ'),
                          const SizedBox(height: 8),
                          _row('Phí dịch vụ StayNest', '30.000đ'),
                          const SizedBox(height: 8),
                          _row('Mã giảm giá STAY100', '-100.000đ'),
                          const Divider(height: 24),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tổng đã thanh toán',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _ink,
                                ),
                              ),
                              Text(
                                '1.800.000đ',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: _teal,
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
                      children: [
                        Text(
                          'Quản lý đặt phòng',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _ink,
                          ),
                        ),
                        Text(
                          'Hỗ trợ 24/7',
                          style: TextStyle(fontSize: 11, color: _muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: _card(),
                      child: Column(
                        children: [
                          _action(
                            context,
                            Icons.confirmation_number_outlined,
                            'Xem voucher đặt phòng',
                            'Mã xác nhận DEMO-1024',
                            '/trips/booking/voucher',
                          ),
                          _action(
                            context,
                            Icons.directions_outlined,
                            'Chỉ đường & Liên hệ',
                            'Vị trí tại Hội An & Nhắn host',
                            '/trips/booking/directions',
                          ),
                          _action(
                            context,
                            Icons.calendar_month_outlined,
                            'Yêu cầu đổi ngày',
                            'Đề xuất đổi lịch lưu trú',
                            '/trips/booking/change-dates',
                          ),
                          _action(
                            context,
                            Icons.receipt_long_outlined,
                            'Biên nhận thanh toán',
                            'Xem và lưu biên nhận 1.800.000đ',
                            '/booking/receipt-demo',
                          ),
                          _action(
                            context,
                            Icons.help_outline,
                            'Trợ giúp & Hỗ trợ',
                            'Trung tâm giải đáp thắc mắc',
                            '/trips/help',
                          ),
                          _action(
                            context,
                            Icons.cancel_outlined,
                            'Hủy đặt phòng',
                            'Xem chính sách hoàn tiền linh hoạt',
                            '/trips/booking/cancel',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Mẹo cho chuyến đi: Hãy tải sẵn voucher hoặc lưu offline để thủ tục nhận phòng tại Mây Homestay diễn ra nhanh chóng nhất ngay cả khi không có kết nối mạng.',
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

  Widget _date(String label, String time, String date) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFFF0F4F4),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: _muted)),
        Text(
          time,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: _ink,
          ),
        ),
        Text(date, style: const TextStyle(fontSize: 11, color: _muted)),
      ],
    ),
  );
  Widget _action(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    String route,
  ) => InkWell(
    onTap: () => context.push(route),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: const Color(0xFFEAF7F6),
            child: Icon(icon, color: _teal, size: 17),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _ink,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: _muted),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 16, color: _muted),
        ],
      ),
    ),
  );
}

class BookingVoucherScreen extends StatelessWidget {
  const BookingVoucherScreen({super.key});
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
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go('/trips/booking'),
                    child: const Icon(Icons.arrow_back, size: 20),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Voucher Dat Phong',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _ink,
                      ),
                    ),
                  ),
                  const Icon(Icons.share_outlined, size: 19),
                  const SizedBox(width: 16),
                  const CircleAvatar(
                    radius: 16,
                    backgroundColor: _teal,
                    child: Icon(
                      Icons.person_outline,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(26, 12, 26, 24),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '✿ Đặt phòng hợp lệ trên StayNest',
                          style: TextStyle(fontSize: 12, color: _teal),
                        ),
                        Text(
                          '#SN-1024',
                          style: TextStyle(fontSize: 12, color: _muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: _card(),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            color: _teal,
                            child: const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '◈ StayNest',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '● ĐÃ XÁC NHẬN · DEMO',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 14),
                                Text(
                                  'VOUCHER XÁC NHẬN ĐẶT PHÒNG',
                                  style: TextStyle(
                                    fontSize: 13,
                                    letterSpacing: 1,
                                    color: Color(0xFFB9DFDD),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Mây Homestay',
                                            style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w700,
                                              color: _ink,
                                            ),
                                          ),
                                          Text(
                                            'Phòng Studio có bếp',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: _teal,
                                            ),
                                          ),
                                          Text(
                                            '⌖ Hội An, Quảng Nam',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: _muted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: const FigmaRaster(
                                        'assets/images/scr_083_00.jpg',
                                        width: 60,
                                        height: 60,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF0F4F4),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: _ink,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Mã xác nhận',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: _muted,
                                            ),
                                          ),
                                          Text(
                                            'DEMO-1024',
                                            style: TextStyle(
                                              fontSize: 16,
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
                                _row('Khách lưu trú', 'Nguyễn An'),
                                const SizedBox(height: 15),
                                _row(
                                  'Lịch trình',
                                  '14/11/2026 – 16/11/2026 (2 đêm)',
                                ),
                                const SizedBox(height: 15),
                                _row(
                                  'Nhận / Trả phòng',
                                  'Nhận 14:00 · Trả 12:00',
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            height: 30,
                            indent: 16,
                            endIndent: 16,
                            color: Color(0xFFB9D5D4),
                          ),
                          const _DemoQrGraphic(),
                          const SizedBox(height: 12),
                          const Text(
                            'MÃ MÔ PHỎNG',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: _ink,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(28, 8, 28, 22),
                            child: Text(
                              'Voucher này chỉ minh họa thông tin đặt phòng trong prototype, không dùng để nhận phòng thực tế.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.5,
                                color: _muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    _button('⇩ Lưu voucher', null),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton(
                        onPressed: null,
                        style: OutlinedButton.styleFrom(
                          disabledForegroundColor: _teal,
                          side: const BorderSide(color: Color(0xFFBBDDDC)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          '♧ Chia sẻ voucher',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextButton(
                      onPressed: () => context.go('/trips/booking'),
                      child: const Text(
                        'Quay lại chi tiết đặt phòng',
                        style: TextStyle(fontSize: 14, color: _muted),
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
}

class _DemoQrGraphic extends StatelessWidget {
  const _DemoQrGraphic();

  @override
  Widget build(BuildContext context) => Container(
    width: 138,
    height: 138,
    padding: const EdgeInsets.all(11),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFE6ECEC),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const Positioned(top: 10, left: 10, child: _QrFinder()),
        const Positioned(top: 10, right: 10, child: _QrFinder()),
        const Positioned(bottom: 10, left: 10, child: _QrFinder()),
        Positioned(
          top: 57,
          left: 50,
          child: SizedBox(
            width: 30,
            child: Wrap(
              spacing: 3,
              runSpacing: 3,
              children: List.generate(
                8,
                (index) => CircleAvatar(
                  radius: 2.5,
                  backgroundColor: index == 5 ? _teal : const Color(0xFF52615F),
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          bottom: 9,
          right: 9,
          child: Text('SN', style: TextStyle(fontSize: 9, color: _teal)),
        ),
      ],
    ),
  );
}

class _QrFinder extends StatelessWidget {
  const _QrFinder();

  @override
  Widget build(BuildContext context) => Container(
    width: 35,
    height: 35,
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(border: Border.all(color: _ink, width: 5)),
    child: Container(color: _ink),
  );
}

class DirectionsContactScreen extends StatelessWidget {
  const DirectionsContactScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            _tripTop(
              context,
              'Chi Tiet Chuyen Di',
              status: 'Mã đặt phòng: SN-1024',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2F1ED),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          const Positioned.fill(child: _FigmaMapCanvas()),
                          const Positioned(
                            top: 12,
                            left: 12,
                            child: Text(
                              '● Bản đồ minh họa',
                              style: TextStyle(fontSize: 11, color: _teal),
                            ),
                          ),
                          const Positioned(
                            top: 90,
                            left: 130,
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: _teal,
                              child: FigmaSvg(
                                'assets/icons/scr_084_18.svg',
                                width: 13.333,
                                height: 16.667,
                              ),
                            ),
                          ),
                          const Positioned(
                            top: 42,
                            left: 95,
                            child: Text(
                              'Phố Cổ Hội An',
                              style: TextStyle(fontSize: 11, color: _teal),
                            ),
                          ),
                          const Positioned(
                            bottom: 42,
                            right: 28,
                            child: Text(
                              'Sông Thu Bồn',
                              style: TextStyle(fontSize: 10, color: _muted),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'ⓘ Vị trí được minh họa ở mức khu vực Hội An. Vui lòng xác nhận địa chỉ cụ thể với chỗ ở trước khi xuất phát.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.5,
                        color: _muted,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: _card(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            '⌂ Homestay nguyên căn',
                            style: TextStyle(fontSize: 11, color: _teal),
                          ),
                          const Text(
                            'Mây Homestay',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _ink,
                            ),
                          ),
                          const Text(
                            '⌖ Khu vực Hội An, Quảng Nam',
                            style: TextStyle(fontSize: 12, color: _muted),
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(12),
                            color: const Color(0xFFF0F4F4),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '▣ 14 – 16/11/2026',
                                  style: TextStyle(fontSize: 12, color: _muted),
                                ),
                                Text(
                                  'SN-1024',
                                  style: TextStyle(fontSize: 12, color: _ink),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            height: 46,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF7F6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              '➤ Chỉ đường mô phỏng',
                              style: TextStyle(fontSize: 13, color: _teal),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      'Liên hệ chỗ ở',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Liên hệ và tin nhắn với chủ nhà được mô phỏng trong bản prototype này.',
                      style: TextStyle(fontSize: 12, color: _muted),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: Column(
                        children: [
                          const Row(
                            children: [
                              CircleAvatar(
                                radius: 22,
                                backgroundColor: Color(0xFFEAF7F6),
                                child: Icon(Icons.person, color: _teal),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Chủ nhà Mây Homestay',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _ink,
                                      ),
                                    ),
                                    Text(
                                      '● Phản hồi nhanh trong 15 phút',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _muted,
                                      ),
                                    ),
                                    Text(
                                      'Tiếng Việt · English',
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
                          const SizedBox(height: 12),
                          _button(
                            '▤ Nhắn chủ nhà →',
                            () => context.push(
                              '/properties/may-homestay/host-chat',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(12),
                            color: const Color(0xFFF0F4F4),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Hotline hỗ trợ:  0900 000 000',
                                  style: TextStyle(fontSize: 12, color: _teal),
                                ),
                                Text(
                                  'DEMO',
                                  style: TextStyle(fontSize: 10, color: _muted),
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
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4F4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Lưu ý nhận phòng\nGiờ nhận phòng: 14:00 (14/11/2026). Hãy liên hệ trước nếu bạn có dự định đến sớm hơn để chủ nhà chuẩn bị phòng chu đáo nhất.',
                        style: TextStyle(
                          fontSize: 12,
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

class _FigmaMapCanvas extends StatelessWidget {
  const _FigmaMapCanvas();

  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    children: [
      _layer(3, -5, 0, 360, 230),
      _layer(4, -25, -20, 290, 99.23),
      _layer(5, 155, 150, 220, 100),
      _layer(6, -25, 153, 160, 87.27),
      _layer(7, -25, 94, 400, 81.98),
      _layer(8, -26, 100, 402, 46.3),
      _layer(9, 15, -10, 32, 257),
      _layer(10, 115, -10, 46, 256),
      _layer(11, -19, 66, 388, 17),
      _layer(12, 135, 145, 236, 56),
      _layer(13, 215, -10, 65, 255),
      _layer(14, -15, 66, 380.1, 10.5),
      _layer(15, 86, 69, 8, 8),
      _layer(15, 271, 111, 8, 8),
    ],
  );

  Widget _layer(
    int index,
    double left,
    double top,
    double width,
    double height,
  ) => Positioned(
    left: left,
    top: top,
    child: FigmaSvg(
      'assets/icons/scr_084_${index.toString().padLeft(2, '0')}.svg',
      width: width,
      height: height,
    ),
  );
}

class ChangeDatesScreen extends StatefulWidget {
  const ChangeDatesScreen({super.key});
  @override
  State<ChangeDatesScreen> createState() => _ChangeDatesScreenState();
}

class _ChangeDatesScreenState extends State<ChangeDatesScreen> {
  final dates = <int>{16, 18};
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            _tripTop(
              context,
              'Chi Tiet Chuyen Di',
              status: 'Bước 1/2: Yêu cầu gửi',
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: _card(),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: const FigmaRaster(
                              'assets/images/scr_085_00.jpg',
                              width: 50,
                              height: 50,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mã: SN-1024',
                                  style: TextStyle(fontSize: 10, color: _teal),
                                ),
                                Text(
                                  'Mây Homestay',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _ink,
                                  ),
                                ),
                                Text(
                                  'Phòng Studio có bếp · Hội An',
                                  style: TextStyle(fontSize: 11, color: _muted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '▣ Lịch hiện tại',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _ink,
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
                          const SizedBox(height: 12),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Nhận phòng',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: _muted,
                                    ),
                                  ),
                                  Text(
                                    '14/11/2026',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: _ink,
                                    ),
                                  ),
                                  Text(
                                    'Thứ 7 · Từ 14:00',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: _muted,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '2 đêm →',
                                style: TextStyle(fontSize: 11, color: _teal),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Trả phòng',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: _muted,
                                    ),
                                  ),
                                  Text(
                                    '16/11/2026',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: _ink,
                                    ),
                                  ),
                                  Text(
                                    'Thứ 2 · Trước 12:00',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: _muted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Lịch đặt phòng hiện tại vẫn có hiệu lực cho đến khi yêu cầu đổi ngày được chủ nhà xác nhận.',
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.4,
                              color: _muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Chọn ngày mới (Đề xuất)',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _ink,
                            ),
                          ),
                          const Text(
                            'Đang chọn: 16/11 – 18/11 (2 đêm)',
                            style: TextStyle(fontSize: 11, color: _muted),
                          ),
                          const SizedBox(height: 16),
                          const Center(
                            child: Text(
                              '‹       Thg 11/2026       ›',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: _ink,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('T2'),
                              Text('T3'),
                              Text('T4'),
                              Text('T5'),
                              Text('T6'),
                              Text('T7'),
                              Text('CN'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 7,
                                  mainAxisSpacing: 4,
                                  crossAxisSpacing: 4,
                                  childAspectRatio: 1.2,
                                ),
                            itemCount: 35,
                            itemBuilder: (context, index) {
                              final day = index - 5;
                              if (day < 1 || day > 30) {
                                return const SizedBox.shrink();
                              }
                              final selected = dates.contains(day);
                              return InkWell(
                                onTap: () => setState(() {
                                  dates.clear();
                                  dates.add(day);
                                  dates.add((day + 2).clamp(1, 30));
                                }),
                                child: CircleAvatar(
                                  backgroundColor: selected
                                      ? _teal
                                      : Colors.transparent,
                                  child: Text(
                                    '$day',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: selected ? Colors.white : _muted,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 10),
                          const Center(
                            child: Text(
                              '● Lịch cũ          ● Đề xuất mới (16–18/11)',
                              style: TextStyle(fontSize: 11, color: _muted),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            color: const Color(0xFFF0F4F4),
                            child: const Text(
                              'Ngày mới chỉ là đề xuất. Việc đổi lịch phụ thuộc tình trạng phòng trống và cần sự chấp thuận từ chỗ ở.',
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.4,
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
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Dự tính chi phí',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _ink,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _row('Tổng đặt phòng hiện tại', '1.800.000đ'),
                          const SizedBox(height: 8),
                          _row('Ngày đề xuất', '16–18/11/2026 (2 đêm)'),
                          const SizedBox(height: 8),
                          _row('Giá mới', 'Chờ kiểm tra'),
                          const SizedBox(height: 8),
                          _row('Chênh lệch giá', 'Chưa xác định'),
                          const SizedBox(height: 14),
                          const Text(
                            'Gửi yêu cầu không đồng nghĩa với việc đổi lịch đã được xác nhận. Giá phòng có thể thay đổi tùy chính sách thời điểm.',
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.4,
                              color: _muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    _button('Kiểm tra khả dụng →', null),
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

class ChangeDatesResultScreen extends StatelessWidget {
  const ChangeDatesResultScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            _tripTop(context, 'Chuyến Đi', status: 'Bước 2/2: Xác nhận gửi'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 22),
                    const Center(
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: Color(0xFFEAF7F6),
                        child: Icon(Icons.edit_calendar_outlined, color: _teal),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        'Cần chủ nhà xác nhận',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _ink,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Yêu cầu đổi ngày cần được chủ nhà kiểm tra và xác nhận. Lịch hiện tại của bạn vẫn được giữ nguyên an toàn.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: _muted,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: _card(),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: const FigmaRaster(
                              'assets/images/scr_086_00.jpg',
                              width: 54,
                              height: 54,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mã đặt: SN-1024 · Studio bếp',
                                  style: TextStyle(fontSize: 11, color: _teal),
                                ),
                                Text(
                                  'Mây Homestay Hội An',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _ink,
                                  ),
                                ),
                                Text(
                                  '2 người lớn · 1 phòng riêng',
                                  style: TextStyle(fontSize: 11, color: _muted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '▣ Lịch hiện tại',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _ink,
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
                          const SizedBox(height: 12),
                          _row('Khoảng thời gian:', '14/11/2026 – 16/11/2026'),
                          const SizedBox(height: 6),
                          _row('Tổng số đêm:', '2 đêm'),
                          const SizedBox(height: 6),
                          _row('Chi phí đã thanh toán:', '1.800.000đ'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '▣ Lịch bạn đề xuất',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _ink,
                                ),
                              ),
                              Text(
                                '● Chờ xác nhận',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFFF9900),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'NHẬN PHÒNG MỚI',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: _muted,
                                    ),
                                  ),
                                  Text(
                                    '16/11/2026',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: _teal,
                                    ),
                                  ),
                                  Text(
                                    'Thứ Hai · Từ 14:00',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: _muted,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'TRẢ PHÒNG MỚI',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: _muted,
                                    ),
                                  ),
                                  Text(
                                    '18/11/2026',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: _teal,
                                    ),
                                  ),
                                  Text(
                                    'Thứ Tư · Trước 12:00',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: _muted,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _row('Thời lượng lưu trú:', '2 đêm'),
                          const SizedBox(height: 6),
                          _row('Giá ngày mới:', 'Chờ kiểm tra · Chưa xác định'),
                          const SizedBox(height: 10),
                          const Text(
                            'Chênh lệch giá (nếu có) phụ thuộc vào tình trạng phòng trống và biểu giá thực tế tại thời điểm chủ nhà bấm duyệt.',
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.4,
                              color: _muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'ⓘ Việc gửi yêu cầu không đồng nghĩa với việc lịch mới đã được xác nhận. Mọi cập nhật lịch trình chỉ có hiệu lực sau khi chủ nhà đồng ý.',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.5,
                          color: _teal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _button('Hủy Yêu Cầu', null),
                    const SizedBox(height: 12),
                    const Center(
                      child: Text(
                        '♢ StayNest bảo vệ quyền lợi đặt phòng của bạn 24/7',
                        style: TextStyle(fontSize: 10, color: _muted),
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
