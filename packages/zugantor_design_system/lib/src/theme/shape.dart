import 'package:flutter/material.dart';

/// A class that holds the shape values for the ZDS design system.
/// This is intended to be used within a `ThemeExtension`.
@immutable
class ZDSShapes {
  const ZDSShapes({
    this.small = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    this.medium = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    this.large = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    this.pill = const StadiumBorder(),
    this.smallRadius = const BorderRadius.all(Radius.circular(8)),
    this.mediumRadius = const BorderRadius.all(Radius.circular(12)),
    this.largeRadius = const BorderRadius.all(Radius.circular(16)),
    this.pillRadius = const BorderRadius.all(Radius.circular(9999)),
  });

  // ShapeBorder for button shapes, card shapes, etc.
  final ShapeBorder small;
  final ShapeBorder medium;
  final ShapeBorder large;
  final ShapeBorder pill;

  // BorderRadius for container decorations, etc.
  final BorderRadius smallRadius;
  final BorderRadius mediumRadius;
  final BorderRadius largeRadius;
  final BorderRadius pillRadius;
}
