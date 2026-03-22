import 'package:meta/meta.dart';

import 'uidl_node.dart';

/// A complete screen template — the top-level unit of a UIDL project.
///
/// A screen template is stored as a single JSON file (e.g. `home_screen.json`)
/// alongside a companion mock data file (`home_screen.mock.json`).
///
/// Example JSON:
/// ```json
/// {
///   "uidl_version": "1",
///   "screen_id": "home_screen",
///   "title": "Home",
///   "layout": { ... }
/// }
/// ```
@immutable
class ScreenTemplate {
  /// Creates a [ScreenTemplate].
  const ScreenTemplate({
    required this.uidlVersion,
    required this.screenId,
    required this.title,
    required this.layout,
  });

  /// The UIDL schema version. Currently `"1"`.
  final String uidlVersion;

  /// Unique identifier for this screen within the project.
  ///
  /// Used as the filename stem (`home_screen.json`), as the route identifier,
  /// and as the class name base for code generation.
  final String screenId;

  /// Human-readable display name shown in the screens panel and export.
  final String title;

  /// The root node of this screen's widget tree.
  final UidlNode layout;

  /// Creates a copy with the given field overrides.
  ScreenTemplate copyWith({
    String? uidlVersion,
    String? screenId,
    String? title,
    UidlNode? layout,
  }) {
    return ScreenTemplate(
      uidlVersion: uidlVersion ?? this.uidlVersion,
      screenId: screenId ?? this.screenId,
      title: title ?? this.title,
      layout: layout ?? this.layout,
    );
  }

  /// Deserialises a [ScreenTemplate] from a JSON map.
  factory ScreenTemplate.fromJson(Map<String, dynamic> json) {
    return ScreenTemplate(
      uidlVersion: json['uidl_version'] as String,
      screenId: json['screen_id'] as String,
      title: json['title'] as String,
      layout: UidlNode.fromJson(json['layout'] as Map<String, dynamic>),
    );
  }

  /// Serialises this screen template to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'uidl_version': uidlVersion,
      'screen_id': screenId,
      'title': title,
      'layout': layout.toJson(),
    };
  }

  /// Collects all nodes in the tree via depth-first traversal.
  List<UidlNode> get allNodes {
    final result = <UidlNode>[];
    void visit(UidlNode node) {
      result.add(node);
      for (final child in node.children) {
        visit(child);
      }
      if (node.itemTemplate != null) visit(node.itemTemplate!);
    }

    visit(layout);
    return result;
  }

  /// Returns the node with the given [id], or `null` if not found.
  UidlNode? findNodeById(String id) {
    for (final node in allNodes) {
      if (node.id == id) return node;
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenTemplate &&
          runtimeType == other.runtimeType &&
          screenId == other.screenId &&
          uidlVersion == other.uidlVersion;

  @override
  int get hashCode => Object.hash(screenId, uidlVersion);

  @override
  String toString() =>
      'ScreenTemplate(screenId: $screenId, version: $uidlVersion)';
}
