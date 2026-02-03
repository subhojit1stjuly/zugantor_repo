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
          value: value,
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item.value,
                  child: Text(item.label),
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
            fillColor: enabled ? null : theme.colors.disabled?.withOpacity(0.1),
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
class AppDropdownItem<T> {
  /// Creates a dropdown item.
  const AppDropdownItem({
    required this.value,
    required this.label,
  });

  /// The value of this item.
  final T value;

  /// The label text for this item.
  final String label;
}
