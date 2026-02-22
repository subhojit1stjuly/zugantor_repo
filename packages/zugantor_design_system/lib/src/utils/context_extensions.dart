import 'package:flutter/widgets.dart';
import '../theme/animations.dart';
import '../theme/colors.dart';
import '../theme/custom_theme.dart';
import '../theme/shape.dart';
import '../theme/spacing.dart';
import '../theme/typography.dart';

/// Extension methods on [BuildContext] for convenient access to ZDS theme properties.
///
/// These extensions provide a cleaner and more concise way to access theme values
/// throughout your widgets without repeatedly calling `ZDSTheme.of(context)`.
///
/// Example:
/// ```dart
/// // Before
/// final theme = ZDSTheme.of(context);
/// Container(
///   color: theme.colors.primary,
///   padding: EdgeInsets.all(theme.spacing.m),
/// );
///
/// // After
/// Container(
///   color: context.colors.primary,
///   padding: EdgeInsets.all(context.spacing.m),
/// );
/// ```
extension ZDSThemeExtension on BuildContext {
  /// Access the complete ZDS theme.
  ZDSTheme get zdsTheme => ZDSTheme.of(this);

  /// Quick access to color tokens.
  ZDSColors get colors => zdsTheme.colors;

  /// Quick access to typography tokens.
  ZDSTypography get typography => zdsTheme.typography;

  /// Quick access to spacing tokens.
  ZDSSpacing get spacing => zdsTheme.spacing;

  /// Quick access to shape tokens.
  ZDSShapes get shapes => zdsTheme.shapes;

  /// Quick access to animation tokens (durations and curves).
  ZDSAnimations get animations => zdsTheme.animations;
}

/// Extension methods on [BuildContext] for responsive design.
///
/// These extensions help you build responsive layouts that adapt to different
/// screen sizes without manually checking MediaQuery everywhere.
///
/// Example:
/// ```dart
/// // Check device type
/// if (context.isMobile) {
///   return MobileLayout();
/// }
///
/// // Responsive values
/// final padding = context.responsive(
///   mobile: 16.0,
///   tablet: 24.0,
///   desktop: 32.0,
/// );
/// ```
extension ResponsiveExtension on BuildContext {
  /// Get the current screen size.
  Size get screenSize => MediaQuery.of(this).size;

  /// Get the current screen width.
  double get screenWidth => screenSize.width;

  /// Get the current screen height.
  double get screenHeight => screenSize.height;

  /// Check if the current device is mobile (width < 600).
  bool get isMobile => screenWidth < 600;

  /// Check if the current device is tablet (600 <= width < 1024).
  bool get isTablet => screenWidth >= 600 && screenWidth < 1024;

  /// Check if the current device is desktop (width >= 1024).
  bool get isDesktop => screenWidth >= 1024;

  /// Check if the current device is mobile or tablet (width < 1024).
  bool get isMobileOrTablet => screenWidth < 1024;

  /// Return different values based on the current screen size.
  ///
  /// The [mobile] value is required and will be used as the default.
  /// If [tablet] is not provided, [mobile] will be used for tablets.
  /// If [desktop] is not provided, [tablet] (or [mobile]) will be used for desktops.
  ///
  /// Example:
  /// ```dart
  /// final columns = context.responsive<int>(
  ///   mobile: 1,
  ///   tablet: 2,
  ///   desktop: 3,
  /// );
  /// ```
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }

  /// Return a value based on a custom breakpoint.
  ///
  /// Example:
  /// ```dart
  /// final fontSize = context.breakpoint(
  ///   breakpoint: 768,
  ///   small: 14.0,
  ///   large: 18.0,
  /// );
  /// ```
  T breakpoint<T>({
    required double breakpoint,
    required T small,
    required T large,
  }) {
    return screenWidth >= breakpoint ? large : small;
  }
}

/// Extension methods on [BuildContext] for common MediaQuery values.
///
/// These extensions provide quick access to frequently used MediaQuery properties.
extension MediaQueryExtension on BuildContext {
  /// Get the current device pixel ratio.
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// Get the current text scale factor.
  double get textScaleFactor => MediaQuery.of(this).textScaler.scale(1.0);

  /// Get the current platform brightness.
  Brightness get brightness => MediaQuery.of(this).platformBrightness;

  /// Check if the platform is in dark mode.
  bool get isDarkMode => brightness == Brightness.dark;

  /// Check if the platform is in light mode.
  bool get isLightMode => brightness == Brightness.light;

  /// Get the safe area padding (notches, system UI).
  EdgeInsets get padding => MediaQuery.of(this).padding;

  /// Get the view insets (keyboard height, etc.).
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;

  /// Check if the keyboard is currently visible.
  bool get isKeyboardVisible => viewInsets.bottom > 0;
}
