import 'package:test/test.dart';
import 'package:zugantor_uidl/zugantor_uidl.dart';

DesignTokens _tokens() => DesignTokens.fromJson(
      colorsJson: {
        'palette': {'purple': '#6C63FF'},
        'semantic': {'primary': '@palette.purple'},
      },
      spacingJson: {
        'scale': {'md': 16}
      },
      radiusJson: {
        'scale': {'sm': 4}
      },
    );

ScreenTemplate _screen({String? duplicateId}) {
  final child = UidlNode(
    type: 'display.text',
    id: duplicateId ?? 'txt_1',
    props: {'content': 'Hello', 'color': '@colors.primary'},
  );
  final layout = UidlNode(
    type: 'layout.column',
    id: 'col_root',
    children: [child],
  );
  return ScreenTemplate(
    uidlVersion: '1.0',
    screenId: 'home',
    title: 'Home',
    layout: layout,
  );
}

void main() {
  group('UidlValidator', () {
    final validator = UidlValidator();

    test('valid screen returns isValid=true with no issues', () {
      final result = validator.validate(_screen(), _tokens());
      expect(result.isValid, isTrue);
      expect(result.issues, isEmpty);
    });

    test('duplicate node ids produce an error', () {
      // col_root and txt_1 both get the same id via duplicateId
      final layout = UidlNode(
        type: 'layout.column',
        id: 'col_root',
        children: [
          UidlNode(
              type: 'display.text', id: 'col_root', props: {'content': 'Hi'}),
        ],
      );
      final screen = ScreenTemplate(
        uidlVersion: '1.0',
        screenId: 's',
        title: 'S',
        layout: layout,
      );
      final result = validator.validate(screen, _tokens());
      expect(result.isValid, isFalse);
      expect(result.errors.any((e) => e.message.contains('Duplicate')), isTrue);
    });

    test('empty node id produces an error', () {
      final layout = UidlNode(
        type: 'layout.column',
        id: 'root',
        children: [
          UidlNode(type: 'display.text', id: '', props: {'content': 'Hi'}),
        ],
      );
      final screen = ScreenTemplate(
        uidlVersion: '1.0',
        screenId: 's',
        title: 'S',
        layout: layout,
      );
      final result = validator.validate(screen, _tokens());
      expect(result.isValid, isFalse);
      expect(result.errors.any((e) => e.message.contains('empty id')), isTrue);
    });

    test('invalid type format produces an error', () {
      final layout = UidlNode(type: 'bad-type', id: 'n1');
      final screen = ScreenTemplate(
        uidlVersion: '1.0',
        screenId: 's',
        title: 'S',
        layout: layout,
      );
      final result = validator.validate(screen, _tokens());
      expect(result.isValid, isFalse);
      expect(
        result.errors.any((e) => e.message.contains('Invalid node type')),
        isTrue,
      );
    });

    test('unresolvable token reference produces an error', () {
      final layout = UidlNode(
        type: 'layout.column',
        id: 'root',
        children: [
          UidlNode(
            type: 'display.text',
            id: 'txt',
            props: {'content': 'Hi', 'color': '@colors.nonexistent'},
          ),
        ],
      );
      final screen = ScreenTemplate(
        uidlVersion: '1.0',
        screenId: 's',
        title: 'S',
        layout: layout,
      );
      final result = validator.validate(screen, _tokens());
      expect(result.isValid, isFalse);
      expect(
        result.errors.any((e) => e.message.contains('cannot be resolved')),
        isTrue,
      );
    });

    test('missing required prop is detected when registry is provided', () {
      final registry = ComponentRegistry.withBuiltins();
      final validatorWithRegistry = UidlValidator(registry: registry);
      // display.text requires 'content'
      final layout = UidlNode(
        type: 'layout.column',
        id: 'root',
        children: [
          UidlNode(type: 'display.text', id: 'txt', props: {}),
        ],
      );
      final screen = ScreenTemplate(
        uidlVersion: '1.0',
        screenId: 's',
        title: 'S',
        layout: layout,
      );
      final result = validatorWithRegistry.validate(screen, _tokens());
      expect(result.isValid, isFalse);
      expect(
        result.errors.any((e) => e.message.contains('"content" is missing')),
        isTrue,
      );
    });
  });

  group('ValidationResult', () {
    test('valid is empty and isValid', () {
      expect(ValidationResult.valid.isValid, isTrue);
      expect(ValidationResult.valid.issues, isEmpty);
    });

    test('isValid is false when errors exist', () {
      final result = ValidationResult([
        const ValidationIssue.error('Something broke'),
      ]);
      expect(result.isValid, isFalse);
    });

    test('isValid is true when only warnings', () {
      final result = ValidationResult([
        const ValidationIssue.warning('Minor issue'),
      ]);
      expect(result.isValid, isTrue);
    });

    test('errors and warnings are separated correctly', () {
      final result = ValidationResult([
        const ValidationIssue.error('Err'),
        const ValidationIssue.warning('Warn'),
      ]);
      expect(result.errors, hasLength(1));
      expect(result.warnings, hasLength(1));
    });
  });

  group('ComponentRegistry', () {
    test('withBuiltins registers all primitive namespaces', () {
      final reg = ComponentRegistry.withBuiltins();
      expect(reg.isRegistered('layout.column'), isTrue);
      expect(reg.isRegistered('display.text'), isTrue);
      expect(reg.isRegistered('input.button'), isTrue);
      expect(reg.isRegistered('data.list'), isTrue);
    });

    test('register overrides existing definition', () {
      final reg = ComponentRegistry.withBuiltins();
      final custom = ComponentDefinition(
        type: 'display.text',
        displayName: 'Custom Text',
        category: 'display',
      );
      reg.register(custom);
      expect(reg.lookup('display.text')?.displayName, 'Custom Text');
    });

    test('lookup returns null for unregistered type', () {
      final reg = ComponentRegistry.empty();
      expect(reg.lookup('myds.button'), isNull);
    });

    test('byCategory returns only matching definitions', () {
      final reg = ComponentRegistry.withBuiltins();
      final layoutDefs = reg.byCategory('layout');
      expect(layoutDefs.every((d) => d.category == 'layout'), isTrue);
      expect(layoutDefs, isNotEmpty);
    });

    test('empty registry has no entries', () {
      final reg = ComponentRegistry.empty();
      expect(reg.length, 0);
      expect(reg.all, isEmpty);
    });
  });
}
