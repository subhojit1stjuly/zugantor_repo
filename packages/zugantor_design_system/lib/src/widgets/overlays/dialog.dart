import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';
import '../buttons/button.dart';

/// The set of actions rendered in the dialog's footer.
class ZDSDialogAction {
  /// Creates a dialog action.
  const ZDSDialogAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
  });

  /// Button label.
  final String label;

  /// Callback when the action is tapped.
  final VoidCallback? onPressed;

  /// Whether to render as a primary (filled) button.
  final bool isPrimary;

  /// Whether this action represents a destructive operation.
  /// When true the primary button uses the error color.
  final bool isDestructive;
}

/// A theme-aware dialog for the ZDS design system.
///
/// ```dart
/// ZDSDialog.show(
///   context,
///   title: 'Delete Item',
///   body: 'This action cannot be undone.',
///   actions: [
///     ZDSDialogAction(label: 'Cancel', onPressed: () => Navigator.pop(context)),
///     ZDSDialogAction(
///       label: 'Delete',
///       onPressed: _delete,
///       isPrimary: true,
///       isDestructive: true,
///     ),
///   ],
/// );
/// ```
abstract final class ZDSDialog {
  /// Shows the dialog and returns the value passed to [Navigator.pop].
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String body,
    List<ZDSDialogAction> actions = const [],
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => _ZDSDialogWidget(
        title: title,
        body: body,
        actions: actions,
      ),
    );
  }
}

class _ZDSDialogWidget extends StatelessWidget {
  const _ZDSDialogWidget({
    required this.title,
    required this.body,
    required this.actions,
  });

  final String title;
  final String body;
  final List<ZDSDialogAction> actions;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    return AlertDialog(
      backgroundColor: theme.colors.surface,
      shape: RoundedRectangleBorder(borderRadius: theme.shapes.largeRadius),
      titlePadding: EdgeInsets.fromLTRB(
        theme.spacing.l,
        theme.spacing.l,
        theme.spacing.l,
        theme.spacing.s,
      ),
      contentPadding: EdgeInsets.fromLTRB(
        theme.spacing.l,
        0,
        theme.spacing.l,
        theme.spacing.m,
      ),
      actionsPadding: EdgeInsets.all(theme.spacing.m),
      title: Text(
        title,
        style: theme.typography.titleLarge
            ?.copyWith(color: theme.colors.textPrimary),
      ),
      content: Text(
        body,
        style: theme.typography.bodyMedium
            ?.copyWith(color: theme.colors.textSecondary),
      ),
      actions: actions.map((action) {
        if (action.isPrimary) {
          return ZDSButton.primary(
            label: action.label,
            onPressed: action.onPressed,
          );
        }
        return ZDSButton.text(
          label: action.label,
          onPressed: action.onPressed,
        );
      }).toList(),
    );
  }
}
