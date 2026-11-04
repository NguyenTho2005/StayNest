import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../data/staynest_api.dart';
import '../utils/date_formatters.dart';

class LiveTripDetailScreen extends ConsumerStatefulWidget {
  const LiveTripDetailScreen({super.key, required this.bookingId});
  final int bookingId;

  @override
  ConsumerState<LiveTripDetailScreen> createState() =>
      _LiveTripDetailScreenState();
}

class _LiveTripDetailScreenState extends ConsumerState<LiveTripDetailScreen> {
  static const teal = Color(0xFF006768);
  Future<Map<String, dynamic>>? bookingFuture;
  bool busy = false;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() => setState(() {
    bookingFuture = ref.read(stayNestApiProvider).booking(widget.bookingId);
  });

  String money(Object? value) =>
      '${NumberFormat.decimalPattern('vi').format(num.tryParse('$value') ?? 0)}đ';

  Future<void> runAction(Future<void> Function() action) async {
    if (busy) return;
    setState(() => busy = true);
    try {
      await action();
      ref.invalidate(myBookingsProvider);
      if (mounted) refresh();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$error')));
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> cancel() async {
    final api = ref.read(stayNestApiProvider);
    final preview = await api.cancellationPreview(widget.bookingId);
    if (!mounted) return;
    final reason = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hủy đặt phòng'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hoàn tiền mô phỏng dự kiến: ${money(preview['estimatedRefundVnd'])}',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: reason,
              decoration: const InputDecoration(labelText: 'Lý do hủy'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Quay lại'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xác nhận hủy'),
          ),
        ],
      ),
    );
    if (confirmed == true && reason.text.trim().isNotEmpty) {
      await api.cancelBooking(widget.bookingId, reason.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã hủy. Hoàn tiền chỉ là mô phỏng.')),
        );
      }
    }
    reason.dispose();
  }

  Future<void> requestChange() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateUtils.dateOnly(now).add(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (range == null ||
        range.duration.inDays < 1 ||
        range.duration.inDays > 30) {
      return;
    }
    await ref
        .read(stayNestApiProvider)
        .changeDates(
          widget.bookingId,
          range.start.toIso8601String().substring(0, 10),
          range.end.toIso8601String().substring(0, 10),
        );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Yêu cầu đổi ngày đã được ghi nhận; ngày đặt phòng hiện tại chưa thay đổi.',
          ),
        ),
      );
    }
  }

  Future<void> writeReview() async {
    var rating = 5;
    final comment = TextEditingController();
    final submit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, update) => AlertDialog(
          title: const Text('Đánh giá lưu trú'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: rating,
                items: [1, 2, 3, 4, 5]
                    .map(
                      (n) => DropdownMenuItem(value: n, child: Text('$n sao')),
                    )
                    .toList(),
                onChanged: (n) => update(() => rating = n ?? rating),
              ),
              TextField(
                controller: comment,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Nhận xét'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Gửi đánh giá'),
            ),
          ],
        ),
      ),
    );
    if (submit == true && comment.text.trim().isNotEmpty) {
      await ref
          .read(stayNestApiProvider)
          .review(widget.bookingId, rating, comment.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Đánh giá đã được lưu.')));
      }
    }
    comment.dispose();
  }

  Future<void> showRefund() async {
    final result = await ref.read(stayNestApiProvider).refund(widget.bookingId);
    if (!mounted) return;
    final refund = result['refund'];
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hoàn tiền mô phỏng'),
        content: Text(
          refund == null
              ? 'Không có khoản hoàn tiền.'
              : 'Mã ${refund['demo_refund_code']} · ${money(refund['amount_vnd'])} · ${refund['status']}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: const Color(0xFFF7F9FC),
    appBar: AppBar(
      title: const Text('Chi tiết chuyến đi'),
      backgroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.go('/trips'),
      ),
    ),
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: FutureBuilder<Map<String, dynamic>>(
          future: bookingFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: snapshot.hasError
                    ? Text('Không thể tải đơn: ${snapshot.error}')
                    : const CircularProgressIndicator(),
              );
            }
            final booking = snapshot.data!;
            final status = '${booking['status']}';
            final checkout = DateTime.tryParse('${booking['check_out_date']}');
            final canReview =
                (status == 'CONFIRMED_DEMO' || status == 'COMPLETED') &&
                checkout != null &&
                checkout.isBefore(DateTime.now());
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${booking['property_name']}',
                          style: const TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w700,
                            color: teal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${booking['room_name']} · ${booking['booking_code']}',
                        ),
                        const SizedBox(height: 8),
                        Text(
                          formatStayDateRange(
                            booking['check_in_date'],
                            booking['check_out_date'],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Trạng thái: $status'),
                        const SizedBox(height: 8),
                        Text(
                          'Tổng: ${money(booking['total_vnd'])}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Thanh toán và hoàn tiền, nếu có, chỉ là mô phỏng.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  leading: const Icon(
                    Icons.confirmation_number_outlined,
                    color: teal,
                  ),
                  title: const Text('Xem voucher xác nhận'),
                  subtitle: const Text('SCR-083: Mã đặt và QR'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => context.push('/trips/booking/voucher'),
                ),
                const SizedBox(height: 8),
                ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  leading: const Icon(Icons.directions_outlined, color: teal),
                  title: const Text('Chỉ đường & Liên hệ host'),
                  subtitle: const Text('SCR-084: Bản đồ & Chat'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => context.push('/trips/booking/directions'),
                ),
                const SizedBox(height: 8),
                ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  leading: const Icon(Icons.help_outline, color: teal),
                  title: const Text('Trung tâm trợ giúp 24/7'),
                  subtitle: const Text('SCR-096: FAQ & Chat hỗ trợ'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () => context.push('/trips/help'),
                ),
                if (status == 'CONFIRMED_DEMO') ...[
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: busy
                        ? null
                        : () => context.push('/trips/booking/change-dates'),
                    child: const Text('Yêu cầu đổi ngày (SCR-085)'),
                  ),
                ],
                if (status == 'CONFIRMED_DEMO' ||
                    status == 'PENDING_PAYMENT') ...[
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: busy
                        ? null
                        : () => context.push('/trips/booking/cancel'),
                    child: const Text('Hủy đặt phòng (SCR-087)'),
                  ),
                ],
                if (status == 'CANCELLED') ...[
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () =>
                        context.push('/trips/refund-tracking-demo'),
                    child: const Text('Theo dõi hoàn tiền (SCR-092)'),
                  ),
                ],
                if (canReview) ...[
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.push('/trips/completed/review'),
                    child: const Text('Viết đánh giá (SCR-095)'),
                  ),
                ],
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => context.push('/trips/overview-demo'),
                  child: const Text('Xem tổng kết hành trình (SCR-100) →'),
                ),
              ],
            );
          },
        ),
      ),
    ),
  );
}
