import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/staynest_api.dart';
import '../design/tokens.dart';
import '../widgets/figma_asset.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(currentUserProvider);
    if (userState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (userState.hasError) {
      return Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () => ref.invalidate(currentUserProvider),
            child: const Text('Không tải được hồ sơ. Thử lại'),
          ),
        ),
      );
    }
    final user = userState.value;
    if (user == null) {
      return Scaffold(
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/login'),
            child: const Text('Đăng nhập để xem hồ sơ'),
          ),
        ),
      );
    }
    final fullName = '${user['full_name'] ?? ''}';
    final email = '${user['email'] ?? ''}';
    final phone = '${user['phone'] ?? 'Chưa cập nhật'}';
    final birthDate = DateTime.tryParse('${user['birth_date'] ?? ''}');
    final birthText = birthDate == null
        ? 'Chưa cập nhật'
        : '${birthDate.day.toString().padLeft(2, '0')}/${birthDate.month.toString().padLeft(2, '0')}/${birthDate.year}';
    final nationality = '${user['nationality'] ?? 'Chưa cập nhật'}';
    return Scaffold(
      backgroundColor: StayNestColors.white,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 390),
          child: Column(
            children: [
              const _ProfileHeader(title: 'Hồ Sơ Cá Nhân'),
              Expanded(
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                      child: Column(
                        children: [
                          const SizedBox(height: 4),
                          Container(
                            width: 84,
                            height: 84,
                            decoration: BoxDecoration(
                              color: StayNestColors.paleTeal,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFEAF7F6),
                                width: 5,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'ND',
                              style: TextStyle(
                                fontSize: 26,
                                height: 32 / 26,
                                fontWeight: FontWeight.w700,
                                color: StayNestColors.teal,
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          Text(
                            fullName,
                            style: TextStyle(
                              fontSize: 17,
                              height: 24 / 17,
                              fontWeight: FontWeight.w700,
                              color: StayNestColors.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          _Pill(
                            icon: 'assets/icons/profile_01.svg',
                            label: 'Thông tin tài khoản',
                            foreground: const Color(0xFF039855),
                            background: const Color(0xFFEAFBF3),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _ProfileStat(
                                  icon: 'assets/icons/profile_02.svg',
                                  label: 'Chuyến đi đã qua',
                                  value:
                                      '${ref.watch(myBookingsProvider).value?.length ?? 0} kỳ nghỉ',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _ProfileStat(
                                  icon: 'assets/icons/profile_03.svg',
                                  label: 'Nơi lưu trú thích',
                                  value:
                                      '${ref.watch(myFavoritesProvider).value?.length ?? 0} điểm',
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Expanded(
                                child: _SectionTitle(
                                  icon: 'assets/icons/profile_05.svg',
                                  title: 'Thông tin cơ bản',
                                ),
                              ),
                              Text(
                                'Chỉ bạn mới thấy',
                                style: TextStyle(
                                  fontSize: 10,
                                  height: 14 / 10,
                                  color: StayNestColors.muted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: StayNestColors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0A172B4D),
                                  blurRadius: 16,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _ProfileField(
                                  icon: 'assets/icons/profile_06.svg',
                                  label: 'Họ và tên',
                                  value: fullName,
                                ),
                                _ProfileField(
                                  icon: 'assets/icons/profile_07.svg',
                                  label: 'Email',
                                  value: email,
                                ),
                                _ProfileField(
                                  icon: 'assets/icons/profile_09.svg',
                                  label: 'Số điện thoại',
                                  value: phone,
                                  badgeIcon: 'assets/icons/profile_10.svg',
                                  badge: 'Liên kết',
                                ),
                                _ProfileField(
                                  icon: 'assets/icons/profile_10.svg',
                                  label: 'Ngày sinh',
                                  value: birthText,
                                  action: '+ Thêm',
                                  italic: true,
                                ),
                                _ProfileField(
                                  icon: 'assets/icons/profile_11.svg',
                                  label: 'Quốc tịch',
                                  value: nationality,
                                  last: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              const Expanded(
                                child: _SectionTitle(
                                  icon: 'assets/icons/profile_12.svg',
                                  title: 'Người đồng hành',
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: StayNestColors.paleTeal,
                                  borderRadius: BorderRadius.circular(99),
                                ),
                                child: const Text(
                                  '1 người',
                                  style: TextStyle(
                                    fontSize: 10,
                                    height: 14 / 10,
                                    color: StayNestColors.teal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: StayNestColors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0A172B4D),
                                  blurRadius: 16,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFE0E9FF),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Text(
                                        'TH',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF344C83),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Trần Thu Hà',
                                            style: TextStyle(
                                              fontSize: 12,
                                              height: 18 / 12,
                                              fontWeight: FontWeight.w600,
                                              color: StayNestColors.ink,
                                            ),
                                          ),
                                          Text(
                                            '0912 *** 789',
                                            style: TextStyle(
                                              fontSize: 10,
                                              height: 14 / 10,
                                              color: StayNestColors.muted,
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Text(
                                            'Bạn bè / Người thân',
                                            style: TextStyle(
                                              fontSize: 9,
                                              height: 13 / 9,
                                              color: StayNestColors.muted,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const FigmaSvg(
                                      'assets/icons/profile_13.svg',
                                      width: 14,
                                      height: 14,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: StayNestColors.paleTeal,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FigmaSvg(
                                        'assets/icons/profile_15.svg',
                                        width: 15,
                                        height: 15,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        '+ Thêm người đồng hành',
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
                          const SizedBox(height: 18),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF2F8FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FigmaSvg(
                                  'assets/icons/profile_16.svg',
                                  width: 16,
                                  height: 16,
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Thông tin chính xác',
                                        style: TextStyle(
                                          fontSize: 11,
                                          height: 16 / 11,
                                          fontWeight: FontWeight.w600,
                                          color: StayNestColors.teal,
                                        ),
                                      ),
                                      SizedBox(height: 3),
                                      Text(
                                        'Giúp thủ tục check-in tại homestay và boutique villa diễn ra nhanh gọn chỉ trong 30 giây.',
                                        style: TextStyle(
                                          fontSize: 10,
                                          height: 15 / 10,
                                          color: StayNestColors.muted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 588,
                      left: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
                        decoration: BoxDecoration(
                          color: StayNestColors.white.withValues(alpha: .95),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x0F172B4D),
                              blurRadius: 16,
                              offset: Offset(0, -4),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: FilledButton.icon(
                            onPressed: () => context.push('/profile/edit'),
                            icon: const FigmaSvg(
                              'assets/icons/profile_17.svg',
                              width: 16.667,
                              height: 16.688,
                            ),
                            label: const Text('Chỉnh sửa hồ sơ'),
                            style: FilledButton.styleFrom(
                              backgroundColor: StayNestColors.teal,
                              foregroundColor: StayNestColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 14,
                                height: 22 / 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
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
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 56,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          InkWell(
            onTap: () => context.pop(),
            child: const FigmaSvg(
              'assets/icons/profile_18.svg',
              width: 16,
              height: 16,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
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
              'assets/icons/profile_19.svg',
              width: 12,
              height: 12,
            ),
          ),
        ],
      ),
    ),
  );
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.icon,
    required this.label,
    required this.foreground,
    required this.background,
  });
  final String icon, label;
  final Color foreground, background;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FigmaSvg(icon, width: 11, height: 11),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            height: 13 / 9,
            fontWeight: FontWeight.w600,
            color: foreground,
          ),
        ),
      ],
    ),
  );
}

class _ProfileStat extends StatelessWidget {
  const _ProfileStat({
    required this.icon,
    required this.label,
    required this.value,
  });
  final String icon, label, value;
  @override
  Widget build(BuildContext context) => Container(
    height: 56,
    padding: const EdgeInsets.symmetric(horizontal: 9),
    decoration: BoxDecoration(
      color: const Color(0xFFF7F9FC),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: StayNestColors.white,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: FigmaSvg(icon, width: 16, height: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 9,
                  height: 13 / 9,
                  color: StayNestColors.muted,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  height: 18 / 13,
                  fontWeight: FontWeight.w700,
                  color: StayNestColors.ink,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});
  final String icon, title;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      FigmaSvg(icon, width: 14, height: 14),
      const SizedBox(width: 5),
      Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          height: 18 / 12,
          fontWeight: FontWeight.w600,
          color: StayNestColors.ink,
        ),
      ),
    ],
  );
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({
    required this.icon,
    required this.label,
    required this.value,
    this.badge,
    this.badgeIcon,
    this.action,
    this.italic = false,
    this.last = false,
  });
  final String icon, label, value;
  final String? badge, action;
  final String? badgeIcon;
  final bool italic, last;
  @override
  Widget build(BuildContext context) => Container(
    height: 63,
    decoration: BoxDecoration(
      border: last
          ? null
          : const Border(bottom: BorderSide(color: Color(0xFFF0F2F5))),
    ),
    child: Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Color(0xFFF7F9FC),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: FigmaSvg(icon, width: 14, height: 14),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 9,
                  height: 13 / 9,
                  color: StayNestColors.muted,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 11,
                  height: 16 / 11,
                  fontWeight: FontWeight.w500,
                  fontStyle: italic ? FontStyle.italic : FontStyle.normal,
                  color: italic
                      ? StayNestColors.mutedLight
                      : StayNestColors.ink,
                ),
              ),
            ],
          ),
        ),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            decoration: BoxDecoration(
              color: StayNestColors.paleTeal,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (badgeIcon != null) ...[
                  FigmaSvg(badgeIcon!, width: 10, height: 10),
                  const SizedBox(width: 3),
                ],
                Text(
                  badge!,
                  style: const TextStyle(
                    fontSize: 9,
                    color: StayNestColors.teal,
                  ),
                ),
              ],
            ),
          ),
        if (action != null)
          Text(
            action!,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: StayNestColors.teal,
            ),
          ),
      ],
    ),
  );
}
