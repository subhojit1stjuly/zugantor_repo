import 'package:flutter/material.dart';

/// A class that holds the color palette for the ZDS design system.
/// This is intended to be used within a `ThemeExtension`.
@immutable
class ZDSColors {
  const ZDSColors({
    required this.primary,
    required this.secondary,
    required this.background,
    required this.backgroundSecondary,
    required this.surface,
    required this.error,
    required this.success,
    required this.warning,
    required this.info,
    required this.border,
    required this.divider,
    required this.disabled,
    required this.disabledText,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.hover,
    required this.pressed,
    required this.focus,
    required this.onPrimary,
    required this.onSecondary,
    required this.onBackground,
    required this.onSurface,
    required this.onError,
    required this.onSuccess,
    required this.onWarning,
    required this.onInfo,
  });

  // --- Brand colors ---

  /// Primary brand color. Used for primary actions, links, and highlights.
  final Color? primary;

  /// Secondary brand color. Used for secondary actions and accents.
  final Color? secondary;

  // --- Background colors ---

  /// Main page/screen background.
  final Color? background;

  /// Alternate background for sections, sidebars, or stripes.
  final Color? backgroundSecondary;

  /// Surface color for cards, dialogs, and elevated containers.
  final Color? surface;

  // --- Semantic colors ---

  /// Used for destructive actions and validation errors.
  final Color? error;

  /// Used for positive confirmations and success states.
  final Color? success;

  /// Used for cautionary information and warning states.
  final Color? warning;

  /// Used for informational messages and neutral highlights.
  final Color? info;

  // --- Border / divider ---

  /// Default border color for inputs, cards, and containers.
  final Color? border;

  /// Divider line color between sections or list items.
  final Color? divider;

  // --- Disabled states ---

  /// Background or surface color for disabled interactive elements.
  final Color? disabled;

  /// Text color inside disabled elements.
  final Color? disabledText;

  // --- Text colors ---

  /// High-emphasis text; headlines, primary labels.
  final Color? textPrimary;

  /// Medium-emphasis text; secondary labels, captions.
  final Color? textSecondary;

  /// Low-emphasis text; hints, placeholders, metadata.
  final Color? textTertiary;

  // --- Interaction state colors ---

  /// Overlay applied on hover (16px alpha recommended).
  final Color? hover;

  /// Overlay applied on press/tap.
  final Color? pressed;

  /// Outline or overlay applied on keyboard focus.
  final Color? focus;

  // --- On-colors (content placed on top of each fill) ---

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
      backgroundSecondary: Color(0xFFF8F9FA),
      surface: Color(0xFFF5F5F5),
      error: Color(0xFFD32F2F),
      success: Color(0xFF388E3C),
      warning: Color(0xFFF57C00),
      info: Color(0xFF0288D1),
      border: Color(0xFFE0E0E0),
      divider: Color(0xFFBDBDBD),
      disabled: Color(0xFFE0E0E0),
      disabledText: Color(0xFF9E9E9E),
      textPrimary: Color(0xFF212121),
      textSecondary: Color(0xFF616161),
      textTertiary: Color(0xFF9E9E9E),
      hover: Color(0x0A000000),
      pressed: Color(0x14000000),
      focus: Color(0x1F1976D2),
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
      backgroundSecondary: Color(0xFF1A1A1A),
      surface: Color(0xFF1E1E1E),
      error: Color(0xFFEF5350),
      success: Color(0xFF66BB6A),
      warning: Color(0xFFFFB74D),
      info: Color(0xFF29B6F6),
      border: Color(0xFF424242),
      divider: Color(0xFF616161),
      disabled: Color(0xFF424242),
      disabledText: Color(0xFF757575),
      textPrimary: Colors.white,
      textSecondary: Color(0xFFBDBDBD),
      textTertiary: Color(0xFF757575),
      hover: Color(0x0AFFFFFF),
      pressed: Color(0x14FFFFFF),
      focus: Color(0x1F42A5F5),
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
