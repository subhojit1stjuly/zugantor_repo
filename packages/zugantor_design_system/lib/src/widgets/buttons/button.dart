import 'package:flutter/material.dart';
import '../../theme/custom_theme.dart';

/// Button variant types for the unified button component.
enum ZDSButtonVariant {
  /// Primary button - Main call-to-action with solid background.
  primary,

  /// Secondary button - Less prominent action with outlined style.
  secondary,

  /// Text button - Low-emphasis action with no background.
  text,

  /// Icon button - Compact action displaying only an icon.
  icon,
}

/// A unified theme-aware button component for the ZDS design system.
///
/// This button provides consistent styling across different variants:
/// - Primary: Main call-to-action with solid background
/// - Secondary: Outlined style for less prominent actions
/// - Text: No background for low-emphasis actions
/// - Icon: Compact icon-only button
///
/// Use factory constructors for cleaner API:
/// ```dart
/// ZDSButton.primary(label: 'Submit', onPressed: () {})
/// ZDSButton.secondary(label: 'Cancel', onPressed: () {})
/// ZDSButton.text(label: 'Skip', onPressed: () {})
/// ZDSButton.icon(icon: Icons.close, onPressed: () {})
/// ```
class ZDSButton extends StatelessWidget {
  /// Creates a button with the specified variant.
  const ZDSButton({
    super.key,
    required this.variant,
    required this.onPressed,
    this.label,
    this.icon,
    this.tooltip,
    this.fullWidth = false,
    this.isLoading = false,
  })  : assert(
          variant != ZDSButtonVariant.icon || icon != null,
          'Icon button requires an icon',
        ),
        assert(
          variant == ZDSButtonVariant.icon || label != null,
          'Non-icon buttons require a label',
        );

  /// Creates a primary button.
  const ZDSButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
    this.isLoading = false,
  })  : variant = ZDSButtonVariant.primary,
        tooltip = null;

  /// Creates a secondary button.
  const ZDSButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.fullWidth = false,
    this.isLoading = false,
  })  : variant = ZDSButtonVariant.secondary,
        tooltip = null;

  /// Creates a text button.
  const ZDSButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
  })  : variant = ZDSButtonVariant.text,
        tooltip = null,
        fullWidth = false;

  /// Creates an icon button.
  const ZDSButton.icon({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.isLoading = false,
  })  : variant = ZDSButtonVariant.icon,
        label = null,
        fullWidth = false;

  /// The button variant type.
  final ZDSButtonVariant variant;

  /// The callback that is called when the button is tapped.
  final VoidCallback? onPressed;

  /// The text to display on the button (not used for icon buttons).
  final String? label;

  /// Optional icon to display alongside the label or as the button content.
  final IconData? icon;

  /// Optional tooltip text (primarily for icon buttons).
  final String? tooltip;

  /// Whether the button should expand to full width.
  final bool fullWidth;

  /// When true, the button shows a loading spinner and ignores taps.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = ZDSTheme.of(context);

    Widget button;

    switch (variant) {
      case ZDSButtonVariant.primary:
        button = _buildPrimaryButton(context, theme);
        break;
      case ZDSButtonVariant.secondary:
        button = _buildSecondaryButton(context, theme);
        break;
      case ZDSButtonVariant.text:
        button = _buildTextButton(context, theme);
        break;
      case ZDSButtonVariant.icon:
        button = _buildIconButton(context, theme);
        break;
    }

    if (fullWidth && variant != ZDSButtonVariant.icon) {
      return SizedBox(width: double.infinity, child: button);
    }

    return button;
  }

  Widget _buildPrimaryButton(BuildContext context, ZDSTheme theme) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) => theme.colors.primary,
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) => theme.colors.onPrimary,
        ),
        shape: WidgetStateProperty.all<OutlinedBorder>(
          theme.shapes.pill as OutlinedBorder,
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: theme.spacing.l,
            vertical: theme.spacing.m,
          ),
        ),
        textStyle: WidgetStateProperty.all(theme.typography.labelLarge),
      ),
      child: isLoading
          ? _LoadingIndicator(color: theme.colors.onPrimary)
          : icon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 18),
                    SizedBox(width: theme.spacing.xs),
                    Text(label!),
                  ],
                )
              : Text(label!),
    );
  }

  Widget _buildSecondaryButton(BuildContext context, ZDSTheme theme) {
    return OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) => states.contains(WidgetState.pressed)
              ? theme.colors.secondary?.withValues(alpha: 0.1)
              : theme.colors.surface,
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) => theme.colors.secondary,
        ),
        side: WidgetStateProperty.all(
          BorderSide(color: theme.colors.secondary ?? Colors.grey),
        ),
        shape: WidgetStateProperty.all<OutlinedBorder>(
          theme.shapes.pill as OutlinedBorder,
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: theme.spacing.l,
            vertical: theme.spacing.m,
          ),
        ),
        textStyle: WidgetStateProperty.all(theme.typography.labelLarge),
      ),
      child: isLoading
          ? _LoadingIndicator(color: theme.colors.secondary)
          : icon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 18),
                    SizedBox(width: theme.spacing.xs),
                    Text(label!),
                  ],
                )
              : Text(label!),
    );
  }

  Widget _buildTextButton(BuildContext context, ZDSTheme theme) {
    return TextButton(
      onPressed: isLoading ? null : onPressed,
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) => states.contains(WidgetState.disabled)
              ? theme.colors.disabled
              : theme.colors.primary,
        ),
        overlayColor: WidgetStateProperty.all(
          theme.colors.primary?.withValues(alpha: 0.1),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: theme.spacing.m,
            vertical: theme.spacing.s,
          ),
        ),
        textStyle: WidgetStateProperty.all(theme.typography.labelLarge),
      ),
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18),
                SizedBox(width: theme.spacing.xs),
                Text(label!),
              ],
            )
          : Text(label!),
    );
  }

  Widget _buildIconButton(BuildContext context, ZDSTheme theme) {
    return IconButton(
      onPressed: isLoading ? null : onPressed,
      tooltip: tooltip,
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (states) => states.contains(WidgetState.disabled)
              ? theme.colors.disabled
              : theme.colors.primary,
        ),
        overlayColor: WidgetStateProperty.all(
          theme.colors.primary?.withValues(alpha: 0.1),
        ),
        padding: WidgetStateProperty.all(
          EdgeInsets.all(theme.spacing.s),
        ),
      ),
      icon: Icon(icon!),
    );
  }
}

/// A compact circular progress indicator sized to fit inside a button.
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator({this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? Colors.white,
        ),
      ),
    );
  }
}
