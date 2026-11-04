import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../data/staynest_api.dart';
import '../widgets/figma_asset.dart';

class LivePaymentSuccessScreen extends ConsumerWidget {
  const LivePaymentSuccessScreen({super.key, required this.bookingId});
  final int bookingId;

  static const teal = Color(0xFF006768);

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: FutureBuilder<Map<String, dynamic>>(
          future: ref.read(stayNestApiProvider).booking(bookingId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: snapshot.hasError
                    ? Text('Không thể tải đặt phòng: ${snapshot.error}')
                    : const CircularProgressIndicator(),
              );
            }
            final booking = snapshot.data!;
            if (booking['status'] != 'CONFIRMED_DEMO') {
              return const Center(
                child: Text(
                  'Đặt phòng này chưa được xác nhận thanh toán mô phỏng.',
                ),
              );
            }
            final amount = NumberFormat.decimalPattern('vi')
                .format(num.tryParse('${booking['total_vnd']}') ?? 0);
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 42, 20, 64),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFFEAF7F6),
                    child: Icon(Icons.check_circle, color: teal, size: 44),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Đặt phòng đã xác nhận',
                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Thanh toán mô phỏng · Không phát sinh giao dịch ngân hàng',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 18),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        const FigmaRaster(
                          'assets/images/scr_074_00.jpg',
                          width: double.infinity,
                          height: 94,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                '${booking['property_name']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Mã đặt phòng: ${booking['booking_code']}',
                                style: const TextStyle(
                                  color: teal,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text('Loại phòng: ${booking['room_name']}'),
                              Text(
                                'Thời gian: ${booking['check_in_date']} – ${booking['check_out_date']}',
                              ),
                              Text('Khách: ${booking['guest_name']}'),
                              const SizedBox(height: 10),
                              Text(
                                'Tổng mô phỏng: $amountđ',
                                style: const TextStyle(
                                  color: teal,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  FutureBuilder<Map<String, dynamic>>(
                    future: ref.read(stayNestApiProvider).receipt(bookingId),
                    builder: (context, receipt) => receipt.hasData
                        ? Text(
                            'Biên nhận demo: ${receipt.data!['payment']['demo_reference']}',
                            style: const TextStyle(color: teal),
                          )
                        : receipt.hasError
                        ? const Text('Biên nhận demo chưa khả dụng')
                        : const CircularProgressIndicator(),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          context.go('/trips/booking/live/$bookingId'),
                      child: const Text('Xem chuyến đi'),
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/'),
                    child: const Text('Về trang chủ'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );
}
