# ADR-004 — Custom Design Systems via Component Registry

| Field | Value |
|---|---|
| Status | **Accepted** |
| Date | March 2026 |
| Supersedes | — |

---

## Context

The initial plan was to hard-code ZDS (Zugantor Design System) components into the renderer.
After discussion, the requirement expanded: any Flutter design system should be usable with
`zugantor_sdui`. The renderer must be decoupled from any specific component library.

---

## Decision

The renderer uses a **`ComponentRegistry`** — a map of type slugs to builder functions.
ZDS is just one implementation of a registry. Users can supply their own.

### Registry API (scoped instance — not global singleton)

```dart
final registry = ComponentRegistry()
  ..register(
    'zds.button',
    (props, children, data) => ZdsButton(
      label: props['label'] as String,
    ),
  );

SduiRenderer(
  node: rootNode,
  tokens: designTokens,
  registry: registry,
  data: mockData,
)
```

The registry is **passed in** to `SduiRenderer` — it is not a global singleton.
This makes it testable and composable (e.g. merge ZDS registry + user registry).

### Unknown type behaviour

If a type slug is not in the registry, the renderer emits a **`UnknownComponentPlaceholder`**:
- Shows the type name (`myds.product_tile`)
- Lists all props as key-value pairs
- Styled with a distinct border so it is visually obvious

This means the builder works with partially-registered component sets — useful during
development.

### `ComponentDefinition`

Every component registered in the registry has a `ComponentDefinition`:
- `type` — the type slug
- `displayName` — shown in the palette
- `category` — groups components in the palette
- `acceptsChildren` — whether this component can have children
- `propSchema` — list of `PropDefinition` (name, type, required, default)

`ComponentDefinition` is used by the builder (palette, property inspector, AI prompt, validator).
The builder-side registry holds definitions. The renderer-side registry holds builder functions.

---

## Consequences

- **Enables:** `zugantor_renderer` works with any Flutter design system, not just ZDS.
- **Enables:** The builder can be extended to understand any design system via a manifest import.
- **Enables:** Partial registration — unknown components degrade gracefully.
- **Constrains:** ZDS components must be registered explicitly; they are not auto-discovered.
- **Constrains:** The `ComponentDefinition` schema must be finalised before Phase 1 ships (OQ-04).
