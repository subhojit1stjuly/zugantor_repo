import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// A theme-aware modal bottom sheet for the ZDS design system.
///
/// Provides a drag handle, optional title, and scrollable content area.
///
/// ```dart
/// ZDSBottomSheet.show(
///   context,
///   title: 'Sort By',
///   child: Column(
///     children: [
///       ZDSListTile(title: 'Price: Low to High', onTap: () {}),
///       ZDSListTile(title: 'Price: High to Low', onTap: () {}),
///     ],
///   ),
/// );
/// ```
abstract final class ZDSBottomSheet {
  /// Shows a ZDS-styled modal bottom sheet.
  ///
  /// [isScrollControlled] makes the sheet expand beyond half the screen
  /// height — useful for long content or full-screen sheets.
  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    bool isScrollControlled = false,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ZDSBottomSheetWidget(
        title: title,
        isScrollControlled: isScrollControlled,
        child: child,
      ),
    );
  }
}

class _ZDSBottomSheetWidget extends StatelessWidget {
  const _ZDSBottomSheetWidget({
    required this.child,
    this.title,
    this.isScrollControlled = false,
  });

  final Widget child;
  final String? title;
  final bool isScrollControlled;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    return Container(
      constraints: isScrollControlled
          ? BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            )
          : null,
      decoration: BoxDecoration(
        color: theme.colors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(theme.shapes.largeRadius.topLeft.x),
          topRight: Radius.circular(theme.shapes.largeRadius.topRight.x),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DragHandle(theme: theme),
          if (title != null) _SheetTitle(title: title!, theme: theme),
          isScrollControlled
              ? Flexible(child: SingleChildScrollView(child: child))
              : child,
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle({required this.theme});

  final ZDSTheme theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: theme.spacing.s),
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: theme.colors.divider,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle({required this.title, required this.theme});

  final String title;
  final ZDSTheme theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        theme.spacing.l,
        0,
        theme.spacing.l,
        theme.spacing.m,
      ),
      child: Text(
        title,
        style: theme.typography.titleMedium
            ?.copyWith(color: theme.colors.textPrimary),
        textAlign: TextAlign.center,
      ),
    );
  }
}
