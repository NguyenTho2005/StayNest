import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design/tokens.dart';
import '../widgets/figma_asset.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
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
                        'assets/icons/settings_13.svg',
                        width: 16,
                        height: 16,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Text(
                        'Cài Đặt',
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
                        'assets/icons/settings_14.svg',
                        width: 12,
                        height: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _GroupLabel('TÙY CHỌN HIỂN THỊ & KHU VỰC'),
                    _SettingsCard(
                      children: [
                        const _SettingsRow(
                          icon: 'assets/icons/settings_01.svg',
                          title: 'Ngôn ngữ',
                          subtitle: 'Ngôn ngữ ứng dụng hiển thị',
                          value: 'Tiếng Việt',
                        ),
                        const _SettingsRow(
                          icon: 'assets/icons/settings_03.svg',
                          title: 'Đơn vị tiền tệ',
                          subtitle: 'Chuẩn thanh toán nội địa',
                          value: 'VND (₫)',
                          locked: true,
                        ),
                        const _SettingsRow(
                          icon: 'assets/icons/settings_05.svg',
                          title: 'Giao diện',
                          subtitle: 'Tông màu và chế độ sáng',
                          value: 'Sáng (Hệ thống)',
                          last: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const _GroupLabel('THÔNG BÁO & QUYỀN RIÊNG TƯ'),
                    _SettingsCard(
                      children: [
                        _SettingsRow(
                          icon: 'assets/icons/settings_06.svg',
                          title: 'Chế độ thông báo',
                          subtitle: 'Nhận tin nhắn đặt phòng & khuyến mãi',
                          toggle: _notifications,
                          onToggle: (v) => setState(() => _notifications = v),
                        ),
                        const _SettingsRow(
                          icon: 'assets/icons/settings_07.svg',
                          title: 'Quyền truy cập vị trí',
                          subtitle: 'Cho phép tìm chỗ ở gần bạn',
                          value: '● Đang bật',
                        ),
                        const _SettingsRow(
                          icon: 'assets/icons/settings_08.svg',
                          title: 'Quyền riêng tư & Bảo mật',
                          subtitle: 'Chính sách dữ liệu và tài khoản',
                          last: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const _GroupLabel('HỆ THỐNG & TÀI KHOẢN'),
                    const _SettingsCard(
                      children: [
                        _SettingsRow(
                          icon: 'assets/icons/settings_10.svg',
                          title: 'Điều khoản dịch vụ & Giới thiệu',
                          subtitle: 'Thông tin pháp lý và quy định',
                          last: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 68,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1F0),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE62E24),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: const FigmaSvg(
                              'assets/icons/settings_11.svg',
                              width: 18,
                              height: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Đăng xuất',
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 18 / 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFD92D20),
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Tài khoản: an.demo@example.com',
                                  style: TextStyle(
                                    fontSize: 10,
                                    height: 14 / 10,
                                    color: StayNestColors.muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const FigmaSvg(
                            'assets/icons/settings_12.svg',
                            width: 14,
                            height: 14,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '● StayNest v1.2.0 • Bản dựng chính thức',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        height: 15 / 10,
                        color: StayNestColors.muted,
                      ),
                    ),
                    const Text(
                      'Nền tảng nghỉ dưỡng & trải nghiệm bản địa Việt Nam',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 9,
                        height: 14 / 9,
                        color: StayNestColors.muted,
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

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 10,
        height: 15 / 10,
        fontWeight: FontWeight.w500,
        letterSpacing: .4,
        color: StayNestColors.muted,
      ),
    ),
  );
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: StayNestColors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0B172B4D),
          blurRadius: 14,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Column(children: children),
  );
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.value,
    this.toggle,
    this.onToggle,
    this.locked = false,
    this.last = false,
  });
  final String icon, title, subtitle;
  final String? value;
  final bool? toggle;
  final ValueChanged<bool>? onToggle;
  final bool locked, last;
  @override
  Widget build(BuildContext context) => Container(
    height: 66,
    decoration: BoxDecoration(
      border: last
          ? null
          : const Border(bottom: BorderSide(color: Color(0xFFF0F2F5))),
    ),
    child: Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: title == 'Đơn vị tiền tệ' || title.contains('Bảo mật')
                ? const Color(0xFFE8EEFF)
                : StayNestColors.paleTeal,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: FigmaSvg(icon, width: 20, height: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  height: 18 / 12,
                  fontWeight: FontWeight.w600,
                  color: StayNestColors.ink,
                ),
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 10,
                  height: 14 / 10,
                  color: StayNestColors.muted,
                ),
              ),
            ],
          ),
        ),
        if (toggle != null)
          Switch(
            value: toggle!,
            onChanged: onToggle,
            activeThumbColor: StayNestColors.teal,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          )
        else if (value != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value!,
                style: TextStyle(
                  fontSize: 12,
                  height: 18 / 12,
                  fontWeight: FontWeight.w500,
                  color: value!.contains('●')
                      ? const Color(0xFF029B6B)
                      : StayNestColors.muted,
                ),
              ),
              if (locked)
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: FigmaSvg(
                    'assets/icons/settings_04.svg',
                    width: 13,
                    height: 14,
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: FigmaSvg(
                    'assets/icons/settings_02.svg',
                    width: 7,
                    height: 11,
                  ),
                ),
            ],
          )
        else
          const FigmaSvg('assets/icons/settings_02.svg', width: 7, height: 11),
      ],
    ),
  );
}
