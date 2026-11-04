import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/staynest_api.dart';
import '../widgets/figma_asset.dart';
import '../widgets/user_avatar_app_bar.dart';

class BookingSummaryScreen extends ConsumerStatefulWidget {
  const BookingSummaryScreen({super.key});

  @override
  ConsumerState<BookingSummaryScreen> createState() =>
      _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends ConsumerState<BookingSummaryScreen> {
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  static const teal = Color(0xFF006768);
  Map<String, dynamic>? quote;
  String? error;

  @override
  void initState() {
    super.initState();
    loadQuote();
  }

  Future<void> loadQuote() async {
    try {
      final api = ref.read(stayNestApiProvider);
      final draft = ref.read(bookingDraftProvider);
      final property = await api.property(draft.propertySlug);
      final rooms = property['rooms'] as List;
      final room = rooms.cast<Map>().firstWhere(
        (item) => toInt(item['id']) == draft.selectedRoomTypeId,
        orElse: () => rooms.first as Map,
      );
      draft.selectedRoomTypeId = toInt(room['id']);
      draft.selectedRoomName = '${room['name']}';
      draft.propertyName = '${property['name'] ?? draft.propertyName}';
      draft.propertyAddress = '${property['address'] ?? draft.propertyAddress}';
      draft.destinationSlug =
          '${property['destination_slug'] ?? draft.destinationSlug}';

      if (await api.token != null) {
        try {
          final user = await api.getMe();
          draft.prefillGuestFromUser(user);
        } catch (_) {}
      }

      final result = await api.quote(draft.details(draft.selectedRoomTypeId!));
      if (mounted) {
        ref.read(bookingDraftProvider).quote = result;
        setState(() {
          quote = result;
          error = null;
        });
      }
    } catch (caught) {
      if (mounted) setState(() => error = '$caught');
    }
  }

  String money(Object? amount) => '${amount ?? 0}'.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );

