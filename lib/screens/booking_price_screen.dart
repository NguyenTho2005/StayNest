import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/staynest_api.dart';

import '../widgets/figma_asset.dart';

class BookingPriceScreen extends ConsumerStatefulWidget {
  const BookingPriceScreen({super.key});

  @override
  ConsumerState<BookingPriceScreen> createState() => _BookingPriceScreenState();
}

class _BookingPriceScreenState extends ConsumerState<BookingPriceScreen> {
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  static const teal = Color(0xFF006768);
  final money = NumberFormat.decimalPattern('vi');
  Map<String, dynamic>? quote;
  int? roomTypeId;
  String? error;
  bool busy = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(loadQuote);
  }

  String vnd(Object? amount) =>
      '${money.format(num.tryParse('$amount') ?? 0)}đ';

  Future<void> loadQuote() async {
    if (mounted) {
      setState(() {
        quote = null;
        error = null;
      });
    }
    try {
      final api = ref.read(stayNestApiProvider);
      final draft = ref.read(bookingDraftProvider);
      final property = await api.property(draft.propertySlug);
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

      final rooms = property['rooms'] as List;
      if (rooms.isEmpty) {
        throw const StayNestApiException(
          'NO_ROOMS',
          'Chưa có phòng khả dụng.',
          404,
        );
      }
      final room = rooms.cast<Map>().firstWhere(
        (item) => toInt(item['id']) == draft.selectedRoomTypeId,
        orElse: () => rooms.first as Map,
      );
      final id = toInt(room['id']);
      draft.selectedRoomTypeId = id;
      draft.selectedRoomName = '${room['name']}';
      final result = await api.quote(draft.details(id));
      if (!mounted) return;
      setState(() {
        roomTypeId = id;
        quote = result;
        error = null;
      });
      ref.read(bookingDraftProvider).quote = result;
    } catch (caught) {
      if (!mounted) return;
      setState(() => error = '$caught');
    }
  }

  Future<void> createBooking() async {
    if (quote == null || roomTypeId == null || busy) return;
    final draft = ref.read(bookingDraftProvider);
    final api = ref.read(stayNestApiProvider);

    if (draft.guestName.isEmpty ||
        draft.guestEmail.isEmpty ||
        draft.guestPhone.isEmpty) {
      if (await api.token != null) {
        try {
          final user = await api.getMe();
          draft.prefillGuestFromUser(user);
        } catch (_) {}
      }
    }

    if (!mounted) return;

    if (draft.guestName.isEmpty ||
        draft.guestEmail.isEmpty ||
        draft.guestPhone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập thông tin khách lưu trú.')),
      );
      context.go('/booking/guests');
      return;
    }
    setState(() => busy = true);
    try {
      if (await api.token == null) {
        draft.resumeAfterLogin = true;
        if (mounted) context.go('/login');
        return;
      }
      final details = {
        ...draft.details(roomTypeId!),
        'guestName': draft.guestName,
        'guestEmail': draft.guestEmail,
        'guestPhone': draft.guestPhone,
        if (draft.specialRequest != null)
          'specialRequest': draft.specialRequest,
        if (draft.arrivalWindow != null) 'arrivalWindow': draft.arrivalWindow,
      };
      draft.idempotencyKey ??= DateTime.now().microsecondsSinceEpoch.toString();
      final booking = await api.book(details, draft.idempotencyKey!);
      draft.booking = booking;
      ref.invalidate(myBookingsProvider);
      if (mounted) context.push('/booking/payment-method');
    } catch (caught) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$caught')));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go('/booking/requests'),
                    icon: const Icon(Icons.arrow_back, size: 20),
                  ),
                  const Expanded(
                    child: Text(
                      'Thanh toán',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 15,
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
            Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 8),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BƯỚC 4/4: THANH TOÁN',
                    style: TextStyle(fontSize: 10, color: teal),
                  ),
                  SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: 1,
                    minHeight: 4,
                    color: teal,
                    backgroundColor: Color(0xFFEAF0FE),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _card(
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(9),
                            child: FigmaRaster(
                              ref
                                      .read(bookingDraftProvider)
                                      .selectedRoomName
                                      .contains('Garden')
                                  ? 'assets/images/room_garden_049.jpg'
                                  : 'assets/images/payment_summary_064.jpg',
                              width: 80,
                              height: 78,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '♧ ${ref.read(bookingDraftProvider).propertyAddress.isNotEmpty ? ref.read(bookingDraftProvider).propertyAddress : ref.read(bookingDraftProvider).destinationName}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: muted,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  ref
                                          .read(bookingDraftProvider)
                                          .propertyName
                                          .isNotEmpty
                                      ? ref
                                            .read(bookingDraftProvider)
                                            .propertyName
                                      : 'Mây Homestay',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: ink,
                                  ),
                                ),
                                Text(
                                  ref
                                      .read(bookingDraftProvider)
                                      .selectedRoomName,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: muted,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '▣ ${ref.read(bookingDraftProvider).checkInIso} – ${ref.read(bookingDraftProvider).checkOutIso} · ${quote?['nights'] ?? '—'} đêm · ${ref.read(bookingDraftProvider).adults} khách',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                color: teal,
                                size: 18,
                              ),
                              SizedBox(width: 7),
                              Text(
                                'Chi tiết giá',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: ink,
                                ),
                              ),
                              Spacer(),
                              Text(
                                '✿ Minh bạch 100%',
                                style: TextStyle(fontSize: 10, color: teal),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _price(
                            '${vnd(quote?['nightlyPriceVnd'])} × ${quote?['nights'] ?? '—'} đêm',
                            vnd(quote?['roomSubtotalVnd']),
                          ),
                          _price('Thuế (VAT 10%)  ⓘ', vnd(quote?['taxVnd'])),
                          _price(
                            'Phí dịch vụ StayNest  ⓘ',
                            vnd(quote?['serviceFeeVnd']),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF7F6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '♧ Mã giảm giá ${ref.read(bookingDraftProvider).promotionCode ?? 'Không có'}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF00A86B),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '−${vnd(quote?['discountVnd'])}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF00A86B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 20, color: Color(0xFFEAF0FE)),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Tổng thanh toán',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: ink,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Đã bao gồm toàn bộ thuế & phí',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: muted,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                vnd(quote?['totalVnd']),
                                style: const TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.w700,
                                  color: teal,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (error != null)
                      Text(error!, style: const TextStyle(color: Colors.red)),
                    if (quote == null && error == null)
                      const Center(child: CircularProgressIndicator()),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () async {
                        await context.push('/booking/coupons');
                        if (mounted) loadQuote();
                      },
                      child: _card(
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 19,
                              backgroundColor: Color(0xFFEAF7F6),
                              child: Icon(Icons.percent, color: teal, size: 20),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ref
                                                .read(bookingDraftProvider)
                                                .promotionCode ==
                                            null
                                        ? 'Mã ưu đãi'
                                        : 'Mã ưu đãi   Đã áp dụng',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: muted,
                                    ),
                                  ),
                                  Text(
                                    ref
                                                .read(bookingDraftProvider)
                                                .promotionCode ==
                                            null
                                        ? 'Chưa áp dụng'
                                        : 'STAY100 (−${vnd(quote?['discountVnd'])})',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: ink,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Text(
                              'Đổi mã ›',
                              style: TextStyle(fontSize: 11, color: teal),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4F4),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.shield_outlined,
                            color: Color(0xFF12B76A),
                            size: 20,
                          ),
                          SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              'Cam kết giá minh bạch từ StayNest: Mọi chi phí được thông báo đầy đủ. Quý khách tuyệt đối không phải chịu phụ phí ẩn phát sinh tại nơi lưu trú.',
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.6,
                                color: muted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _card(
                      Text(
                        '▣  Hủy phòng miễn phí trước 14:00, ${ref.read(bookingDraftProvider).checkIn.subtract(const Duration(days: 2)).day}/${ref.read(bookingDraftProvider).checkIn.subtract(const Duration(days: 2)).month}/${ref.read(bookingDraftProvider).checkIn.year}',
                        style: const TextStyle(fontSize: 11, color: ink),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
              color: Colors.white,
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed:
                      quote == null ||
                          busy ||
                          (num.tryParse('${quote?['availableUnits']}') ?? 0) < 1
                      ? null
                      : createBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: teal,
                    disabledBackgroundColor: const Color(0xFF9AA9A9),
                    disabledForegroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    busy ? 'Đang giữ phòng…' : 'Chọn thanh toán',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _card(Widget child) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0D172B4D),
          blurRadius: 13,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: child,
  );
  Widget _price(String label, String price) => Padding(
    padding: const EdgeInsets.only(bottom: 15),
    child: Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: muted),
          ),
        ),
        Text(price, style: const TextStyle(fontSize: 12, color: ink)),
      ],
    ),
  );
}
