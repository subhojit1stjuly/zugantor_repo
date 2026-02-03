import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// A theme-aware radio button component for the ZDS design system.
///
/// This radio button provides consistent styling and behavior across the application.
class AppRadio<T> extends StatelessWidget {
  /// Creates a radio button.
  const AppRadio({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    this.label,
    this.enabled = true,
  });

  /// The value represented by this radio button.
  final T value;

  /// The currently selected value for the group.
  final T? groupValue;

  /// Callback when the radio button is selected.
  final ValueChanged<T?>? onChanged;

  /// Optional label text displayed next to the radio button.
  final String? label;

  /// Whether the radio button is enabled.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    final radio = Radio<T>(
      value: value,
      groupValue: groupValue,
      onChanged: enabled ? onChanged : null,
      activeColor: theme.colors.primary,
    );

    if (label == null) {
      return radio;
    }

    return InkWell(
      onTap: enabled ? () => onChanged?.call(value) : null,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: theme.spacing.xs,
          horizontal: theme.spacing.xxs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            radio,
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

/// A group of radio buttons with a common label.
class AppRadioGroup<T> extends StatelessWidget {
  /// Creates a radio button group.
  const AppRadioGroup({
    super.key,
    required this.value,
    required this.onChanged,
    required this.items,
    this.label,
    this.enabled = true,
    this.direction = Axis.vertical,
  });

  /// The currently selected value.
  final T? value;

  /// Callback when the selection changes.
  final ValueChanged<T?>? onChanged;

  /// The radio button items.
  final List<AppRadioItem<T>> items;

  /// Optional label for the group.
  final String? label;

  /// Whether the group is enabled.
  final bool enabled;

  /// The direction to layout the radio buttons (vertical or horizontal).
  final Axis direction;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    final radios = items
        .map(
          (item) => AppRadio<T>(
            value: item.value,
            groupValue: value,
            onChanged: onChanged,
            label: item.label,
            enabled: enabled && item.enabled,
          ),
        )
        .toList();

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
        if (direction == Axis.vertical)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: radios,
          )
        else
          Wrap(
            spacing: theme.spacing.m,
            children: radios,
          ),
      ],
    );
  }
}

/// A single item in a radio button group.
class AppRadioItem<T> {
  /// Creates a radio button item.
  const AppRadioItem({
    required this.value,
    required this.label,
    this.enabled = true,
  });

  /// The value of this item.
  final T value;

  /// The label text for this item.
  final String label;

  /// Whether this item is enabled.
  final bool enabled;
}
