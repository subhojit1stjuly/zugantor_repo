import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// Elevation variants for cards.
enum CardElevation { low, medium, high }

/// A theme-aware card component for the ZDS design system.
///
/// This card provides consistent elevation, padding, and styling
/// for grouping related content.
class AppCard extends StatelessWidget {
  /// Creates a card.
  const AppCard({
    super.key,
    required this.child,
    this.elevation = CardElevation.low,
    this.padding,
    this.margin,
    this.onTap,
  });

  /// The widget to display inside the card.
  final Widget child;

  /// The elevation level of the card.
  final CardElevation elevation;

  /// Optional padding inside the card.
  final EdgeInsetsGeometry? padding;

  /// Optional margin outside the card.
  final EdgeInsetsGeometry? margin;

  /// Optional tap callback to make the card interactive.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    double shadowElevation;
    switch (elevation) {
      case CardElevation.low:
        shadowElevation = 2;
        break;
      case CardElevation.medium:
        shadowElevation = 4;
        break;
      case CardElevation.high:
        shadowElevation = 8;
        break;
    }

    final cardChild = Container(
      padding: padding ?? EdgeInsets.all(theme.spacing.m),
      decoration: BoxDecoration(
        color: theme.colors.surface,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: shadowElevation * 2,
            offset: Offset(0, shadowElevation),
          ),
        ],
        border: Border.all(
          color:
              theme.colors.border?.withValues(alpha: 0.2) ?? Colors.transparent,
        ),
      ),
      child: child,
    );

    if (onTap != null) {
      return Container(
        margin: margin,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            child: cardChild,
          ),
        ),
      );
    }

    return Container(
      margin: margin,
      child: cardChild,
    );
  }
}
