import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/staynest_api.dart';
import '../design/tokens.dart';
import '../widgets/figma_asset.dart';
import '../widgets/figma_status_bar.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _obscure = true;
  bool _loading = false;
  final _identity = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _identity.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_identity.text.trim().isEmpty || _password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nhập email/số điện thoại và mật khẩu.')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await ref
          .read(stayNestApiProvider)
          .login(_identity.text.trim(), _password.text);
      ref.invalidate(currentUserProvider);
      ref.invalidate(myBookingsProvider);
      ref.invalidate(myFavoritesProvider);
      try {
        final user = await ref.read(stayNestApiProvider).getMe();
        ref.read(bookingDraftProvider).prefillGuestFromUser(user);
      } catch (_) {}
      final draft = ref.read(bookingDraftProvider);
      final destination = draft.resumeAfterLogin
          ? '/booking/price'
          : '/account';
      draft.resumeAfterLogin = false;
      if (mounted) context.go(destination);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$error')));
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: StayNestColors.canvas,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const FigmaStatusBar(),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => context.pop(),
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: StayNestColors.white,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const FigmaSvg(
                          'assets/icons/login_04.svg',
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Đăng nhập',
                      style: TextStyle(
                        fontSize: 28,
                        height: 36 / 28,
                        fontWeight: FontWeight.w700,
                        color: StayNestColors.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Chào mừng bạn quay lại cùng StayNest',
                      style: TextStyle(
                        fontSize: 14,
                        height: 22 / 14,
                        color: StayNestColors.muted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _FieldLabel('Email hoặc số điện thoại'),
                    const SizedBox(height: 8),
                    _LoginInput(
                      icon: 'assets/icons/login_05.svg',
                      hint: 'an.demo@example.com hoặc 0900...',
                      controller: _identity,
                    ),
                    const SizedBox(height: 18),
                    const _FieldLabel('Mật khẩu'),
                    const SizedBox(height: 8),
                    _LoginInput(
                      icon: 'assets/icons/login_06.svg',
                      hint: '••••••••••••',
                      controller: _password,
                      obscure: _obscure,
                      trailing: InkWell(
                        onTap: () => setState(() => _obscure = !_obscure),
                        child: const FigmaSvg(
                          'assets/icons/login_07.svg',
                          width: 18,
                          height: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.check_box,
                              color: StayNestColors.teal,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Ghi nhớ đăng nhập',
                              style: TextStyle(
                                fontSize: 12,
                                height: 18 / 12,
                                color: StayNestColors.body,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => context.push('/forgot-password'),
                          child: const Text(
                            'Quên mật khẩu?',
                            style: TextStyle(
                              fontSize: 12,
                              height: 18 / 12,
                              fontWeight: FontWeight.w600,
                              color: StayNestColors.teal,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: _loading ? null : _submit,
                        style: FilledButton.styleFrom(
                          backgroundColor: StayNestColors.teal,
                          disabledBackgroundColor: StayNestColors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _loading ? 'Đang đăng nhập...' : 'Đăng nhập',
                          style: TextStyle(
                            fontSize: 14,
                            height: 20 / 14,
                            fontWeight: FontWeight.w600,
                            color: StayNestColors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Row(
                      children: [
                        Expanded(child: Divider(color: StayNestColors.border)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'Hoặc đăng nhập với',
                            style: TextStyle(
                              fontSize: 11,
                              height: 16 / 11,
                              color: StayNestColors.muted,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: StayNestColors.border)),
                      ],
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: null,
                        style: OutlinedButton.styleFrom(
                          disabledForegroundColor: StayNestColors.ink,
                          backgroundColor: StayNestColors.white,
                          side: const BorderSide(color: StayNestColors.border),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            FigmaSvg(
                              'assets/icons/login_09.svg',
                              width: 18,
                              height: 18,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Tiếp tục với Google',
                              style: TextStyle(
                                fontSize: 13,
                                height: 18 / 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Chưa có tài khoản? ',
                      style: TextStyle(
                        fontSize: 12,
                        height: 18 / 12,
                        color: StayNestColors.muted,
                      ),
                    ),
                    InkWell(
                      onTap: () => context.push('/signup'),
                      child: const Text(
                        'Đăng ký',
                        style: TextStyle(
                          fontSize: 12,
                          height: 18 / 12,
                          fontWeight: FontWeight.w600,
                          color: StayNestColors.teal,
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
    ),
  );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 13,
      height: 18 / 13,
      fontWeight: FontWeight.w600,
      color: StayNestColors.ink,
    ),
  );
}

class _LoginInput extends StatelessWidget {
  const _LoginInput({
    required this.icon,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.trailing,
  });
  final String icon;
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final Widget? trailing;
  @override
  Widget build(BuildContext context) => Container(
    height: 50,
    padding: const EdgeInsets.symmetric(horizontal: 14),
    decoration: BoxDecoration(
      color: StayNestColors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: StayNestColors.border),
    ),
    child: Row(
      children: [
        FigmaSvg(icon, width: 18, height: 18),
        const SizedBox(width: 10),
        Expanded(
          child: TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                fontSize: 12,
                color: StayNestColors.mutedLight,
              ),
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
