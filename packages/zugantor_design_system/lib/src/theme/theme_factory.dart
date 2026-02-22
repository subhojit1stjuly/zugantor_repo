import 'package:flutter/material.dart';
import 'colors.dart';
import 'custom_theme.dart';
import 'shape.dart';
import 'spacing.dart';
import 'typography.dart';

/// A factory for creating `ThemeData` objects that are configured with the
/// ZDS design system's custom theme extension.
class ZDSThemeFactory {
  /// Creates a light `ThemeData` object with the default ZDS light theme.
  ///
  /// An app can use this as a starting point and override specific properties
  /// or provide its own `ZDSTheme` for complete customization.
  static ThemeData light() {
    final zdsColors = ZDSColors.light();
    final zdsTypography =
        ZDSTypography.fromTextTheme(ZDSTypography.defaultTextTheme);
    const zdsSpacing = ZDSSpacing();
    const zdsShapes = ZDSShapes();

    return ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: zdsColors.primary!,
        brightness: Brightness.light,
      ),
      textTheme: ZDSTypography.defaultTextTheme,
      extensions: [
        ZDSTheme(
          colors: zdsColors,
          typography: zdsTypography,
          spacing: zdsSpacing,
          shapes: zdsShapes,
        ),
      ],
    );
  }

  /// Creates a dark `ThemeData` object with the default ZDS dark theme.
  ///
  /// An app can use this as a starting point and override specific properties
  /// or provide its own `ZDSTheme` for complete customization.
  static ThemeData dark() {
    final zdsColors = ZDSColors.dark();
    final zdsTypography =
        ZDSTypography.fromTextTheme(ZDSTypography.defaultTextTheme);
    const zdsSpacing = ZDSSpacing();
    const zdsShapes = ZDSShapes();

    return ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: zdsColors.primary!,
        brightness: Brightness.dark,
      ),
      textTheme: ZDSTypography.defaultTextTheme,
      extensions: [
        ZDSTheme(
          colors: zdsColors,
          typography: zdsTypography,
          spacing: zdsSpacing,
          shapes: zdsShapes,
        ),
      ],
    );
  }
}
