import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// Semantic variants for [ZDSChip].
enum ZDSChipVariant {
  /// Default neutral chip.
  neutral,

  /// Primary brand-colored chip.
  primary,

  /// Positive / success state.
  success,

  /// Cautionary / warning state.
  warning,

  /// Error / danger state.
  error,

  /// Informational state.
  info,
}

/// A theme-aware chip/tag widget for the ZDS design system.
///
/// Use chips for labels, statuses, categories, and filter options.
///
/// ```dart
/// const ZDSChip(label: 'In Stock', variant: ZDSChipVariant.success)
/// ZDSChip(label: 'Category', onTap: _handleTap, onDelete: _handleDelete)
/// ```
class ZDSChip extends StatelessWidget {
  /// Creates a ZDS-styled chip.
  const ZDSChip({
    super.key,
    required this.label,
    this.variant = ZDSChipVariant.neutral,
    this.leadingIcon,
    this.onTap,
    this.onDelete,
    this.isSelected = false,
  });

  /// The label text.
  final String label;

  /// The semantic color variant.
  final ZDSChipVariant variant;

  /// Optional icon on the left side of the label.
  final IconData? leadingIcon;

  /// Called when the chip is tapped. Makes the chip interactive.
  final VoidCallback? onTap;

  /// Called when the delete icon is pressed. Shows an × icon when set.
  final VoidCallback? onDelete;

  /// Whether the chip appears selected (e.g. in a filter group).
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    final (bg, fg) = _resolveColors(theme);
    final effectiveBg =
        isSelected ? fg?.withValues(alpha: 0.9) : bg?.withValues(alpha: 0.15);
    final effectiveFg = isSelected ? bg : fg;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: theme.animations.fast,
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.s,
          vertical: theme.spacing.xxs + 2,
        ),
        decoration: BoxDecoration(
          color: effectiveBg,
          borderRadius: theme.shapes.pillRadius,
          border: Border.all(
            color: fg?.withValues(alpha: 0.3) ?? Colors.transparent,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, size: 14, color: effectiveFg),
              SizedBox(width: theme.spacing.xxs),
            ],
            Text(
              label,
              style: theme.typography.labelSmall
                  ?.copyWith(color: effectiveFg, fontWeight: FontWeight.w600),
            ),
            if (onDelete != null) ...[
              SizedBox(width: theme.spacing.xxs),
              GestureDetector(
                onTap: onDelete,
                child: Icon(Icons.close, size: 14, color: effectiveFg),
              ),
            ],
          ],
        ),
      ),
    );
  }

  (Color?, Color?) _resolveColors(ZDSTheme theme) => switch (variant) {
        ZDSChipVariant.neutral => (
            theme.colors.textSecondary,
            theme.colors.textSecondary,
          ),
        ZDSChipVariant.primary => (
            theme.colors.primary,
            theme.colors.primary,
          ),
        ZDSChipVariant.success => (
            theme.colors.success,
            theme.colors.success,
          ),
        ZDSChipVariant.warning => (
            theme.colors.warning,
            theme.colors.warning,
          ),
        ZDSChipVariant.error => (
            theme.colors.error,
            theme.colors.error,
          ),
        ZDSChipVariant.info => (theme.colors.info, theme.colors.info),
      };
}
