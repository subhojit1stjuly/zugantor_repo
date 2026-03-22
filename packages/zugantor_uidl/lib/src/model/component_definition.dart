import 'package:meta/meta.dart';

import 'prop_definition.dart';

/// Describes a registered component and the props it accepts.
///
/// Built-in primitive components (e.g. `layout.column`) are registered
/// automatically by the default [ComponentRegistry]. Custom design-system
/// components are registered via [ComponentRegistry.register] using a
/// [ComponentDefinition] sourced from the design system's manifest.
///
/// See ADR-004 for the full registry contract.
@immutable
class ComponentDefinition {
  /// Creates a [ComponentDefinition].
  const ComponentDefinition({
    required this.type,
    required this.displayName,
    this.category = 'custom',
    this.acceptsChildren = false,
    this.propSchema = const [],
    this.description,
  });

  /// Fully qualified type string in `namespace.name` format, e.g.
  /// `layout.column` or `myds.button`.
  final String type;

  /// Human-readable label shown in the editor component picker.
  final String displayName;

  /// Category used to group components in the panel.
  ///
  /// Built-in categories are `layout`, `display`, `input`, `data`.
  /// Custom design-system components may declare any category string.
  final String category;

  /// Whether this component renders child [UidlNode]s.
  ///
  /// When `false` the renderer ignores the `children` list and the editor
  /// prevents nesting child nodes on the canvas.
  final bool acceptsChildren;

  /// Ordered list of props this component accepts.
  final List<PropDefinition> propSchema;

  /// Optional description shown in the editor component picker tooltip.
  final String? description;

  /// Convenience accessor — returns the [PropDefinition] for [name], or
  /// `null` if no such prop is declared.
  PropDefinition? propFor(String name) {
    for (final p in propSchema) {
      if (p.name == name) return p;
    }
    return null;
  }

  /// Returns all required props that are missing from [props].
  List<PropDefinition> missingRequired(Map<String, Object?> props) {
    return propSchema
        .where((p) => p.isRequired && !props.containsKey(p.name))
        .toList();
  }

  /// Deserialises a [ComponentDefinition] from JSON.
  factory ComponentDefinition.fromJson(Map<String, dynamic> json) {
    return ComponentDefinition(
      type: json['type'] as String,
      displayName: json['display_name'] as String,
      category: json['category'] as String? ?? 'custom',
      acceptsChildren: json['accepts_children'] as bool? ?? false,
      propSchema: (json['prop_schema'] as List<dynamic>? ?? [])
          .map((e) => PropDefinition.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String?,
    );
  }

  /// Serialises this [ComponentDefinition] to JSON.
  Map<String, dynamic> toJson() => {
        'type': type,
        'display_name': displayName,
        if (category != 'custom') 'category': category,
        if (acceptsChildren) 'accepts_children': acceptsChildren,
        if (propSchema.isNotEmpty)
          'prop_schema': propSchema.map((p) => p.toJson()).toList(),
        if (description != null) 'description': description,
      };

  @override
  String toString() => 'ComponentDefinition($type)';
}
