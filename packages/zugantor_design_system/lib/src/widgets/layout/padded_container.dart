import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// Padding size for padded containers.
enum ZDSPaddingSize { none, small, medium, large, custom }

/// A container with consistent padding based on the design system.
///
/// This widget provides a convenient way to apply standard padding
/// to content without manually specifying EdgeInsets values.
class ZDSPaddedContainer extends StatelessWidget {
  /// Creates a padded container.
  const ZDSPaddedContainer({
    super.key,
    required this.child,
    this.padding = ZDSPaddingSize.medium,
    this.customPadding,
    this.color,
  });

  /// Creates a padded container with no padding.
  const ZDSPaddedContainer.none({
    super.key,
    required this.child,
    this.color,
  })  : padding = ZDSPaddingSize.none,
        customPadding = null;

  /// Creates a padded container with small padding (12px).
  const ZDSPaddedContainer.small({
    super.key,
    required this.child,
    this.color,
  })  : padding = ZDSPaddingSize.small,
        customPadding = null;

  /// Creates a padded container with medium padding (16px).
  const ZDSPaddedContainer.medium({
    super.key,
    required this.child,
    this.color,
  })  : padding = ZDSPaddingSize.medium,
        customPadding = null;

  /// Creates a padded container with large padding (24px).
  const ZDSPaddedContainer.large({
    super.key,
    required this.child,
    this.color,
  })  : padding = ZDSPaddingSize.large,
        customPadding = null;

  /// The child widget to wrap with padding.
  final Widget child;

  /// The padding size to apply.
  final ZDSPaddingSize padding;

  /// Custom padding value. Only used when padding is ZDSPaddingSize.custom.
  final EdgeInsetsGeometry? customPadding;

  /// Optional background color for the container.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    EdgeInsetsGeometry effectivePadding;
    switch (padding) {
      case ZDSPaddingSize.none:
        effectivePadding = EdgeInsets.zero;
        break;
      case ZDSPaddingSize.small:
        effectivePadding = EdgeInsets.all(theme.spacing.s);
        break;
      case ZDSPaddingSize.medium:
        effectivePadding = EdgeInsets.all(theme.spacing.m);
        break;
      case ZDSPaddingSize.large:
        effectivePadding = EdgeInsets.all(theme.spacing.l);
        break;
      case ZDSPaddingSize.custom:
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
