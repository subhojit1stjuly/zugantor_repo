import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that holds the typography for the Zugantor design system.
/// This is intended to be used within a `ThemeExtension`.
@immutable
class ZDSTypography {
  const ZDSTypography({
    required this.headlineLarge,
    required this.headlineMedium,
    required this.headlineSmall,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
  });

  final TextStyle? headlineLarge;
  final TextStyle? headlineMedium;
  final TextStyle? headlineSmall;
  final TextStyle? titleLarge;
  final TextStyle? titleMedium;
  final TextStyle? titleSmall;
  final TextStyle? bodyLarge;
  final TextStyle? bodyMedium;
  final TextStyle? bodySmall;
  final TextStyle? labelLarge;
  final TextStyle? labelMedium;
  final TextStyle? labelSmall;

  /// A default typography set.
  factory ZDSTypography.fromTextTheme(TextTheme textTheme) {
    return ZDSTypography(
      headlineLarge: textTheme.headlineLarge,
      headlineMedium: textTheme.headlineMedium,
      headlineSmall: textTheme.headlineSmall,
      titleLarge: textTheme.titleLarge,
      titleMedium: textTheme.titleMedium,
      titleSmall: textTheme.titleSmall,
      bodyLarge: textTheme.bodyLarge,
      bodyMedium: textTheme.bodyMedium,
      bodySmall: textTheme.bodySmall,
      labelLarge: textTheme.labelLarge,
      labelMedium: textTheme.labelMedium,
      labelSmall: textTheme.labelSmall,
    );
  }

  /// A default text theme using Google Fonts.
  ///
  /// **Raleway** is used for display and headline styles — geometric and
  /// elegant, it creates strong visual hierarchy at large sizes.
  ///
  /// **Lato** is used for all body, UI titles, and label styles — warm,
  /// humanist, and highly legible at small sizes on both screen and print.
  static TextTheme get defaultTextTheme {
    return TextTheme(
      headlineLarge: GoogleFonts.raleway(
        fontSize: 57,
        fontWeight: FontWeight.w300,
        letterSpacing: -0.25,
      ),
      headlineMedium: GoogleFonts.raleway(
        fontSize: 45,
        fontWeight: FontWeight.w300,
      ),
      headlineSmall: GoogleFonts.raleway(
        fontSize: 36,
        fontWeight: FontWeight.w400,
      ),
      titleLarge: GoogleFonts.raleway(
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      titleMedium: GoogleFonts.lato(
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
      titleSmall: GoogleFonts.lato(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.1,
      ),
      labelMedium: GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
      labelSmall: GoogleFonts.lato(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }
}
