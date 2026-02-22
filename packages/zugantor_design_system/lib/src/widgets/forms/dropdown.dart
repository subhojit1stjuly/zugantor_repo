import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// A theme-aware dropdown component for the ZDS design system.
///
/// This dropdown provides consistent styling and behavior across the application.
class AppDropdown<T> extends StatelessWidget {
  /// Creates a dropdown.
  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.label,
    this.hint,
    this.enabled = true,
  });

  /// The currently selected value.
  final T? value;

  /// The list of items to display in the dropdown.
  final List<AppDropdownItem<T>> items;

  /// Callback when the selection changes.
  final ValueChanged<T?>? onChanged;

  /// Optional label for the dropdown.
  final String? label;

  /// Optional hint text when no value is selected.
  final String? hint;

  /// Whether the dropdown is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: theme.typography.titleMedium,
          ),
          SizedBox(height: theme.spacing.s),
        ],
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item.value,
                  child: item.buildChild(context),
                ),
              )
              .toList(),
          onChanged: enabled ? onChanged : null,
          hint: hint != null ? Text(hint!) : null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colors.border ?? Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: theme.colors.border ?? Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                  color: theme.colors.primary ?? Colors.blue, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
                  BorderSide(color: theme.colors.disabled ?? Colors.grey),
            ),
            filled: !enabled,
            fillColor:
                enabled ? null : theme.colors.disabled?.withValues(alpha: 0.1),
            contentPadding: EdgeInsets.symmetric(
              horizontal: theme.spacing.m,
              vertical: theme.spacing.m,
            ),
          ),
          style: theme.typography.bodyMedium,
          dropdownColor: theme.colors.surface,
        ),
      ],
    );
  }
}

/// A single item in a dropdown.
///
/// Supports three display modes:
/// 1. Text only: `AppDropdownItem(value: 1, label: 'Option 1')`
/// 2. Icon + Text: `AppDropdownItem(value: 2, label: 'Settings', icon: Icons.settings)`
/// 3. Custom widget: `AppDropdownItem(value: 3, child: YourCustomWidget())`
class AppDropdownItem<T> {
  /// Creates a dropdown item with text label (and optional icon).
  const AppDropdownItem({
    required this.value,
    this.label,
    this.icon,
    this.child,
  }) : assert(
          label != null || child != null,
          'Either label or child must be provided',
        );

  /// Creates a dropdown item with icon and text.
  const AppDropdownItem.withIcon({
    required this.value,
    required String this.label,
    required IconData this.icon,
  }) : child = null;

  /// Creates a dropdown item with a custom widget.
  const AppDropdownItem.custom({
    required this.value,
    required Widget this.child,
  })  : label = null,
        icon = null;

  /// The value of this item.
  final T value;

  /// The label text for this item.
  ///
  /// Required if [child] is not provided.
  final String? label;

  /// Optional icon to display before the label.
  ///
  /// Only used when [child] is null.
  final IconData? icon;

  /// Custom widget to display instead of the default text/icon layout.
  ///
  /// When provided, [label] and [icon] are ignored.
  final Widget? child;

  /// Builds the widget to display in the dropdown.
  Widget buildChild(BuildContext context) {
    // If custom child is provided, use it directly
    if (child != null) {
      return child!;
    }

    // If icon is provided, show icon + text
    if (icon != null) {
      final theme = ZDSTheme.of(context);
      return Row(
        children: [
          Icon(icon, size: 20),
          SizedBox(width: theme.spacing.s),
          Text(label!),
        ],
      );
    }

    // Default: just text
    return Text(label!);
  }
}
