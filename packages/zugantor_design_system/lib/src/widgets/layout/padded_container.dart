import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// Padding size for padded containers.
enum PaddingSize { none, small, medium, large, custom }

/// A container with consistent padding based on the design system.
///
/// This widget provides a convenient way to apply standard padding
/// to content without manually specifying EdgeInsets values.
class PaddedContainer extends StatelessWidget {
  /// Creates a padded container.
  const PaddedContainer({
    super.key,
    required this.child,
    this.padding = PaddingSize.medium,
    this.customPadding,
    this.color,
  });

  /// Creates a padded container with no padding.
  const PaddedContainer.none({
    super.key,
    required this.child,
    this.color,
  })  : padding = PaddingSize.none,
        customPadding = null;

  /// Creates a padded container with small padding (12px).
  const PaddedContainer.small({
    super.key,
    required this.child,
    this.color,
  })  : padding = PaddingSize.small,
        customPadding = null;

  /// Creates a padded container with medium padding (16px).
  const PaddedContainer.medium({
    super.key,
    required this.child,
    this.color,
  })  : padding = PaddingSize.medium,
        customPadding = null;

  /// Creates a padded container with large padding (24px).
  const PaddedContainer.large({
    super.key,
    required this.child,
    this.color,
  })  : padding = PaddingSize.large,
        customPadding = null;

  /// The child widget to wrap with padding.
  final Widget child;

  /// The padding size to apply.
  final PaddingSize padding;

  /// Custom padding value. Only used when padding is PaddingSize.custom.
  final EdgeInsetsGeometry? customPadding;

  /// Optional background color for the container.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    EdgeInsetsGeometry effectivePadding;
    switch (padding) {
      case PaddingSize.none:
        effectivePadding = EdgeInsets.zero;
        break;
      case PaddingSize.small:
        effectivePadding = EdgeInsets.all(theme.spacing.s);
        break;
      case PaddingSize.medium:
        effectivePadding = EdgeInsets.all(theme.spacing.m);
        break;
      case PaddingSize.large:
        effectivePadding = EdgeInsets.all(theme.spacing.l);
        break;
      case PaddingSize.custom:
        effectivePadding = customPadding ?? EdgeInsets.all(theme.spacing.m);
        break;
    }

    return Container(
      padding: effectivePadding,
      color: color,
      child: child,
    );
  }
}
