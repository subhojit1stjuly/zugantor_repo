import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// Semantic variants for [ZDSSnackbar].
enum ZDSSnackbarVariant {
  /// Neutral informational message.
  info,

  /// Positive feedback or successful operation.
  success,

  /// Cautionary message; action may be needed.
  warning,

  /// Error or failure message.
  error,
}

/// A helper class for displaying themed snackbars in the ZDS design system.
///
/// Always call this after the widget tree is built (e.g. in a button callback)
/// so the `BuildContext` has a valid `ScaffoldMessenger`.
///
/// ```dart
/// ZDSSnackbar.show(
///   context,
///   message: 'Changes saved successfully.',
///   variant: ZDSSnackbarVariant.success,
/// );
/// ```
abstract final class ZDSSnackbar {
  /// Shows a themed snackbar anchored to the nearest [ScaffoldMessenger].
  static void show(
    BuildContext context, {
    required String message,
    ZDSSnackbarVariant variant = ZDSSnackbarVariant.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = ZDSTheme.of(context);

    final (backgroundColor, foregroundColor, icon) = switch (variant) {
      ZDSSnackbarVariant.info => (
          theme.colors.info,
          theme.colors.onInfo,
          Icons.info_outline,
        ),
      ZDSSnackbarVariant.success => (
          theme.colors.success,
          theme.colors.onSuccess,
          Icons.check_circle_outline,
        ),
      ZDSSnackbarVariant.warning => (
          theme.colors.warning,
          theme.colors.onWarning,
          Icons.warning_amber_outlined,
        ),
      ZDSSnackbarVariant.error => (
          theme.colors.error,
          theme.colors.onError,
          Icons.error_outline,
        ),
    };

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          duration: duration,
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: theme.shapes.mediumRadius,
          ),
          content: Row(
            children: [
              Icon(icon, color: foregroundColor, size: 20),
              SizedBox(width: theme.spacing.s),
              Expanded(
                child: Text(
                  message,
                  style: theme.typography.bodyMedium
                      ?.copyWith(color: foregroundColor),
                ),
              ),
            ],
          ),
          action: actionLabel != null
              ? SnackBarAction(
                  label: actionLabel,
                  textColor: foregroundColor,
                  onPressed: onAction ?? () {},
                )
              : null,
        ),
      );
  }
}
