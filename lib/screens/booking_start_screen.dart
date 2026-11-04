import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/staynest_api.dart';

import '../widgets/figma_asset.dart';
import '../widgets/user_avatar_app_bar.dart';

class BookingStartScreen extends ConsumerStatefulWidget {
  const BookingStartScreen({super.key});
  @override
  ConsumerState<BookingStartScreen> createState() => _BookingStartScreenState();
}

class _BookingStartScreenState extends ConsumerState<BookingStartScreen> {
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  static const teal = Color(0xFF006768);
  bool selfGuest = true;
  BookingDraft get draft => ref.read(bookingDraftProvider);
  int get nights => draft.checkOut.difference(draft.checkIn).inDays;
  String money(Object? amount) => '${amount ?? 0}'.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => '.',
  );
  String get subtotal => draft.quote == null
      ? 'Xem giá ở bước tiếp theo'
      : '${money(draft.quote!['roomSubtotalVnd'])}đ';

  Future<void> selectDates() async {
    final draft = ref.read(bookingDraftProvider);
    final today = DateUtils.dateOnly(DateTime.now());
    final range = await showDateRangePicker(
      context: context,
      firstDate: today.add(const Duration(days: 1)),
      lastDate: today.add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: draft.checkIn,
        end: draft.checkOut,
      ),
    );
    if (range == null || !mounted) return;
    if (range.duration.inDays < 1 || range.duration.inDays > 30) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn từ 1 đến 30 đêm.')),
      );
      return;
    }
    setState(() {
      draft.checkIn = range.start;
      draft.checkOut = range.end;
      draft.idempotencyKey = null;
      draft.booking = null;
      draft.quote = null;
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
              height: 48,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go('/booking/summary'),
                    icon: const Icon(Icons.arrow_back, size: 19),
                  ),
                  const Expanded(
                    child: Text(
                      'Đặt phòng',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: ink,
                      ),
                    ),
                  ),
                  const UserAvatarAppBar(size: 28),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 7, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Bước 1/4 — THÔNG TIN PHÒNG',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: teal,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const LinearProgressIndicator(
                      value: .25,
                      minHeight: 4,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: teal,
                      backgroundColor: Color(0xFFE6EAEF),
                    ),
                    const SizedBox(height: 16),
                    _card(
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(13),
                            ),
                            child: Stack(
                              children: [
                                FigmaRaster(
                                  draft.selectedRoomImage,
                                  width: 350,
                                  height: 150,
                                ),
                                Positioned(
                                  left: 10,
                                  top: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      '♧ ${draft.propertyAddress.isNotEmpty ? draft.propertyAddress : draft.destinationName}',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: ink,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  left: 10,
                                  bottom: 12,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        draft.propertyName.isNotEmpty
                                            ? draft.propertyName
                                            : 'Mây Homestay',
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        draft.selectedRoomName,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 9),
                          Row(
                            children: [
                              const Text(
                                '♧ Xem chính sách hủy khi xác nhận giá',
                                style: TextStyle(fontSize: 10, color: teal),
                              ),
                              const Spacer(),
                              const Text(
                                'Sửa phòng ›',
                                style: TextStyle(fontSize: 10, color: teal),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          InkWell(
                            onTap: selectDates,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '▣ Thời gian · chạm để đổi',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: muted,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '${ref.read(bookingDraftProvider).checkIn.day}/${ref.read(bookingDraftProvider).checkIn.month} – ${ref.read(bookingDraftProvider).checkOut.day}/${ref.read(bookingDraftProvider).checkOut.month}/${ref.read(bookingDraftProvider).checkOut.year}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: ink,
                                          ),
                                        ),
                                        Text(
                                          '$nights đêm',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: muted,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '♧ Khách & Phòng',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: muted,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '${draft.adults} người lớn',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: ink,
                                          ),
                                        ),
                                        Text(
                                          '${draft.roomCount} × ${draft.selectedRoomName}',
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
                              Text(
                                'TẠM TÍNH TIỀN PHÒNG',
                                style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: .5,
                                  color: muted,
                                ),
                              ),
                              Spacer(),
                              Text(
                                'Giá tốt nhất',
                                style: TextStyle(fontSize: 9, color: muted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Text(
                                draft.quote == null
                                    ? 'Giá phòng đang cập nhật'
                                    : '${money(draft.quote!['nightlyPriceVnd'])}đ × $nights đêm',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: ink,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                subtotal,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: ink,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Text(
                            'ⓘ Chưa bao gồm thuế và phí dịch vụ',
                            style: TextStyle(fontSize: 10, color: muted),
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
                              Text(
                                'Ai sẽ lưu trú?',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: ink,
                                ),
                              ),
                              Spacer(),
                              Text(
                                '♙ Bảo mật',
                                style: TextStyle(fontSize: 10, color: teal),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          _choice(
                            true,
                            'Tôi là người lưu trú',
                            'Sử dụng thông tin tài khoản đã đăng ký của bạn',
                          ),
                          const SizedBox(height: 8),
                          _choice(
                            false,
                            'Tôi đặt phòng giúp người khác',
                            'Nhập tên và số liên hệ của người nhận phòng',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF7F6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'ⓘ Mọi chi tiết đặt phòng có thể xem lại trước khi tiến hành thanh toán. Không phát sinh chi phí ẩn trong suốt quá trình.',
                        style: TextStyle(fontSize: 11, height: 1.5, color: ink),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _card(
                      const Row(
                        children: [
                          Icon(
                            Icons.verified_user_outlined,
                            size: 20,
                            color: teal,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cam kết phòng đúng ảnh',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: ink,
                                  ),
                                ),
                                Text(
                                  'Hoàn tiền 100% nếu phòng không như mô tả',
                                  style: TextStyle(fontSize: 10, color: muted),
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
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Row(
                    children: [
                      Text(
                        'Tiền phòng tạm tính',
                        style: TextStyle(fontSize: 10, color: muted),
                      ),
                      Spacer(),
                      Text(
                        '♧ Giữ giá tốt',
                        style: TextStyle(fontSize: 10, color: teal),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '$subtotal / $nights đêm',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: teal,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => context.push('/booking/guests'),
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
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    ),
    child: child,
  );
  Widget _choice(bool value, String title, String subtitle) => InkWell(
    onTap: () => setState(() => selfGuest = value),
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: selfGuest == value
            ? const Color(0xFFEAF7F6)
            : const Color(0xFFF7F9FC),
        borderRadius: BorderRadius.circular(11),
        border: selfGuest == value ? Border.all(color: teal) : null,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Icon(
              value ? Icons.person : Icons.person_add_alt_1_outlined,
              color: teal,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
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
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 10, color: muted),
                ),
              ],
            ),
          ),
          Icon(
            selfGuest == value
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: selfGuest == value ? teal : muted,
            size: 18,
          ),
        ],
      ),
    ),
  );
}
