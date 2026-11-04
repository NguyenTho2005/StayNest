import 'package:flutter/material.dart';

abstract final class StayNestColors {
  static const canvas = Color(0xFFF8F9FF);
  static const ink = Color(0xFF121C2A);
  static const body = Color(0xFF3D4949);
  static const muted = Color(0xFF667085);
  static const mutedLight = Color(0xFF98A2B3);
  static const teal = Color(0xFF006768);
  static const tealBright = Color(0xFF0F8B8D);
  static const paleBlue = Color(0xFFEFF3FF);
  static const paleTeal = Color(0xFFEAF7F6);
  static const border = Color(0xFFEAECF0);
  static const white = Color(0xFFFFFFFF);
  static const orange = Color(0xFFBB5636);
}

abstract final class StayNestTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: StayNestColors.canvas,
    colorScheme: const ColorScheme.light(
      primary: StayNestColors.teal,
      secondary: StayNestColors.tealBright,
      surface: StayNestColors.white,
      error: Color(0xFFD92D20),
      onPrimary: StayNestColors.white,
      onSurface: StayNestColors.ink,
    ),
    textTheme: const TextTheme(
      bodySmall: TextStyle(
        fontSize: 11,
        height: 16 / 11,
        color: StayNestColors.body,
      ),
      bodyMedium: TextStyle(
        fontSize: 12,
        height: 18 / 12,
        color: StayNestColors.body,
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        height: 22 / 14,
        color: StayNestColors.ink,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w600,
        color: StayNestColors.ink,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        height: 22 / 16,
        fontWeight: FontWeight.w600,
        color: StayNestColors.ink,
      ),
      titleLarge: TextStyle(
        fontSize: 24,
        height: 30 / 24,
        fontWeight: FontWeight.w600,
        color: StayNestColors.ink,
      ),
    ),
    dividerColor: StayNestColors.border,
    splashFactory: NoSplash.splashFactory,
  );
}
