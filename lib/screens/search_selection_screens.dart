import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/staynest_api.dart';
import '../design/tokens.dart';
import '../widgets/figma_asset.dart';

class GuestRoomPickerScreen extends ConsumerStatefulWidget {
  const GuestRoomPickerScreen({super.key});
  @override
  ConsumerState<GuestRoomPickerScreen> createState() =>
      _GuestRoomPickerScreenState();
}

class _GuestRoomPickerScreenState extends ConsumerState<GuestRoomPickerScreen> {
  int adults = 2;
  int children = 0;
  int rooms = 1;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(bookingDraftProvider);
    adults = draft.adults;
    children = draft.children;
    rooms = draft.roomCount;
  }

  void applyGuests() {
    final draft = ref.read(bookingDraftProvider);
    draft.adults = adults;
    draft.children = children;
    draft.roomCount = rooms;
    draft.quote = null;
    draft.booking = null;
    draft.idempotencyKey = null;
    context.pop();
  }

  String get selectedDates {
    final draft = ref.read(bookingDraftProvider);
    return '${draft.checkIn.day}–${draft.checkOut.day}/${draft.checkOut.month}/${draft.checkOut.year} · ${draft.checkOut.difference(draft.checkIn).inDays} đêm';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: StayNestColors.canvas,
    body: Column(
      children: [
        _SelectionHeader(
          title: 'Khách & phòng',
          backPath: '/search',
          backIcon: 'assets/icons/guest_room_icon_10.svg',
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: _cardDecoration(),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0x4D8FF3F4),
                          shape: BoxShape.circle,
                        ),
                        child: const FigmaSvg(
                          'assets/icons/guest_room_icon_01.svg',
                          width: 14,
                          height: 17,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hội An',
                              style: TextStyle(
                                color: Color(0xFF121C2A),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              selectedDates,
                              style: const TextStyle(
                                color: Color(0xFF4C5E83),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0x4D8FF3F4),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Row(
                          children: [
                            CircleAvatar(
                              radius: 3,
                              backgroundColor: Color(0xFF006768),
                            ),
                            SizedBox(width: 6),
                            Text(
                              'Đang chọn',
                              style: TextStyle(
                                color: Color(0xFF006768),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: _cardDecoration(),
                  child: Column(
                    children: [
                      _GuestStepper(
                        icon: 'assets/icons/guest_room_icon_02.svg',
                        minusIcon: 'assets/icons/guest_room_icon_03.svg',
                        plusIcon: 'assets/icons/guest_room_icon_04.svg',
                        title: 'Người lớn',
                        subtitle: 'Từ 13 tuổi trở lên',
                        value: adults,
                        onMinus: adults > 1
                            ? () => setState(() => adults--)
                            : null,
                        onPlus: () => setState(() => adults++),
                      ),
                      _GuestStepper(
                        icon: 'assets/icons/guest_room_icon_05.svg',
                        minusIcon: 'assets/icons/guest_room_icon_06.svg',
                        plusIcon: 'assets/icons/guest_room_icon_07.svg',
                        title: 'Trẻ em',
                        subtitle: 'Dưới 12 tuổi',
                        value: children,
                        onMinus: children > 0
                            ? () => setState(() => children--)
                            : null,
                        onPlus: () => setState(() => children++),
                      ),
                      _GuestStepper(
                        icon: 'assets/icons/guest_room_icon_08.svg',
                        minusIcon: 'assets/icons/guest_room_icon_06.svg',
                        plusIcon: 'assets/icons/guest_room_icon_07.svg',
                        title: 'Phòng',
                        subtitle: 'Số lượng phòng lưu trú',
                        value: rooms,
                        onMinus: rooms > 1
                            ? () => setState(() => rooms--)
                            : null,
                        onPlus: () => setState(() => rooms++),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FigmaSvg(
                      'assets/icons/guest_room_icon_11.svg',
                      width: 17,
                      height: 19,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Mỗi tìm kiếm cần ít nhất 1 người lớn và 1 phòng.',
                        style: TextStyle(
                          color: Color(0xFF3D4949),
                          fontSize: 12,
                          height: 19.5 / 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    bottomNavigationBar: Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: Color(0xE6F8F9FF),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F172B4D),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Đang chọn:',
                style: TextStyle(color: Color(0xFF3D4949), fontSize: 12),
              ),
              Text(
                '$adults người lớn, $rooms phòng',
                style: const TextStyle(color: Color(0xFF121C2A), fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: applyGuests,
              style: FilledButton.styleFrom(
                backgroundColor: StayNestColors.tealBright,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Áp dụng',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8),
                  FigmaSvg(
                    'assets/icons/guest_room_icon_09.svg',
                    width: 14,
                    height: 14,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class StayDatePickerScreen extends ConsumerStatefulWidget {
  const StayDatePickerScreen({super.key});
  @override
  ConsumerState<StayDatePickerScreen> createState() =>
      _StayDatePickerScreenState();
}

class _StayDatePickerScreenState extends ConsumerState<StayDatePickerScreen> {
  late DateTime month;
  late DateTime checkIn;
  late DateTime checkOut;
  bool selectingCheckOut = false;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(bookingDraftProvider);
    checkIn = draft.checkIn;
    checkOut = draft.checkOut;
    month = DateTime(checkIn.year, checkIn.month);
  }

  void applyDates() {
    if (!checkOut.isAfter(checkIn)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ngày trả phòng phải sau ngày nhận phòng.'),
        ),
      );
      return;
    }
    final draft = ref.read(bookingDraftProvider);
    draft.checkIn = checkIn;
    draft.checkOut = checkOut;
    draft.quote = null;
    draft.booking = null;
    draft.idempotencyKey = null;
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);
    final offset = (DateTime(month.year, month.month, 1).weekday + 6) % 7;
    final cellCount = ((offset + daysInMonth + 6) ~/ 7) * 7;
    return Scaffold(
      backgroundColor: StayNestColors.canvas,
      body: Column(
        children: [
          _SelectionHeader(
            title: 'Chọn ngày',
            backPath: '/search',
            backIcon: 'assets/icons/stay_dates_icon_09.svg',
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF3FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        FigmaSvg(
                          'assets/icons/stay_dates_icon_01.svg',
                          width: 12,
                          height: 15,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Hội An',
                          style: TextStyle(
                            color: Color(0xFF121C2A),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _DateSummary(
                          label: 'NHẬN PHÒNG',
                          date: _formatDate(checkIn),
                          weekday: _weekday(checkIn),
                          icon: 'assets/icons/stay_dates_icon_02.svg',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _DateSummary(
                          label: 'TRẢ PHÒNG',
                          date: _formatDate(checkOut),
                          weekday: _weekday(checkOut),
                          icon: 'assets/icons/stay_dates_icon_03.svg',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.fromLTRB(12, 11, 12, 12),
                    decoration: _cardDecoration(),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () => setState(
                                () => month = DateTime(
                                  month.year,
                                  month.month - 1,
                                ),
                              ),
                              icon: FigmaSvg(
                                'assets/icons/stay_dates_icon_04.svg',
                                width: 14,
                                height: 14,
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  '${_monthName(month.month)}, ${month.year}',
                                  style: const TextStyle(
                                    color: Color(0xFF121C2A),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              onPressed: () => setState(
                                () => month = DateTime(
                                  month.year,
                                  month.month + 1,
                                ),
                              ),
                              icon: FigmaSvg(
                                'assets/icons/stay_dates_icon_05.svg',
                                width: 14,
                                height: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Row(
                          children: [
                            for (final d in [
                              'T2',
                              'T3',
                              'T4',
                              'T5',
                              'T6',
                              'T7',
                              'CN',
                            ])
                              Expanded(
                                child: Center(
                                  child: Text(
                                    d,
                                    style: TextStyle(
                                      color: Color(0xFF667085),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        for (var week = 0; week < cellCount ~/ 7; week++)
                          Row(
                            children: [
                              for (var col = 0; col < 7; col++)
                                Expanded(
                                  child: _CalendarDay(
                                    date: _calendarDate(
                                      week * 7 + col - offset + 1,
                                    ),
                                    currentMonth:
                                        _calendarDate(
                                          week * 7 + col - offset + 1,
                                        ).month ==
                                        month.month,
                                    selected: _isSelected(
                                      _calendarDate(
                                        week * 7 + col - offset + 1,
                                      ),
                                    ),
                                    inRange: _isInRange(
                                      _calendarDate(
                                        week * 7 + col - offset + 1,
                                      ),
                                    ),
                                    onTap: () => _selectDate(
                                      _calendarDate(
                                        week * 7 + col - offset + 1,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      for (final shortcut in ['Cuối tuần này', '1 tuần'])
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: OutlinedButton(
                            onPressed: () => _selectShortcut(shortcut),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFFDFe9FC),
                              foregroundColor: const Color(0xFF121C2A),
                              side: BorderSide.none,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              minimumSize: const Size(0, 34),
                            ),
                            child: Text(
                              shortcut,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => setState(() {
                          final draft = ref.read(bookingDraftProvider);
                          checkIn = draft.checkIn;
                          checkOut = draft.checkOut;
                          month = DateTime(checkIn.year, checkIn.month);
                        }),
                        child: const Text(
                          'Xoá chọn',
                          style: TextStyle(
                            color: Color(0xFF121C2A),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 10,
                    ),
                    decoration: _cardDecoration(),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEFF3FF),
                            shape: BoxShape.circle,
                          ),
                          child: const FigmaSvg(
                            'assets/icons/stay_dates_icon_06.svg',
                            width: 14,
                            height: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nhận ${checkIn.day}/${checkIn.month} • Trả ${checkOut.day}/${checkOut.month}',
                                style: const TextStyle(
                                  color: Color(0xFF121C2A),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Text(
                                'Giờ nhận 14:00 • Trả 12:00',
                                style: TextStyle(
                                  color: Color(0xFF3D4949),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEFF3FF),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            '${checkOut.difference(checkIn).inDays} đêm',
                            style: const TextStyle(
                              color: Color(0xFF006768),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton(
                onPressed: applyDates,
                style: FilledButton.styleFrom(
                  backgroundColor: StayNestColors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Xác nhận',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    FigmaSvg(
                      'assets/icons/stay_dates_icon_07.svg',
                      width: 14,
                      height: 14,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  DateTime _calendarDate(int day) => DateTime(month.year, month.month, day);
  bool _isSelected(DateTime date) =>
      DateUtils.isSameDay(date, checkIn) || DateUtils.isSameDay(date, checkOut);
  bool _isInRange(DateTime date) =>
      date.isAfter(checkIn) && date.isBefore(checkOut);
  void _selectDate(DateTime date) => setState(() {
    if (!selectingCheckOut ||
        date.isBefore(checkIn) ||
        DateUtils.isSameDay(date, checkIn)) {
      checkIn = date;
      checkOut = date;
      selectingCheckOut = true;
    } else {
      checkOut = date;
      selectingCheckOut = false;
    }
  });
  void _selectShortcut(String label) => setState(() {
    final today = DateUtils.dateOnly(DateTime.now());
    final daysUntilSaturday = (DateTime.saturday - today.weekday + 7) % 7;
    final start = label == 'Cuối tuần này'
        ? today.add(
            Duration(days: daysUntilSaturday == 0 ? 7 : daysUntilSaturday),
          )
        : today.add(const Duration(days: 7));
    checkIn = start;
    checkOut = start.add(Duration(days: label == 'Cuối tuần này' ? 2 : 7));
    selectingCheckOut = false;
    month = DateTime(start.year, start.month);
  });
  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
  String _weekday(DateTime date) => const [
    'Thứ Hai',
    'Thứ Ba',
    'Thứ Tư',
    'Thứ Năm',
    'Thứ Sáu',
    'Thứ Bảy',
    'Chủ Nhật',
  ][date.weekday - 1];
  String _monthName(int value) => const [
    'Tháng 1',
    'Tháng 2',
    'Tháng 3',
    'Tháng 4',
    'Tháng 5',
    'Tháng 6',
    'Tháng 7',
    'Tháng 8',
    'Tháng 9',
    'Tháng 10',
    'Tháng 11',
    'Tháng 12',
  ][value - 1];
}

class _SelectionHeader extends StatelessWidget {
  const _SelectionHeader({
    required this.title,
    required this.backPath,
    required this.backIcon,
  });
  final String title, backPath, backIcon;
  @override
  Widget build(BuildContext context) => Container(
    height: 56,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    decoration: const BoxDecoration(
      color: Color(0xCCF8F9FF),
      boxShadow: [BoxShadow(color: Color(0x0A172B4D), blurRadius: 8)],
    ),
    child: Row(
      children: [
        InkWell(
          onTap: () => context.go(backPath),
          child: FigmaSvg(backIcon, width: 18, height: 18),
        ),
        Expanded(
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF121C2A),
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 36),
      ],
    ),
  );
}

class _GuestStepper extends StatelessWidget {
  const _GuestStepper({
    required this.icon,
    required this.minusIcon,
    required this.plusIcon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });
  final String icon, minusIcon, plusIcon, title, subtitle;
  final int value;
  final VoidCallback? onMinus, onPlus;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FigmaSvg(icon, width: 15, height: 15),
                  const SizedBox(width: 6),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF121C2A),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: Color(0xFF3D4949), fontSize: 12),
              ),
            ],
          ),
        ),
        _CountButton(icon: minusIcon, onTap: onMinus),
        SizedBox(
          width: 34,
          child: Center(
            child: Text(
              '$value',
              style: const TextStyle(
                color: Color(0xFF121C2A),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        _CountButton(icon: plusIcon, onTap: onPlus),
      ],
    ),
  );
}

class _CountButton extends StatelessWidget {
  const _CountButton({required this.icon, required this.onTap});
  final String icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    customBorder: const CircleBorder(),
    child: Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFFE6EEFF),
        shape: BoxShape.circle,
      ),
      child: FigmaSvg(icon, width: 12, height: 12),
    ),
  );
}

class _DateSummary extends StatelessWidget {
  const _DateSummary({
    required this.label,
    required this.date,
    required this.weekday,
    required this.icon,
  });
  final String label, date, weekday, icon;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color(0xFFEFF3FF),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0D000000),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Color(0xFF006768),
                  fontSize: 11,
                  letterSpacing: .55,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            FigmaSvg(icon, width: 12, height: 12),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          date,
          style: const TextStyle(
            color: Color(0xFF121C2A),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          weekday,
          style: const TextStyle(color: Color(0xFF3D4949), fontSize: 12),
        ),
      ],
    ),
  );
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.date,
    required this.currentMonth,
    required this.selected,
    required this.inRange,
    required this.onTap,
  });
  final DateTime date;
  final bool currentMonth, selected, inRange;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      height: 39,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected
            ? StayNestColors.teal
            : inRange
            ? const Color(0xFFEAF7F6)
            : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Text(
        '${date.day}',
        style: TextStyle(
          color: !currentMonth
              ? const Color(0xFFB8C0CC)
              : selected
              ? Colors.white
              : const Color(0xFF121C2A),
          fontSize: 13,
          fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
        ),
      ),
    ),
  );
}

BoxDecoration _cardDecoration() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  boxShadow: const [
    BoxShadow(color: Color(0x0D000000), blurRadius: 2, offset: Offset(0, 1)),
  ],
);
