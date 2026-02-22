import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// A wrapper widget that provides a consistent label, helper text, error
/// text, and required-field indicator around any form control.
///
/// Use this to wrap custom controls that don't use Flutter's built-in
/// `InputDecoration` (e.g., date pickers, dropdowns, checkbox groups) so
/// they share the same visual structure as `AppTextInput`.
///
/// ```dart
/// ZDSFormField(
///   label: 'Date of Birth',
///   isRequired: true,
///   helperText: 'Select from calendar',
///   child: AppDatePicker(...),
/// )
/// ```
class ZDSFormField extends StatelessWidget {
  /// Creates a form field wrapper.
  const ZDSFormField({
    super.key,
    required this.child,
    this.label,
    this.helperText,
    this.errorText,
    this.isRequired = false,
    this.enabled = true,
  });

  /// The form control to wrap (input, picker, selector, etc.).
  final Widget child;

  /// Optional label displayed above the control.
  final String? label;

  /// Optional helper text shown below the control.
  final String? helperText;

  /// Optional error message. When non-null, shown in error color and
  /// replaces `helperText`.
  final String? errorText;

  /// Whether to show a required indicator (*) next to the label.
  final bool isRequired;

  /// Whether the form field is enabled. Dims the label when false.
  final bool enabled;

  bool get _hasError => errorText != null && errorText!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);
    final labelColor =
        enabled ? theme.colors.textSecondary : theme.colors.disabledText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          _FormFieldLabel(
            label: label!,
            isRequired: isRequired,
            color: labelColor,
            style: theme.typography.labelLarge,
          ),
          SizedBox(height: theme.spacing.xxs),
        ],
        child,
        if (_hasError || helperText != null) ...[
          SizedBox(height: theme.spacing.xxs),
          _FormFieldFooter(
            text: _hasError ? errorText! : helperText!,
            isError: _hasError,
            errorColor: theme.colors.error,
            helperColor: theme.colors.textTertiary,
            style: theme.typography.labelSmall,
          ),
        ],
      ],
    );
  }
}

class _FormFieldLabel extends StatelessWidget {
  const _FormFieldLabel({
    required this.label,
    required this.isRequired,
    required this.color,
    required this.style,
  });

  final String label;
  final bool isRequired;
  final Color? color;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    if (!isRequired) {
      return Text(label, style: style?.copyWith(color: color));
    }

    return RichText(
      text: TextSpan(
        text: label,
        style: style?.copyWith(color: color),
        children: const [
          TextSpan(
            text: ' *',
            style: TextStyle(color: Color(0xFFD32F2F)),
          ),
        ],
      ),
    );
  }
}

class _FormFieldFooter extends StatelessWidget {
  const _FormFieldFooter({
    required this.text,
    required this.isError,
    required this.errorColor,
    required this.helperColor,
    required this.style,
  });

  final String text;
  final bool isError;
  final Color? errorColor;
  final Color? helperColor;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final color = isError ? errorColor : helperColor;
    return Text(text, style: style?.copyWith(color: color));
  }
}
