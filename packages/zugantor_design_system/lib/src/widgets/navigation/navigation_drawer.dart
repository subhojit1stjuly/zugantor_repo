import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// A navigation entry for [ZDSNavigationDrawer].
class ZDSDrawerItem {
  /// Creates a drawer navigation item.
  const ZDSDrawerItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.isSelected = false,
  });

  /// The icon representing this destination.
  final IconData icon;

  /// The display label.
  final String label;

  /// Callback fired when the item is tapped.
  final VoidCallback? onTap;

  /// Whether this item represents the currently active route.
  final bool isSelected;
}

/// A theme-aware navigation drawer for the ZDS design system.
///
/// Ideal for desktop and tablet layouts, or as a side-menu on mobile.
///
/// ```dart
/// Scaffold(
///   drawer: ZDSNavigationDrawer(
///     header: DrawerHeader(child: Text('My App')),
///     items: [
///       ZDSDrawerItem(icon: Icons.home, label: 'Home', isSelected: true),
///       ZDSDrawerItem(icon: Icons.settings, label: 'Settings'),
///     ],
///   ),
/// )
/// ```
class ZDSNavigationDrawer extends StatelessWidget {
  /// Creates a ZDS-styled navigation drawer.
  const ZDSNavigationDrawer({
    super.key,
    required this.items,
    this.header,
    this.footer,
  });

  /// Optional header widget at the top of the drawer.
  final Widget? header;

  /// The list of navigation items.
  final List<ZDSDrawerItem> items;

  /// Optional footer widget at the bottom of the drawer.
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    return Drawer(
      backgroundColor: theme.colors.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (header != null) header!,
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(
                  vertical: theme.spacing.s,
                  horizontal: theme.spacing.xs,
                ),
                children: items.map((item) => _DrawerTile(item: item)).toList(),
              ),
            ),
            if (footer != null) ...[
              const Divider(),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({required this.item});

  final ZDSDrawerItem item;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);
    final selectedBg = theme.colors.primary?.withValues(alpha: 0.12);
    final selectedFg = theme.colors.primary;
    final defaultFg = theme.colors.textSecondary;

    return AnimatedContainer(
      duration: theme.animations.fast,
      margin: EdgeInsets.symmetric(vertical: theme.spacing.xxs),
      decoration: BoxDecoration(
        color: item.isSelected ? selectedBg : Colors.transparent,
        borderRadius: theme.shapes.mediumRadius,
      ),
      child: ListTile(
        leading: Icon(
          item.icon,
          color: item.isSelected ? selectedFg : defaultFg,
          size: 22,
        ),
        title: Text(
          item.label,
          style: theme.typography.bodyMedium?.copyWith(
            color: item.isSelected ? selectedFg : theme.colors.textPrimary,
            fontWeight: item.isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        onTap: item.onTap,
        shape: RoundedRectangleBorder(
          borderRadius: theme.shapes.mediumRadius,
        ),
      ),
    );
  }
}
