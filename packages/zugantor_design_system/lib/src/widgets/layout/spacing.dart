import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// A widget that adds vertical spacing based on the design system's spacing scale.
///
/// This is more semantic than using `SizedBox(height: ...)` directly and
/// ensures consistent spacing throughout the application.
class ZDSVerticalSpacing extends StatelessWidget {
  /// Creates a vertical spacing widget.
  const ZDSVerticalSpacing(this.size, {super.key});

  /// Creates an extra extra small vertical spacing (4px).
  const ZDSVerticalSpacing.xxs({super.key}) : size = _SpacingSize.xxs;

  /// Creates an extra small vertical spacing (8px).
  const ZDSVerticalSpacing.xs({super.key}) : size = _SpacingSize.xs;

  /// Creates a small vertical spacing (12px).
  const ZDSVerticalSpacing.s({super.key}) : size = _SpacingSize.s;

  /// Creates a medium vertical spacing (16px).
  const ZDSVerticalSpacing.m({super.key}) : size = _SpacingSize.m;

  /// Creates a large vertical spacing (24px).
  const ZDSVerticalSpacing.l({super.key}) : size = _SpacingSize.l;

  /// Creates an extra large vertical spacing (32px).
  const ZDSVerticalSpacing.xl({super.key}) : size = _SpacingSize.xl;

  /// Creates an extra extra large vertical spacing (48px).
  const ZDSVerticalSpacing.xxl({super.key}) : size = _SpacingSize.xxl;

  /// The size of the spacing.
  final _SpacingSize size;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);
    final height = _getSpacingValue(theme, size);
    return SizedBox(height: height);
  }
}

/// A widget that adds horizontal spacing based on the design system's spacing scale.
///
/// This is more semantic than using `SizedBox(width: ...)` directly and
/// ensures consistent spacing throughout the application.
class ZDSHorizontalSpacing extends StatelessWidget {
  /// Creates a horizontal spacing widget.
  const ZDSHorizontalSpacing(this.size, {super.key});

  /// Creates an extra extra small horizontal spacing (4px).
  const ZDSHorizontalSpacing.xxs({super.key}) : size = _SpacingSize.xxs;

  /// Creates an extra small horizontal spacing (8px).
  const ZDSHorizontalSpacing.xs({super.key}) : size = _SpacingSize.xs;

  /// Creates a small horizontal spacing (12px).
  const ZDSHorizontalSpacing.s({super.key}) : size = _SpacingSize.s;

  /// Creates a medium horizontal spacing (16px).
  const ZDSHorizontalSpacing.m({super.key}) : size = _SpacingSize.m;

  /// Creates a large horizontal spacing (24px).
  const ZDSHorizontalSpacing.l({super.key}) : size = _SpacingSize.l;

  /// Creates an extra large horizontal spacing (32px).
  const ZDSHorizontalSpacing.xl({super.key}) : size = _SpacingSize.xl;

  /// Creates an extra extra large horizontal spacing (48px).
  const ZDSHorizontalSpacing.xxl({super.key}) : size = _SpacingSize.xxl;

  /// The size of the spacing.
  final _SpacingSize size;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);
    final width = _getSpacingValue(theme, size);
    return SizedBox(width: width);
  }
}

/// Internal enum for spacing sizes.
enum _SpacingSize { xxs, xs, s, m, l, xl, xxl }

/// Helper function to get the spacing value from the theme.
double _getSpacingValue(ZDSTheme theme, _SpacingSize size) {
  switch (size) {
    case _SpacingSize.xxs:
      return theme.spacing.xxs;
    case _SpacingSize.xs:
      return theme.spacing.xs;
    case _SpacingSize.s:
      return theme.spacing.s;
    case _SpacingSize.m:
      return theme.spacing.m;
    case _SpacingSize.l:
      return theme.spacing.l;
    case _SpacingSize.xl:
      return theme.spacing.xl;
    case _SpacingSize.xxl:
      return theme.spacing.xxl;
  }
}
