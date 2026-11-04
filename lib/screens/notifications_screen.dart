import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../design/tokens.dart';
import '../widgets/figma_asset.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _filter = 0;
  bool _read = false;
  bool _copied = false;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: StayNestColors.white,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            SizedBox(
              height: 56,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => context.pop(),
                      child: const FigmaSvg(
                        'assets/icons/notifications_10.svg',
                        width: 16,
                        height: 16,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Text(
                        'Thông Báo',
                        style: TextStyle(
                          fontSize: 17,
                          height: 24 / 17,
                          fontWeight: FontWeight.w600,
                          color: StayNestColors.ink,
                        ),
                      ),
                    ),
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: StayNestColors.teal,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const FigmaSvg(
                        'assets/icons/notifications_11.svg',
                        width: 12,
                        height: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
              child: Row(
                children: [
                  const Text(
                    'Gần đây',
                    style: TextStyle(
                      fontSize: 12,
                      height: 18 / 12,
                      fontWeight: FontWeight.w600,
                      color: StayNestColors.ink,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: StayNestColors.paleTeal,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      _read ? '0 mới' : '1 mới',
                      style: const TextStyle(
                        fontSize: 9,
                        height: 13 / 9,
                        color: StayNestColors.teal,
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => setState(() => _read = true),
                    child: Row(
                      children: [
                        const FigmaSvg(
                          'assets/icons/notifications_01.svg',
                          width: 14,
                          height: 12,
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Đánh dấu đã đọc',
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
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              child: _NotificationFilters(
                selected: _filter,
                onChanged: (value) => setState(() => _filter = value),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    if (_filter != 2) ...[
                      _NotificationCard(
                        icon: 'assets/icons/notifications_02.svg',
                        tint: const Color(0xFFE9F7F6),
                        title: 'Đặt phòng thành công — Mây Homestay',
                        age: '10 phút trước',
                        body: 'Mã đặt phòng SN-1024 đã được xác nhận. Phòng Studio có bếp, 14–16/11/2026 tại Hội An.',
                        footer: _BookingFooter(),
                        unread: !_read,
                        action: 'Xem đặt phòng →',
                      ),
                      const SizedBox(height: 12),
                      _NotificationCard(
                        icon: 'assets/icons/notifications_05.svg',
                        tint: const Color(0xFFFFF8E8),
                        title: 'Nhắc nhở lịch lưu trú sắp tới',
                        age: '2 giờ trước',
                        body: 'Chuyến đi Hội An của bạn sẽ bắt đầu trong 3 ngày nữa. Chuẩn bị CCCD để nhận phòng nhanh chóng.',
                        footer: const _InfoFooter(
                          icon: 'assets/icons/notifications_06.svg',
                          text: 'Giờ nhận phòng tiêu chuẩn: 14:00 • Trả phòng: 11:00',
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    if (_filter != 1)
                      _NotificationCard(
                        icon: 'assets/icons/notifications_07.svg',
                        tint: const Color(0xFFFFEEEE),
                        title: 'Ưu đãi thành viên mới: Giảm 100.000đ',
                        age: 'Hôm qua',
                        body: 'Nhập mã STAY100 khi thanh toán để nhận ngay giảm giá 100.000đ cho chuyến đi tiếp theo.',
                        footer: _VoucherFooter(
                          copied: _copied,
                          onCopy: _copyVoucher,
                        ),
                      ),
                    const SizedBox(height: 24),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: StayNestColors.paleTeal,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const FigmaSvg(
                        'assets/icons/notifications_09.svg',
                        width: 18,
                        height: 18,
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      'Bạn đã xem hết thông báo gần đây',
                      style: TextStyle(
                        fontSize: 11,
                        height: 16 / 11,
                        color: StayNestColors.muted,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'StayNest luôn cập nhật thông tin chuẩn xác từng phút',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        height: 14 / 9,
                        color: StayNestColors.mutedLight,
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

  Future<void> _copyVoucher() async {
    await Clipboard.setData(const ClipboardData(text: 'STAY100'));
    if (mounted) setState(() => _copied = true);
  }
}

class _VoucherFooter extends StatelessWidget {
  const _VoucherFooter({required this.copied, required this.onCopy});
  final bool copied;
  final VoidCallback onCopy;
  @override
  Widget build(BuildContext context) => Container(
    height: 44,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    decoration: BoxDecoration(
      color: const Color(0xFFF0F3FF),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      children: [
        const FigmaSvg(
          'assets/icons/notifications_08.svg',
          width: 16,
          height: 14,
        ),
        const SizedBox(width: 8),
        const Text(
          'STAY100',
          style: TextStyle(
            fontSize: 11,
            height: 16 / 11,
            fontWeight: FontWeight.w700,
            color: StayNestColors.ink,
          ),
        ),
        const Spacer(),
        SizedBox(
          height: 28,
          child: OutlinedButton(
            onPressed: onCopy,
            style: OutlinedButton.styleFrom(
              backgroundColor: StayNestColors.white,
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: Text(
              copied ? 'Đã chép' : 'Sao chép mã',
              style: const TextStyle(fontSize: 9, color: StayNestColors.teal),
            ),
          ),
        ),
      ],
    ),
  );
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.icon,
    required this.tint,
    required this.title,
    required this.age,
    required this.body,
    required this.footer,
    this.unread = false,
    this.action,
  });
  final String icon, title, age, body;
  final Color tint;
  final Widget footer;
  final bool unread;
  final String? action;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: StayNestColors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(
          color: Color(0x10172B4D),
          blurRadius: 14,
          offset: Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: FigmaSvg(icon, width: 19, height: 19),
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
                      height: 17 / 12,
                      fontWeight: FontWeight.w600,
                      color: StayNestColors.ink,
                    ),
                  ),
                  Text(
                    age,
                    style: const TextStyle(
                      fontSize: 10,
                      height: 15 / 10,
                      color: StayNestColors.muted,
                    ),
                  ),
                ],
              ),
            ),
            if (unread)
              const Padding(
                padding: EdgeInsets.only(top: 3),
                child: Icon(Icons.circle, size: 10, color: StayNestColors.teal),
              ),
          ],
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(left: 52),
          child: Text(
            body,
            style: const TextStyle(
              fontSize: 11,
              height: 17 / 11,
              color: StayNestColors.muted,
            ),
          ),
        ),
        const SizedBox(height: 10),
        if (action != null)
          Row(
            children: [
              footer,
              const Spacer(),
              FilledButton(
                onPressed: null,
                style: FilledButton.styleFrom(
                  disabledBackgroundColor: StayNestColors.teal,
                  disabledForegroundColor: StayNestColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  action!,
                  style: const TextStyle(
                    fontSize: 10,
                    height: 14 / 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          )
        else
          footer,
      ],
    ),
  );
}

class _NotificationFilters extends StatelessWidget {
  const _NotificationFilters({required this.selected, required this.onChanged});
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const labels = ['Tất cả', 'Đặt phòng', 'Ưu đãi'];
    return Container(
      height: 46,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F3FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          for (var index = 0; index < labels.length; index++)
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(index),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected == index
                        ? StayNestColors.teal
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: 11,
                      height: 16 / 11,
                      fontWeight: selected == index
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: selected == index
                          ? StayNestColors.white
                          : StayNestColors.muted,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _BookingFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
    decoration: BoxDecoration(
      color: StayNestColors.paleTeal,
      borderRadius: BorderRadius.circular(7),
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FigmaSvg('assets/icons/notifications_04.svg', width: 12, height: 12),
        SizedBox(width: 4),
        Text(
          'Đã thanh toán',
          style: TextStyle(
            fontSize: 9,
            height: 13 / 9,
            fontWeight: FontWeight.w600,
            color: StayNestColors.teal,
          ),
        ),
      ],
    ),
  );
}

class _InfoFooter extends StatelessWidget {
  const _InfoFooter({required this.icon, required this.text});
  final String icon, text;
  @override
  Widget build(BuildContext context) => Container(
    height: 42,
    padding: const EdgeInsets.symmetric(horizontal: 9),
    decoration: BoxDecoration(
      color: const Color(0xFFF0F3FF),
      borderRadius: BorderRadius.circular(9),
    ),
    child: Row(
      children: [
        FigmaSvg(icon, width: 14, height: 14),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 9,
              height: 14 / 9,
              color: StayNestColors.muted,
            ),
          ),
        ),
      ],
    ),
  );
}
