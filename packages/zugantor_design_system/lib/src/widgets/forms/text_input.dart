import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// Validation state for text input fields.
enum TextInputState { normal, success, warning, error }

/// A theme-aware text input component for the ZDS design system.
///
/// This input field supports different validation states and provides
/// consistent styling across the application.
class AppTextInput extends StatelessWidget {
  /// Creates a text input field.
  const AppTextInput({
    super.key,
    required this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.state = TextInputState.normal,
    this.onChanged,
    this.controller,
    this.enabled = true,
    this.obscureText = false,
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
  });

  /// The label text for the input field.
  final String label;

  /// Optional hint text shown when the field is empty.
  final String? hint;

  /// Optional helper text shown below the field.
  final String? helperText;

  /// Optional error text shown when state is error.
  final String? errorText;

  /// The validation state of the input field.
  final TextInputState state;

  /// Callback when the text changes.
  final ValueChanged<String>? onChanged;

  /// Text editing controller.
  final TextEditingController? controller;

  /// Whether the field is enabled.
  final bool enabled;

  /// Whether to obscure the text (for passwords).
  final bool obscureText;

  /// Maximum number of lines.
  final int maxLines;

  /// Optional prefix icon.
  final IconData? prefixIcon;

  /// Optional suffix icon.
  final IconData? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    Color? borderColor;
    Color? focusColor;
    String? displayErrorText;

    switch (state) {
      case TextInputState.success:
        borderColor = theme.colors.success;
        focusColor = theme.colors.success;
        break;
      case TextInputState.warning:
        borderColor = theme.colors.warning;
        focusColor = theme.colors.warning;
        break;
      case TextInputState.error:
        borderColor = theme.colors.error;
        focusColor = theme.colors.error;
        displayErrorText = errorText;
        break;
      case TextInputState.normal:
        borderColor = theme.colors.border;
        focusColor = theme.colors.primary;
        break;
    }

    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      enabled: enabled,
      obscureText: obscureText,
      maxLines: maxLines,
      style: theme.typography.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: displayErrorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor ?? Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor ?? Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: focusColor ?? Colors.blue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colors.error ?? Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide:
              BorderSide(color: theme.colors.error ?? Colors.red, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: theme.colors.disabled ?? Colors.grey),
        ),
        filled: !enabled,
        fillColor: enabled ? null : theme.colors.disabled?.withOpacity(0.1),
        contentPadding: EdgeInsets.symmetric(
          horizontal: theme.spacing.m,
          vertical: theme.spacing.m,
        ),
      ),
    );
  }
}
