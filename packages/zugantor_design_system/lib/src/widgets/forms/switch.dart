import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// A theme-aware switch component for the ZDS design system.
///
/// This switch provides consistent styling and behavior across the application.
class AppSwitch extends StatelessWidget {
  /// Creates a switch.
  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.label,
    this.enabled = true,
  });

  /// The current value of the switch.
  final bool value;

  /// Callback when the switch value changes.
  final ValueChanged<bool>? onChanged;

  /// Optional label text displayed next to the switch.
  final String? label;

  /// Whether the switch is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    final switchWidget = Switch(
      value: value,
      onChanged: enabled ? onChanged : null,
      activeThumbColor: theme.colors.primary,
      activeTrackColor: theme.colors.primary?.withValues(alpha: 0.5),
      inactiveThumbColor: theme.colors.disabled,
      inactiveTrackColor: theme.colors.disabled?.withValues(alpha: 0.3),
    );

    if (label == null) {
      return switchWidget;
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
            Flexible(
              child: Text(
                label!,
                style: theme.typography.bodyMedium?.copyWith(
                  color:
                      enabled ? theme.colors.onSurface : theme.colors.disabled,
                ),
              ),
            ),
            SizedBox(width: theme.spacing.m),
            switchWidget,
          ],
        ),
      ),
    );
  }
}
