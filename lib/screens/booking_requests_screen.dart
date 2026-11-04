import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/staynest_api.dart';

import '../widgets/figma_asset.dart';
import '../widgets/user_avatar_app_bar.dart';

class BookingRequestsScreen extends ConsumerStatefulWidget {
  const BookingRequestsScreen({super.key});
  @override
  ConsumerState<BookingRequestsScreen> createState() =>
      _BookingRequestsScreenState();
}

class _BookingRequestsScreenState extends ConsumerState<BookingRequestsScreen> {
  static const ink = Color(0xFF182230);
  static const muted = Color(0xFF667085);
  static const teal = Color(0xFF006768);
  final note = TextEditingController();
  int arrival = 0;
  bool agree = true;

  @override
  void dispose() {
    note.dispose();
    super.dispose();
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
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.canPop()
                        ? context.pop()
                        : context.go('/booking/guests'),
                    icon: const Icon(Icons.arrow_back, size: 19),
                  ),
                  const Expanded(
                    child: Text(
                      'Yêu cầu dịch vụ',
                      textAlign: TextAlign.center,
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
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BƯỚC 3/4: YÊU CẦU DỊCH VỤ',
                    style: TextStyle(fontSize: 9, color: teal),
                  ),
                  SizedBox(height: 5),
                  LinearProgressIndicator(
                    value: .75,
                    minHeight: 4,
                    color: teal,
                    backgroundColor: Color(0xFFE6EAEF),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '● Phòng được kiểm tra khi tạo đơn',
                    style: TextStyle(fontSize: 9, color: muted),
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
                    _card(
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: FigmaRaster(
                              ref.read(bookingDraftProvider).selectedRoomImage,
                              width: 50,
                              height: 52,
                            ),
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CHỖ NGHỈ ĐÃ CHỌN',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                    color: teal,
                                  ),
                                ),
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
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: ink,
                                  ),
                                ),
                                Text(
                                  '▣ ${ref.read(bookingDraftProvider).checkInIso} – ${ref.read(bookingDraftProvider).checkOutIso} (${ref.read(bookingDraftProvider).nights} đêm) · ${ref.read(bookingDraftProvider).selectedRoomName}',
                                  style: const TextStyle(
                                    fontSize: 9,
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
                                Icons.access_time_filled,
                                size: 18,
                                color: teal,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Giờ đến dự kiến',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: ink,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Homestay nhận phòng từ 14:00 ngày ${ref.read(bookingDraftProvider).checkIn.day}/${ref.read(bookingDraftProvider).checkIn.month}/${ref.read(bookingDraftProvider).checkIn.year}',
                            style: const TextStyle(fontSize: 10, color: muted),
                          ),
                          const SizedBox(height: 12),
                          _arrival(
                            0,
                            '14:00 – 16:00',
                            'Khung giờ phổ biến của homestay',
                          ),
                          _arrival(
                            1,
                            '16:00 – 18:00',
                            'Nhận phòng chiều tà, ngắm hoàng hôn',
                          ),
                          _arrival(
                            2,
                            'Sau 18:00',
                            'Check-in muộn (Vui lòng báo trước host)',
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            '♧ Host hỗ trợ tự nhận phòng qua smartlock nếu bạn đến sau 21:00.',
                            style: TextStyle(
                              fontSize: 10,
                              height: 1.5,
                              color: muted,
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
                              Expanded(
                                child: Text(
                                  'Ghi chú cho chỗ ở',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: ink,
                                  ),
                                ),
                              ),
                              Text(
                                'Không bắt buộc',
                                style: TextStyle(fontSize: 9, color: muted),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Yêu cầu thêm (tùy chọn)',
                            style: TextStyle(fontSize: 10, color: muted),
                          ),
                          const SizedBox(height: 6),
                          TextField(
                            controller: note,
                            maxLines: 4,
                            maxLength: 250,
                            decoration: InputDecoration(
                              hintText: 'Ví dụ: yêu cầu chuẩn bị thêm gối, check-in sớm nếu có phòng trống, chuẩn bị bàn trà ngoài sân...',
                              hintStyle: const TextStyle(
                                fontSize: 11,
                                color: muted,
                              ),
                              filled: true,
                              fillColor: const Color(0xFFF5F8F8),
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const Text(
                            'GỢI Ý NHANH',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: muted,
                            ),
                          ),
                          const SizedBox(height: 7),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              for (final suggestion in [
                                '+ Thêm gối & chăn',
                                '+ Check-in sớm nếu được',
                                '+ View đồi yên tĩnh',
                              ])
                                ActionChip(
                                  label: Text(
                                    suggestion,
                                    style: const TextStyle(fontSize: 9),
                                  ),
                                  onPressed: () {
                                    note.text = note.text.isEmpty
                                        ? suggestion.substring(2)
                                        : '${note.text}, ${suggestion.substring(2)}';
                                  },
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF7F6),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: const Text(
                              'ⓘ Yêu cầu đặc biệt tùy thuộc vào tình trạng phòng sẵn có và cần được chủ nhà xác nhận khi tiếp nhận đặt phòng.',
                              style: TextStyle(
                                fontSize: 10,
                                height: 1.5,
                                color: ink,
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
                          const Text(
                            '♧ Điều khoản & Nội quy',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: ink,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Checkbox(
                                value: agree,
                                activeColor: teal,
                                onChanged: (value) =>
                                    setState(() => agree = value ?? false),
                              ),
                              const Expanded(
                                child: Text(
                                  'Tôi đã đọc và đồng ý với các nội quy chỗ ở & quy định lưu trú của Mây Homestay.',
                                  style: TextStyle(
                                    fontSize: 10,
                                    height: 1.5,
                                    color: ink,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(),
                          const Text(
                            '● Hủy miễn phí trước 48h                  Chính sách hủy →',
                            style: TextStyle(fontSize: 10, color: teal),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _card(
                      const Row(
                        children: [
                          Icon(Icons.handshake_outlined, color: teal, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Cam kết hỗ trợ 24/7 từ StayNest',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: ink,
                                  ),
                                ),
                                Text(
                                  'Bảo vệ quyền lợi khách hàng suốt chuyến đi',
                                  style: TextStyle(fontSize: 9, color: muted),
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
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tiền phòng tạm tính',
                          style: TextStyle(fontSize: 9, color: muted),
                        ),
                        Text(
                          '${ref.read(bookingDraftProvider).roomSubtotalLabel} / ${ref.read(bookingDraftProvider).nights} đêm',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 104,
                    height: 42,
                    child: ElevatedButton(
                      onPressed: agree
                          ? () {
                              final draft = ref.read(bookingDraftProvider);
                              draft.specialRequest = note.text.trim().isEmpty
                                  ? null
                                  : note.text.trim();
                              draft.arrivalWindow = [
                                '14:00-16:00',
                                '16:00-18:00',
                                '18:00-20:00',
                              ][arrival];
                              draft.idempotencyKey = null;
                              draft.booking = null;
                              context.push('/booking/price');
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: teal,
                        disabledForegroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: const Text(
                        'Tiếp tục →',
                        style: TextStyle(fontSize: 11),
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
      borderRadius: BorderRadius.circular(13),
    ),
    child: child,
  );
  Widget _arrival(int index, String title, String subtitle) => InkWell(
    onTap: () => setState(() => arrival = index),
    child: Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: arrival == index
            ? const Color(0xFFEAF7F6)
            : const Color(0xFFF5F8F8),
        borderRadius: BorderRadius.circular(9),
        border: arrival == index ? Border.all(color: teal) : null,
      ),
      child: Row(
        children: [
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
                  style: const TextStyle(fontSize: 9, color: muted),
                ),
              ],
            ),
          ),
          Icon(
            arrival == index ? Icons.check_circle : Icons.circle,
            color: arrival == index ? teal : const Color(0xFFE3E8E9),
            size: 19,
          ),
        ],
      ),
    ),
  );
}
