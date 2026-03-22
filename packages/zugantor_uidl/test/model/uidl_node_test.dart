import 'package:test/test.dart';
import 'package:zugantor_uidl/zugantor_uidl.dart';

void main() {
  group('UidlNode', () {
    final json = {
      'type': 'display.text',
      'id': 'txt_1',
      'props': {'content': 'Hello', 'color': '@colors.primary'},
      'bind': {'content': r'$.user.name'},
      'children': <dynamic>[
        {
          'type': 'display.icon',
          'id': 'ico_1',
          'props': <String, dynamic>{},
          'bind': <String, dynamic>{},
          'children': <dynamic>[],
        },
      ],
    };

    test('fromJson parses all fields', () {
      final node = UidlNode.fromJson(json);
      expect(node.type, 'display.text');
      expect(node.id, 'txt_1');
      expect(node.props['content'], 'Hello');
      expect(node.props['color'], '@colors.primary');
      expect(node.bind['content'], r'$.user.name');
      expect(node.children, hasLength(1));
      expect(node.children.first.type, 'display.icon');
    });

    test('toJson round-trips correctly', () {
      final node = UidlNode.fromJson(json);
      final roundTripped = UidlNode.fromJson(node.toJson());
      expect(roundTripped.type, node.type);
      expect(roundTripped.id, node.id);
      expect(roundTripped.props, node.props);
      expect(roundTripped.bind, node.bind);
      expect(roundTripped.children.first.id, node.children.first.id);
    });

    test('namespace and name getters split on first dot', () {
      final node = UidlNode.fromJson(json);
      expect(node.namespace, 'display');
      expect(node.name, 'text');
    });

    test('isPrimitive is true for built-in namespaces', () {
      for (final ns in ['layout', 'display', 'input', 'data']) {
        final n = UidlNode(type: '$ns.foo', id: 'x');
        expect(n.isPrimitive, isTrue, reason: 'namespace=$ns');
      }
    });

    test('isPrimitive is false for custom namespaces', () {
      final n = UidlNode(type: 'myds.button', id: 'btn');
      expect(n.isPrimitive, isFalse);
    });

    test('copyWith returns a new node with updated fields', () {
      final node =
          UidlNode(type: 'display.text', id: 'a', props: {'content': 'Hi'});
      final copy = node.copyWith(props: {'content': 'Bye'});
      expect(copy.id, 'a');
      expect(copy.props['content'], 'Bye');
      expect(node.props['content'], 'Hi'); // original unchanged
    });

    test('findNodeById returns self when id matches', () {
      final node = UidlNode(type: 'display.text', id: 'target');
      expect(node.findNodeById('target')?.id, 'target');
    });

    test('findNodeById searches children depth-first', () {
      final grandchild = UidlNode(type: 'display.text', id: 'gc');
      final child =
          UidlNode(type: 'layout.column', id: 'c', children: [grandchild]);
      final root =
          UidlNode(type: 'layout.column', id: 'root', children: [child]);
      expect(root.findNodeById('gc')?.id, 'gc');
    });

    test('findNodeById returns null when not found', () {
      final node = UidlNode(type: 'display.text', id: 'a');
      expect(node.findNodeById('missing'), isNull);
    });
  });
}
