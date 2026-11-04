import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/staynest_api.dart';
import '../design/tokens.dart';
import '../widgets/figma_asset.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});
  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  bool acceptedTerms = false;
  bool obscurePassword = true;
  bool loading = false;
  final name = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final confirmation = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    password.dispose();
    confirmation.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!acceptedTerms || password.text != confirmation.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Vui lòng đồng ý điều khoản và xác nhận đúng mật khẩu.',
          ),
        ),
      );
      return;
    }
    setState(() => loading = true);
    try {
      await ref
          .read(stayNestApiProvider)
          .register(
            fullName: name.text,
            email: email.text,
            phone: phone.text,
            password: password.text,
          );
      ref.invalidate(currentUserProvider);
      ref.invalidate(myBookingsProvider);
      ref.invalidate(myFavoritesProvider);
      final draft = ref.read(bookingDraftProvider);
      draft.guestName = name.text.trim();
      draft.guestEmail = email.text.trim();
      draft.guestPhone = phone.text.trim();
      final destination = draft.resumeAfterLogin
          ? '/booking/price'
          : '/signup/success';
      draft.resumeAfterLogin = false;
      if (mounted) context.go(destination);
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$error')));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Column(
        children: [
          const _StatusBar(prefix: 'signup'),
          SizedBox(
            height: 44,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _BackButton(onTap: () => context.pop()),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      children: [
                        CircleAvatar(
                          radius: 3,
                          backgroundColor: Color(0xFF0F8B8D),
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Bước 1/2',
                          style: TextStyle(
                            color: Color(0xFF172B4D),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tạo tài khoản',
                    style: TextStyle(
                      color: Color(0xFF172B4D),
                      fontSize: 23,
                      height: 1.25,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 3),
                  const Text(
                    'Bắt đầu hành trình lưu trú cùng StayNest',
                    style: TextStyle(
                      color: Color(0xFF667085),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _InputField(
                    hint: 'Họ và tên',
                    icon: 'assets/icons/signup_05.svg',
                    controller: name,
                  ),
                  const SizedBox(height: 10),
                  _InputField(
                    hint: 'Email liên hệ',
                    icon: 'assets/icons/signup_06.svg',
                    keyboardType: TextInputType.emailAddress,
                    controller: email,
                  ),
                  const SizedBox(height: 10),
                  _InputField(
                    hint: 'Số điện thoại',
                    icon: 'assets/icons/signup_07.svg',
                    keyboardType: TextInputType.phone,
                    controller: phone,
                  ),
                  const SizedBox(height: 10),
                  _InputField(
                    hint: 'Mật khẩu (tối thiểu 8 ký tự)',
                    icon: 'assets/icons/signup_08.svg',
                    obscureText: obscurePassword,
                    controller: password,
                    suffix: IconButton(
                      onPressed: () =>
                          setState(() => obscurePassword = !obscurePassword),
                      icon: const FigmaSvg(
                        'assets/icons/signup_09.svg',
                        width: 18,
                        height: 18,
                      ),
                      splashRadius: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _InputField(
                    hint: 'Xác nhận lại mật khẩu',
                    icon: 'assets/icons/signup_08.svg',
                    obscureText: true,
                    controller: confirmation,
                  ),
                  const SizedBox(height: 9),
                  InkWell(
                    onTap: () => setState(() => acceptedTerms = !acceptedTerms),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 18,
                          height: 18,
                          margin: const EdgeInsets.only(top: 2, right: 9),
                          decoration: BoxDecoration(
                            color: acceptedTerms
                                ? StayNestColors.tealBright
                                : Colors.white,
                            border: Border.all(
                              color: acceptedTerms
                                  ? StayNestColors.tealBright
                                  : const Color(0xFFD0D5DD),
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: acceptedTerms
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const Expanded(
                          child: Text.rich(
                            TextSpan(
                              style: TextStyle(
                                color: Color(0xFF667085),
                                fontSize: 11,
                                height: 1.5,
                              ),
                              children: [
                                TextSpan(text: 'Tôi đồng ý với '),
                                TextSpan(
                                  text: 'Điều khoản dịch vụ',
                                  style: TextStyle(
                                    color: Color(0xFF0F8B8D),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(text: ' và '),
                                TextSpan(
                                  text: 'Chính sách quyền riêng tư',
                                  style: TextStyle(
                                    color: Color(0xFF0F8B8D),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(text: ' của StayNest.'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: FilledButton(
                      onPressed: loading ? null : submit,
                      style: FilledButton.styleFrom(
                        backgroundColor: StayNestColors.tealBright,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Tạo tài khoản',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            size: 18,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 13),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'HOẶC',
                          style: TextStyle(
                            color: Color(0xFF98A2B3),
                            fontSize: 10,
                            letterSpacing: .6,
                          ),
                        ),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton(
                      onPressed: null,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFFE4E7EC)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          FigmaSvg(
                            'assets/icons/signup_13.svg',
                            width: 16,
                            height: 16,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Đăng ký với Google',
                            style: TextStyle(
                              color: Color(0xFF172B4D),
                              fontSize: 13.5,
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
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 4),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Đã có tài khoản? ',
                      style: TextStyle(color: Color(0xFF667085), fontSize: 13),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/login'),
                      child: const Text(
                        'Đăng nhập',
                        style: TextStyle(
                          color: Color(0xFF0F8B8D),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  width: 134,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0x33172B4D),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Column(
        children: [
          const _StatusBar(prefix: 'otp'),
          SizedBox(
            height: 48,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _BackButton(onTap: () => context.pop()),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF7F6),
                      border: Border.all(color: const Color(0x1A0F8B8D)),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Bước 2 / 2',
                      style: TextStyle(
                        color: Color(0xFF0F8B8D),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Container(
                    width: 56,
                    height: 56,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF7F6),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0D000000),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const FigmaSvg(
                      'assets/icons/otp_05.svg',
                      width: 28,
                      height: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Xác thực tài khoản',
                    style: TextStyle(
                      color: Color(0xFF172B4D),
                      fontSize: 24,
                      height: 1.25,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(
                    width: 280,
                    child: Text(
                      'Nhập mã 6 số đã được gửi đến số điện thoại / email của bạn',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF667085),
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const SizedBox(height: 13),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      border: Border.all(color: const Color(0x99E5E7EB)),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '0900 *** 123',
                          style: TextStyle(
                            color: Color(0xFF172B4D),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Text(
                            '•',
                            style: TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 12,
                            ),
                          ),
                        ),
                        Text(
                          'an.demo@example.com',
                          style: TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 33),
                  SizedBox(
                    height: 58,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(6, (index) {
                            const digits = '852';
                            return Container(
                              width: 48,
                              height: 56,
                              margin: const EdgeInsets.symmetric(horizontal: 5),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color:
                                      index ==
                                          (digits.length < 6
                                              ? digits.length
                                              : 5)
                                      ? StayNestColors.tealBright
                                      : const Color(0xFFE4E7EC),
                                  width:
                                      index ==
                                          (digits.length < 6
                                              ? digits.length
                                              : 5)
                                      ? 1.5
                                      : 1,
                                ),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x0D000000),
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: Text(
                                index < digits.length ? digits[index] : '',
                                style: const TextStyle(
                                  color: Color(0xFF172B4D),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
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
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Đăng nhập Google chưa được cấu hình.'),
                      ),
                    ),
                    child: const Text(
                      'Gửi lại mã',
                      style: TextStyle(
                        color: Color(0xFF0F8B8D),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: () => ScaffoldMessenger.of(context)
                            .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Xác thực sẽ được bật khi kết nối dịch vụ OTP.',
                                ),
                              ),
                            ),
                        style: FilledButton.styleFrom(
                          backgroundColor: StayNestColors.tealBright,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Xác nhận',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 198),
                  const Text(
                    'Không nhận được mã? Kiểm tra hộp thư rác (spam)',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFF667085), fontSize: 12),
                  ),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text(
                      'hoặc thử lại phương thức khác',
                      style: TextStyle(
                        color: Color(0xFF0F8B8D),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              width: 134,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0x33172B4D),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _StatusBar extends StatelessWidget {
  const _StatusBar({required this.prefix});
  final String prefix;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 44,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
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
    ),
  );
}

class _BackButton extends StatelessWidget {
  const _BackButton({required this.onTap});
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    customBorder: const CircleBorder(),
    child: Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: const FigmaSvg(
        'assets/icons/signup_04.svg',
        width: 20,
        height: 20,
      ),
    ),
  );
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.hint,
    required this.icon,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.suffix,
  });
  final String hint;
  final String icon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffix;
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 47,
    child: TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(fontSize: 14, color: Color(0xFF172B4D)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF98A2B3), fontSize: 14),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: FigmaSvg(icon, width: 18, height: 18),
        ),
        prefixIconConstraints: const BoxConstraints(
          minWidth: 41,
          minHeight: 47,
        ),
        suffixIcon: suffix,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 15,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF0F8B8D)),
          borderRadius: BorderRadius.circular(14),
        ),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE4E7EC)),
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    ),
  );
}
