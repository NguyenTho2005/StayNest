import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../design/tokens.dart';
import '../widgets/figma_asset.dart';

class LoginErrorScreen extends StatefulWidget {
  const LoginErrorScreen({super.key});
  @override
  State<LoginErrorScreen> createState() => _LoginErrorScreenState();
}

class _LoginErrorScreenState extends State<LoginErrorScreen> {
  bool obscurePassword = true;
  bool rememberLogin = true;

  void _serviceNotice() => ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Đăng nhập sẽ khả dụng khi kết nối backend.')),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: Column(
      children: [
        SizedBox(
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: () => context.pop(),
                icon: const FigmaSvg(
                  'assets/icons/login_error_10.svg',
                  width: 16,
                  height: 16,
                ),
                style: IconButton.styleFrom(fixedSize: const Size(40, 44)),
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Đăng nhập',
                  style: TextStyle(
                    color: Color(0xFF182230),
                    fontSize: 24,
                    height: 1.25,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -.6,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Chào mừng bạn quay lại cùng StayNest',
                  style: TextStyle(
                    color: Color(0xFF667085),
                    fontSize: 14,
                    height: 22 / 14,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0x66FFDAD6),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 32,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: Color(0x1AD92D20),
                          shape: BoxShape.circle,
                        ),
                        child: const FigmaSvg(
                          'assets/icons/login_error_01.svg',
                          width: 17,
                          height: 17,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email hoặc mật khẩu chưa đúng',
                              style: TextStyle(
                                color: Color(0xFFD92D20),
                                fontSize: 14,
                                height: 22 / 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Vui lòng kiểm tra lại thông tin đăng nhập hoặc lấy lại mật khẩu.',
                              style: TextStyle(
                                color: Color(0xFF667085),
                                fontSize: 12,
                                height: 16.5 / 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const _Label('Email hoặc số điện thoại'),
                const SizedBox(height: 6),
                _LoginErrorField(
                  icon: 'assets/icons/login_error_02.svg',
                  initialValue: 'an.demo@example.com',
                ),
                const SizedBox(height: 16),
                const _Label('Mật khẩu'),
                const SizedBox(height: 6),
                _LoginErrorField(
                  icon: 'assets/icons/login_error_04.svg',
                  initialValue: 'password123',
                  obscure: obscurePassword,
                  error: true,
                  trailing: IconButton(
                    onPressed: () =>
                        setState(() => obscurePassword = !obscurePassword),
                    icon: const FigmaSvg(
                      'assets/icons/login_error_05.svg',
                      width: 18,
                      height: 13,
                    ),
                    splashRadius: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FigmaSvg(
                      'assets/icons/login_error_06.svg',
                      width: 14,
                      height: 16,
                    ),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'Mật khẩu không chính xác. Bạn còn 4 lần thử trước khi tạm khóa tài khoản.',
                        style: TextStyle(
                          color: Color(0xFFD92D20),
                          fontSize: 12,
                          height: 18 / 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    InkWell(
                      onTap: () =>
                          setState(() => rememberLogin = !rememberLogin),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: rememberLogin
                                  ? StayNestColors.teal
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: rememberLogin
                                ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Ghi nhớ đăng nhập',
                            style: TextStyle(
                              color: Color(0xFF667085),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => context.push('/forgot-password'),
                      child: const Text(
                        'Quên mật khẩu?',
                        style: TextStyle(
                          color: Color(0xFF006768),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _ActionButton(
                  label: 'Đăng nhập',
                  icon: 'assets/icons/login_error_07.svg',
                  onPressed: _serviceNotice,
                ),
                const SizedBox(height: 8),
                _ActionButton(
                  label: 'Thử lại',
                  icon: 'assets/icons/login_error_08.svg',
                  onPressed: _serviceNotice,
                  secondary: true,
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Expanded(child: Divider(color: Color(0xFFD9E3F6))),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'HOẶC',
                        style: TextStyle(
                          color: Color(0xFF667085),
                          fontSize: 12,
                          letterSpacing: .6,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Color(0xFFD9E3F6))),
                  ],
                ),
                const SizedBox(height: 12),
                _ActionButton(
                  label: 'Đăng nhập với Google',
                  icon: 'assets/icons/login_error_09.svg',
                  onPressed: _serviceNotice,
                  secondary: true,
                  pale: true,
                ),
                const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Chưa có tài khoản? ',
                        style: TextStyle(
                          color: Color(0xFF667085),
                          fontSize: 14,
                        ),
                      ),
                      InkWell(
                        onTap: () => context.push('/signup'),
                        child: const Text(
                          'Đăng ký',
                          style: TextStyle(
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
      ],
    ),
  );
}

class _Label extends StatelessWidget {
  const _Label(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: Color(0xFF182230),
      fontSize: 14,
      height: 22 / 14,
      fontWeight: FontWeight.w500,
    ),
  );
}

class _LoginErrorField extends StatelessWidget {
  const _LoginErrorField({
    required this.icon,
    required this.initialValue,
    this.obscure = false,
    this.error = false,
    this.trailing,
  });
  final String icon;
  final String initialValue;
  final bool obscure;
  final bool error;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Container(
    height: 52,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: error ? const Color(0x33FFDAD6) : const Color(0xFFF7F9FC),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0D000000),
          blurRadius: 2,
          offset: Offset(0, 1),
        ),
      ],
    ),
    child: Row(
      children: [
        FigmaSvg(icon, width: 19, height: 19),
        const SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            initialValue: initialValue,
            obscureText: obscure,
            style: const TextStyle(
              color: Color(0xFF182230),
              fontSize: 14,
              letterSpacing: 1.0,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        ?trailing,
      ],
    ),
  );
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.secondary = false,
    this.pale = false,
  });
  final String label;
  final String icon;
  final VoidCallback onPressed;
  final bool secondary;
  final bool pale;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 52,
    child: FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: secondary
            ? (pale ? const Color(0xFFF7F9FC) : const Color(0xFFEAF7F6))
            : StayNestColors.teal,
        foregroundColor: secondary ? const Color(0xFF006768) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (pale)
            FigmaSvg(icon, width: 20, height: 20)
          else
            FigmaSvg(icon, width: 14, height: 14),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: secondary ? const Color(0xFF006768) : Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}
