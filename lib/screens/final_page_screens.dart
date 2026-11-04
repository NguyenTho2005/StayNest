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
    BoxShadow(color: Color(0x0D000000), blurRadius: 3, offset: Offset(0, 1)),
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
Widget _button(String label, VoidCallback? action) => SizedBox(
  height: 48,
  width: double.infinity,
  child: ElevatedButton(
    onPressed: action,
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
Widget _header(BuildContext context, String title) => Container(
  height: 56,
  color: Colors.white,
  padding: const EdgeInsets.symmetric(horizontal: 26),
  child: Row(
    children: [
      InkWell(
        onTap: () =>
            context.canPop() ? context.pop() : context.go('/trips/help'),
        child: const Icon(Icons.arrow_back, size: 20, color: _ink),
      ),
      const SizedBox(width: 18),
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: _ink,
          ),
        ),
      ),
      const CircleAvatar(
        radius: 16,
        backgroundColor: _teal,
        child: Icon(Icons.person_outline, color: Colors.white, size: 16),
      ),
    ],
  ),
);

class CancellationFaqScreen extends StatefulWidget {
  const CancellationFaqScreen({super.key});
  @override
  State<CancellationFaqScreen> createState() => _CancellationFaqScreenState();
}

class _CancellationFaqScreenState extends State<CancellationFaqScreen> {
  int expanded = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            _header(context, 'Gửi Yêu Cầu Hỗ Trợ'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 16, 28, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '⬟ Đơn SN-1024',
                      style: TextStyle(fontSize: 11, color: _teal),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tìm hiểu điều kiện hủy đặt phòng và thời gian xử lý hoàn tiền.',
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.5,
                        color: _muted,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: _card(),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: const FigmaRaster(
                              'assets/images/scr_097_00.jpg',
                              width: 54,
                              height: 54,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mây Homestay & Villa',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: _ink,
                                  ),
                                ),
                                Text(
                                  '▣ 14 Th11 – 16 Th11, 2026 (2 đêm)',
                                  style: TextStyle(fontSize: 11, color: _muted),
                                ),
                                Text(
                                  'Tổng tiền: 1.800.000đ',
                                  style: TextStyle(fontSize: 11, color: _muted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Câu hỏi thường gặp',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: _ink,
                          ),
                        ),
                        Text(
                          '4 câu hỏi',
                          style: TextStyle(fontSize: 11, color: _muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _faq(
                      0,
                      'Có hủy miễn phí không?',
                      'Theo chính sách minh họa của StayNest, trước 12/11/2026 lúc 18:00 được hoàn 100% số tiền đủ điều kiện hoàn. Với booking SN-1024, số tiền hoàn dự kiến là 1.800.000đ. Không mất phí dịch vụ hủy phòng.',
                    ),
                    _faq(
                      1,
                      'Nếu hủy sau thời hạn miễn phí thì sao?',
                      'Sau hạn miễn phí và trước khi nhận phòng, mức hoàn minh họa là 50%.',
                    ),
                    _faq(
                      2,
                      'Khi nào nhận được tiền hoàn?',
                      'Thời gian xử lý minh họa là 3–7 ngày làm việc.',
                    ),
                    _faq(
                      3,
                      'Tôi theo dõi hoàn tiền ở đâu?',
                      'Bạn có thể xem tiến độ trong mục Chi tiết hoàn tiền của đơn đã hủy.',
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => context.push(
                        '/properties/may-homestay/policies/refund',
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: _card(),
                        child: const Row(
                          children: [
                            Icon(Icons.policy_outlined, color: _teal),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Xem chính sách hủy đầy đủ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: _ink,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_forward, color: _teal),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'ⓘ Thông tin và thời gian hoàn tiền trên màn hình này là dữ liệu minh họa.',
                      style: TextStyle(fontSize: 11, color: _muted),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: _card(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Vẫn cần hỗ trợ?',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _ink,
                            ),
                          ),
                          const Text(
                            'Đội ngũ tư vấn viên StayNest luôn sẵn sàng 24/7 để giải đáp mọi thắc mắc của bạn.',
                            style: TextStyle(
                              fontSize: 12,
                              height: 1.5,
                              color: _muted,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _button(
                            '▤ Liên hệ hỗ trợ',
                            () => context.push('/trips/help/chat-demo'),
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

  Widget _faq(int index, String title, String body) => Container(
    margin: const EdgeInsets.only(bottom: 9),
    padding: const EdgeInsets.all(14),
    decoration: _card(),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () =>
              setState(() => expanded = expanded == index ? -1 : index),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 15,
                backgroundColor: Color(0xFFEAF7F6),
                child: Icon(Icons.help_outline, size: 16, color: _teal),
              ),
              const SizedBox(width: 10),
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
              Icon(
                expanded == index
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: _muted,
              ),
            ],
          ),
        ),
        if (expanded == index) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(11),
            color: const Color(0xFFEAF7F6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  body,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 1.5,
                    color: _teal,
                  ),
                ),
                if (index == 0) ...[
                  const SizedBox(height: 12),
                  const Row(
                    children: [
                      Icon(Icons.check_circle_outline, size: 13, color: _teal),
                      SizedBox(width: 5),
                      Text(
                        'Không mất phí dịch vụ hủy phòng',
                        style: TextStyle(fontSize: 11, color: _teal),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ],
    ),
  );
}

class BookingSupportChatDemoScreen extends StatelessWidget {
  const BookingSupportChatDemoScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _bg,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            Container(
              height: 64,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go('/trips/help'),
                    child: const Icon(Icons.arrow_back, size: 20, color: _ink),
                  ),
                  const SizedBox(width: 18),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'StayNest hỗ trợ',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: _ink,
                          ),
                        ),
                        Text(
                          'Chat Hỗ Trợ',
                          style: TextStyle(fontSize: 11, color: _muted),
                        ),
                      ],
                    ),
                  ),
                  const CircleAvatar(
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'ⓘ Các phản hồi trong cuộc trò chuyện này được mô phỏng cho mục đích trình diễn.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: _teal),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Hôm nay, 14:32',
                      style: TextStyle(fontSize: 11, color: _muted),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: _teal,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Text(
                          'Tôi cần kiểm tra hoàn tiền SN-1024',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '14:32 · Đã nhận',
                        style: TextStyle(fontSize: 10, color: _muted),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 14,
                          backgroundColor: _teal,
                          child: Icon(
                            Icons.support_agent,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(14),
                            decoration: _card(),
                            child: const Text(
                              'Khoản hoàn tiền RF-1024 đang được xử lý trong bản mô phỏng. Số tiền hoàn dự kiến là 1.800.000đ.',
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.6,
                                color: _ink,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.only(left: 36),
                      padding: const EdgeInsets.all(12),
                      decoration: _card(),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: const FigmaRaster(
                                  'assets/images/scr_098_00.jpg',
                                  width: 48,
                                  height: 48,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Mã đơn: SN-1024',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: _muted,
                                      ),
                                    ),
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
                                        fontSize: 11,
                                        color: _muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '● Đã hủy      ● RF-1024 · Đang xử lý',
                            style: TextStyle(fontSize: 11, color: _muted),
                          ),
                          const SizedBox(height: 12),
                          _row('Số tiền hoàn dự kiến:', '1.800.000đ (100%)'),
                          const SizedBox(height: 6),
                          _row('Thời gian xử lý:', '3–7 ngày làm việc'),
                          const SizedBox(height: 6),
                          _row('Phương thức:', 'Tài khoản gốc'),
                          const SizedBox(height: 12),
                          InkWell(
                            onTap: () =>
                                context.push('/trips/refund-tracking-demo'),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              color: const Color(0xFFEAF7F6),
                              child: const Text(
                                'Xem chi tiết hoàn tiền →',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, color: _teal),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '14:32 · Hệ thống tự động StayNest',
                      style: TextStyle(fontSize: 10, color: _muted),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
              child: const Row(
                children: [
                  Icon(Icons.add_circle_outline, color: _muted),
                  SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        fillColor: Color(0xFFF0F4F4),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        hintText: 'Nhập nội dung tin nhắn…',
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: _teal,
                    child: Icon(Icons.send, color: Colors.white, size: 18),
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

class UpcomingTripsEmptyScreen extends StatelessWidget {
  const UpcomingTripsEmptyScreen({super.key});
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
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Chuyến Đi',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                      ),
                    ),
                  ),
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
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _teal,
                    ),
                  ),
                  Text(
                    'Đã hoàn thành',
                    style: TextStyle(fontSize: 14, color: _muted),
                  ),
                  Text(
                    'Đã hủy ●',
                    style: TextStyle(fontSize: 14, color: _muted),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(32, 38, 32, 20),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 64,
                      backgroundColor: Color(0xFFEAF7F6),
                      child: CircleAvatar(
                        radius: 42,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.luggage_outlined,
                          color: _teal,
                          size: 42,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Bạn chưa có chuyến đi nào',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Các chuyến đi sắp tới của bạn sẽ xuất hiện tại đây sau khi được đặt và xác nhận.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: _muted,
                      ),
                    ),
                    const SizedBox(height: 34),
                    _button('◉ Khám phá chỗ ở', () => context.go('/')),
                    const SizedBox(height: 36),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '✣ Gợi ý cho kỳ nghỉ tới',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _ink,
                          ),
                        ),
                        Text(
                          'Dành riêng cho bạn',
                          style: TextStyle(fontSize: 11, color: _muted),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _suggestion(
                            'assets/images/scr_099_00.jpg',
                            'ĐÀ LẠT',
                            'Pine Hill Sanctuary',
                            '850.000đ',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _suggestion(
                            'assets/images/scr_099_01.jpg',
                            'PHÚ QUỐC',
                            'Ocean Breeze Villa',
                            '1.450.000đ',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4F4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.support_agent, color: _teal),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Cần hỗ trợ đặt phòng?\nĐội ngũ StayNest sẵn sàng đồng hành 24/7',
                              style: TextStyle(fontSize: 12, color: _ink),
                            ),
                          ),
                          Icon(Icons.arrow_forward, size: 17, color: _muted),
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

  Widget _suggestion(
    String image,
    String place,
    String name,
    String price,
  ) => Container(
    decoration: _card(),
    clipBehavior: Clip.antiAlias,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            FigmaRaster(image, width: double.infinity, height: 126),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  place == 'ĐÀ LẠT' ? '⭐ 4.9' : '⭐ 4.8',
                  style: const TextStyle(fontSize: 11, color: _ink),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(place, style: const TextStyle(fontSize: 11, color: _teal)),
              Text(name, style: const TextStyle(fontSize: 12, color: _ink)),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: price,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _teal,
                      ),
                    ),
                    const TextSpan(
                      text: '/đêm',
                      style: TextStyle(fontSize: 10, color: _muted),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class TripOverviewScreen extends StatelessWidget {
  const TripOverviewScreen({super.key});
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
              padding: const EdgeInsets.symmetric(horizontal: 28),
              color: Colors.white,
              child: const Row(
                children: [
                  Expanded(
                    child: Text(
                      'Chi Tiết Chuyến Đi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                      ),
                    ),
                  ),
                  CircleAvatar(
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
                padding: const EdgeInsets.fromLTRB(28, 11, 28, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      '✿ CỘT MỐC HOÀN THÀNH',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _teal,
                      ),
                    ),
                    const SizedBox(height: 0),
                    const Text(
                      'Tổng kết hành trình của bạn',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Toàn bộ thông tin đặt phòng, hủy và theo dõi hoàn tiền trong nguyên mẫu StayNest.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.5,
                        color: _muted,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Container(
                      decoration: _card(),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              const FigmaRaster(
                                'assets/images/scr_100_00.jpg',
                                width: double.infinity,
                                height: 150,
                              ),
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFEE4E2),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Text(
                                    '⊗ Đã hủy',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Color(0xFFB42318),
                                    ),
                                  ),
                                ),
                              ),
                              const Positioned(
                                bottom: 12,
                                left: 12,
                                child: Text(
                                  'HỘI AN, QUẢNG NAM\nMây Homestay · Phòng Studio có bếp',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  color: const Color(0xFFF0F4F4),
                                  child: _row(
                                    'Ngày lưu trú',
                                    '14/11/2026 – 16/11/2026',
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _row('Mã đặt phòng:', 'SN-1024'),
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
                              Text(
                                'Theo dõi hoàn tiền',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: _ink,
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
                          const SizedBox(height: 20),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Số tiền hoàn trả',
                                style: TextStyle(fontSize: 12, color: _muted),
                              ),
                              Row(
                                children: [
                                  Text(
                                    '1.800.000đ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: _teal,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    '100%',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: _teal,
                                      backgroundColor: Color(0xFFEAF7F6),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          _row('Mã hoàn tiền:', 'RF-1024'),
                          const SizedBox(height: 10),
                          const Text(
                            'ⓘ Thời gian xử lý dự kiến 3–7 ngày làm việc.',
                            style: TextStyle(fontSize: 11, color: _muted),
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () =>
                                context.push('/trips/refund-tracking-demo'),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              color: const Color(0xFFEAF7F6),
                              child: const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Chi tiết quy trình hoàn tiền',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: _teal,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 16,
                                    color: _teal,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '◉ Tiếp tục khám phá',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _link(
                      context,
                      Icons.home_outlined,
                      'Trang chủ',
                      'Khám phá chỗ ở và điểm đến độc bản',
                      '/',
                    ),
                    _link(
                      context,
                      Icons.delete_outline,
                      'Đơn đã hủy',
                      'Xem lại đặt phòng đã hủy và trạng thái hoàn tiền',
                      '/trips/cancelled-demo',
                    ),
                    _link(
                      context,
                      Icons.support_agent,
                      'Hỗ trợ & Khiếu nại',
                      'Tìm câu trả lời cho các thắc mắc về chuyến đi',
                      '/trips/help',
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

  Widget _link(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    String route,
  ) => InkWell(
    onTap: () => context.go(route),
    child: Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(12),
      decoration: _card(),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: const Color(0xFFEAF7F6),
            child: Icon(icon, color: _teal),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _ink,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 11, color: _muted),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 18, color: _muted),
        ],
      ),
    ),
  );
}

class ProfileUpdatedDemoScreen extends StatelessWidget {
  const ProfileUpdatedDemoScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            Container(
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => context.canPop()
                        ? context.pop()
                        : context.go('/profile'),
                    child: const Icon(Icons.arrow_back, color: _ink, size: 20),
                  ),
                  const Spacer(),
                  const CircleAvatar(
                    radius: 15,
                    backgroundColor: _teal,
                    child: Icon(
                      Icons.home_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'StayNest',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _ink,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 20),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEFCF2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '✔ Đã cập nhật thông tin thành công',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF00A86B),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const CircleAvatar(
                      radius: 48,
                      backgroundColor: Color(0xFFEAF7F6),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Color(0xFF00A86B),
                        child: Icon(Icons.check, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Thông tin hồ sơ đã được cập nhật',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Mọi thay đổi của bạn đã được lưu an toàn trên hệ thống StayNest.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: _muted,
                      ),
                    ),
                    const SizedBox(height: 26),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: _card(),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '♙ Hồ sơ cá nhân cập nhật',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: _ink,
                                ),
                              ),
                              Text(
                                'Vừa xong',
                                style: TextStyle(fontSize: 11, color: _teal),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(12),
                            color: const Color(0xFFF4F6FB),
                            child: const Row(
                              children: [
                                CircleAvatar(
                                  radius: 23,
                                  backgroundColor: Color(0xFFDCEBED),
                                  child: Text(
                                    'ND',
                                    style: TextStyle(color: _teal),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Nguyễn An',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: _ink,
                                      ),
                                    ),
                                    Text(
                                      '♢ Thành viên StayNest',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: _muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          _row('Số điện thoại', '0900 *** 123'),
                          const SizedBox(height: 20),
                          _row('Quốc tịch', '🇻🇳 Việt Nam'),
                          const SizedBox(height: 20),
                          _row('Email liên hệ', 'an.demo@example.com'),
                          const SizedBox(height: 20),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            color: const Color(0xFFEEFCF2),
                            child: const Text(
                              '✿ Trạng thái: Hoạt động & Đã xác minh',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF00A86B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDF2FE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.luggage_outlined, color: _teal),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Sẵn sàng cho chuyến đi kế tiếp\nThông tin đặt phòng và liên lạc tiếp tân sẽ dùng hồ sơ cập nhật này.',
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
                    const SizedBox(height: 36),
                    _button('♙ Quay lại hồ sơ', () => context.go('/profile')),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => context.go('/account'),
                      child: const Text(
                        'Về trang tài khoản',
                        style: TextStyle(color: _muted),
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
