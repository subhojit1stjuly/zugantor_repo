# ADR-001 — UIDL Type Taxonomy: Generic Primitives

| Field | Value |
|---|---|
| Status | **Accepted** |
| Date | March 2026 |
| Supersedes | — |

---

## Context

The UIDL JSON must describe UI intent in a way that can be translated to Flutter, SwiftUI,
Jetpack Compose, and Next.js. Using Flutter-specific type names (e.g. `Column`, `Padding`,
`mainAxisAlignment`) would embed platform bias into the data contract and make future
multi-platform code generation either impossible or require lossy remapping.

---

## Decision

All node types use a **`namespace.name`** format. Two tiers exist:

### Tier 1 — UIDL Primitives (built-in)

These are implemented directly by `zugantor_renderer` and translated by every code generator.

| Namespace | Types |
|---|---|
| `layout` | `column`, `row`, `stack`, `scroll`, `grid`, `spacer`, `padding` |
| `display` | `text`, `image`, `icon`, `divider`, `card`, `avatar`, `badge` |
| `input` | `button`, `text_field`, `checkbox`, `switch`, `select`, `slider` |
| `data` | `list`, `conditional` |

### Tier 2 — Custom Components (user-registered)

Any type whose namespace is not one of the four above is treated as a custom component:
- `zds.button` — Zugantor Design System
- `myds.product_tile` — user's own design system

Custom types must be registered in a `ComponentRegistry` at runtime.
The renderer shows a **styled placeholder** for unregistered types.

### Type string rules

- Always lowercase `snake_case` in both parts: `layout.column`, `input.text_field`
- No dots except the single separator: `layout.column` ✓, `layout.my.column` ✗
- Primitive namespaces are reserved: `layout`, `display`, `input`, `data`

---

## Consequences

- **Enables:** Clean multi-platform code generation. Each generator maps `layout.column` → `Column` / `VStack` / `Column` / `div flex-col` independently.
- **Enables:** The renderer and code generators are completely decoupled from user code.
- **Constrains:** Users must learn the UIDL primitive names rather than Flutter's native widget names.
- **Constrains:** The complete primitive catalogue must be specced before Phase 1 ships (OQ-01).
