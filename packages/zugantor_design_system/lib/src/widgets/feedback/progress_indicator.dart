import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// Variants for [ZDSProgressIndicator].
enum ZDSProgressVariant {
  /// A circular spinner.
  circular,

  /// A horizontal bar.
  linear,
}

/// A theme-aware progress indicator for the ZDS design system.
///
/// Supports both circular and linear variants and automatically uses
/// the primary brand color from the ZDS theme.
///
/// ```dart
/// // Indeterminate circular
/// const ZDSProgressIndicator()
///
/// // Determinate linear at 60%
/// ZDSProgressIndicator.linear(value: 0.6)
/// ```
class ZDSProgressIndicator extends StatelessWidget {
  /// Creates a circular progress indicator.
  const ZDSProgressIndicator({
    super.key,
    this.value,
    this.size = 36,
    this.strokeWidth = 3,
  }) : variant = ZDSProgressVariant.circular;

  /// Creates a linear progress indicator.
  const ZDSProgressIndicator.linear({
    super.key,
    this.value,
    this.strokeWidth = 4,
  })  : variant = ZDSProgressVariant.linear,
        size = null;

  /// The variant to display.
  final ZDSProgressVariant variant;

  /// The progress value between 0.0 and 1.0.
  /// When null, the indicator runs continuously (indeterminate).
  final double? value;

  /// Diameter of the circular indicator in logical pixels.
  final double? size;

  /// Stroke width for circular; bar height for linear.
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);
    final color = theme.colors.primary;

    return switch (variant) {
      ZDSProgressVariant.circular => SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            value: value,
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color?>(color),
          ),
        ),
      ZDSProgressVariant.linear => LinearProgressIndicator(
          value: value,
          minHeight: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color?>(color),
          backgroundColor: color?.withValues(alpha: 0.2),
        ),
    };
  }
}
