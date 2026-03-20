import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// The visual style variant for a [Badge].
///
/// Maps to standard component.gallery badge/tag patterns.
enum BadgeVariant {
  /// Solid filled background (default).
  filled,

  /// Outlined with no fill.
  outlined,

  /// Subtle tinted background.
  soft,
}

/// A theme-aware badge component for the ZDS design system.
///
/// Badges display a small count or status label, following the
/// **Badge** component pattern documented at
/// [component.gallery](https://component.gallery/components/badge/).
///
/// Badges are commonly used to indicate counts (notifications, cart items)
/// or status (active, pending, archived).
///
/// Example:
/// ```dart
/// Badge(
///   label: '5',
///   color: BadgeColor.primary,
/// )
///
/// // Wrap a widget to overlay a count badge:
/// Badge.overlay(
///   count: 3,
///   child: Icon(Icons.notifications),
/// )
/// ```
class ZDSBadge extends StatelessWidget {
  /// Creates a badge with a text label.
  const ZDSBadge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.filled,
    this.color,
    this.textColor,
  });

  /// Creates a badge that overlays [child] with a numeric count in the
  /// top-right corner.
  ///
  /// If [count] is 0 or null, no badge is shown.
  static Widget overlay({
    Key? key,
    required Widget child,
    required int? count,
    int maxCount = 99,
  }) {
    if (count == null || count <= 0) return child;

    final label = count > maxCount ? '$maxCount+' : '$count';
    return Stack(
      key: key,
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -6,
          right: -6,
          child: ZDSBadge(label: label),
        ),
      ],
    );
  }

  /// The text to display inside the badge.
  final String label;

  /// The visual variant.
  final BadgeVariant variant;

  /// Background color override. Defaults to the primary theme color.
  final Color? color;

  /// Text/icon color override.
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);
    final resolvedColor = color ?? theme.colors.primary ?? Colors.blue;
    final resolvedTextColor = textColor ??
        (variant == BadgeVariant.outlined ? resolvedColor : Colors.white);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: _backgroundColor(resolvedColor),
        borderRadius: BorderRadius.circular(100),
        border: variant == BadgeVariant.outlined
            ? Border.all(color: resolvedColor)
            : null,
      ),
      child: Text(
        label,
        style: (theme.typography.labelSmall ??
                const TextStyle(fontSize: 10, fontWeight: FontWeight.w600))
            .copyWith(color: resolvedTextColor, height: 1.4),
      ),
    );
  }

  Color _backgroundColor(Color base) {
    switch (variant) {
      case BadgeVariant.filled:
        return base;
      case BadgeVariant.outlined:
        return Colors.transparent;
      case BadgeVariant.soft:
        return base.withOpacity(0.15);
    }
  }
}
