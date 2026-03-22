import '../model/component_definition.dart';
import '../model/prop_definition.dart';

/// A scoped registry of [ComponentDefinition]s.
///
/// Every renderer and code-generator instance receives its own
/// [ComponentRegistry], pre-populated with the built-in primitives and
/// optionally extended with custom design-system components.
///
/// The registry is **not** a global singleton — it is constructed once and
/// passed explicitly to the renderer or validator. This ensures isolation
/// between different projects/design systems loaded at the same time.
///
/// See ADR-004 for the full registry contract.
class ComponentRegistry {
  ComponentRegistry._() : _definitions = {};

  final Map<String, ComponentDefinition> _definitions;

  /// Creates a [ComponentRegistry] pre-populated with the built-in primitive
  /// components only.
  factory ComponentRegistry.withBuiltins() {
    final registry = ComponentRegistry._();
    for (final def in _builtins) {
      registry._definitions[def.type] = def;
    }
    return registry;
  }

  /// Creates an empty [ComponentRegistry].
  ///
  /// Useful for testing or for scenarios where only custom components are
  /// registered.
  factory ComponentRegistry.empty() => ComponentRegistry._();

  /// Registers a [ComponentDefinition] under its [ComponentDefinition.type].
  ///
  /// If a definition with the same type already exists it is replaced.
  void register(ComponentDefinition definition) {
    _definitions[definition.type] = definition;
  }

  /// Registers a list of [ComponentDefinition]s.
  void registerAll(Iterable<ComponentDefinition> definitions) {
    for (final def in definitions) {
      register(def);
    }
  }

  /// Returns the [ComponentDefinition] for [type], or `null` if not registered.
  ComponentDefinition? lookup(String type) => _definitions[type];

  /// Returns `true` if [type] is registered.
  bool isRegistered(String type) => _definitions.containsKey(type);

  /// All registered definitions in undefined order.
  List<ComponentDefinition> get all => _definitions.values.toList();

  /// Returns all definitions whose [ComponentDefinition.category] matches
  /// [category].
  List<ComponentDefinition> byCategory(String category) =>
      _definitions.values.where((d) => d.category == category).toList();

  /// Total number of registered definitions.
  int get length => _definitions.length;
}

// ---------------------------------------------------------------------------
// Built-in primitive definitions (ADR-001)
// ---------------------------------------------------------------------------

