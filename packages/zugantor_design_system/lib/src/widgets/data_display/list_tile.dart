import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// A theme-aware list tile for the ZDS design system.
///
/// Wraps Flutter's [ListTile] with consistent ZDS typography, colors, and
/// spacing. Suitable for menu items, contact lists, and settings screens.
///
/// ```dart
/// ZDSListTile(
///   title: 'Account Settings',
///   subtitle: 'Manage your profile and security',
///   leading: Icons.manage_accounts_outlined,
///   trailing: const Icon(Icons.chevron_right),
///   onTap: () {},
/// )
/// ```
class ZDSListTile extends StatelessWidget {
  /// Creates a ZDS-styled list tile.
  const ZDSListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.isSelected = false,
    this.enabled = true,
  });

  /// Primary text content.
  final String title;

  /// Optional secondary text below the title.
  final String? subtitle;

  /// Optional icon on the left side.
  final IconData? leading;

  /// Optional widget on the right side (e.g. a chevron or badge).
  final Widget? trailing;

  /// Called when the tile is tapped.
  final VoidCallback? onTap;

  /// Whether the tile appears in a selected/active state.
  final bool isSelected;

  /// Whether the tile is interactive.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    final titleColor = isSelected
        ? theme.colors.primary
        : (enabled ? theme.colors.textPrimary : theme.colors.disabledText);
    final iconColor = isSelected
        ? theme.colors.primary
        : (enabled ? theme.colors.textSecondary : theme.colors.disabledText);
    final selectedBg = theme.colors.primary?.withValues(alpha: 0.08);

    return Material(
      color: isSelected ? selectedBg : Colors.transparent,
      borderRadius: theme.shapes.smallRadius,
      child: ListTile(
        enabled: enabled,
        onTap: onTap,
        selected: isSelected,
        shape: RoundedRectangleBorder(
          borderRadius: theme.shapes.smallRadius,
        ),
        leading:
            leading != null ? Icon(leading, color: iconColor, size: 22) : null,
        title: Text(
          title,
          style: theme.typography.bodyMedium?.copyWith(
            color: titleColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: theme.typography.bodySmall
                    ?.copyWith(color: theme.colors.textSecondary),
              )
            : null,
        trailing: trailing,
      ),
    );
  }
}
