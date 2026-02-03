import 'package:flutter/material.dart';

/// A class that holds the color palette for the ZDS design system.
/// This is intended to be used within a `ThemeExtension`.
@immutable
class ZDSColors {
  const ZDSColors({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.surface,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
    required this.border,
    required this.divider,
    required this.disabled,
    required this.onPrimary,
    required this.onSecondary,
    required this.onBackground,
    required this.onSurface,
    required this.onError,
    required this.onSuccess,
    required this.onWarning,
    required this.onInfo,
  });

  final Color? primary;
  final Color? secondary;
  final Color? background;
  final Color? surface;
  final Color? error;
  final Color? success;
  final Color? warning;
  final Color? info;
  final Color? border;
  final Color? divider;
  final Color? disabled;
  final Color? onPrimary;
  final Color? onSecondary;
  final Color? onBackground;
  final Color? onSurface;
  final Color? onError;
  final Color? onSuccess;
  final Color? onWarning;
  final Color? onInfo;

  /// A default light theme color scheme.
  factory ZDSColors.light() {
    return const ZDSColors(
      primary: Color(0xFF1976D2),
      secondary: Color(0xFF388E3C),
      background: Colors.white,
      surface: Color(0xFFF5F5F5),
      error: Color(0xFFD32F2F),
      success: Color(0xFF388E3C),
      warning: Color(0xFFF57C00),
      info: Color(0xFF0288D1),
      border: Color(0xFFE0E0E0),
      divider: Color(0xFFBDBDBD),
      disabled: Color(0xFF9E9E9E),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: Color(0xFF212121),
      onSurface: Color(0xFF212121),
      onError: Colors.white,
      onSuccess: Colors.white,
      onWarning: Colors.white,
      onInfo: Colors.white,
    );
  }

  /// A default dark theme color scheme.
  factory ZDSColors.dark() {
    return const ZDSColors(
      primary: Color(0xFF42A5F5),
      secondary: Color(0xFF66BB6A),
      background: Color(0xFF121212),
      surface: Color(0xFF1E1E1E),
      error: Color(0xFFEF5350),
      success: Color(0xFF66BB6A),
      warning: Color(0xFFFFB74D),
      info: Color(0xFF29B6F6),
      border: Color(0xFF424242),
      divider: Color(0xFF616161),
      disabled: Color(0xFF757575),
      onPrimary: Color(0xFF121212),
      onSecondary: Color(0xFF121212),
      onBackground: Colors.white,
      onSurface: Colors.white,
      onError: Color(0xFF121212),
      onSuccess: Color(0xFF121212),
      onWarning: Color(0xFF121212),
      onInfo: Color(0xFF121212),
    );
  }
}
