import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/staynest_api.dart';
import '../design/tokens.dart';

/// Trích xuất chữ cái đầu (tối đa 2 ký tự) từ họ tên người dùng.
String extractInitials(String? fullName) {
  if (fullName == null) return '';
  final trimmed = fullName.trim();
  if (trimmed.isEmpty) return '';
  final parts = trimmed.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '';
  if (parts.length == 1) {
    final word = parts.first;
    return (word.length >= 2 ? word.substring(0, 2) : word).toUpperCase();
  }
  final first = parts.first.substring(0, 1);
  final last = parts.last.substring(0, 1);
  return '$first$last'.toUpperCase();
}

/// Avatar người dùng đồng bộ cho toàn bộ AppBar, Header và Profile trong ứng dụng.
/// Tự động cập nhật tức thì khi [currentUserProvider] thay đổi dữ liệu.
class UserAvatarAppBar extends ConsumerWidget {
  const UserAvatarAppBar({
    super.key,
    this.size = 36,
    this.onTap,
    this.backgroundColor,
    this.foregroundColor,
    this.border,
  });

  /// Đường kính avatar.
  final double size;

  /// Hành động khi nhấn vào avatar (thường điều hướng đến `/account` hoặc `/profile`).
  final VoidCallback? onTap;

  /// Màu nền của khung avatar khi hiển thị initials hoặc icon.
  final Color? backgroundColor;

  /// Màu chữ initials hoặc màu icon.
  final Color? foregroundColor;

  /// Viền ngoài của avatar (nếu có).
  final Border? border;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.value;
    final avatarUrl = user?['avatar_url']?.toString().trim();
    final fullName = user?['full_name']?.toString() ?? '';
    final initials = extractInitials(fullName);

    final bg = backgroundColor ?? StayNestColors.paleTeal;
    final fg = foregroundColor ?? StayNestColors.teal;

    Widget content;

    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      final api = ref.read(stayNestApiProvider);
      final normalizedUrl =
          avatarUrl.startsWith('http://') || avatarUrl.startsWith('https://')
              ? avatarUrl
              : api.mediaUrl(avatarUrl).toString();

      content = ClipOval(
        child: Image.network(
          normalizedUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallback(initials, fg),
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return _buildFallback(initials, fg);
          },
        ),
      );
    } else {
      content = _buildFallback(initials, fg);
    }

    final avatarBox = Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: border,
      ),
      alignment: Alignment.center,
      child: content,
    );

    if (onTap == null) {
      return avatarBox;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(size / 2),
      child: avatarBox,
    );
  }

  Widget _buildFallback(String initials, Color fg) {
    if (initials.isNotEmpty) {
      return Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.40,
          height: 1.0,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      );
    }
    return Icon(
      Icons.person_outline,
      size: size * 0.55,
      color: fg,
    );
  }
}
