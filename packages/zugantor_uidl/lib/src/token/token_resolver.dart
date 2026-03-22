import '../model/design_tokens.dart';
import 'token_ref.dart';

/// Resolves `@token` references in UIDL props against a [DesignTokens] set.
///
/// The resolver is stateless beyond its [tokens] reference and is safe to
/// reuse across multiple resolve calls.
///
/// Usage:
/// ```dart
/// final resolver = TokenResolver(tokens: myDesignTokens);
///
/// // Resolve a single prop value.
/// final color = resolver.resolveValue('@colors.primary'); // "#6C63FF"
///
/// // Resolve a whole props map.
/// final resolved = resolver.resolveProps(node.props);
/// ```
///
/// See ADR-002 for the full token resolution rules.
class TokenResolver {
  /// Creates a [TokenResolver] backed by [tokens].
  const TokenResolver({required this.tokens});

  /// The design tokens used for all lookups.
  final DesignTokens tokens;

  /// Resolves a single prop [value].
  ///
  /// - If [value] is a [String] that starts with `@`, it is treated as a
  ///   token reference and looked up in [tokens].
  /// - Any other type (int, double, bool, Map, List) is returned unchanged.
  /// - If the reference cannot be resolved, the original `@token` string is
  ///   returned unchanged so that [UidlValidator] can detect missing tokens.
  Object? resolveValue(Object? value) {
    if (value is! String) return value;
    final ref = TokenRef.tryParse(value);
    if (ref == null) return value;
    return tokens.resolve(value) ?? value;
  }

  /// Resolves all values in [props], returning a new map with token
  /// references replaced by their concrete values.
  ///
  /// Entries whose references cannot be resolved are kept as-is (the
  /// original `@token` string is preserved so callers can detect missing
  /// tokens during validation).
  Map<String, Object?> resolveProps(Map<String, Object?> props) {
    if (props.isEmpty) return props;
    return {
      for (final entry in props.entries) entry.key: _resolveEntry(entry.value),
    };
  }

  Object? _resolveEntry(Object? value) {
    if (value is String) return resolveValue(value);
    if (value is Map<String, Object?>) return resolveProps(value);
    if (value is List) return value.map(_resolveEntry).toList();
    return value;
  }

  /// Returns `true` if [ref] resolves to a concrete value in [tokens].
  bool canResolve(String ref) => tokens.resolve(ref) != null;
}
