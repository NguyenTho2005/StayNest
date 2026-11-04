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
  borderRadius: BorderRadius.circular(14),
  boxShadow: const [
    BoxShadow(color: Color(0x10172B4D), blurRadius: 8, offset: Offset(0, 4)),
  ],
);
Widget _row(String label, String value) => Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(label, style: const TextStyle(fontSize: 12, color: _muted)),
    Text(
      value,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: _ink,
      ),
    ),
  ],
);
Widget _button(String label, VoidCallback? onPressed) => SizedBox(
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
      label,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ),
  ),
);
Widget _header(BuildContext context, String title, {bool back = true}) =>
    Container(
      height: 56,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          if (back)
            InkWell(
              onTap: () =>
                  context.canPop() ? context.pop() : context.go('/trips'),
              child: const Icon(Icons.arrow_back, color: _ink, size: 20),
            )
          else
            const Icon(Icons.luggage_outlined, color: _teal, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _ink,
              ),
            ),
          ),
          const Icon(Icons.notifications_none, size: 18, color: _muted),
          const SizedBox(width: 12),
          const CircleAvatar(
            radius: 15,
            backgroundColor: _teal,
            child: Icon(Icons.person_outline, size: 15, color: Colors.white),
          ),
        ],
      ),
    );

class RefundTrackingScreen extends StatelessWidget {
  const RefundTrackingScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            _header(context, 'Hoàn Tiền'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '● Đang cập nhật trực tiếp',
                      style: TextStyle(fontSize: 11, color: _teal),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: _card(),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: const FigmaRaster(
                                  'assets/images/scr_092_00.jpg',
                                  width: 42,
                                  height: 42,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Column(
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
                                      'Phòng Studio có bếp · 2 khách',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Text(
                                'Hủy phòng',
                                style: TextStyle(fontSize: 10, color: _muted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            color: const Color(0xFFF0F4F4),
                            child: const Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'MÃ ĐẶT CHỖ\nSN-1024',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _ink,
                                      ),
                                    ),
                                    Text(
                                      'MÃ HOÀN TIỀN\nRF-1024',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: _ink,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'THỜI GIAN LƯU TRÚ  14/11/2026 – 16/11/2026 (2 đêm)',
                                  style: TextStyle(fontSize: 10, color: _muted),
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
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [_teal, Color(0xFF178E8A)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Số tiền hoàn dự kiến',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Hoàn 100%',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            '1.800.000 ₫',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Đã thanh toán ban đầu: 1.800.000₫               RF-1024',
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: _card(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Tiến độ hoàn tiền',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _ink,
                                ),
                              ),
                              Text(
                                '3 giai đoạn',
                                style: TextStyle(fontSize: 10, color: _muted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _step(
                            Icons.check,
                            'Đã tiếp nhận yêu cầu hủy',
                            '12/11/2026 · Đã ghi nhận trong bản mô phỏng',
                            const Color(0xFF0ABC77),
                          ),
                          _step(
                            Icons.autorenew,
                            'Đang xử lý hoàn tiền',
                            'Hệ thống đang đối soát với ngân hàng/cổng thanh toán để hoàn tất thủ tục chuyển tiền.',
                            _teal,
                          ),
                          _step(
                            Icons.credit_card,
                            'Đã hoàn tiền',
                            'Dự kiến hoàn về phương thức ban đầu.',
                            const Color(0xFFB8C3C8),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'PHƯƠNG THỨC HOÀN TIỀN',
                            style: TextStyle(fontSize: 10, color: _muted),
                          ),
                          Text(
                            'Tài khoản nhận tiền',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _ink,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Thông tin nhận tiền được minh họa trong prototype. Tiền sẽ hoàn lại theo đúng nguồn thanh toán ban đầu của quý khách.',
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.5,
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
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'THỜI GIAN XỬ LÝ',
                            style: TextStyle(fontSize: 10, color: _muted),
                          ),
                          Text(
                            '3–7 ngày làm việc',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: _ink,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Thời gian hiển thị chỉ mang tính minh họa. Trạng thái hoàn tiền thực tế không được kết nối trong prototype.',
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.5,
                              color: _muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    InkWell(
                      onTap: () => context.push('/trips/help'),
                      child: Container(
                        height: 45,
                        alignment: Alignment.center,
                        decoration: _card(),
                        child: const Text(
                          'ⓘ Trợ giúp về hoàn tiền',
                          style: TextStyle(fontSize: 13, color: _ink),
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

  Widget _step(IconData icon, String title, String subtitle, Color color) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 13,
              backgroundColor: color,
              child: Icon(icon, size: 13, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.4,
                      color: _muted,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class RefundCompleteScreen extends StatelessWidget {
  const RefundCompleteScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 88, 24, 30),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundColor: Color(0xFFEAF7F6),
                      child: CircleAvatar(
                        radius: 22,
                        backgroundColor: _teal,
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '● Đã hoàn',
                      style: TextStyle(fontSize: 11, color: Color(0xFF0ABC77)),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Đã hoàn tiền thành công',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Khoản hoàn tiền trong kịch bản mô phỏng đã được ghi nhận là hoàn tất.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: _muted,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Số tiền hoàn trả',
                                style: TextStyle(fontSize: 11, color: _muted),
                              ),
                              Text(
                                'Hoàn 100%',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF0ABC77),
                                ),
                              ),
                            ],
                          ),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '1.800.000đ',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w700,
                                color: _teal,
                              ),
                            ),
                          ),
                          const Divider(height: 24),
                          _row('Chỗ nghỉ', 'Mây Homestay'),
                          const SizedBox(height: 10),
                          _row('Mã đặt phòng', 'SN-1024'),
                          const SizedBox(height: 10),
                          _row('Mã hoàn tiền', 'RF-1024'),
                          const SizedBox(height: 10),
                          _row('Số tiền đã thanh toán', '1.800.000đ'),
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
                              Text(
                                'Tiến trình hoàn tiền',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _ink,
                                ),
                              ),
                              Text(
                                '3/3 Hoàn tất',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF0ABC77),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          _done(
                            'Đã tiếp nhận yêu cầu hủy',
                            'Xác nhận tự động theo chính sách hoàn 100%',
                          ),
                          _done(
                            'Đã xử lý hoàn tiền',
                            'Cổng thanh toán đã duyệt lệnh hoàn trả',
                          ),
                          _done(
                            'Đã hoàn tiền',
                            'Đã ghi nhận số dư về nguồn thanh toán',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: Column(
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '▤ Thông tin giao dịch',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _ink,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          _row('Phương thức', 'Tài khoản ban đầu'),
                          const SizedBox(height: 10),
                          _row('Thời gian hoàn', '14/11/2026'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: const Color(0xFFF0F4F4),
                      child: const Text(
                        'ⓘ Đây là trạng thái hoàn tiền minh họa cho prototype, không phải xác nhận giao dịch ngân hàng thực tế.',
                        style: TextStyle(
                          fontSize: 11,
                          height: 1.5,
                          color: _muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _button(
                      '▣ Về đơn đã hủy',
                      () => context.push('/trips/cancelled-demo'),
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

  Widget _done(String title, String subtitle) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      children: [
        const CircleAvatar(
          radius: 10,
          backgroundColor: _teal,
          child: Icon(Icons.check, size: 12, color: Colors.white),
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
      ],
    ),
  );
}

class CompletedTripsScreen extends StatelessWidget {
  const CompletedTripsScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            _header(context, 'Chuyen Di', back: false),
            Container(
              height: 52,
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
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _teal,
                    ),
                  ),
                  Text('Đã hủy', style: TextStyle(fontSize: 14, color: _muted)),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(30, 16, 30, 24),
                child: Column(
                  children: [
                    Container(
                      decoration: _card(),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              const FigmaRaster(
                                'assets/images/scr_094_00.jpg',
                                width: double.infinity,
                                height: 200,
                              ),
                              Positioned(
                                top: 12,
                                left: 12,
                                child: Container(
                                  padding: const EdgeInsets.all(7),
                                  color: Colors.white,
                                  child: const Text(
                                    '● Đã hoàn thành',
                                    style: TextStyle(fontSize: 11, color: _ink),
                                  ),
                                ),
                              ),
                              const Positioned(
                                bottom: 10,
                                left: 12,
                                child: Text(
                                  '▣ Tháng 09/2026',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'An Villa',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: _ink,
                                      ),
                                    ),
                                    Text(
                                      '★ 4.9',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _teal,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 7),
                                const Text(
                                  '⌖ Cẩm Thanh, Hội An, Quảng Nam',
                                  style: TextStyle(fontSize: 14, color: _muted),
                                ),
                                const SizedBox(height: 14),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  color: const Color(0xFFF0F4F4),
                                  child: const Text(
                                    'ⓘ Chuyến lưu trú mẫu dùng để minh họa tính năng đánh giá sau chuyến đi.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      height: 1.5,
                                      color: _muted,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _button(
                                  '▣ Đánh giá chỗ ở',
                                  () => context.push('/trips/completed/review'),
                                ),
                                const SizedBox(height: 10),
                                const Center(
                                  child: Text(
                                    '⌕ Xem thông tin chỗ ở',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: _teal,
                                    ),
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
                      padding: const EdgeInsets.all(16),
                      decoration: _card(),
                      child: const Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xFFEAF7F6),
                            child: Icon(
                              Icons.celebration_outlined,
                              color: _teal,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kỷ niệm hành trình',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: _ink,
                                  ),
                                ),
                                Text(
                                  'Bạn đã hoàn thành 1 kỳ nghỉ cùng StayNest trong năm 2026.',
                                  style: TextStyle(fontSize: 12, color: _muted),
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
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.map_outlined, color: _teal),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Sẵn sàng cho kỳ nghỉ kế tiếp?',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _ink,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Khám phá các homestay mộc mạc và khu nghỉ dưỡng đặc sắc trên khắp Việt Nam.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: _muted,
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextButton(
                            onPressed: () => context.go('/'),
                            child: const Text(
                              'Tìm cảm hứng mới →',
                              style: TextStyle(color: _teal),
                            ),
                          ),
                        ],
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

class WriteReviewScreen extends StatefulWidget {
  const WriteReviewScreen({super.key});
  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  int stars = 5;
  final tags = <String>{'Sạch sẽ', 'Vị trí'};
  final reviewController = TextEditingController(
    text: 'Khu vườn An Villa rất yên bình, nhân viên thân thiện và đón tiếp nồng hậu.',
  );

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            _header(context, 'Đánh Giá'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(38, 12, 38, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: _card(),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: const FigmaRaster(
                              'assets/images/scr_095_00.jpg',
                              width: 70,
                              height: 70,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '● Đã hoàn thành',
                                  style: TextStyle(fontSize: 11, color: _teal),
                                ),
                                Text(
                                  'An Villa',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: _ink,
                                  ),
                                ),
                                Text(
                                  '▣ Thời gian: Tháng 09/2026',
                                  style: TextStyle(fontSize: 11, color: _muted),
                                ),
                                Text(
                                  'Mã kỳ nghỉ: #STAY-88219',
                                  style: TextStyle(fontSize: 11, color: _muted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: Column(
                        children: [
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: Color(0xFFEAF7F6),
                            child: Icon(Icons.star_border, color: _teal),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Bạn cảm nhận thế nào về kỳ nghỉ?',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _ink,
                            ),
                          ),
                          const Text(
                            'Chạm vào sao để đánh giá trải nghiệm tại An Villa',
                            style: TextStyle(fontSize: 11, color: _muted),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              5,
                              (i) => InkWell(
                                onTap: () => setState(() => stars = i + 1),
                                child: Icon(
                                  i < stars ? Icons.star : Icons.star_border,
                                  color: const Color(0xFFFF9900),
                                  size: 32,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tuyệt vời · $stars/5 sao',
                            style: const TextStyle(fontSize: 12, color: _teal),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Điều bạn muốn chia sẻ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: ['Sạch sẽ', 'Vị trí', 'Phục vụ']
                          .map(
                            (tag) => ChoiceChip(
                              label: Text(tag),
                              selected: tags.contains(tag),
                              selectedColor: _teal,
                              labelStyle: TextStyle(
                                color: tags.contains(tag)
                                    ? Colors.white
                                    : _muted,
                              ),
                              onSelected: (value) => setState(
                                () => value ? tags.add(tag) : tags.remove(tag),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Nhận xét của bạn',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: _card(),
                      child: TextField(
                        maxLength: 100,
                        minLines: 4,
                        maxLines: 6,
                        controller: reviewController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Thêm hình ảnh (không bắt buộc)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: const FigmaRaster(
                            'assets/images/scr_095_01.jpg',
                            width: 90,
                            height: 90,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          width: 90,
                          height: 90,
                          decoration: _card(),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate_outlined,
                                color: _teal,
                              ),
                              Text(
                                'Tải ảnh',
                                style: TextStyle(fontSize: 11, color: _ink),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Tải ảnh chụp không gian phòng, ban công hoặc bữa sáng thực tế để giúp cộng đồng du khách.',
                      style: TextStyle(
                        fontSize: 11,
                        height: 1.5,
                        color: _muted,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(12),
                      color: const Color(0xFFF0F4F4),
                      child: const Text(
                        'Bạn chỉ có thể đánh giá chuyến lưu trú đã hoàn thành. Nội dung gửi đi trong prototype chỉ mang tính minh họa.',
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
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(38, 10, 38, 16),
              child: Column(
                children: [
                  _button('Gửi đánh giá ▷', null),
                  TextButton(
                    onPressed: () => context.go('/trips/completed-demo'),
                    child: const Text(
                      'Để sau',
                      style: TextStyle(color: _muted),
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
}

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            _header(context, 'Trung Tâm Trợ Giúp'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(32, 12, 32, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '◉ Hỗ trợ StayNest',
                      style: TextStyle(fontSize: 12, color: _teal),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Chúng tôi có thể giúp gì cho bạn?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Tìm kiếm câu trả lời nhanh hoặc chọn danh mục bên dưới.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: _muted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: _card(),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Color(0xFF98A2B3)),
                          SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Tìm câu hỏi hoặc chủ đề hỗ trợ',
                                hintStyle: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF98A2B3),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      '⚡ Check-in muộn       ▤ Xuất hóa đơn VAT       Đổi mật khẩu',
                      style: TextStyle(fontSize: 11, color: _muted),
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Chủ đề hỗ trợ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _ink,
                          ),
                        ),
                        Text(
                          '3 chủ đề',
                          style: TextStyle(fontSize: 12, color: _muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _topic(
                      Icons.calendar_month_outlined,
                      'Đặt phòng',
                      'Thông tin đặt phòng và quản lý chuyến',
                      () => context.push('/trips/booking'),
                    ),
                    const SizedBox(height: 10),
                    _topic(
                      Icons.credit_card_outlined,
                      'Thanh toán',
                      'Thông tin giao dịch và biên nhận',
                      () => context.push('/booking/receipt-demo'),
                    ),
                    const SizedBox(height: 10),
                    _topic(
                      Icons.history,
                      'Hủy và hoàn tiền',
                      'Chính sách hủy và theo dõi khoản hoàn',
                      () => context.push('/trips/help/cancellation-faq'),
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Cần hỗ trợ thêm?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _ink,
                          ),
                        ),
                        Text(
                          '● Sẵn sàng',
                          style: TextStyle(fontSize: 11, color: _teal),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: _card(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Color(0xFFEAF7F6),
                                child: Icon(Icons.chat_outlined, color: _teal),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Chat hỗ trợ  Online',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: _ink,
                                      ),
                                    ),
                                    Text(
                                      'Trao đổi với trợ lý hỗ trợ trong bản mô phỏng',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          _button(
                            '▤ Bắt đầu chat',
                            () => context.push('/trips/help/chat-demo'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4F4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Mẹo tìm kiếm nhanh\nBạn có thể nhập trực tiếp mã đặt chỗ (booking ID) vào ô tìm kiếm để kiểm tra trạng thái phòng nhanh chóng.',
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

  Widget _topic(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) => InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: _card(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFEAF7F6),
            child: Icon(icon, color: _teal),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _ink,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: _muted),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: _muted, size: 18),
        ],
      ),
    ),
  );
}
