import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// A theme-aware checkbox component for the ZDS design system.
///
/// This checkbox provides consistent styling and behavior across the application.
class AppCheckbox extends StatelessWidget {
  /// Creates a checkbox.
  const AppCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.enabled = true,
  });

  /// The current value of the checkbox.
  final bool value;

  /// Callback when the checkbox value changes.
  final ValueChanged<bool?>? onChanged;

  /// Optional label text displayed next to the checkbox.
  final String? label;

  /// Whether the checkbox is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    final checkbox = Checkbox(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeColor: theme.colors.primary,
      checkColor: theme.colors.onPrimary,
      side: BorderSide(
        color: enabled
            ? theme.colors.border ?? Colors.grey
            : theme.colors.disabled ?? Colors.grey,
      ),
    );

    if (label == null) {
      return checkbox;
    }

    return InkWell(
      onTap: enabled ? () => onChanged?.call(!value) : null,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: theme.spacing.xs,
          horizontal: theme.spacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            checkbox,
            SizedBox(width: theme.spacing.xs),
            Flexible(
              child: Text(
                label!,
                style: theme.typography.bodyMedium?.copyWith(
                  color:
                      enabled ? theme.colors.onSurface : theme.colors.disabled,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
