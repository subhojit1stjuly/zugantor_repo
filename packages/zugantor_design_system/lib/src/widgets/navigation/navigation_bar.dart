import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// A navigation destination entry for [ZDSNavigationBar].
///
/// ```dart
/// const ZDSNavigationItem(
///   icon: Icons.home_outlined,
///   selectedIcon: Icons.home,
///   label: 'Home',
/// )
/// ```
class ZDSNavigationItem {
  /// Creates a navigation item.
  const ZDSNavigationItem({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });

  /// Icon shown when the item is not selected.
  final IconData icon;

  /// Icon shown when the item is selected. Falls back to [icon] when null.
  final IconData? selectedIcon;

  /// Accessible label and text shown below the icon.
  final String label;
}

/// A theme-aware bottom navigation bar for the ZDS design system.
///
/// Wraps Material 3's [NavigationBar] with ZDS colors and token-driven styling.
///
/// ```dart
/// ZDSNavigationBar(
///   currentIndex: _index,
///   onDestinationSelected: (i) => setState(() => _index = i),
///   items: const [
///     ZDSNavigationItem(icon: Icons.home_outlined, label: 'Home'),
///     ZDSNavigationItem(icon: Icons.search, label: 'Search'),
///     ZDSNavigationItem(icon: Icons.person_outlined, label: 'Profile'),
///   ],
/// )
/// ```
class ZDSNavigationBar extends StatelessWidget {
  /// Creates a ZDS-styled bottom navigation bar.
  const ZDSNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.items,
  }) : assert(items.length >= 2, 'NavigationBar requires at least 2 items');

  /// The index of the currently selected destination.
  final int currentIndex;

  /// Called when the user taps a destination.
  final ValueChanged<int> onDestinationSelected;

  /// The list of destinations to display.
  final List<ZDSNavigationItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      backgroundColor: theme.colors.surface,
      indicatorColor: theme.colors.primary?.withValues(alpha: 0.15),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final style = theme.typography.labelSmall;
        if (states.contains(WidgetState.selected)) {
          return style?.copyWith(
            color: theme.colors.primary,
            fontWeight: FontWeight.w600,
          );
        }
        return style?.copyWith(color: theme.colors.textSecondary);
      }),
      destinations: items
          .map(
            (item) => NavigationDestination(
              icon: Icon(
                item.icon,
                color: theme.colors.textSecondary,
                size: 24,
              ),
              selectedIcon: Icon(
                item.selectedIcon ?? item.icon,
                color: theme.colors.primary,
                size: 24,
              ),
              label: item.label,
            ),
          )
          .toList(),
    );
  }
}
