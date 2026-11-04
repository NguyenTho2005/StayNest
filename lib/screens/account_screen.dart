import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/staynest_api.dart';
import '../design/tokens.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/figma_asset.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider).value;
    final vouchers = ref.watch(availableVouchersProvider).value ?? [];
    final trips = ref.watch(myBookingsProvider).value ?? [];
    return Scaffold(
      backgroundColor: StayNestColors.canvas,
      bottomNavigationBar: const StayNestBottomNavigation(selectedIndex: 4),
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
                      const Expanded(
                        child: Text(
                          'Tài Khoản',
                          style: TextStyle(
                            fontSize: 22,
                            height: 28 / 22,
                            fontWeight: FontWeight.w600,
                            color: StayNestColors.ink,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            context.go(user == null ? '/login' : '/profile'),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: StayNestColors.teal,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: FigmaSvg(
                              'assets/icons/account_14.svg',
                              width: 12,
                              height: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InkWell(
                        onTap: () =>
                            context.go(user == null ? '/login' : '/profile'),
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          height: 88,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: StayNestColors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x08172B4D),
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: StayNestColors.paleTeal,
                                  shape: BoxShape.circle,
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    const Text(
                                      'ND',
                                      style: TextStyle(
                                        fontSize: 22,
                                        height: 28 / 22,
                                        fontWeight: FontWeight.w600,
                                        color: StayNestColors.teal,
                                      ),
                                    ),
                                    Positioned(
                                      right: -1,
                                      bottom: -1,
                                      child: Container(
                                        width: 16,
                                        height: 16,
                                        decoration: const BoxDecoration(
                                          color: StayNestColors.teal,
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: const FigmaSvg(
                                          'assets/icons/account_01.svg',
                                          width: 10,
                                          height: 9.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      user?['full_name']?.toString() ?? 'Khách',
                                      style: TextStyle(
                                        fontSize: 14,
                                        height: 20 / 14,
                                        fontWeight: FontWeight.w600,
                                        color: StayNestColors.ink,
                                      ),
                                    ),
                                    Text(
                                      user?['email']?.toString() ??
                                          'Đăng nhập để xem hồ sơ',
                                      style: TextStyle(
                                        fontSize: 11,
                                        height: 16 / 11,
                                        color: StayNestColors.muted,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (user != null)
                                      const Visibility(
                                        visible: false,
                                        child: _SilverBadge(),
                                      ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF7F9FC),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: FigmaSvg(
                                    'assets/icons/account_03.svg',
                                    width: 6.167,
                                    height: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              icon: 'assets/icons/account_04.svg',
                              status: 'Khả dụng',
                              count: '${vouchers.length}',
                              title: 'mã ưu đãi',
                              subtitle: vouchers.isEmpty
                                  ? 'Chưa có ưu đãi'
                                  : '${vouchers.first['code']}',
                              tint: StayNestColors.paleTeal,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _StatCard(
                              icon: 'assets/icons/account_05.svg',
                              status: 'Sắp tới',
                              count: '${trips.length}',
                              title: 'chuyến đi',
                              subtitle: trips.isEmpty
                                  ? 'Chưa có chuyến đi'
                                  : '${trips.first['property_name']}',
                              tint: const Color(0xFFDFE9FC),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Visibility(
                        visible: false,
                        child: Container(
                          height: 90,
                          decoration: BoxDecoration(
                            color: StayNestColors.paleTeal,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  const FigmaSvg(
                                    'assets/icons/account_06.svg',
                                    width: 12,
                                    height: 15.75,
                                  ),
                                  const SizedBox(width: 6),
                                  const Expanded(
                                    child: Text(
                                      'Tiến độ lên hạng Gold',
                                      style: TextStyle(
                                        fontSize: 12,
                                        height: 18 / 12,
                                        fontWeight: FontWeight.w600,
                                        color: StayNestColors.ink,
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    '3 / 5 đêm',
                                    style: TextStyle(
                                      fontSize: 11,
                                      height: 16 / 11,
                                      fontWeight: FontWeight.w600,
                                      color: StayNestColors.teal,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(99),
                                child: const LinearProgressIndicator(
                                  value: .6,
                                  minHeight: 5,
                                  color: StayNestColors.teal,
                                  backgroundColor: StayNestColors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Đặt thêm 2 đêm để hưởng ưu đãi nâng hạng phòng và nhận phòng sớm.',
                                style: TextStyle(
                                  fontSize: 10,
                                  height: 14 / 10,
                                  color: StayNestColors.muted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 8),
                        child: Text(
                          'CÀI ĐẶT CHUNG',
                          style: TextStyle(
                            fontSize: 11,
                            height: 16 / 11,
                            fontWeight: FontWeight.w500,
                            letterSpacing: .6,
                            color: Color(0xFF667085),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: StayNestColors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x08172B4D),
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Column(
                          children: [
                            _AccountMenuRow(
                              icon: 'assets/icons/account_07.svg',
                              title: 'Hồ sơ',
                              subtitle: 'Thông tin cá nhân & người đồng hành',
                            ),
                            _AccountMenuRow(
                              icon: 'assets/icons/account_08.svg',
                              title: 'Cá nhân hóa',
                              subtitle: 'Sở thích lưu trú, tiện nghi yêu thích',
                            ),
                            _AccountMenuRow(
                              icon: 'assets/icons/account_09.svg',
                              title: 'Thông báo',
                              subtitle: 'Cập nhật đặt phòng, ưu đãi độc quyền',
                              badge: 'Mới',
                            ),
                            _AccountMenuRow(
                              icon: 'assets/icons/account_10.svg',
                              title: 'Cài đặt ứng dụng',
                              subtitle: 'Ngôn ngữ (Tiếng Việt), tiền tệ (VND), bảo mật',
                            ),
                            _AccountMenuRow(
                              icon: 'assets/icons/account_11.svg',
                              title: 'Trợ giúp & Hỗ trợ',
                              subtitle: 'Trung tâm trợ giúp (giao diện demo)',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        height: 72,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: StayNestColors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: StayNestColors.paleTeal,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: FigmaSvg(
                                  'assets/icons/account_12.svg',
                                  width: 19.25,
                                  height: 19.25,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Đăng ký làm chủ nhà',
                                    style: TextStyle(
                                      fontSize: 12,
                                      height: 18 / 12,
                                      fontWeight: FontWeight.w600,
                                      color: StayNestColors.ink,
                                    ),
                                  ),
                                  Text(
                                    'Chia sẻ không gian của bạn',
                                    style: TextStyle(
                                      fontSize: 10,
                                      height: 14 / 10,
                                      color: StayNestColors.muted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                color: StayNestColors.paleTeal,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Tìm hiểu',
                                style: TextStyle(
                                  fontSize: 11,
                                  height: 16 / 11,
                                  fontWeight: FontWeight.w500,
                                  color: StayNestColors.teal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () async {
                          if (user != null) {
                            try {
                              await ref.read(stayNestApiProvider).logout();
                            } catch (_) {
                              // The local token is cleared by logout even if the API is offline.
                            }
                            ref.invalidate(currentUserProvider);
                            ref.invalidate(myBookingsProvider);
                            ref.invalidate(myFavoritesProvider);
                          }
                          if (context.mounted) context.go('/login');
                        },
                        child: Container(
                          height: 54,
                          decoration: BoxDecoration(
                            color: StayNestColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const FigmaSvg(
                                  'assets/icons/account_13.svg',
                                  width: 15,
                                  height: 15,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  user == null ? 'Đăng nhập' : 'Đăng xuất',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    height: 18 / 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFD92D20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Column(
                        children: [
                          Text(
                            'StayNest · Bản demo kết nối API',
                            style: TextStyle(
                              fontSize: 10,
                              height: 14 / 10,
                              color: StayNestColors.muted,
                            ),
                          ),
                          Text(
                            'Chăm chút từng hành trình nghỉ dưỡng Việt',
                            style: TextStyle(
                              fontSize: 10,
                              height: 14 / 10,
                              color: StayNestColors.muted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
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
}

class _SilverBadge extends StatelessWidget {
  const _SilverBadge();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
    decoration: BoxDecoration(
      color: const Color(0xFFDFE9FC),
      borderRadius: BorderRadius.circular(9999),
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FigmaSvg('assets/icons/account_02.svg', width: 10.833, height: 10.292),
        SizedBox(width: 3),
        Text(
          'StayNest Silver',
          style: TextStyle(
            fontSize: 10,
            height: 14 / 10,
            fontWeight: FontWeight.w500,
            color: StayNestColors.ink,
          ),
        ),
      ],
    ),
  );
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.status,
    required this.count,
    required this.title,
    required this.subtitle,
    required this.tint,
  });
  final String icon;
  final String status;
  final String count;
  final String title;
  final String subtitle;
  final Color tint;

  @override
  Widget build(BuildContext context) => Container(
    height: 90,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: StayNestColors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x08172B4D),
          blurRadius: 10,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: FigmaSvg(icon, width: 15, height: 15)),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: tint,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  fontSize: 10,
                  height: 14 / 10,
                  color: StayNestColors.teal,
                ),
              ),
            ),
          ],
        ),
        const Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              count,
              style: const TextStyle(
                fontSize: 20,
                height: 24 / 20,
                fontWeight: FontWeight.w600,
                color: StayNestColors.ink,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                height: 14 / 10,
                color: StayNestColors.muted,
              ),
            ),
          ],
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
  );
}

class _AccountMenuRow extends StatelessWidget {
  const _AccountMenuRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.badge,
  });
  final String icon;
  final String title;
  final String subtitle;
  final String? badge;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 58,
    child: InkWell(
      onTap: () {
        if (title == 'Hồ sơ') context.go('/profile');
        if (title == 'Cài đặt ứng dụng') context.go('/settings');
        if (title == 'Thông báo') context.go('/notifications');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4FF),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Center(child: FigmaSvg(icon, width: 16, height: 16)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                      if (badge != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE4E2),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            badge!,
                            style: const TextStyle(
                              fontSize: 9,
                              height: 12 / 9,
                              color: Color(0xFFD92D20),
                            ),
                          ),
                        ),
                      ],
                    ],
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
            const FigmaSvg(
              'assets/icons/account_03.svg',
              width: 6.167,
              height: 10,
            ),
          ],
        ),
      ),
    ),
  );
}
