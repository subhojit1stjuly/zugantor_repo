import 'package:test/test.dart';
import 'package:zugantor_uidl/zugantor_uidl.dart';

DesignTokens _makeTokens() => DesignTokens.fromJson(
      colorsJson: {
        'palette': {'purple_500': '#6C63FF', 'white': '#FFFFFF'},
        'semantic': {
          'primary': '@palette.purple_500',
          'surface': '@palette.white',
        },
      },
      spacingJson: {
        'scale': {'xs': 4, 'sm': 8, 'md': 16, 'lg': 24},
      },
      radiusJson: {
        'scale': {'sm': 4, 'md': 8, 'lg': 12, 'full': 9999},
      },
      typographyJson: {
        'families': {'inter': 'Inter'},
        'styles': {
          'heading_1': {
            'family': '@families.inter',
            'size': 32,
            'weight': 700,
            'height': 1.25,
          },
        },
      },
    );

void main() {
  group('DesignTokens.fromJson', () {
    test('resolves palette aliases in semantic color map', () {
      final tokens = _makeTokens();
      expect(tokens.colors['primary'], '#6C63FF');
      expect(tokens.colors['surface'], '#FFFFFF');
    });

    test('resolves spacing scale to doubles', () {
      final tokens = _makeTokens();
      expect(tokens.spacing['md'], 16.0);
      expect(tokens.spacing['lg'], 24.0);
    });

    test('resolves radius scale to doubles', () {
      final tokens = _makeTokens();
      expect(tokens.radius['full'], 9999.0);
    });

    test('resolves @families alias in typography styles', () {
      final tokens = _makeTokens();
      expect(tokens.typography['heading_1']?['family'], 'Inter');
    });

    test('DesignTokens.empty has no tokens', () {
      expect(DesignTokens.empty.colors, isEmpty);
      expect(DesignTokens.empty.spacing, isEmpty);
    });
  });

  group('DesignTokens.resolve', () {
    late DesignTokens tokens;
    setUp(() => tokens = _makeTokens());

    test('resolves @colors reference', () {
      expect(tokens.resolve('@colors.primary'), '#6C63FF');
    });

    test('resolves @spacing reference', () {
      expect(tokens.resolve('@spacing.lg'), 24.0);
    });

    test('resolves @radius reference', () {
      expect(tokens.resolve('@radius.md'), 8.0);
    });

    test('returns null for unknown token', () {
      expect(tokens.resolve('@colors.nonexistent'), isNull);
    });

    test('returns null for unknown category', () {
      expect(tokens.resolve('@shadows.lg'), isNull);
    });

    test('isTokenRef returns true for valid refs', () {
      expect(DesignTokens.isTokenRef('@colors.primary'), isTrue);
    });

    test('isTokenRef returns false for non-refs', () {
      expect(DesignTokens.isTokenRef('#FF0000'), isFalse);
      expect(DesignTokens.isTokenRef('plain string'), isFalse);
    });
  });

  group('TokenRef', () {
    test('tryParse parses a valid @category.name string', () {
      final ref = TokenRef.tryParse('@spacing.md');
      expect(ref?.category, 'spacing');
      expect(ref?.name, 'md');
    });

    test('tryParse returns null for non-ref strings', () {
      expect(TokenRef.tryParse('not a ref'), isNull);
      expect(TokenRef.tryParse('@noname'), isNull);
    });

    test('ref getter reconstructs the original string', () {
      final ref = TokenRef.tryParse('@colors.primary')!;
      expect(ref.ref, '@colors.primary');
    });

    test('equality by value', () {
      final a = TokenRef.tryParse('@spacing.md')!;
      final b = TokenRef.tryParse('@spacing.md')!;
      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
    });
  });

  group('TokenResolver', () {
    late TokenResolver resolver;
    setUp(() => resolver = TokenResolver(tokens: _makeTokens()));

    test('resolveValue substitutes @colors ref', () {
      expect(resolver.resolveValue('@colors.primary'), '#6C63FF');
    });

    test('resolveValue passes non-ref strings through unchanged', () {
      expect(resolver.resolveValue('Hello world'), 'Hello world');
    });

    test('resolveValue passes numeric values through unchanged', () {
      expect(resolver.resolveValue(42), 42);
    });

    test('resolveValue preserves unresolvable ref (for validator to flag)', () {
      expect(resolver.resolveValue('@colors.missing'), '@colors.missing');
    });

    test('resolveProps resolves all string values in map', () {
      final props = <String, Object?>{
        'color': '@colors.primary',
        'padding': '@spacing.md',
        'label': 'Click me',
      };
      final resolved = resolver.resolveProps(props);
      expect(resolved['color'], '#6C63FF');
      expect(resolved['padding'], 16.0);
      expect(resolved['label'], 'Click me');
    });

    test('canResolve returns true for known refs', () {
      expect(resolver.canResolve('@spacing.xs'), isTrue);
    });

    test('canResolve returns false for unknown refs', () {
      expect(resolver.canResolve('@spacing.xxl'), isFalse);
    });
  });
}
