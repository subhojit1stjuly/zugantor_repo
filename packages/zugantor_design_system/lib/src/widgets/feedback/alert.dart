import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// The severity variant for an [Alert].
///
/// Maps to standard component.gallery alert/banner patterns:
/// - [info]: Neutral informational message.
/// - [success]: Confirmation that an action succeeded.
/// - [warning]: A cautionary message requiring attention.
/// - [error]: A critical problem that must be resolved.
enum AlertVariant { info, success, warning, error }

/// A theme-aware alert component for the ZDS design system.
///
/// Alerts display short, important messages to the user, corresponding to
/// the **Alert / Banner** component pattern documented at
/// [component.gallery](https://component.gallery/components/alert/).
///
/// At least one of [title] or [message] must be provided.
///
/// Example:
/// ```dart
/// Alert(
///   variant: AlertVariant.success,
///   title: 'Profile saved',
///   message: 'Your changes have been saved successfully.',
/// )
/// ```
class Alert extends StatelessWidget {
  /// Creates an alert.
  ///
  /// At least one of [title] or [message] must be non-null.
  const Alert({
    super.key,
    required this.variant,
    this.title,
    this.message,
    this.onClose,
    this.icon,
  }) : assert(
          title != null || message != null,
          'Alert must have a title or a message.',
        );

  /// Creates an informational alert.
  ///
  /// At least one of [title] or [message] must be non-null.
  const Alert.info({
    super.key,
    String? title,
    String? message,
    VoidCallback? onClose,
  })  : assert(
          title != null || message != null,
          'Alert.info must have a title or a message.',
        ),
        variant = AlertVariant.info,
        title = title,
        message = message,
        onClose = onClose,
        icon = null;

  /// Creates a success alert.
  ///
  /// At least one of [title] or [message] must be non-null.
  const Alert.success({
    super.key,
    String? title,
    String? message,
    VoidCallback? onClose,
  })  : assert(
          title != null || message != null,
          'Alert.success must have a title or a message.',
        ),
        variant = AlertVariant.success,
        title = title,
        message = message,
        onClose = onClose,
        icon = null;

  /// Creates a warning alert.
  ///
  /// At least one of [title] or [message] must be non-null.
  const Alert.warning({
    super.key,
    String? title,
    String? message,
    VoidCallback? onClose,
  })  : assert(
          title != null || message != null,
          'Alert.warning must have a title or a message.',
        ),
        variant = AlertVariant.warning,
        title = title,
        message = message,
        onClose = onClose,
        icon = null;

  /// Creates an error alert.
  ///
  /// At least one of [title] or [message] must be non-null.
  const Alert.error({
    super.key,
    String? title,
    String? message,
    VoidCallback? onClose,
  })  : assert(
          title != null || message != null,
          'Alert.error must have a title or a message.',
        ),
        variant = AlertVariant.error,
        title = title,
        message = message,
        onClose = onClose,
        icon = null;

  /// The severity variant of the alert.
  final AlertVariant variant;

  /// Optional bold title for the alert.
  final String? title;

  /// Optional descriptive message body.
  final String? message;

  /// Optional callback to dismiss the alert. Renders a close button when set.
  final VoidCallback? onClose;

  /// Optional override icon. Defaults to an icon matching the [variant].
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);
    final colors = _resolveColors(theme);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.m,
        vertical: theme.spacing.s,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: theme.shapes.smallRadius,
        border: Border.all(color: colors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon ?? colors.defaultIcon, color: colors.foreground, size: 20),
          SizedBox(width: theme.spacing.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: theme.typography.titleSmall?.copyWith(
                      color: colors.foreground,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (title != null && message != null)
                  SizedBox(height: theme.spacing.xxs),
                if (message != null)
                  Text(
                    message!,
                    style: theme.typography.bodySmall?.copyWith(
                      color: colors.foreground,
                    ),
                  ),
              ],
            ),
          ),
          if (onClose != null) ...[
            SizedBox(width: theme.spacing.xs),
            IconButton(
              icon: Icon(Icons.close, size: 16, color: colors.foreground),
              onPressed: onClose,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              tooltip: 'Close',
            ),
          ],
        ],
      ),
    );
  }

  _AlertColors _resolveColors(ZDSTheme theme) {
    switch (variant) {
      case AlertVariant.info:
        return _AlertColors(
          background: theme.colors.info?.withOpacity(0.1) ??
              const Color(0xFFE3F2FD),
          border: theme.colors.info ?? const Color(0xFF0288D1),
          foreground: theme.colors.info ?? const Color(0xFF0288D1),
          defaultIcon: Icons.info_outline,
        );
      case AlertVariant.success:
        return _AlertColors(
          background: theme.colors.success?.withOpacity(0.1) ??
              const Color(0xFFE8F5E9),
          border: theme.colors.success ?? const Color(0xFF388E3C),
          foreground: theme.colors.success ?? const Color(0xFF388E3C),
          defaultIcon: Icons.check_circle_outline,
        );
      case AlertVariant.warning:
        return _AlertColors(
          background: theme.colors.warning?.withOpacity(0.1) ??
              const Color(0xFFFFF3E0),
          border: theme.colors.warning ?? const Color(0xFFF57C00),
          foreground: theme.colors.warning ?? const Color(0xFFF57C00),
          defaultIcon: Icons.warning_amber_outlined,
        );
      case AlertVariant.error:
        return _AlertColors(
          background: theme.colors.error?.withOpacity(0.1) ??
              const Color(0xFFFFEBEE),
          border: theme.colors.error ?? const Color(0xFFD32F2F),
          foreground: theme.colors.error ?? const Color(0xFFD32F2F),
          defaultIcon: Icons.error_outline,
        );
    }
  }
}

class _AlertColors {
  const _AlertColors({
    required this.background,
    required this.border,
    required this.foreground,
    required this.defaultIcon,
  });

  final Color background;
  final Color border;
  final Color foreground;
  final IconData defaultIcon;
}
