import 'package:flutter/material.dart';
import 'animations.dart';
import 'colors.dart';
import 'shape.dart';
import 'spacing.dart';
import 'typography.dart';

/// The custom theme for the ZDS design system.
///
/// This class holds all the design tokens for the application, including
/// colors, typography, spacing, shapes, and animations. It is intended to be
/// used with `ThemeData.extensions` to make it available throughout the
/// widget tree.
@immutable
class ZDSTheme extends ThemeExtension<ZDSTheme> {
  const ZDSTheme({
    required this.colors,
    required this.typography,
    required this.spacing,
    required this.shapes,
    this.animations = const ZDSAnimations(),
  });

  final ZDSColors colors;
  final ZDSTypography typography;
  final ZDSSpacing spacing;
  final ZDSShapes shapes;

  /// Motion tokens: durations and curves for all animated widgets.
  final ZDSAnimations animations;

  @override
  ThemeExtension<ZDSTheme> copyWith({
    ZDSColors? colors,
    ZDSTypography? typography,
    ZDSSpacing? spacing,
    ZDSShapes? shapes,
    ZDSAnimations? animations,
  }) {
    return ZDSTheme(
      colors: colors ?? this.colors,
      typography: typography ?? this.typography,
      spacing: spacing ?? this.spacing,
      shapes: shapes ?? this.shapes,
      animations: animations ?? this.animations,
    );
  }

  @override
  ThemeExtension<ZDSTheme> lerp(
    ThemeExtension<ZDSTheme>? other,
    double t,
  ) {
    return t < 0.5 ? this : other ?? this;
  }

  /// Helper to get the [ZDSTheme] from the build context.
  static ZDSTheme of(BuildContext context) {
    final theme = Theme.of(context).extension<ZDSTheme>();
    if (theme == null) {
      throw StateError(
        'No ZDSTheme found in the context. '
        'Make sure to add it to your ThemeData extensions.',
      );
    }
    return theme;
  }
}
