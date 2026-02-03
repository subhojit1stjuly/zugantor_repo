import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// A theme-aware date picker component for the ZDS design system.
///
/// This component provides a text field with a date picker dialog.
class AppDatePicker extends StatelessWidget {
  /// Creates a date picker.
  const AppDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.label,
    this.hint = 'Select a date',
    this.firstDate,
    this.lastDate,
    this.enabled = true,
  });

  /// The currently selected date.
  final DateTime? selectedDate;

  /// Callback when a date is selected.
  final ValueChanged<DateTime?> onDateSelected;

  /// Optional label for the date picker.
  final String? label;

  /// Hint text when no date is selected.
  final String hint;

  /// The earliest selectable date. Defaults to 100 years ago.
  final DateTime? firstDate;

  /// The latest selectable date. Defaults to 100 years from now.
  final DateTime? lastDate;

  /// Whether the date picker is enabled.
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
        InkWell(
          onTap: enabled ? () => _showDatePicker(context) : null,
          borderRadius: BorderRadius.circular(8),
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: hint,
              suffixIcon: Icon(
                Icons.calendar_today,
                color: enabled ? theme.colors.primary : theme.colors.disabled,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    BorderSide(color: theme.colors.border ?? Colors.grey),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    BorderSide(color: theme.colors.border ?? Colors.grey),
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
                  enabled ? null : theme.colors.disabled?.withOpacity(0.1),
              contentPadding: EdgeInsets.symmetric(
                horizontal: theme.spacing.m,
                vertical: theme.spacing.m,
              ),
            ),
            child: Text(
              selectedDate != null ? _formatDate(selectedDate!) : hint,
              style: theme.typography.bodyMedium?.copyWith(
                color: selectedDate != null
                    ? (enabled ? theme.colors.onSurface : theme.colors.disabled)
                    : theme.colors.disabled,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final now = DateTime.now();
    final theme = ZDSTheme.of(context);

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: firstDate ?? DateTime(now.year - 100),
      lastDate: lastDate ?? DateTime(now.year + 100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: theme.colors.primary ?? Colors.blue,
              onPrimary: theme.colors.onPrimary ?? Colors.white,
              surface: theme.colors.surface ?? Colors.white,
              onSurface: theme.colors.onSurface ?? Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
