import '../model/design_tokens.dart';
import '../model/screen_template.dart';
import '../model/uidl_node.dart';
import '../registry/component_registry.dart';
import '../token/token_ref.dart';
import 'validation_result.dart';

/// Validates a [ScreenTemplate] against a set of [DesignTokens] and an
/// optional [ComponentRegistry].
///
/// Checks performed:
/// - Every node `id` is non-empty and unique within the screen.
/// - Every node `type` matches the `namespace.name` format.
/// - All `@token` prop values reference a token that exists in [DesignTokens].
/// - If a [ComponentRegistry] is provided, required props are present for
///   registered components.
///
/// Example:
/// ```dart
/// final validator = UidlValidator();
/// final result = validator.validate(screen, tokens);
/// if (!result.isValid) {
///   for (final e in result.errors) print(e);
/// }
/// ```
///
/// See ADR-001, ADR-002, ADR-004 for the rules enforced here.
class UidlValidator {
  /// Creates a [UidlValidator].
  ///
  /// Pass a [registry] to enable required-prop checking for registered
  /// components. Without a registry, only structural rules are validated.
  const UidlValidator({this.registry});

  /// Optional registry used to check required props on registered components.
  final ComponentRegistry? registry;

  /// Validates [template] and returns a [ValidationResult].
  ValidationResult validate(ScreenTemplate template, DesignTokens tokens) {
    final issues = <ValidationIssue>[];
    final seenIds = <String>{};

    _walkNode(template.layout, issues, seenIds, tokens);

    return ValidationResult(issues);
  }

  void _walkNode(
    UidlNode node,
    List<ValidationIssue> issues,
    Set<String> seenIds,
    DesignTokens tokens,
  ) {
    _checkId(node, issues, seenIds);
    _checkType(node, issues);
    _checkTokenRefs(node, issues, tokens);
    _checkRequiredProps(node, issues);

    for (final child in node.children) {
      _walkNode(child, issues, seenIds, tokens);
    }
    final template = node.itemTemplate;
    if (template != null) {
      _walkNode(template, issues, seenIds, tokens);
    }
  }

  void _checkId(
      UidlNode node, List<ValidationIssue> issues, Set<String> seenIds) {
    if (node.id.isEmpty) {
      issues.add(
        ValidationIssue.error(
          'Node of type "${node.type}" has an empty id.',
          nodeId: node.type,
        ),
      );
      return;
    }
    if (seenIds.contains(node.id)) {
      issues.add(
        ValidationIssue.error(
          'Duplicate node id "${node.id}".',
          nodeId: node.id,
        ),
      );
    } else {
      seenIds.add(node.id);
    }
  }

  void _checkType(UidlNode node, List<ValidationIssue> issues) {
    final dot = node.type.indexOf('.');
    final valid =
        dot > 0 && dot < node.type.length - 1 && !node.type.contains(' ');
    if (!valid) {
      issues.add(
        ValidationIssue.error(
          'Invalid node type "${node.type}". Must be "namespace.name".',
          nodeId: node.id,
          field: 'type',
        ),
      );
    }
  }

  void _checkTokenRefs(
      UidlNode node, List<ValidationIssue> issues, DesignTokens tokens) {
    for (final entry in node.props.entries) {
      final value = entry.value;
      if (value is String && TokenRef.isTokenRef(value)) {
        final resolved = tokens.resolve(value);
        if (resolved == null) {
          issues.add(
            ValidationIssue.error(
              'Token reference "$value" cannot be resolved.',
              nodeId: node.id,
              field: entry.key,
            ),
          );
        }
      }
    }
  }

  void _checkRequiredProps(UidlNode node, List<ValidationIssue> issues) {
    final reg = registry;
    if (reg == null) return;
    final definition = reg.lookup(node.type);
    if (definition == null) return;
    final missing = definition.missingRequired(node.props);
    for (final prop in missing) {
      issues.add(
        ValidationIssue.error(
          'Required prop "${prop.name}" is missing on "${node.type}".',
          nodeId: node.id,
          field: prop.name,
        ),
      );
    }
  }
}
