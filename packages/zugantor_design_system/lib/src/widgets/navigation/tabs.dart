import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// A single tab definition used by [ZDSTabs].
class ZDSTabItem {
  /// Creates a tab item.
  const ZDSTabItem({
    required this.label,
    required this.content,
    this.icon,
    this.enabled = true,
  });

  /// The label displayed in the tab header.
  final String label;

  /// The widget displayed when this tab is active.
  final Widget content;

  /// Optional leading icon in the tab header.
  final IconData? icon;

  /// Whether this tab can be selected.
  final bool enabled;
}

/// A theme-aware horizontal tabs component for the ZDS design system.
///
/// Tabs organise content into separate views and allow navigation between
/// them without leaving the current page. This follows the **Tabs** component
/// pattern documented at
/// [component.gallery](https://component.gallery/components/tabs/).
///
/// Example:
/// ```dart
/// ZDSTabs(
///   tabs: [
///     ZDSTabItem(label: 'Overview', content: OverviewView()),
///     ZDSTabItem(label: 'Details', content: DetailsView()),
///     ZDSTabItem(label: 'History', content: HistoryView()),
///   ],
/// )
/// ```
class ZDSTabs extends StatefulWidget {
  /// Creates a tabs widget.
  ZDSTabs({
    super.key,
    required this.tabs,
    this.initialIndex = 0,
    this.onTabChanged,
  }) : assert(tabs.isNotEmpty, 'ZDSTabs requires at least one tab.');

  /// The tab definitions.
  final List<ZDSTabItem> tabs;

  /// The index of the tab that is initially selected.
  final int initialIndex;

  /// Called when the active tab changes.
  final ValueChanged<int>? onTabChanged;

  @override
  State<ZDSTabs> createState() => _ZDSTabsState();
}

class _ZDSTabsState extends State<ZDSTabs> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _selectTab(int index) {
    if (!widget.tabs[index].enabled || index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    widget.onTabChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TabBar(
          tabs: widget.tabs,
          selectedIndex: _selectedIndex,
          onTabSelected: _selectTab,
          theme: theme,
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: theme.colors.border,
        ),
        widget.tabs[_selectedIndex].content,
      ],
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    required this.theme,
  });

  final List<ZDSTabItem> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final ZDSTheme theme;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          tabs.length,
          (i) => _TabButton(
            tab: tabs[i],
            isSelected: i == selectedIndex,
            onTap: () => onTabSelected(i),
            theme: theme,
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.tab,
    required this.isSelected,
    required this.onTap,
    required this.theme,
  });

  final ZDSTabItem tab;
  final bool isSelected;
  final VoidCallback onTap;
  final ZDSTheme theme;

  @override
  Widget build(BuildContext context) {
    final activeColor = theme.colors.primary ?? Colors.blue;
    final inactiveColor =
        theme.colors.onSurface?.withOpacity(0.6) ?? Colors.grey;
    final disabledColor = theme.colors.disabled ?? Colors.grey;

    final effectiveColor = !tab.enabled
        ? disabledColor
        : isSelected
            ? activeColor
            : inactiveColor;

    return InkWell(
      onTap: tab.enabled ? onTap : null,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.m,
          vertical: theme.spacing.s,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? activeColor : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (tab.icon != null) ...[
              Icon(tab.icon, size: 16, color: effectiveColor),
              SizedBox(width: theme.spacing.xs),
            ],
            Text(
              tab.label,
              style: (isSelected
                      ? theme.typography.labelLarge
                      : theme.typography.bodyMedium)
                  ?.copyWith(
                color: effectiveColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
