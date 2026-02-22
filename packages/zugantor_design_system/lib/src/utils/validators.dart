import 'package:flutter/material.dart';

/// A collection of composable form field validators for the ZDS design system.
///
/// All validators return `null` when valid and a human-readable error string
/// when invalid — matching Flutter's `FormField.validator` signature.
///
/// Combine multiple validators with [ZDSValidators.compose]:
/// ```dart
/// AppTextInput(
///   label: 'Email',
///   validator: ZDSValidators.compose([
///     ZDSValidators.required(),
///     ZDSValidators.email(),
///   ]),
/// )
/// ```
abstract final class ZDSValidators {
  /// Fails if the value is null or empty (after trimming).
  static FormFieldValidator<String> required([
    String message = 'This field is required.',
  ]) =>
      (value) => (value == null || value.trim().isEmpty) ? message : null;

  /// Fails if the value is not a valid email address.
  static FormFieldValidator<String> email([
    String message = 'Enter a valid email address.',
  ]) =>
      (value) {
        if (value == null || value.isEmpty) return null;
        final emailRegex = RegExp(
          r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
        );
        return emailRegex.hasMatch(value.trim()) ? null : message;
      };

  /// Fails if the value has fewer than [min] characters (after trimming).
  static FormFieldValidator<String> minLength(
    int min, [
    String? message,
  ]) =>
      (value) {
        if (value == null || value.isEmpty) return null;
        final trimmed = value.trim();
        return trimmed.length < min
            ? (message ?? 'Must be at least $min characters.')
            : null;
      };

  /// Fails if the value has more than [max] characters (after trimming).
  static FormFieldValidator<String> maxLength(
    int max, [
    String? message,
  ]) =>
      (value) {
        if (value == null || value.isEmpty) return null;
        final trimmed = value.trim();
        return trimmed.length > max
            ? (message ?? 'Must be at most $max characters.')
            : null;
      };

  /// Fails if the value does not match the given [pattern].
  static FormFieldValidator<String> pattern(
    RegExp pattern, [
    String message = 'Invalid format.',
  ]) =>
      (value) {
        if (value == null || value.isEmpty) return null;
        return pattern.hasMatch(value.trim()) ? null : message;
      };

  /// Fails if the value is not a valid phone number
  /// (E.164 or common local formats).
  static FormFieldValidator<String> phone([
    String message = 'Enter a valid phone number.',
  ]) =>
      pattern(RegExp(r'^\+?[0-9\s\-().]{7,15}$'), message);

  /// Fails if the value is not a parseable number.
  static FormFieldValidator<String> numeric([
    String message = 'Enter a valid number.',
  ]) =>
      (value) {
        if (value == null || value.isEmpty) return null;
        return double.tryParse(value.trim()) == null ? message : null;
      };

  /// Fails if the numeric value is less than [min].
  static FormFieldValidator<String> min(
    double min, [
    String? message,
  ]) =>
      (value) {
        if (value == null || value.isEmpty) return null;
        final parsed = double.tryParse(value.trim());
        if (parsed == null) return 'Enter a valid number.';
        return parsed < min ? (message ?? 'Must be at least $min.') : null;
      };

  /// Fails if the numeric value is greater than [max].
  static FormFieldValidator<String> max(
    double max, [
    String? message,
  ]) =>
      (value) {
        if (value == null || value.isEmpty) return null;
        final parsed = double.tryParse(value.trim());
        if (parsed == null) return 'Enter a valid number.';
        return parsed > max ? (message ?? 'Must be at most $max.') : null;
      };

  /// Combines multiple validators and returns the first error message found.
  ///
  /// Returns `null` only when all validators pass.
  static FormFieldValidator<String> compose(
    List<FormFieldValidator<String>> validators,
  ) =>
      (value) {
        for (final validator in validators) {
          final error = validator(value);
          if (error != null) return error;
        }
        return null;
      };
}
