import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design/tokens.dart';
import '../widgets/figma_asset.dart';

class SignUpSuccessScreen extends StatelessWidget {
  const SignUpSuccessScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AuthStatusBar(prefix: 'success'),
              const SizedBox(height: 16),
              const Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0xFFEAF7F6),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(9),
                      child: FigmaSvg(
                        'assets/icons/success_04.svg',
                        width: 17,
                        height: 14,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'StayNest',
                    style: TextStyle(
                      color: Color(0xFF172B4D),
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Spacer(flex: 3),
        const CircleAvatar(
          radius: 48,
          backgroundColor: Color(0xFFF0FAF9),
          child: CircleAvatar(
            radius: 40,
            backgroundColor: Color(0xFFEAF7F6),
            child: Icon(Icons.check, size: 40, color: Color(0xFF0DB872)),
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Tạo tài khoản thành công!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF172B4D),
            fontSize: 24,
            height: 1.5,
            fontWeight: FontWeight.w700,
            letterSpacing: -.6,
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Chào mừng bạn đến với StayNest. Hãy\nbắt đầu khám phá những nơi lưu trú\ntuyệt vời.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 15,
              height: 1.625,
            ),
          ),
        ),
        const Spacer(flex: 3),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            children: [
              _PrimaryAction(
                label: 'Tiếp tục',
                onPressed: () => context.go('/'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => context.go('/login'),
                child: const Text(
                  'Về trang đăng nhập',
                  style: TextStyle(
                    color: Color(0xFF0F8B8D),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _HomeIndicator(color: const Color(0x26172B4D)),
            ],
          ),
        ),
      ],
    ),
  );
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AuthStatusBar(prefix: 'forgot'),
            const SizedBox(height: 16),
            _RoundBack(
              onTap: () => context.pop(),
              icon: 'assets/icons/forgot_04.svg',
            ),
            const SizedBox(height: 24),
            const Text(
              'Quên mật khẩu?',
              style: TextStyle(
                color: Color(0xFF172B4D),
                fontSize: 24,
                height: 1.5,
                fontWeight: FontWeight.w700,
                letterSpacing: -.6,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Nhập email hoặc số điện thoại để nhận mã xác thực đặt lại mật khẩu.',
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
                height: 1.625,
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Email hoặc số điện thoại',
              style: TextStyle(
                color: Color(0xFF374151),
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Padding(
                  padding: EdgeInsets.all(15),
                  child: FigmaSvg(
                    'assets/icons/forgot_05.svg',
                    width: 20,
                    height: 20,
                  ),
                ),
                hintText: 'Nhập email hoặc số điện thoại',
                hintStyle: const TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 14,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 17,
                  vertical: 15,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: StayNestColors.tealBright,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _PrimaryAction(
              label: 'Gửi mã xác thực',
              onPressed: () => _notConnected(
                context,
                'Dịch vụ khôi phục mật khẩu chưa được kết nối.',
              ),
            ),
            const Spacer(),
            Center(
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: const Text(
                  'Quay lại đăng nhập',
                  style: TextStyle(
                    color: Color(0xFF0F8B8D),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const _HomeIndicator(color: Color(0xFFD1D5DB)),
          ],
        ),
      ),
    ),
  );
}

