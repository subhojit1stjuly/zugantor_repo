import 'package:meta/meta.dart';

/// Holds all resolved design tokens for a project.
///
/// Token files live in `design/` and are loaded once per project open.
/// All `@token` references in screen JSON are resolved against this object
/// by [TokenResolver] before rendering or code generation.
///
/// See ADR-002 for the full token contract.
@immutable
class DesignTokens {
  /// Creates [DesignTokens] with the given token maps.
  const DesignTokens({
    this.colors = const {},
    this.typography = const {},
    this.spacing = const {},
    this.radius = const {},
  });

  /// Semantic color tokens (e.g. `{"primary": "#6C63FF"}`).
  ///
  /// Palette aliases are resolved during loading — this map contains
  /// only concrete hex values, never `@palette.*` references.
  final Map<String, String> colors;

  /// Typography style tokens.
  ///
  /// Each entry is a map with keys: `family`, `size`, `weight`, `height`.
  /// Example: `{"heading_1": {"family": "Inter", "size": 32, "weight": 700, "height": 1.25}}`
  final Map<String, Map<String, Object>> typography;

  /// Spacing tokens — concrete pixel values.
  ///
  /// Example: `{"xs": 4, "sm": 8, "md": 16, "lg": 24}`
  final Map<String, double> spacing;

  /// Border radius tokens — concrete pixel values.
  ///
  /// Example: `{"sm": 4, "md": 8, "lg": 12, "full": 9999}`
  final Map<String, double> radius;

  /// Empty token set — useful as a default when no design files exist.
  static const DesignTokens empty = DesignTokens();

  /// Looks up a token by its `@`-prefixed reference string.
  ///
  /// Returns `null` if the reference is not found.
  ///
  /// Examples:
  /// ```dart
  /// tokens.resolve('@colors.primary')   // returns "#6C63FF"
  /// tokens.resolve('@spacing.lg')       // returns 24.0
  /// tokens.resolve('@radius.md')        // returns 8.0
  /// ```
  Object? resolve(String ref) {
    if (!ref.startsWith('@')) return null;
    final parts = ref.substring(1).split('.');
    if (parts.length != 2) return null;
    final (category, name) = (parts[0], parts[1]);
    return switch (category) {
      'colors' => colors[name],
      'spacing' => spacing[name],
      'radius' => radius[name],
      'typography' => typography[name],
      _ => null,
    };
  }

  /// Returns `true` if [ref] is a token reference string (starts with `@`).
  static bool isTokenRef(String value) => value.startsWith('@');

  /// Loads [DesignTokens] from the raw JSON maps of each token file.
  ///
  /// [colorsJson] — parsed contents of `design/colors.json`
  /// [typographyJson] — parsed contents of `design/typography.json`
  /// [spacingJson] — parsed contents of `design/spacing.json`
  /// [radiusJson] — parsed contents of `design/radius.json`
  factory DesignTokens.fromJson({
    Map<String, dynamic> colorsJson = const {},
    Map<String, dynamic> typographyJson = const {},
    Map<String, dynamic> spacingJson = const {},
    Map<String, dynamic> radiusJson = const {},
  }) {
    return DesignTokens(
      colors: _resolveColors(colorsJson),
      typography: _resolveTypography(typographyJson),
      spacing:
          _resolveScale(spacingJson['scale'] as Map<String, dynamic>? ?? {}),
      radius: _resolveScale(radiusJson['scale'] as Map<String, dynamic>? ?? {}),
    );
  }

  static Map<String, String> _resolveColors(Map<String, dynamic> json) {
    final palette =
        (json['palette'] as Map<String, dynamic>? ?? {}).cast<String, String>();
    final semantic = (json['semantic'] as Map<String, dynamic>? ?? {})
        .cast<String, String>();
    final resolved = <String, String>{};
    for (final entry in semantic.entries) {
      final value = entry.value;
      if (value.startsWith('@palette.')) {
        final key = value.substring('@palette.'.length);
        resolved[entry.key] = palette[key] ?? value;
      } else {
        resolved[entry.key] = value;
      }
    }
    return resolved;
  }

  static Map<String, Map<String, Object>> _resolveTypography(
      Map<String, dynamic> json) {
    final styles = json['styles'] as Map<String, dynamic>? ?? {};
    final families = (json['families'] as Map<String, dynamic>? ?? {})
        .cast<String, String>();
    final resolved = <String, Map<String, Object>>{};
    for (final entry in styles.entries) {
      final style =
          (entry.value as Map<String, dynamic>).cast<String, Object>();
      final family = style['family'] as String?;
      if (family != null && family.startsWith('@families.')) {
        final key = family.substring('@families.'.length);
        style['family'] = families[key] ?? family;
      }
      resolved[entry.key] = style;
    }
    return resolved;
  }

  static Map<String, double> _resolveScale(Map<String, dynamic> json) {
    return json.map((k, v) => MapEntry(k, (v as num).toDouble()));
  }

  @override
  String toString() =>
      'DesignTokens(colors: ${colors.length}, typography: ${typography.length}, '
      'spacing: ${spacing.length}, radius: ${radius.length})';
}
