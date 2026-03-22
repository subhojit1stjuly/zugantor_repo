import 'package:meta/meta.dart';

/// Severity level of a [ValidationIssue].
enum ValidationSeverity {
  /// The screen cannot be rendered or code-generated correctly.
  error,

  /// The screen will render but the output may not match the intended design.
  warning,
}

/// A single problem found during UIDL validation.
@immutable
class ValidationIssue {
  /// Creates a [ValidationIssue].
  const ValidationIssue({
    required this.severity,
    required this.message,
    this.nodeId,
    this.field,
  });

  /// How serious this issue is.
  final ValidationSeverity severity;

  /// Human-readable description of the problem.
  final String message;

  /// The [UidlNode.id] of the node where the issue was found, if applicable.
  final String? nodeId;

  /// The prop or field name where the issue was found, if applicable.
  final String? field;

  /// Convenience constructor for error-severity issues.
  const ValidationIssue.error(
    String message, {
    String? nodeId,
    String? field,
  }) : this(
          severity: ValidationSeverity.error,
          message: message,
          nodeId: nodeId,
          field: field,
        );

  /// Convenience constructor for warning-severity issues.
  const ValidationIssue.warning(
    String message, {
    String? nodeId,
    String? field,
  }) : this(
          severity: ValidationSeverity.warning,
          message: message,
          nodeId: nodeId,
          field: field,
        );

  @override
  String toString() {
    final loc = [
      if (nodeId != null) 'node=$nodeId',
      if (field != null) 'field=$field'
    ].join(', ');
    return '[$severity]${loc.isNotEmpty ? ' ($loc)' : ''} $message';
  }
}

/// The result of validating a [ScreenTemplate].
///
/// Check [isValid] first, then inspect [errors] and [warnings] as needed.
@immutable
class ValidationResult {
  /// Creates a [ValidationResult] from the given [issues] list.
  const ValidationResult(this.issues);

  /// An empty result with no issues — represents a fully valid screen.
  static const ValidationResult valid = ValidationResult([]);

  /// All issues found during validation.
  final List<ValidationIssue> issues;

  /// Returns `true` when there are no [ValidationSeverity.error] issues.
  bool get isValid =>
      issues.every((i) => i.severity != ValidationSeverity.error);

  /// All error-severity issues.
  List<ValidationIssue> get errors =>
      issues.where((i) => i.severity == ValidationSeverity.error).toList();

  /// All warning-severity issues.
  List<ValidationIssue> get warnings =>
      issues.where((i) => i.severity == ValidationSeverity.warning).toList();

  @override
  String toString() => issues.isEmpty
      ? 'ValidationResult(valid)'
      : 'ValidationResult(${errors.length} error(s), ${warnings.length} warning(s))';
}
