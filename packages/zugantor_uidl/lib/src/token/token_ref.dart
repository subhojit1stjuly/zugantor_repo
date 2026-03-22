import 'package:meta/meta.dart';

/// A parsed `@category.name` token reference.
///
/// Token references appear as string values in the `props` or `bind` maps of
/// a [UidlNode]. They start with `@` and contain exactly one `.`:
///
/// ```json
/// { "color": "@colors.primary", "padding": "@spacing.lg" }
/// ```
///
/// Use [TokenRef.tryParse] to safely obtain a [TokenRef] from an arbitrary
/// string, or [TokenRef.isTokenRef] to test whether a string is a reference
/// before parsing.
///
/// See ADR-002 for the full token syntax specification.
@immutable
class TokenRef {
  const TokenRef._({required this.category, required this.name});

  /// The token category: `colors`, `spacing`, `typography`, or `radius`.
  final String category;

  /// The token name within the category.
  final String name;

  /// The original reference string, e.g. `@colors.primary`.
  String get ref => '@$category.$name';

  /// Returns `true` if [value] matches the `@category.name` pattern.
  static bool isTokenRef(String value) {
    if (!value.startsWith('@')) return false;
    final rest = value.substring(1);
    final dot = rest.indexOf('.');
    return dot > 0 && dot < rest.length - 1;
  }

  /// Tries to parse [value] as a token reference.
  ///
  /// Returns `null` if [value] does not start with `@` or does not contain
  /// exactly one `.` after the prefix.
  static TokenRef? tryParse(String value) {
    if (!isTokenRef(value)) return null;
    final rest = value.substring(1);
    final dot = rest.indexOf('.');
    return TokenRef._(
      category: rest.substring(0, dot),
      name: rest.substring(dot + 1),
    );
  }

  @override
  String toString() => 'TokenRef($ref)';

  @override
  bool operator ==(Object other) =>
      other is TokenRef && other.category == category && other.name == name;

  @override
  int get hashCode => Object.hash(category, name);
}
