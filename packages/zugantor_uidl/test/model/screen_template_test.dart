import 'package:test/test.dart';
import 'package:zugantor_uidl/zugantor_uidl.dart';

void main() {
  final rootJson = <String, dynamic>{
    'uidl_version': '1.0',
    'screen_id': 'home',
    'title': 'Home Screen',
    'layout': {
      'type': 'layout.column',
      'id': 'col_root',
      'props': <String, dynamic>{},
      'bind': <String, dynamic>{},
      'children': [
        {
          'type': 'display.text',
          'id': 'txt_1',
          'props': {'content': 'Hello'},
          'bind': <String, dynamic>{},
          'children': <dynamic>[],
        },
        {
          'type': 'display.image',
          'id': 'img_1',
          'props': {'src': 'https://example.com/a.png'},
          'bind': <String, dynamic>{},
          'children': <dynamic>[],
        },
      ],
    },
  };

  group('ScreenTemplate', () {
    test('fromJson parses all top-level fields', () {
      final screen = ScreenTemplate.fromJson(rootJson);
      expect(screen.uidlVersion, '1.0');
      expect(screen.screenId, 'home');
      expect(screen.title, 'Home Screen');
      expect(screen.layout.type, 'layout.column');
    });

    test('toJson round-trips correctly', () {
      final screen = ScreenTemplate.fromJson(rootJson);
      final copy = ScreenTemplate.fromJson(screen.toJson());
      expect(copy.screenId, screen.screenId);
      expect(copy.layout.id, screen.layout.id);
      expect(copy.layout.children, hasLength(2));
    });

    test('allNodes returns all nodes depth-first', () {
      final screen = ScreenTemplate.fromJson(rootJson);
      final ids = screen.allNodes.map((n) => n.id).toList();
      expect(ids, ['col_root', 'txt_1', 'img_1']);
    });

    test('findNodeById locates a nested node', () {
      final screen = ScreenTemplate.fromJson(rootJson);
      final node = screen.findNodeById('img_1');
      expect(node?.type, 'display.image');
    });

    test('findNodeById returns null for unknown id', () {
      final screen = ScreenTemplate.fromJson(rootJson);
      expect(screen.findNodeById('nope'), isNull);
    });

    test('copyWith preserves unchanged fields', () {
      final screen = ScreenTemplate.fromJson(rootJson);
      final copy = screen.copyWith(title: 'New Title');
      expect(copy.title, 'New Title');
      expect(copy.screenId, 'home');
    });
  });
}
