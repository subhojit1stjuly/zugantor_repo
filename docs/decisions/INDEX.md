# ADR Index — Zugantor Architecture Decisions

> Read this at the start of every session before making or discussing decisions.
> If a decision is not in this index, it is not locked.

---

| ADR | Title | Status |
|---|---|---|
| [ADR-001](ADR-001-uidl-type-taxonomy.md) | UIDL Type Taxonomy: Generic Primitives | Accepted |
| [ADR-002](ADR-002-design-tokens.md) | Design Tokens: Separate Files, `@` References | Accepted |
| [ADR-003](ADR-003-renderer-codegen-separation.md) | Renderer and Code Generator Are Independent | Accepted |
| [ADR-004](ADR-004-component-registry.md) | Custom Design Systems via Component Registry | Accepted |
| [ADR-005](ADR-005-mock-data-backend.md) | Backend = Dummy Mock Data in v1 | Accepted |

---

## One-line Summary of Each Decision

- **ADR-001** — Types use `namespace.name` (e.g. `layout.column`, `display.text`). Four built-in namespaces: `layout`, `display`, `input`, `data`. Custom types use any other namespace (e.g. `zds.button`).
- **ADR-002** — Screens never contain hard-coded colors/sizes. Token files live in `design/`. References use `@colors.primary`, `@spacing.lg`, `@typography.heading_1`, `@radius.md`.
- **ADR-003** — `zugantor_renderer` (UIDL→Flutter widgets) and `zugantor_codegen` (UIDL→source code) are separate packages. Neither depends on the other.
- **ADR-004** — The renderer has a pluggable `ComponentRegistry`. ZDS is just one implementation. Unknown types render as annotated placeholders.
- **ADR-005** — No real API or backend in v1. Each screen has a `.mock.json` file. Bind expressions (`$.user.name`) resolve against that mock object.

---

## Open Questions (not yet decided)

| # | Question | Blocks |
|---|---|---|
| OQ-01 | Full UIDL primitive catalogue — all types and their props | Phase 1, 2 |
| OQ-02 | Bind expression operators — equality, negation, string formatting? | Phase 1 |
| OQ-03 | `on_tap` action model in v1 — named strings only or built-in `navigate_to`? | Phase 1, 2 |
| OQ-04 | Component Definition Schema full spec | Phase 1, 7 |
| OQ-05 | Registry API — global singleton or scoped instance? | Phase 2 |