class ResetOtpScreen extends StatelessWidget {
  const ResetOtpScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 4, 24, 16),
        child: Column(
          children: [
            const _AuthStatusBar(prefix: 'resetotp'),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: _RoundBack(
                onTap: () => context.pop(),
                icon: 'assets/icons/resetotp_04.svg',
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF7F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const FigmaSvg(
                'assets/icons/resetotp_05.svg',
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Xác thực tài khoản',
              style: TextStyle(
                color: Color(0xFF172B4D),
                fontSize: 22,
                height: 1.5,
                fontWeight: FontWeight.w700,
                letterSpacing: -.55,
              ),
            ),
            const SizedBox(height: 8),
            const SizedBox(
              width: 290,
              child: Text(
                'Nhập mã 6 số đã được gửi đến email hoặc\nsố điện thoại của bạn.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 14,
                  height: 1.375,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                6,
                (index) => _OtpDigit(
                  value: const ['4', '9', '1', '', '', ''][index],
                  active: index == 3,
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text.rich(
              TextSpan(
                style: TextStyle(color: Color(0xFF667085), fontSize: 13),
                children: [
                  TextSpan(text: 'Gửi lại mã sau '),
                  TextSpan(
                    text: '00:45',
                    style: TextStyle(
                      color: Color(0xFF172B4D),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: null,
              child: const Text(
                'Gửi lại mã',
                style: TextStyle(
                  color: Color(0xFF0F8B8D),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _PrimaryAction(
              label: 'Tiếp tục',
              onPressed: () => _notConnected(
                context,
                'Xác thực mã sẽ khả dụng khi kết nối dịch vụ OTP.',
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Không nhận được mã? Hãy kiểm tra trong thư mục thư rác (spam) hoặc thử lại.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF667085),
                fontSize: 12,
                height: 1.5,
              ),
            ),
            const Spacer(),
            const _HomeIndicator(color: Color(0xFFD1D5DB)),
          ],
        ),
      ),
    ),
  );
}

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});
  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  bool hidePassword = true;
  bool hideConfirmation = true;
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _RoundBack(
                  onTap: () => context.pop(),
                  icon: 'assets/icons/newpass_01.svg',
                  filled: true,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF7F6),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Row(
                    children: [
                      FigmaSvg(
                        'assets/icons/newpass_02.svg',
                        width: 10,
                        height: 12,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Bảo mật',
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
            const SizedBox(height: 24),
            const Text(
              'Đặt mật khẩu mới',
              style: TextStyle(
                color: Color(0xFF182230),
                fontSize: 24,
                height: 1.25,
                fontWeight: FontWeight.w600,
                letterSpacing: -.6,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tạo mật khẩu mới an toàn để bảo vệ tài khoản StayNest của bạn.',
              style: TextStyle(
                color: Color(0xFF667085),
                fontSize: 14,
                height: 1.625,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Mật khẩu mới',
              style: TextStyle(
                color: Color(0xFF182230),
                fontSize: 14,
                height: 1.55,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            _PasswordField(
              hint: 'Mật khẩu mới',
              hidden: hidePassword,
              leading: 'assets/icons/newpass_03.svg',
              onToggle: () => setState(() => hidePassword = !hidePassword),
            ),
            const SizedBox(height: 22),
            const Text(
              'Xác nhận mật khẩu',
              style: TextStyle(
                color: Color(0xFF182230),
                fontSize: 14,
                height: 1.55,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            _PasswordField(
              hint: 'Xác nhận mật khẩu',
              hidden: hideConfirmation,
              leading: 'assets/icons/newpass_05.svg',
              onToggle: () =>
                  setState(() => hideConfirmation = !hideConfirmation),
            ),
            const SizedBox(height: 24),
            const Text(
              'Yêu cầu mật khẩu',
              style: TextStyle(
                color: Color(0xFF182230),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            const _PasswordRule(text: 'Tối thiểu 8 ký tự'),
            const SizedBox(height: 8),
            const _PasswordRule(text: 'Có ít nhất một chữ hoa'),
            const SizedBox(height: 8),
            const _PasswordRule(text: 'Có ít nhất một chữ số'),
            const SizedBox(height: 26),
            _PrimaryAction(
              label: 'Cập nhật mật khẩu',
              onPressed: () => _notConnected(
                context,
                'Đổi mật khẩu sẽ khả dụng khi kết nối backend.',
              ),
            ),
            const SizedBox(height: 18),
            const Center(
              child: Text.rich(
                TextSpan(
                  style: TextStyle(color: Color(0xFF667085), fontSize: 12),
                  children: [
                    TextSpan(text: 'Cần hỗ trợ? '),
                    TextSpan(
                      text: 'Liên hệ bộ phận CSKH StayNest',
                      style: TextStyle(
                        color: Color(0xFF006768),
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
    ),
  );
}

class PasswordResetSuccessScreen extends StatelessWidget {
  const PasswordResetSuccessScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 18),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FigmaSvg(
                    'assets/icons/resetok_01.svg',
                    width: 21,
                    height: 19,
                  ),
                  SizedBox(width: 5),
                  Text(
                    'StayNest',
                    style: TextStyle(
                      color: Color(0xFF121C2A),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -.45,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF7F6),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  width: 64,
                  height: 64,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Color(0x1A006768),
                    shape: BoxShape.circle,
                  ),
                  child: const FigmaSvg(
                    'assets/icons/resetok_02.svg',
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'Đổi mật khẩu thành công!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF121C2A),
                  fontSize: 24,
                  height: 1.25,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -.6,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Mật khẩu của bạn đã được cập nhật. Hãy\nđăng nhập bằng mật khẩu mới.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF667085),
                  fontSize: 14,
                  height: 1.625,
                ),
              ),
              const Spacer(),
              _PrimaryAction(
                label: 'Đăng nhập ngay',
                color: StayNestColors.teal,
                onPressed: () => context.go('/login'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        const Positioned(
          bottom: 8,
          left: 0,
          right: 0,
          child: _HomeIndicator(color: Color(0x33121C2A)),
        ),
      ],
    ),
  );
}

class _AuthStatusBar extends StatelessWidget {
  const _AuthStatusBar({required this.prefix});
  final String prefix;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 28,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '9:41',
          style: TextStyle(
            color: Color(0xFF172B4D),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            FigmaSvg('assets/icons/${prefix}_01.svg', width: 14, height: 13),
            const SizedBox(width: 5),
            FigmaSvg('assets/icons/${prefix}_02.svg', width: 16, height: 12),
            const SizedBox(width: 5),
            FigmaSvg('assets/icons/${prefix}_03.svg', width: 8, height: 15),
          ],
        ),
      ],
    ),
  );
}

class _RoundBack extends StatelessWidget {
  const _RoundBack({
    required this.onTap,
    required this.icon,
    this.filled = false,
  });
  final VoidCallback onTap;
  final String icon;
  final bool filled;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    customBorder: const CircleBorder(),
    child: Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: filled ? const Color(0xFFEFF3FF) : Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: filled ? const Color(0xFFEFF3FF) : const Color(0xFFE5E7EB),
        ),
      ),
      child: FigmaSvg(icon, width: 20, height: 20),
    ),
  );
}

class _PrimaryAction extends StatelessWidget {
  const _PrimaryAction({
    required this.label,
    required this.onPressed,
    this.color = const Color(0xFF0F8B8D),
  });
  final String label;
  final VoidCallback onPressed;
  final Color color;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 52,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 1,
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
  );
}

class _OtpDigit extends StatelessWidget {
  const _OtpDigit({required this.value, required this.active});
  final String value;
  final bool active;
  @override
  Widget build(BuildContext context) => Container(
    width: 48,
    height: 54,
    margin: const EdgeInsets.symmetric(horizontal: 5),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(
        color: active ? StayNestColors.tealBright : const Color(0xFFE5E7EB),
        width: 2,
      ),
      borderRadius: BorderRadius.circular(16),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0D000000),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: value.isEmpty && active
        ? Container(
            width: 2,
            height: 20,
            decoration: BoxDecoration(
              color: StayNestColors.tealBright,
              borderRadius: BorderRadius.circular(99),
            ),
          )
        : Text(
            value,
            style: const TextStyle(
              color: Color(0xFF172B4D),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
  );
}

class _PasswordField extends StatelessWidget {
  const _PasswordField({
    required this.hint,
    required this.hidden,
    required this.leading,
    required this.onToggle,
  });
  final String hint;
  final bool hidden;
  final String leading;
  final VoidCallback onToggle;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 52,
    child: TextField(
      obscureText: hidden,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.all(14),
          child: FigmaSvg(leading, width: 19, height: 19),
        ),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: FigmaSvg(
            hidden
                ? 'assets/icons/newpass_04.svg'
                : 'assets/icons/newpass_06.svg',
            width: 18,
            height: 14,
          ),
        ),
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF98A2B3), fontSize: 14),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: StayNestColors.tealBright),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}

class _PasswordRule extends StatelessWidget {
  const _PasswordRule({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const FigmaSvg('assets/icons/newpass_06.svg', width: 15, height: 15),
      const SizedBox(width: 8),
      Text(
        text,
        style: const TextStyle(color: Color(0xFF667085), fontSize: 13),
      ),
    ],
  );
}

class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: 128,
      height: 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(99),
      ),
    ),
  );
}

void _notConnected(BuildContext context, String message) =>
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
