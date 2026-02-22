import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// A theme-aware app bar for the ZDS design system.
///
/// Wraps Flutter's [AppBar] and applies ZDS colors and typography
/// automatically.
///
/// ```dart
/// Scaffold(
///   appBar: ZDSAppBar(title: 'Dashboard'),
/// )
/// ```
class ZDSAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Creates a ZDS-styled app bar.
  const ZDSAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actions,
    this.centerTitle = true,
    this.elevation = 0,
    this.bottom,
  });

  /// The primary title text.
  final String title;

  /// Optional leading widget (e.g. back button or menu icon).
  final Widget? leading;

  /// Optional trailing action widgets.
  final List<Widget>? actions;

  /// Whether to center the title.
  final bool centerTitle;

  /// Elevation of the app bar shadow. Defaults to 0 for a flat look.
  final double elevation;

  /// Optional bottom widget (e.g. a [TabBar]).
  final PreferredSizeWidget? bottom;

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0),
      );

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    return AppBar(
      title: Text(
        title,
        style: theme.typography.titleLarge
            ?.copyWith(color: theme.colors.onPrimary),
      ),
      leading: leading,
      actions: actions,
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: theme.colors.primary,
      foregroundColor: theme.colors.onPrimary,
      bottom: bottom,
    );
  }
}
