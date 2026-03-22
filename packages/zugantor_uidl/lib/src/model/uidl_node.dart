import 'package:meta/meta.dart';

/// A single node in a UIDL widget tree.
///
/// Every node has a [type] (`namespace.name`), a unique [id], optional
/// static [props], optional data [bind] expressions, and optional [children].
///
/// Example JSON:
/// ```json
/// {
///   "type": "layout.column",
///   "id": "root_col",
///   "props": { "gap": "@spacing.md", "padding": "@spacing.lg" },
///   "bind": { "visible": "$.user.is_logged_in" },
///   "children": []
/// }
/// ```
@immutable
class UidlNode {
  /// Creates a [UidlNode].
  const UidlNode({
    required this.type,
    required this.id,
    this.props = const {},
    this.bind = const {},
    this.children = const [],
    this.itemTemplate,
  });

  /// The component type in `namespace.name` format.
  ///
  /// Built-in namespaces: `layout`, `display`, `input`, `data`.
  /// Custom namespaces: any other prefix (e.g. `zds.button`, `myds.card`).
  final String type;

  /// Unique identifier for this node within the screen.
  ///
  /// Must be non-empty and unique within the screen template.
  /// Format: `snake_case`, e.g. `hero_title`, `cta_button`.
  final String id;

  /// Static configuration props for this node.
  ///
  /// Values may be concrete (`16`) or token references (`@spacing.md`).
  /// Keys are platform-neutral prop names defined in the UIDL spec.
  final Map<String, Object?> props;

  /// Data binding expressions for this node.
  ///
  /// Keys mirror prop names. Values are JSONPath expressions resolved
  /// against the screen's data map at render time (e.g. `$.user.name`).
  /// Bind values override the corresponding static prop at render time.
  final Map<String, String> bind;

  /// Child nodes. Only valid for container types (e.g. `layout.column`).
  final List<UidlNode> children;

  /// Item template for `data.list` nodes.
  ///
  /// This node is rendered once per item in the `bind.source` array.
  /// Use `$.item.<field>` to reference the current item's fields.
  final UidlNode? itemTemplate;

  /// Returns the namespace portion of [type] (e.g. `"layout"`).
  String get namespace {
    final dot = type.indexOf('.');
    return dot == -1 ? type : type.substring(0, dot);
  }

  /// Returns the name portion of [type] (e.g. `"column"`).
  String get name {
    final dot = type.indexOf('.');
    return dot == -1 ? '' : type.substring(dot + 1);
  }

  /// Whether this node is a UIDL primitive (built-in namespace).
  bool get isPrimitive =>
      const {'layout', 'display', 'input', 'data'}.contains(namespace);

  /// Creates a copy of this node with the given field overrides.
  UidlNode copyWith({
    String? type,
    String? id,
    Map<String, Object?>? props,
    Map<String, String>? bind,
    List<UidlNode>? children,
    UidlNode? itemTemplate,
  }) {
    return UidlNode(
      type: type ?? this.type,
      id: id ?? this.id,
      props: props ?? this.props,
      bind: bind ?? this.bind,
      children: children ?? this.children,
      itemTemplate: itemTemplate ?? this.itemTemplate,
    );
  }

  /// Deserialises a [UidlNode] from a JSON map.
  factory UidlNode.fromJson(Map<String, dynamic> json) {
    return UidlNode(
      type: json['type'] as String,
      id: json['id'] as String,
      props:
          (json['props'] as Map<String, dynamic>?)?.cast<String, Object?>() ??
              {},
      bind:
          (json['bind'] as Map<String, dynamic>?)?.cast<String, String>() ?? {},
      children: (json['children'] as List<dynamic>?)
              ?.map((e) => UidlNode.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      itemTemplate: json['item_template'] == null
          ? null
          : UidlNode.fromJson(json['item_template'] as Map<String, dynamic>),
    );
  }

  /// Serialises this node to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'id': id,
      if (props.isNotEmpty) 'props': props,
      if (bind.isNotEmpty) 'bind': bind,
      if (children.isNotEmpty)
        'children': children.map((c) => c.toJson()).toList(),
      if (itemTemplate != null) 'item_template': itemTemplate!.toJson(),
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UidlNode &&
          runtimeType == other.runtimeType &&
          type == other.type &&
          id == other.id;

  /// Returns the first node whose [id] matches [nodeId] in a depth-first
  /// search of this node and all its descendants, including [itemTemplate].
  ///
  /// Returns `null` if no matching node is found.
  UidlNode? findNodeById(String nodeId) {
    if (id == nodeId) return this;
    for (final child in children) {
      final found = child.findNodeById(nodeId);
      if (found != null) return found;
    }
    return itemTemplate?.findNodeById(nodeId);
  }

  @override
  int get hashCode => Object.hash(type, id);

  @override
  String toString() => 'UidlNode(type: $type, id: $id)';
}
