import 'package:flutter/animation.dart';

/// A class that holds the animation tokens for the ZDS design system.
///
/// Provides a consistent set of durations and curves to use across all
/// animated widgets, keeping motion cohesive and easy to tune globally.
///
/// Example:
/// ```dart
/// AnimatedContainer(
///   duration: context.zdsTheme.animations.normal,
///   curve: context.zdsTheme.animations.standard,
/// )
/// ```
class ZDSAnimations {
  const ZDSAnimations({
    this.fast = const Duration(milliseconds: 150),
    this.normal = const Duration(milliseconds: 250),
    this.slow = const Duration(milliseconds: 400),
    this.standard = Curves.easeInOut,
    this.decelerate = Curves.easeOut,
    this.accelerate = Curves.easeIn,
    this.emphasized = Curves.fastOutSlowIn,
  });

  // --- Durations ---

  /// Short transitions: button feedback, hover overlays, ripples.
  final Duration fast;

  /// Standard transitions: route changes, expanding panels.
  final Duration normal;

  /// Deliberate transitions: modals, drawers, bottom sheets.
  final Duration slow;

  // --- Curves ---

  /// General-purpose easing. Use for most transitions.
  final Curve standard;

  /// Elements entering the screen. Start fast, settle gently.
  final Curve decelerate;

  /// Elements leaving the screen. Start slow, end fast.
  final Curve accelerate;

  /// Expressive entry transitions; follows Material 3 motion guidelines.
  final Curve emphasized;
}
