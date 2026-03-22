import 'package:flutter/material.dart';

/// A class that holds the spacing values for the ZDS design system.
/// This is intended to be used within a `ThemeExtension`.
@immutable
class ZDSSpacing {
  const ZDSSpacing({
    this.xxs = 4.0,
    this.xs = 8.0,
    this.s = 12.0,
    this.m = 16.0,
    this.l = 24.0,
    this.xl = 32.0,
    this.xxl = 48.0,
  });

  final double xxs;
  final double xs;
  final double s;
  final double m;
  final double l;
  final double xl;
  final double xxl;
}
