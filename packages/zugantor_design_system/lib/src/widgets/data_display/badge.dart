import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// A notification badge that overlays a count or dot on a child widget.
///
/// Commonly used on navigation icons, cart buttons, and notification bells.
///
/// ```dart
/// // Dot badge (no count)
/// ZDSBadge(child: Icon(Icons.notifications))
///
/// // Count badge
/// ZDSBadge(count: 12, child: Icon(Icons.shopping_cart))
///
/// // Suppress at zero
/// ZDSBadge(count: cartItems, showWhenZero: false, child: Icon(Icons.cart))
/// ```
class ZDSBadge extends StatelessWidget {
  /// Creates a dot badge with no count.
  const ZDSBadge({
    super.key,
    required this.child,
  })  : count = null,
        showWhenZero = false;

  /// Creates a count badge.
  const ZDSBadge.count({
    super.key,
    required this.child,
    required int this.count,
    this.showWhenZero = false,
  });

  /// The widget that the badge is anchored to.
  final Widget child;

  /// The count to display. When null, a dot is shown. When 0 and
  /// [showWhenZero] is false, the badge is hidden.
  final int? count;

  /// Whether to display the badge when [count] is 0.
  final bool showWhenZero;

  bool get _isVisible => count == null || count! > 0 || showWhenZero;

  String get _label {
    if (count == null) return '';
    return count! > 99 ? '99+' : '$count';
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return child;

    final theme = ZDSTheme.of(context);
    final badgeColor = theme.colors.error ?? Colors.red;
    final textColor = theme.colors.onError ?? Colors.white;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          top: -4,
          right: -4,
          child: count == null
              ? _DotBadge(color: badgeColor)
              : _CountBadge(
                  label: _label,
                  color: badgeColor,
                  textColor: textColor,
                  textStyle: theme.typography.labelSmall,
                ),
        ),
      ],
    );
  }
}

class _DotBadge extends StatelessWidget {
  const _DotBadge({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1.5),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  const _CountBadge({
    required this.label,
    required this.color,
    required this.textColor,
    required this.textStyle,
  });

  final String label;
  final Color color;
  final Color textColor;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Center(
        child: Text(
          label,
          style: textStyle?.copyWith(
            color: textColor,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            height: 1,
          ),
        ),
      ),
    );
  }
}