  @override
  Widget build(BuildContext context) {
    final draft = ref.read(bookingDraftProvider);
    final nights = draft.checkOut.difference(draft.checkIn).inDays;
    final isQuoteLoading = quote == null && error == null;
    final isAvailable =
        quote != null && toInt(quote!['availableUnits']) >= draft.roomCount;
    final availabilityMessage = quote == null
        ? null
        : isAvailable
            ? null
            : 'Không đủ ${draft.roomCount} phòng cho ngày đã chọn.';
    final roomSubtotal = quote?['roomSubtotalVnd'];
    final nightly = quote?['nightlyPriceVnd'];
    final priceLabel = roomSubtotal == null
        ? 'Đang tải giá...'
        : '${money(roomSubtotal)}đ';
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390),
          child: Column(
            children: [
              Container(
                height: 44,
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.canPop()
                          ? context.pop()
                          : context.go('/properties/may-homestay/rooms'),
                      icon: const Icon(Icons.arrow_back, size: 19),
                    ),
                    const Expanded(
                      child: Text(
                        'Tóm Tắt Đặt Phòng',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: ink,
                        ),
                      ),
                    ),
                    const UserAvatarAppBar(size: 22),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Tiến trình đặt chỗ',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: ink,
                              ),
                            ),
                          ),
                          Text(
                            'Bước 1/3',
                            style: TextStyle(fontSize: 10, color: teal),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const LinearProgressIndicator(
                        value: 1 / 3,
                        minHeight: 4,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: teal,
                        backgroundColor: Color(0xFFEAF0FE),
                      ),
                      const SizedBox(height: 4),
                      const Row(
                        children: [
                          Expanded(
                            child: Text(
                              '1. Tóm tắt phòng',
                              style: TextStyle(fontSize: 9, color: teal),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '2. Thông tin khách',
                              style: TextStyle(fontSize: 9, color: muted),
                            ),
                          ),
                          Text(
                            '3. Thanh toán',
                            style: TextStyle(fontSize: 9, color: muted),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _card(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(13),
                              ),
                              child: FigmaRaster(
                                draft.selectedRoomImage,
                                width: 350,
                                height: 150,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'HOMESTAY DI SẢN',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: teal,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              draft.propertyName.isNotEmpty
                                  ? draft.propertyName
                                  : 'Mây Homestay - Hội An',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: ink,
                              ),
                            ),
                            Text(
                              '♧ ${draft.propertyAddress.isNotEmpty ? draft.propertyAddress : draft.destinationName}',
                              style: const TextStyle(
                                fontSize: 10,
                                color: muted,
                              ),
                            ),
                            const Divider(height: 20, color: Color(0xFFEAF0FE)),
                            _detail(
                              Icons.bed_outlined,
                              draft.selectedRoomName,
                              draft.selectedRoomName.contains('Garden')
                                  ? '32m² • 1 giường King • Ban công sân vườn'
                                  : '28m² • 1 giường Queen lớn • Ban công sân vườn',
                            ),
                            _detail(
                              Icons.calendar_month_outlined,
                              '${draft.checkIn.day}/${draft.checkIn.month}/${draft.checkIn.year} – ${draft.checkOut.day}/${draft.checkOut.month}/${draft.checkOut.year}',
                              'Thời lượng: $nights đêm lưu trú',
                            ),
                            _detail(
                              Icons.people_outline,
                              '${draft.adults} người lớn',
                              '${draft.children} trẻ em • ${draft.roomCount} phòng',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF7F6),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '●  Chính sách hủy linh hoạt',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: ink,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Chính sách hủy được tính theo ngày đặt phòng và hiển thị khi xác nhận giá.',
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.5,
                                color: muted,
                              ),
                            ),
                            const SizedBox(height: 8),
                            InkWell(
                              onTap: () => context.push(
                                '/properties/may-homestay/policies/refund',
                              ),
                              child: const Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  'Xem điều kiện hủy chi tiết →',
                                  style: TextStyle(fontSize: 10, color: teal),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      _card(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Thời gian nhận phòng & Quy định',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: ink,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: _time(
                                    'Nhận phòng',
                                    'Từ 14:00',
                                    'Hỗ trợ nhận sớm theo tình trạng phòng',
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: _time(
                                    'Trả phòng',
                                    'Trước 12:00',
                                    'Quầy tự phục vụ hoặc trực tiếp',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              '♧ Phòng không hút thuốc • Không thú cưng',
                              style: TextStyle(fontSize: 10, color: muted),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      _card(
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Chi tiết tạm tính',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: ink,
                                    ),
                                  ),
                                ),
                                Text(
                                  'VND (₫)',
                                  style: TextStyle(fontSize: 10, color: teal),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (error != null) ...[
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEE4E2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.error_outline,
                                      color: Color(0xFFD92D20),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        error!,
                                        style: const TextStyle(
                                          color: Color(0xFFD92D20),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: loadQuote,
                                      child: const Text('Thử lại'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                            if (availabilityMessage != null) ...[
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF3F2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: const Color(0xFFFDA29B),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.warning_amber_rounded,
                                      color: Color(0xFFD92D20),
                                      size: 18,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        availabilityMessage,
                                        style: const TextStyle(
                                          color: Color(0xFFB42318),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                            ],
                            _price(
                              nightly == null
                                  ? 'Giá phòng cơ bản'
                                  : 'Giá phòng cơ bản (${money(nightly)}đ × $nights đêm)',
                              priceLabel,
                            ),
                            _price('Phí dọn dẹp buồng phòng', 'Miễn phí'),
                            _price('Ưu đãi đặt sớm người địa phương', '-0đ'),
                            const Divider(height: 20, color: Color(0xFFEAF0FE)),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Tổng cộng tạm tính',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: ink,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  priceLabel,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: teal,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'ⓘ Giá chưa bao gồm thuế VAT (10%) và phí dịch vụ sàn. Mọi chi phí sẽ được hiển thị minh bạch trước khi bấm thanh toán ở bước kế tiếp.',
                              style: TextStyle(
                                fontSize: 10,
                                height: 1.5,
                                color: muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      _card(
                        Row(
                          children: [
                            ClipOval(
                              child: const FigmaRaster(
                                'assets/images/booking_summary_060_02.jpg',
                                width: 38,
                                height: 38,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '“Chúng mình luôn chuẩn bị trà sen và nón lá chào đón bạn ghé thăm phố Hội!”',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontStyle: FontStyle.italic,
                                      color: muted,
                                    ),
                                  ),
                                  Text(
                                    '— Chị Lan, Quản gia Mây Homestay',
                                    style: TextStyle(fontSize: 10, color: ink),
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
                padding: const EdgeInsets.fromLTRB(20, 9, 20, 10),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tạm tính: $priceLabel',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: teal,
                            ),
                          ),
                          Text(
                            '$nights đêm • ${draft.adults + draft.children} khách • ${draft.selectedRoomName}',
                            style: const TextStyle(fontSize: 9, color: muted),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 145,
                      height: 40,
                      child: ElevatedButton(
                        onPressed:
                            (!isAvailable || isQuoteLoading || error != null)
                            ? null
                            : () => context.push('/booking/start'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: teal,
                          disabledBackgroundColor: const Color(0xFFCFD8DC),
                          disabledForegroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                        ),
                        child: Text(
                          isQuoteLoading
                              ? 'Đang tải…'
                              : error != null
                                  ? 'Lỗi tải phòng'
                                  : !isAvailable
                                      ? 'Không đủ phòng'
                                      : 'Tiếp tục đặt phòng →',
                          style: const TextStyle(fontSize: 10),
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
  }

  Widget _card(Widget child) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: child,
  );
  Widget _detail(IconData icon, String title, String subtitle) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      children: [
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF7F6),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, size: 15, color: teal),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: ink,
                ),
              ),
              Text(subtitle, style: const TextStyle(fontSize: 9, color: muted)),
            ],
          ),
        ),
      ],
    ),
  );
  Widget _time(String label, String value, String subtitle) => Container(
    padding: const EdgeInsets.all(9),
    decoration: BoxDecoration(
      color: const Color(0xFFEAF0FE),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: muted)),
        Text(
          value,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: ink,
          ),
        ),
        Text(subtitle, style: const TextStyle(fontSize: 9, color: muted)),
      ],
    ),
  );
  Widget _price(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 9),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 10, color: muted),
          ),
        ),
        Text(value, style: const TextStyle(fontSize: 10, color: ink)),
      ],
    ),
  );
}
