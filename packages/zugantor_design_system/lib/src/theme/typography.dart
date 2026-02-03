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
  static TextTheme get defaultTextTheme {
    return TextTheme(
      headlineLarge:
          GoogleFonts.oswald(fontSize: 57, fontWeight: FontWeight.w400),
      headlineMedium:
          GoogleFonts.oswald(fontSize: 45, fontWeight: FontWeight.w400),
      headlineSmall:
          GoogleFonts.oswald(fontSize: 36, fontWeight: FontWeight.w400),
      titleLarge: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.w500),
      titleMedium:
          GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
      titleSmall: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge:
          GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium:
          GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w400),
      bodySmall:
          GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.w400),
      labelLarge: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
      labelMedium:
          GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w500),
      labelSmall: GoogleFonts.roboto(fontSize: 11, fontWeight: FontWeight.w500),
    );
  }
}