const List<ComponentDefinition> _builtins = [
  // layout namespace
  ComponentDefinition(
    type: 'layout.column',
    displayName: 'Column',
    category: 'layout',
    acceptsChildren: true,
    propSchema: [
      PropDefinition(name: 'gap', type: PropType.spacing),
      PropDefinition(name: 'padding', type: PropType.spacing),
      PropDefinition(
        name: 'alignment',
        type: PropType.enum_,
        enumValues: ['start', 'center', 'end', 'stretch'],
        defaultValue: 'start',
      ),
      PropDefinition(
        name: 'crossAlignment',
        type: PropType.enum_,
        enumValues: ['start', 'center', 'end', 'stretch'],
        defaultValue: 'start',
      ),
    ],
    description: 'Lays out children vertically.',
  ),
  ComponentDefinition(
    type: 'layout.row',
    displayName: 'Row',
    category: 'layout',
    acceptsChildren: true,
    propSchema: [
      PropDefinition(name: 'gap', type: PropType.spacing),
      PropDefinition(name: 'padding', type: PropType.spacing),
      PropDefinition(
        name: 'alignment',
        type: PropType.enum_,
        enumValues: [
          'start',
          'center',
          'end',
          'spaceBetween',
          'spaceAround',
          'spaceEvenly'
        ],
        defaultValue: 'start',
      ),
      PropDefinition(
        name: 'crossAlignment',
        type: PropType.enum_,
        enumValues: ['start', 'center', 'end', 'stretch', 'baseline'],
        defaultValue: 'center',
      ),
    ],
    description: 'Lays out children horizontally.',
  ),
  ComponentDefinition(
    type: 'layout.stack',
    displayName: 'Stack',
    category: 'layout',
    acceptsChildren: true,
    propSchema: [
      PropDefinition(
        name: 'alignment',
        type: PropType.enum_,
        enumValues: [
          'topStart',
          'topCenter',
          'topEnd',
          'center',
          'bottomStart',
          'bottomEnd'
        ],
        defaultValue: 'topStart',
      ),
    ],
    description: 'Overlays children on top of each other.',
  ),
  ComponentDefinition(
    type: 'layout.container',
    displayName: 'Container',
    category: 'layout',
    acceptsChildren: true,
    propSchema: [
      PropDefinition(name: 'padding', type: PropType.spacing),
      PropDefinition(name: 'width', type: PropType.double_),
      PropDefinition(name: 'height', type: PropType.double_),
      PropDefinition(name: 'backgroundColor', type: PropType.color),
      PropDefinition(name: 'borderRadius', type: PropType.radius),
    ],
    description: 'A box with optional background, padding, and size.',
  ),
  ComponentDefinition(
    type: 'layout.spacer',
    displayName: 'Spacer',
    category: 'layout',
    acceptsChildren: false,
    propSchema: [
      PropDefinition(name: 'size', type: PropType.spacing),
    ],
    description: 'Adds fixed or flexible empty space.',
  ),

  // display namespace
  ComponentDefinition(
    type: 'display.text',
    displayName: 'Text',
    category: 'display',
    acceptsChildren: false,
    propSchema: [
      PropDefinition(name: 'content', type: PropType.string, isRequired: true),
      PropDefinition(name: 'style', type: PropType.typography),
      PropDefinition(name: 'color', type: PropType.color),
      PropDefinition(
        name: 'align',
        type: PropType.enum_,
        enumValues: ['left', 'center', 'right', 'justify'],
        defaultValue: 'left',
      ),
      PropDefinition(name: 'maxLines', type: PropType.integer),
    ],
    description: 'Renders a string of text.',
  ),
  ComponentDefinition(
    type: 'display.image',
    displayName: 'Image',
    category: 'display',
    acceptsChildren: false,
    propSchema: [
      PropDefinition(name: 'src', type: PropType.string, isRequired: true),
      PropDefinition(name: 'width', type: PropType.double_),
      PropDefinition(name: 'height', type: PropType.double_),
      PropDefinition(name: 'borderRadius', type: PropType.radius),
      PropDefinition(
        name: 'fit',
        type: PropType.enum_,
        enumValues: ['cover', 'contain', 'fill', 'none'],
        defaultValue: 'cover',
      ),
    ],
    description: 'Renders an image from a URL or asset path.',
  ),
  ComponentDefinition(
    type: 'display.icon',
    displayName: 'Icon',
    category: 'display',
    acceptsChildren: false,
    propSchema: [
      PropDefinition(name: 'name', type: PropType.string, isRequired: true),
      PropDefinition(name: 'size', type: PropType.double_),
      PropDefinition(name: 'color', type: PropType.color),
    ],
    description: 'Renders a named icon.',
  ),
  ComponentDefinition(
    type: 'display.divider',
    displayName: 'Divider',
    category: 'display',
    acceptsChildren: false,
    propSchema: [
      PropDefinition(name: 'color', type: PropType.color),
      PropDefinition(name: 'thickness', type: PropType.double_),
    ],
    description: 'A horizontal line separator.',
  ),

  // input namespace
  ComponentDefinition(
    type: 'input.button',
    displayName: 'Button',
    category: 'input',
    acceptsChildren: false,
    propSchema: [
      PropDefinition(name: 'label', type: PropType.string, isRequired: true),
      PropDefinition(name: 'onPressed', type: PropType.action),
      PropDefinition(name: 'backgroundColor', type: PropType.color),
      PropDefinition(name: 'textColor', type: PropType.color),
      PropDefinition(
        name: 'variant',
        type: PropType.enum_,
        enumValues: ['filled', 'outlined', 'text'],
        defaultValue: 'filled',
      ),
    ],
    description: 'A tappable button.',
  ),
  ComponentDefinition(
    type: 'input.text_field',
    displayName: 'Text Field',
    category: 'input',
    acceptsChildren: false,
    propSchema: [
      PropDefinition(name: 'placeholder', type: PropType.string),
      PropDefinition(name: 'label', type: PropType.string),
      PropDefinition(name: 'onChanged', type: PropType.action),
      PropDefinition(name: 'obscureText', type: PropType.bool_),
    ],
    description: 'A single-line text input.',
  ),
  ComponentDefinition(
    type: 'input.checkbox',
    displayName: 'Checkbox',
    category: 'input',
    acceptsChildren: false,
    propSchema: [
      PropDefinition(name: 'label', type: PropType.string),
      PropDefinition(name: 'checked', type: PropType.bool_),
      PropDefinition(name: 'onChanged', type: PropType.action),
    ],
    description: 'A boolean checkbox input.',
  ),

  // data namespace
  ComponentDefinition(
    type: 'data.list',
    displayName: 'List',
    category: 'data',
    acceptsChildren: false,
    propSchema: [
      PropDefinition(name: 'source', type: PropType.string, isRequired: true),
    ],
    description:
        'Renders a scrollable list. Requires an `item_template` child node '
        'and a `source` bind expression (e.g. `\$.products`).',
  ),
];
