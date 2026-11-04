import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/staynest_api.dart';
import '../design/tokens.dart';
import '../widgets/figma_asset.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});
  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _birthDate = TextEditingController();
  String email = '';
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    try {
      final user = await ref.read(stayNestApiProvider).getMe();
      if (!mounted) return;
      _name.text = '${user['full_name'] ?? ''}';
      _phone.text = '${user['phone'] ?? ''}';
      email = '${user['email'] ?? ''}';
      final date = DateTime.tryParse('${user['birth_date'] ?? ''}');
      if (date != null) {
        _birthDate.text =
            '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      }
      setState(() {});
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$error')));
      }
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _save() async {
    final parts = _birthDate.text.trim().split('/');
    String? date;
    if (_birthDate.text.trim().isNotEmpty) {
      if (parts.length != 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ngày sinh cần có dạng DD/MM/YYYY.')),
        );
        return;
      }
      date =
          '${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}';
    }
    setState(() => loading = true);
    try {
      final changes = <String, dynamic>{
        'fullName': _name.text.trim(),
        'phone': _phone.text.trim(),
      };
      if (date != null) changes['birthDate'] = date;
      await ref.read(stayNestApiProvider).updateMe(changes);
      ref.invalidate(currentUserProvider);
      if (mounted) context.go('/profile');
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
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _birthDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: StayNestColors.white,
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 390),
        child: Column(
          children: [
            const _EditHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: StayNestColors.paleTeal,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const FigmaSvg(
                            'assets/icons/profile_edit_01.svg',
                            width: 20,
                            height: 20,
                          ),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hồ sơ xác thực cấp 1',
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 18 / 12,
                                    fontWeight: FontWeight.w600,
                                    color: StayNestColors.ink,
                                  ),
                                ),
                                Text(
                                  'Bảo vệ thông tin cá nhân & hoàn tất hồ sơ',
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
                              horizontal: 8,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD6F0ED),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: const Text(
                              '85% hoàn thiện',
                              style: TextStyle(
                                fontSize: 9,
                                height: 13 / 9,
                                fontWeight: FontWeight.w600,
                                color: StayNestColors.teal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 92,
                                height: 92,
                                decoration: const BoxDecoration(
                                  color: StayNestColors.tealBright,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: const Text(
                                  'ND',
                                  style: TextStyle(
                                    fontSize: 28,
                                    height: 34 / 28,
                                    fontWeight: FontWeight.w600,
                                    color: StayNestColors.white,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: -1,
                                bottom: 0,
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: StayNestColors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0x1A172B4D),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: const FigmaSvg(
                                    'assets/icons/profile_edit_02.svg',
                                    width: 17,
                                    height: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Thay đổi ảnh chân dung',
                            style: TextStyle(
                              fontSize: 12,
                              height: 18 / 12,
                              fontWeight: FontWeight.w600,
                              color: StayNestColors.teal,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Hỗ trợ JPG, PNG dung lượng dưới 5MB',
                            style: TextStyle(
                              fontSize: 10,
                              height: 15 / 10,
                              color: StayNestColors.muted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    _EditLabel('Họ và tên', required: true),
                    const SizedBox(height: 6),
                    _EditInput(
                      controller: _name,
                      trailing: const FigmaSvg(
                        'assets/icons/profile_edit_03.svg',
                        width: 16,
                        height: 16,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _EditLabel('Số liên hệ', required: true),
                    const SizedBox(height: 6),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F9FC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            '🇻🇳  +84  ⌄',
                            style: TextStyle(
                              fontSize: 11,
                              height: 16 / 11,
                              color: StayNestColors.ink,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            width: 1,
                            height: 24,
                            color: StayNestColors.border,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _phone,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                hintStyle: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 4, top: 5),
                      child: Text(
                        'Dùng để nhận mã SMS nhận phòng và hỗ trợ khẩn cấp',
                        style: TextStyle(
                          fontSize: 9,
                          height: 13 / 9,
                          color: StayNestColors.muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Expanded(child: _EditLabel('Email liên hệ')),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE7EEFC),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: const Row(
                            children: [
                              FigmaSvg(
                                'assets/icons/profile_edit_05.svg',
                                width: 10,
                                height: 10,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Không thể thay đổi',
                                style: TextStyle(
                                  fontSize: 9,
                                  height: 13 / 9,
                                  color: Color(0xFF4C5E83),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _EditInput(
                      initialValue: email,
                      enabled: false,
                      trailing: const FigmaSvg(
                        'assets/icons/profile_edit_05.svg',
                        width: 17,
                        height: 17,
                      ),
                      background: const Color(0xFFE8EEFC),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 4, top: 5),
                      child: Text(
                        'Để đổi email tài khoản chính, vui lòng liên hệ CSKH StayNest',
                        style: TextStyle(
                          fontSize: 9,
                          height: 13 / 9,
                          color: StayNestColors.muted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Row(
                      children: [
                        Text(
                          'Ngày sinh',
                          style: TextStyle(
                            fontSize: 12,
                            height: 18 / 12,
                            fontWeight: FontWeight.w600,
                            color: StayNestColors.ink,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '(không bắt buộc)',
                          style: TextStyle(
                            fontSize: 10,
                            color: StayNestColors.muted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _EditInput(
                      controller: _birthDate,
                      trailing: const FigmaSvg(
                        'assets/icons/profile_edit_06.svg',
                        width: 16,
                        height: 16,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _EditLabel('Quốc tịch', required: true),
                    const SizedBox(height: 6),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F9FC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Text('🇻🇳', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 9),
                          const Expanded(
                            child: Text(
                              'Việt Nam',
                              style: TextStyle(
                                fontSize: 12,
                                color: StayNestColors.ink,
                              ),
                            ),
                          ),
                          const FigmaSvg(
                            'assets/icons/profile_edit_07.svg',
                            width: 13,
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F4FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FigmaSvg(
                            'assets/icons/profile_edit_09.svg',
                            width: 15,
                            height: 15,
                          ),
                          SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              '* Các trường thông tin bắt buộc để đảm bảo quyền lợi và bảo hiểm đặt phòng tại StayNest theo quy định lưu trú địa phương.',
                              style: TextStyle(
                                fontSize: 10,
                                height: 15 / 10,
                                color: StayNestColors.muted,
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
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 8),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton.icon(
                  onPressed: loading ? null : _save,
                  icon: const FigmaSvg(
                    'assets/icons/profile_edit_10.svg',
                    width: 15,
                    height: 15,
                  ),
                  label: const Text('Lưu thay đổi'),
                  style: FilledButton.styleFrom(
                    backgroundColor: StayNestColors.teal,
                    disabledBackgroundColor: StayNestColors.teal,
                    foregroundColor: StayNestColors.white,
                    disabledForegroundColor: StayNestColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text(
                'Hủy',
                style: TextStyle(
                  fontSize: 12,
                  height: 18 / 12,
                  color: StayNestColors.muted,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _EditHeader extends StatelessWidget {
  const _EditHeader();
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
              'assets/icons/profile_edit_11.svg',
              width: 16,
              height: 16,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Text(
              'Chỉnh Sửa Hồ Sơ',
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
              'assets/icons/profile_edit_12.svg',
              width: 12,
              height: 12,
            ),
          ),
        ],
      ),
    ),
  );
}

class _EditLabel extends StatelessWidget {
  const _EditLabel(this.label, {this.required = false});
  final String label;
  final bool required;
  @override
  Widget build(BuildContext context) => Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 12,
            height: 18 / 12,
            fontWeight: FontWeight.w600,
            color: StayNestColors.ink,
          ),
        ),
        if (required)
          const TextSpan(
            text: ' *',
            style: TextStyle(color: Color(0xFFD92D20)),
          ),
      ],
    ),
  );
}

class _EditInput extends StatelessWidget {
  const _EditInput({
    this.controller,
    this.initialValue,
    this.enabled = true,
    this.trailing,
    this.background = const Color(0xFFF7F9FC),
  });
  final TextEditingController? controller;
  final String? initialValue;
  final bool enabled;
  final Widget? trailing;
  final Color background;
  @override
  Widget build(BuildContext context) => Container(
    height: 48,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            enabled: enabled,
            readOnly: !enabled,
            decoration: InputDecoration(
              hintText: initialValue,
              hintStyle: TextStyle(
                fontSize: 12,
                color: enabled ? StayNestColors.ink : StayNestColors.muted,
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
