import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/staynest_api.dart';
import '../design/tokens.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/figma_asset.dart';

class MyTripsScreen extends ConsumerStatefulWidget {
  const MyTripsScreen({super.key});

  @override
  ConsumerState<MyTripsScreen> createState() => _MyTripsScreenState();
}

class _MyTripsScreenState extends ConsumerState<MyTripsScreen> {
  int _tab = 0;

  int tripGroup(Map item) {
    final status = item['status'];
    if (status == 'CANCELLED') return 2;
    final checkout = DateTime.tryParse('${item['check_out_date']}');
    if (status == 'COMPLETED' ||
        (status == 'CONFIRMED_DEMO' &&
            checkout != null &&
            checkout.isBefore(DateTime.now()))) {
      return 1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final bookings = ref.watch(myBookingsProvider);
    final items = bookings.value ?? [];
    final visible = items
        .where((item) => tripGroup(item as Map) == _tab)
        .toList();
    return Scaffold(
      backgroundColor: StayNestColors.canvas,
      bottomNavigationBar: const StayNestBottomNavigation(selectedIndex: 3),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390),
          child: Column(
            children: [
              SizedBox(
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: StayNestColors.paleTeal,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.luggage_outlined,
                            size: 20,
                            color: StayNestColors.teal,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Chuyến Đi',
                          style: TextStyle(
                            fontSize: 22,
                            height: 28 / 22,
                            fontWeight: FontWeight.w600,
                            color: StayNestColors.ink,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(
                          Icons.notifications_none,
                          size: 22,
                          color: StayNestColors.ink,
                        ),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () => context.go('/account'),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: StayNestColors.teal,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: FigmaSvg(
                              'assets/icons/trips_04.svg',
                              width: 12,
                              height: 13.333,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 48,
                child: Row(
                  children: [
                    _TripTab(
                      label:
                          'Sắp tới (${items.where((item) => tripGroup(item as Map) == 0).length})',
                      selected: _tab == 0,
                      onTap: () => setState(() => _tab = 0),
                    ),
                    _TripTab(
                      label: 'Đã hoàn thành',
                      selected: _tab == 1,
                      onTap: () => setState(() => _tab = 1),
                    ),
                    _TripTab(
                      label: 'Đã hủy',
                      selected: _tab == 2,
                      onTap: () => setState(() => _tab = 2),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: bookings.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : bookings.hasError
                      ? Center(
                          child: Text(
                            'Không thể tải chuyến đi: ${bookings.error}',
                          ),
                        )
                      : visible.isEmpty
                      ? _TripEmptyState(tab: _tab)
                      : Column(
                          children: visible
                              .map(
                                (item) => _LiveTripCard(
                                  booking: item as Map<String, dynamic>,
                                ),
                              )
                              .toList(),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LiveTripCard extends StatelessWidget {
  const _LiveTripCard({required this.booking});
  final Map<String, dynamic> booking;

  @override
  Widget build(BuildContext context) {
    final amount = NumberFormat.decimalPattern('vi')
        .format(num.tryParse('${booking['total_vnd']}') ?? 0);
    final status = booking['status'] == 'CONFIRMED_DEMO'
        ? 'Đã xác nhận mô phỏng'
        : booking['status'] == 'PENDING_PAYMENT'
        ? 'Chờ thanh toán mô phỏng'
        : booking['status'] == 'CANCELLED'
        ? 'Đã hủy'
        : 'Đã hoàn thành';
    return InkWell(
      onTap: () => context.push('/trips/booking/live/${booking['id']}'),
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${booking['property_name']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Text('${booking['room_name']} · ${booking['booking_code']}'),
              const SizedBox(height: 6),
              Text(
                '${booking['check_in_date']} – ${booking['check_out_date']}',
              ),
              const SizedBox(height: 6),
              Text(status, style: const TextStyle(color: StayNestColors.teal)),
              const SizedBox(height: 8),
              Text(
                '$amountđ',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: StayNestColors.teal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TripTab extends StatelessWidget {
  const _TripTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? StayNestColors.teal
                      : const Color(0xFF667085),
                ),
              ),
            ),
          ),
          Container(
            height: 2,
            width: 80,
            decoration: BoxDecoration(
              color: selected ? StayNestColors.teal : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    ),
  );
}

class UpcomingTripDemoContent extends StatelessWidget {
  const UpcomingTripDemoContent({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Container(
        height: 56,
        decoration: BoxDecoration(
          color: StayNestColors.paleTeal,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: StayNestColors.white,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FigmaSvg(
                  'assets/icons/trips_05.svg',
                  width: 12,
                  height: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Chuyến đi sắp tới của bạn đã được thanh toán và xác nhận an toàn bởi StayNest.',
                style: TextStyle(
                  fontSize: 11,
                  height: 16 / 11,
                  color: StayNestColors.teal,
                ),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: StayNestColors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D172B4D),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1.99,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const FigmaRaster('assets/images/trips_01.jpg'),
                  Positioned(
                    left: 12,
                    top: 12,
                    child: _TripBadge(
                      icon: 'assets/icons/trips_08.svg',
                      text: 'Mã: SN-1024',
                    ),
                  ),
                  Positioned(
                    right: 12,
                    top: 12,
                    child: _TripBadge(
                      icon: 'assets/icons/trips_09.svg',
                      text: 'Đã xác nhận',
                      success: true,
                    ),
                  ),
                  const Positioned(
                    left: 12,
                    bottom: 12,
                    child: Row(
                      children: [
                        FigmaSvg(
                          'assets/icons/trips_06.svg',
                          width: 15,
                          height: 15,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Hội An, Quảng Nam',
                          style: TextStyle(
                            fontSize: 11,
                            height: 16 / 11,
                            color: StayNestColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Mây Homestay',
                    style: TextStyle(
                      fontSize: 16,
                      height: 22 / 16,
                      fontWeight: FontWeight.w600,
                      color: StayNestColors.ink,
                    ),
                  ),
                  const Text(
                    'Phòng Studio có bếp',
                    style: TextStyle(
                      fontSize: 14,
                      height: 20 / 14,
                      color: StayNestColors.muted,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F4F4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            FigmaSvg(
                              'assets/icons/trips_03.svg',
                              width: 13.5,
                              height: 15,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '14–16/11/2026 · 2 đêm',
                              style: TextStyle(
                                fontSize: 11,
                                height: 16 / 11,
                                color: StayNestColors.ink,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            FigmaSvg(
                              'assets/icons/trips_04.svg',
                              width: 16.5,
                              height: 12,
                            ),
                            SizedBox(width: 8),
                            Text(
                              '2 người lớn · 1 phòng',
                              style: TextStyle(
                                fontSize: 11,
                                height: 16 / 11,
                                color: StayNestColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Đã thanh toán',
                              style: TextStyle(
                                fontSize: 11,
                                height: 16 / 11,
                                color: StayNestColors.muted,
                              ),
                            ),
                            Text(
                              '1.800.000đ',
                              style: TextStyle(
                                fontSize: 16,
                                height: 22 / 16,
                                fontWeight: FontWeight.w700,
                                color: StayNestColors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: StayNestColors.paleTeal,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            FigmaSvg(
                              'assets/icons/trips_10.svg',
                              width: 12,
                              height: 12,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Thẻ tín dụng',
                              style: TextStyle(
                                fontSize: 10,
                                height: 14 / 10,
                                color: StayNestColors.teal,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: StayNestColors.teal,
                        foregroundColor: StayNestColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Chi tiết đặt phòng',
                            style: TextStyle(
                              fontSize: 14,
                              height: 20 / 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          FigmaSvg(
                            'assets/icons/trips_11.svg',
                            width: 9.75,
                            height: 8.667,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 48,
              color: const Color(0xFFF9FBFC),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _TripAction(
                    icon: 'assets/icons/trips_12.svg',
                    label: 'Chỉ đường',
                  ),
                  _ActionDivider(),
                  _TripAction(
                    icon: 'assets/icons/trips_13.svg',
                    label: 'Xem voucher',
                  ),
                  _ActionDivider(),
                  _TripAction(
                    icon: 'assets/icons/trips_14.svg',
                    label: 'Liên hệ host',
                    muted: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Container(
        height: 64,
        decoration: BoxDecoration(
          color: StayNestColors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: const Row(
          children: [
            FigmaSvg('assets/icons/trips_15.svg', width: 20, height: 20),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hỗ trợ nhận phòng 24/7',
                    style: TextStyle(
                      fontSize: 11,
                      height: 16 / 11,
                      fontWeight: FontWeight.w600,
                      color: StayNestColors.ink,
                    ),
                  ),
                  Text(
                    'Đội ngũ StayNest luôn đồng hành',
                    style: TextStyle(
                      fontSize: 10,
                      height: 14 / 10,
                      color: StayNestColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Gọi ngay',
              style: TextStyle(
                fontSize: 11,
                height: 16 / 11,
                fontWeight: FontWeight.w600,
                color: StayNestColors.teal,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 80),
    ],
  );
}

class _TripBadge extends StatelessWidget {
  const _TripBadge({
    required this.icon,
    required this.text,
    this.success = false,
  });
  final String icon;
  final String text;
  final bool success;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: StayNestColors.white.withValues(alpha: .92),
      borderRadius: BorderRadius.circular(9999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FigmaSvg(icon, width: 12, height: 12),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 10,
            height: 14 / 10,
            color: success ? const Color(0xFF027A48) : StayNestColors.ink,
          ),
        ),
      ],
    ),
  );
}

class _TripAction extends StatelessWidget {
  const _TripAction({
    required this.icon,
    required this.label,
    this.muted = false,
  });
  final String icon;
  final String label;
  final bool muted;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      FigmaSvg(icon, width: 14, height: 14),
      const SizedBox(width: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 10,
          height: 14 / 10,
          color: muted ? StayNestColors.muted : StayNestColors.teal,
        ),
      ),
    ],
  );
}

class _ActionDivider extends StatelessWidget {
  const _ActionDivider();
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 16, color: const Color(0xFFE0E6EC));
}

class _TripEmptyState extends StatelessWidget {
  const _TripEmptyState({required this.tab});
  final int tab;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 300,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const FigmaSvg('assets/icons/trips_15.svg', width: 36, height: 36),
          const SizedBox(height: 12),
          Text(
            tab == 0
                ? 'Chưa có chuyến đi sắp tới'
                : tab == 1
                ? 'Chưa có chuyến đi đã hoàn thành'
                : 'Chưa có chuyến đi đã hủy',
            style: const TextStyle(
              fontSize: 14,
              height: 20 / 14,
              fontWeight: FontWeight.w600,
              color: StayNestColors.ink,
            ),
          ),
        ],
      ),
    ),
  );
}
