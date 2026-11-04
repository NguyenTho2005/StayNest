import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/onboarding_controller.dart';
import '../design/tokens.dart';
import '../widgets/figma_asset.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key, this.duration = const Duration(milliseconds: 1200)});
  final Duration duration;

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTransition();
  }

  void _startTransition() {
    _timer = Timer(widget.duration, _navigateNext);
  }

  Future<void> _navigateNext() async {
    if (!mounted) return;
    final isCompleted =
        await ref.read(onboardingControllerProvider.notifier).checkCompleted();
    if (!mounted) return;
    if (isCompleted) {
      context.go('/');
    } else {
      context.go('/onboarding/1');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      _timer?.cancel();
      _navigateNext();
    },
    child: Scaffold(
    backgroundColor: const Color(0xFF172B4D),
    body: Stack(
      children: [
        const Positioned(
          top: 13,
          left: 28,
          child: Text(
            '9:41',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Positioned(
          top: 16,
          right: 28,
          child: _SignalBar(prefix: 'splash'),
        ),
        Center(
          child: Transform.translate(
            offset: const Offset(0, -20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F999A), Color(0xFF096C70)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: const [
                      BoxShadow(color: Color(0x5500A8A8), blurRadius: 28),
                    ],
                  ),
                  child: const FigmaSvg(
                    'assets/icons/splash_01.svg',
                    width: 42,
                    height: 42,
                  ),
                ),
                const SizedBox(height: 38),
                const Text(
                  'StayNest',
                  style: TextStyle(
                    fontSize: 32,
                    height: 1.2,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Khách sạn & Homestay Việt Nam',
                  style: TextStyle(fontSize: 14, color: Color(0xFFD6E3F0)),
                ),
                const SizedBox(height: 25),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF263F61),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    '“Ở đâu cũng thấy thân quen”',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 34,
          left: 0,
          right: 0,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0A9899),
                      borderRadius: BorderRadius.circular(9),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'ĐANG KHỞI TẠO...',
                style: TextStyle(
                  color: Color(0xFFC3D0DF),
                  fontSize: 10,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 108,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);
}

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key, required this.step});
  final int step;

  static const _titles = [
    'Khám phá nơi ở phù hợp',
    'Lọc đúng nhu cầu',
    'Giá rõ ràng, đặt dễ dàng',
  ];
  static const _descriptions = [
    'Hàng nghìn homestay độc đáo, khách sạn tiện nghi và biệt thự nghỉ dưỡng khắp Việt Nam với hình ảnh và tiện ích thật 100%.',
    'Dễ dàng tìm thấy chỗ ở hoàn hảo theo mức giá, vị trí trung tâm, tiện nghi làm việc hoặc không gian bếp nấu ấm cúng.',
    'Mọi chi phí phòng và thuế phí đều hiển thị trọn gói ngay từ đầu. Hỗ trợ 24/7 và chính sách hoàn hủy minh bạch cho từng kỳ nghỉ của bạn.',
  ];
  static const _photos = [
    'assets/images/onboarding1_01.jpg',
    'assets/images/onboarding2_01.jpg',
    'assets/images/onboarding3_01.jpg',
  ];
  static const _iconPrefixes = ['onboarding1', 'onboarding2', 'onboarding3'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = step.clamp(1, 3) - 1;
    final prefix = _iconPrefixes[index];
    final heroHeight = index == 0
        ? 490.0
        : index == 1
        ? 430.0
        : 470.0;
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) => Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              height: heroHeight,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  FigmaRaster(
                    _photos[index],
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x44000000),
                          Color(0x00000000),
                          Color(0x99000000),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 28,
                    child: Text(
                      '9:41',
                      style: TextStyle(
                        color: index == 0 ? Colors.white : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15,
                    right: 28,
                    child: _SignalBar(
                      prefix: prefix,
                      startAt: index == 0
                          ? 3
                          : index == 1
                          ? 4
                          : 2,
                    ),
                  ),
                  if (index != 0)
                    Positioned(
                      top: 56,
                      left: 20,
                      child: _CircleIconButton(
                        path:
                            'assets/icons/${prefix}_${index == 1 ? '07' : '05'}.svg',
                        dark: true,
                        onTap: () => context.go(
                          index == 1 ? '/onboarding/1' : '/onboarding/2',
                        ),
                      ),
                    ),
                  if (index < 2)
                    Positioned(
                      top: 56,
                      right: 20,
                      child: TextButton(
                        onPressed: () {
                          ref
                              .read(onboardingControllerProvider.notifier)
                              .completeOnboarding();
                          context.go('/welcome');
                        },
                        child: const Text(
                          'Bỏ qua',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  if (index == 0)
                    Positioned(
                      left: 22,
                      bottom: 24,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xCC172B4D),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Ven biển Đà Nẵng',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  if (index == 1)
                    const Positioned(
                      left: 20,
                      top: 315,
                      child: _HeroTag(
                        text: 'Hồ bơi riêng',
                        icon: 'assets/icons/onboarding2_02.svg',
                      ),
                    ),
                  if (index == 1)
                    const Positioned(
                      right: 20,
                      top: 354,
                      child: _HeroTag(
                        text: '4.9 / 5.0',
                        icon: 'assets/icons/onboarding2_03.svg',
                      ),
                    ),
                  if (index == 2)
                    const Positioned(
                      left: 24,
                      right: 24,
                      bottom: 22,
                      child: _TrustCard(),
                    ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: heroHeight - 16,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                ),
                padding: const EdgeInsets.fromLTRB(24, 23, 24, 26),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(
                        3,
                        (i) => Container(
                          margin: const EdgeInsets.only(right: 6),
                          width: i == index ? 32 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: i == index
                                ? StayNestColors.tealBright
                                : const Color(0xFFE5E7EB),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      _titles[index],
                      style: const TextStyle(
                        color: Color(0xFF172B4D),
                        fontSize: 22,
                        height: 1.25,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _descriptions[index],
                      style: const TextStyle(
                        color: Color(0xFF667085),
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                    if (index == 1) ...[
                      const SizedBox(height: 17),
                      const Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _FeatureChip(
                            label: 'Wi-Fi tốc độ cao',
                            icon: 'assets/icons/onboarding2_08.svg',
                          ),
                          _FeatureChip(
                            label: 'Hồ bơi',
                            icon: 'assets/icons/onboarding2_09.svg',
                          ),
                          _FeatureChip(
                            label: 'Bếp nấu ăn',
                            icon: 'assets/icons/onboarding2_10.svg',
                          ),
                          _FeatureChip(
                            label: 'Giường King',
                            icon: 'assets/icons/onboarding2_11.svg',
                          ),
                        ],
                      ),
                    ],
                    const Spacer(),
                    Row(
                      children: [
                        if (index > 0)
                          _CircleIconButton(
                            path:
                                'assets/icons/${prefix}_${index == 1 ? '07' : '05'}.svg',
                            onTap: () => context.go('/onboarding/$index'),
                          ),
                        if (index > 0) const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: StayNestColors.tealBright,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                if (index == 2) {
                                  ref
                                      .read(
                                        onboardingControllerProvider.notifier,
                                      )
                                      .completeOnboarding();
                                  context.go('/welcome');
                                } else {
                                  context.go('/onboarding/${index + 2}');
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    index == 2 ? 'Bắt đầu' : 'Tiếp tục',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(width: 9),
                                  FigmaSvg(
                                    'assets/icons/${prefix}_${index == 0
                                        ? '06'
                                        : index == 1
                                        ? '14'
                                        : '09'}.svg',
                                    width: 16,
                                    height: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 108,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF172B4D),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    backgroundColor: const Color(0xFFF7F9FC),
    body: Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _WelcomeStatusBar(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FigmaSvg('assets/icons/welcome_02.svg', width: 30, height: 30),
              SizedBox(width: 8),
              Text(
                'StayNest',
                style: TextStyle(
                  color: Color(0xFF172B4D),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Chuyến đi tiếp theo\nbắt đầu tại đây',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF172B4D),
              fontSize: 25,
              height: 1.2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 9),
          const Text(
            'Khám phá và đặt phòng homestay, khách sạn nhanh chóng, minh bạch và an toàn tuyệt đối.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF667085),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 25),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: Stack(
              children: [
                const FigmaRaster(
                  'assets/images/welcome_01.jpg',
                  width: double.infinity,
                  height: 176,
                ),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      children: [
                        FigmaSvg(
                          'assets/icons/welcome_03.svg',
                          width: 14,
                          height: 14,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Mây Homestay • Hội An',
                          style: TextStyle(
                            color: Color(0xFF172B4D),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 96),
          _WelcomeButton(
            label: 'Đăng nhập',
            filled: true,
            onPressed: () {
              ref
                  .read(onboardingControllerProvider.notifier)
                  .completeOnboarding();
              context.push('/login');
            },
          ),
          const SizedBox(height: 10),
          _WelcomeButton(
            label: 'Tạo tài khoản',
            onPressed: () {
              ref
                  .read(onboardingControllerProvider.notifier)
                  .completeOnboarding();
              context.push('/signup');
            },
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: () {
              ref
                  .read(onboardingControllerProvider.notifier)
                  .completeOnboarding();
              context.go('/');
            },
            child: const Text(
              'Khám phá với tư cách khách',
              style: TextStyle(
                color: Color(0xFF0F8B8D),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'Hoặc tiếp tục với',
                  style: TextStyle(color: Color(0xFF98A2B3), fontSize: 11),
                ),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 10),
          _WelcomeButton(
            label: 'Tiếp tục với Google',
            icon: 'assets/icons/welcome_08.svg',
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đăng nhập Google chưa được cấu hình.'),
              ),
            ),
          ),
          const SizedBox(height: 6),
          const Spacer(),
          Center(
            child: Container(
              width: 108,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFF172B4D),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _SignalBar extends StatelessWidget {
  const _SignalBar({required this.prefix, this.startAt = 2});
  final String prefix;
  final int startAt;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (var i = startAt; i < startAt + 3; i++)
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: FigmaSvg(
            'assets/icons/${prefix}_0$i.svg',
            width: 15,
            height: 13,
          ),
        ),
    ],
  );
}

class _WelcomeStatusBar extends StatelessWidget {
  const _WelcomeStatusBar();
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          '9:41',
          style: TextStyle(
            color: Color(0xFF172B4D),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        _SignalBar(prefix: 'welcome', startAt: 4),
      ],
    ),
  );
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.path,
    required this.onTap,
    this.dark = false,
  });
  final String path;
  final VoidCallback onTap;
  final bool dark;
  @override
  Widget build(BuildContext context) => Material(
    color: dark ? const Color(0x66000000) : const Color(0xFFF8F9FC),
    shape: const CircleBorder(),
    child: InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: dark ? Colors.transparent : const Color(0xFFE5E7EB),
          ),
        ),
        child: Icon(
          Icons.arrow_back,
          size: 20,
          color: dark ? Colors.white : const Color(0xFF172B4D),
        ),
      ),
    ),
  );
}

class _HeroTag extends StatelessWidget {
  const _HeroTag({required this.text, required this.icon});
  final String text;
  final String icon;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(999),
      boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 12)],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FigmaSvg(icon, width: 15, height: 15),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF172B4D),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class _FeatureChip extends StatelessWidget {
  const _FeatureChip({required this.label, required this.icon});
  final String label;
  final String icon;
  @override
  Widget build(BuildContext context) {
    final selected = label != 'Giường King';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFEAF7F6) : const Color(0xFFF8F9FC),
        border: Border.all(
          color: selected ? StayNestColors.tealBright : const Color(0xFFE5E7EB),
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FigmaSvg(icon, width: 14, height: 14),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF344054),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustCard extends StatelessWidget {
  const _TrustCard();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(
          color: Color(0x26000000),
          blurRadius: 16,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        const FigmaSvg(
          'assets/icons/onboarding3_06.svg',
          width: 28,
          height: 28,
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Xác nhận phòng tức thì',
                style: TextStyle(
                  color: Color(0xFF172B4D),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Minh bạch giá • Không phụ phí ẩn',
                style: TextStyle(color: Color(0xFF667085), fontSize: 10),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF7F6),
            borderRadius: BorderRadius.circular(999),
          ),
          child: const Text(
            '100% Yên tâm',
            style: TextStyle(
              color: Color(0xFF0F8B8D),
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

class _WelcomeButton extends StatelessWidget {
  const _WelcomeButton({
    required this.label,
    required this.onPressed,
    this.filled = false,
    this.icon,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool filled;
  final String? icon;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 48,
    child: filled
        ? FilledButton(
            onPressed: onPressed,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0F8B8D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          )
        : OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF172B4D),
              side: const BorderSide(color: Color(0xFFE4E7EC)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  FigmaSvg(icon!, width: 17, height: 17),
                  const SizedBox(width: 9),
                ],
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
  );
}
