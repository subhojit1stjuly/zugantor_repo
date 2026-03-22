import 'package:meta/meta.dart';

/// Supported primitive value types for component props.
///
/// See ADR-004 for the full `ComponentDefinition` / `PropDefinition` contract.
enum PropType {
  /// A plain text string.
  string,

  /// An integer number.
  integer,

  /// A floating-point number.
  double_,

  /// A boolean flag.
  bool_,

  /// A reference to a design token color (resolved via `@colors.*`).
  color,

  /// A reference to a design token spacing value (resolved via `@spacing.*`).
  spacing,

  /// A reference to a design token typography style (resolved via
  /// `@typography.*`).
  typography,

  /// A reference to a design token radius value (resolved via `@radius.*`).
  radius,

  /// An enumerated string value. The set of valid values is in
  /// [PropDefinition.enumValues].
  enum_,

  /// An action callback (e.g. `onPressed`). Value is a string action key.
  action,
}

/// Declares a single prop that a component accepts.
///
/// Used by the renderer to validate incoming props at load time and by the
/// editor surface to render the correct input control in the properties panel.
@immutable
class PropDefinition {
  /// Creates a [PropDefinition].
  const PropDefinition({
    required this.name,
    required this.type,
    this.isRequired = false,
    this.defaultValue,
    this.enumValues = const [],
    this.description,
  });

  /// The prop key as it appears in the `props` map of a [UidlNode].
  final String name;

  /// The primitive type of this prop.
  final PropType type;

  /// Whether this prop must be set for the component to render correctly.
  final bool isRequired;

  /// Value used by the renderer when the prop is absent.
  final Object? defaultValue;

  /// Valid string values when [type] is [PropType.enum_].
  final List<String> enumValues;

  /// Human-readable hint shown in the editor properties panel.
  final String? description;

  /// Deserialises a [PropDefinition] from JSON.
  factory PropDefinition.fromJson(Map<String, dynamic> json) {
    return PropDefinition(
      name: json['name'] as String,
      type: PropType.values.byName(json['type'] as String),
      isRequired: json['isRequired'] as bool? ?? false,
      defaultValue: json['default_value'],
      enumValues: (json['enum_values'] as List<dynamic>? ?? []).cast<String>(),
      description: json['description'] as String?,
    );
  }

  /// Serialises this [PropDefinition] to JSON.
  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type.name,
        if (isRequired) 'isRequired': isRequired,
        if (defaultValue != null) 'default_value': defaultValue,
        if (enumValues.isNotEmpty) 'enum_values': enumValues,
        if (description != null) 'description': description,
      };

  @override
  String toString() => 'PropDefinition($name: $type)';
}
