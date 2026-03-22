# Zugantor — Product Roadmap

> Last updated: March 2026 · Branch: `feature/sdui`

This document is the authoritative product roadmap for the Zugantor platform. It captures all
architectural decisions made to date and maps them to a phased delivery plan.

---

## Vision

Zugantor is a **Platform-Agnostic UI Description Language (UIDL) toolchain**. It lets teams
design entire application screens — and, eventually, full applications — without writing
platform-specific code. The output is a set of platform-neutral JSON files that code generators
translate into Flutter, SwiftUI, Jetpack Compose, or Next.js.

```
Design once (UIDL JSON)
  ├─► Flutter (Dart)
  ├─► SwiftUI (Swift)          [future]
  ├─► Jetpack Compose (Kotlin) [future]
  └─► Next.js (TSX)            [future]
```

---

## Locked Architectural Decisions

These decisions are final. All implementation must conform to them.

### AD-01 · UIDL Type Taxonomy: Generic Primitives

Types are namespaced into two tiers:

| Tier | Format | Example | Renderer |
|---|---|---|---|
| UIDL primitives | `namespace.name` | `layout.column`, `display.text` | Built into `zugantor_renderer` |
| Custom components | `namespace.name` | `zds.button`, `myds.card` | Registered via `ComponentRegistry` |

**Namespaces:** `layout` · `display` · `input` · `data`

### AD-02 · Design Tokens: Separate Files, Semantic References

Screens never contain hard-coded values. All design constants live in token files and are
referenced with `@` syntax.

| Token file | Reference syntax | Example |
|---|---|---|
| `design/colors.json` | `@colors.<name>` | `@colors.primary` |
| `design/typography.json` | `@typography.<name>` | `@typography.heading_1` |
| `design/spacing.json` | `@spacing.<name>` | `@spacing.lg` |
| `design/radius.json` | `@radius.<name>` | `@radius.md` |

### AD-03 · Renderer and Code Generator Are Separate Systems

```
UIDL JSON ──► zugantor_renderer  → Flutter widgets (runtime preview)
          └─► zugantor_codegen   → Dart / Swift / Kotlin / TSX source (export)
```

Neither knows about the other. Both consume the same UIDL contract.

### AD-04 · Custom Design Systems via Component Registry

The renderer is not ZDS-specific. Any design system can be registered:

```dart
registry.register('myds.button', (props, children, data) => MyButton(...));
```

For unknown types the renderer shows a **styled placeholder** (type name + props list).
The code generator emits the constructor call using the type slug → PascalCase convention.

### AD-05 · Backend = Dummy Mock Data in v1

No API spec, no endpoint definitions, no real network calls in the builder.
Each screen has a companion `.mock.json` file containing the data shape the template expects.
Bind expressions resolve against this mock at preview time.

### AD-06 · Platform Targets

| Target | v1 | Future |
|---|---|---|
| Flutter (Dart) | ✅ | — |
| SwiftUI (Swift) | — | ✅ |
| Jetpack Compose (Kotlin) | — | ✅ |
| Next.js (TSX) | — | ✅ |

---

## Package Architecture

```
zugantor_uidl             Pure Dart — UIDL data model, token resolver, JSON schema validator
                          Zero Flutter dependency. Used by everything.
      │
      ├── zugantor_renderer      Flutter — UIDL JSON → Widget tree (runtime, uses registry)
      │
      ├── zugantor_codegen       Pure Dart — UIDL JSON → source code strings (pluggable generators)
      │         ├── FlutterGenerator
      │         ├── SwiftUIGenerator   [future]
      │         ├── ComposeGenerator   [future]
      │         └── NextJsGenerator    [future]
      │
      ├── zugantor_design_system Flutter — ZDS component implementations + ZDS registry
      │
      └── zugantor_build         Flutter app — the visual builder tool
                ├── uses: zugantor_uidl, zugantor_renderer, zugantor_codegen
                └── uses: zugantor_design_system (as the default component set)
```

---

## Phase 0 — Foundation (Current Phase)

**Goal:** Lock all contracts and design decisions before writing any implementation code.

| Task | Status |
|---|---|
| UIDL JSON contract (node shape, field names, `@` token refs) | ✅ Locked |
| Design token file format (colors, typography, spacing, radius) | ✅ Locked |
| Type taxonomy (generic primitives, two-tier namespace) | ✅ Locked |
| Renderer / codegen separation | ✅ Locked |
| Backend approach for v1 (mock data only) | ✅ Locked |
| Platform target scope | ✅ Locked |
| Component Definition Schema (Problem 2) | 🔲 In discussion |
| Registry API surface (Problem 3) | 🔲 Pending |
| UIDL primitive catalogue (all types + their props) | 🔲 Pending |
| Bind expression operator spec | 🔲 Pending |
| `on_tap` action model for v1 | 🔲 Pending |

---

## Phase 1 — `zugantor_uidl` Package

**Goal:** Pure Dart package. The contract layer every other package depends on.

| Deliverable | Description |
|---|---|
| `UidlNode` data class | `type`, `id`, `props`, `bind`, `children`, `item_template` |
| `ScreenTemplate` data class | `uidl_version`, `screen_id`, `title`, `layout` |
| `DesignTokens` data class | Holds resolved colors, typography, spacing, radius |
| `TokenResolver` | Resolves `@colors.primary` → `#6C63FF` against token files |
| `UidlValidator` | Validates a `ScreenTemplate` against the UIDL JSON schema |
| `ComponentDefinition` data class | Type, display name, category, prop schema, accepts children |
| `ComponentRegistry` | Stores `ComponentDefinition` entries; looked up by type slug |
| JSON serialization | `fromJson` / `toJson` for all data classes |
| Unit tests | 100% coverage of resolver, validator, and data classes |

---

## Phase 2 — `zugantor_renderer` Package

**Goal:** Flutter package. UIDL JSON → Flutter widget tree. Pluggable registry.

| Deliverable | Description |
|---|---|
| `SduiRenderer` widget | `SduiRenderer(node, tokens, registry, data)` → Widget |
| UIDL primitive implementations | All `layout.*`, `display.*`, `input.*`, `data.*` types rendered as Flutter widgets |
| Token-aware rendering | Props with `@token` values resolved before rendering |
| Bind expression evaluation | JSONPath `$.path` resolved against `data` map |
| `data.list` loop rendering | Iterates source array, renders `item_template` per item |
| `data.conditional` | Shows/hides children based on bind condition |
| Unknown type placeholder | Displays component name + props when type is not in registry |
| ZDS registry adapter | Registers all ZDS components into a `ComponentRegistry` |

---

## Phase 3 — `zugantor_codegen` Package

**Goal:** Pure Dart package. UIDL JSON → Dart source code strings. Pluggable generator interface.

| Deliverable | Description |
|---|---|
| `CodeGenerator` interface | `generate(ScreenTemplate, DesignTokens, ComponentRegistry) → String` |
| `FlutterGenerator` | Implements `CodeGenerator` → Dart `StatelessWidget` source |
| Type slug → class name | `layout.column` → `Column`, `myds.button` → `MyButton` (PascalCase) |
| Token resolution → Dart | `@colors.primary` → `Theme.of(context).colorScheme.primary` |
| Bind props → constructor params | `bind.text: $.user.name` → `text: data['user']['name']` |
| `dart format` compliant output | Generated code passes `dart format` with zero changes |
| CLI tool | `dart run zugantor_codegen --input screens/ --output lib/screens/` |

---

## Phase 4 — `zugantor_build` App — Foundation

**Goal:** The builder app core — project storage, editor state, navigation shell.

| Deliverable | Description |
|---|---|
| Navigation shell | GoRouter + persistent sidebar (`Home / Projects / Templates / Settings`) |
| Home screen | Recent projects grid, New Project dialog, Open from file |
| Project storage | Read/write `.zbuild` + per-screen UIDL JSON + mock data to disk |
| Editor state | `ChangeNotifier` — current screen, selected node, dirty flag, undo/redo |
| Canvas ↔ JSON sync engine | Bidirectional — Canvas→JSON instant, JSON→Canvas 500ms debounce + diff by `id` |
| Token file editors | Color, typography, spacing, radius editors in the Design panel |

---

## Phase 5 — `zugantor_build` App — Editor Surface

**Goal:** The full authoring workspace — canvas, JSON editor, palette, AI bar.

| Deliverable | Description |
|---|---|
| Canvas | Drag-and-drop structural blocks, select, reorder, nest, delete |
| Palette | Component catalogue from `ComponentRegistry`, search, drag to canvas |
| Layers tree | Widget tree view, select, reorder, context menu |
| JSON editor | `flutter_code_editor` — syntax highlight, error gutter, format, scroll sync |
| Live preview | `SduiRenderer` in phone frame (requires Phase 2) |
| Mock data editor | JSON editor for `.mock.json`, re-renders preview on change |
| AI prompt bar | Generate / Modify / Explain — OpenAI + Anthropic, user-supplied API key |
| Status bar | Screen ID · schema version · sync status · Export button |
| Export dialog | SDUI JSON · Dart Widget · Flutter Project zip |

---

## Phase 6 — Collaboration & Sync

**Goal:** Git-model cloud sync with async per-person collaboration.

| Deliverable | Description |
|---|---|
| Remote push / pull | Per-screen sync to a remote server |
| Auto-merge | Different screens modified → no conflict |
| Conflict detection | Same screen modified by two people → conflict state |
| Conflict UI | Side-by-side diff view (v1: lock + prompt; v1+: full diff UI) |
| Sync status in status bar | ✓ Synced / ↑ Pushing / ↓ Pulling / ⚠ Conflict |

---

## Phase 7 — Custom Design System Support

**Goal:** Users can register their own component libraries in the builder.

| Deliverable | Description |
|---|---|
| Component manifest format | `zugantor_components.json` schema — type, display name, props, dart class |
| Manifest import in builder | File picker → load manifest → populate palette with custom components |
| Schema annotation package | `zugantor_annotations` — `@SduiComponent`, `@SduiProp`, build_runner generator |
| Placeholder rendering | Unknown types shown as annotated blocks in canvas + preview |
| Code generation for custom types | Type slug → PascalCase constructor, import path from manifest |

---

## Phase 8 — Multi-Platform Code Generation (Future)

**Goal:** Export to platforms beyond Flutter.

| Deliverable | Platform | Notes |
|---|---|---|
| `SwiftUIGenerator` | iOS / macOS | Requires SwiftUI mapping for all UIDL primitives |
| `ComposeGenerator` | Android | Requires Compose mapping |
| `NextJsGenerator` | Web | TSX + Tailwind CSS output |
| Platform selector in Export dialog | All | User picks target platform before export |

---

## Open Questions (Phase 0 — Pending)

| # | Question | Blocks |
|---|---|---|
| 1 | Full UIDL primitive catalogue — what types exist and what props each accepts | Phase 1, 2 |
| 2 | Bind expression operators — equality, negation, string formatting? | Phase 1 |
| 3 | `on_tap` action model in v1 — named strings only or built-in `navigate_to`? | Phase 1, 2 |
| 4 | Component Definition Schema full spec | Phase 1, 7 |
| 5 | Registry API surface — global singleton or scoped instance? | Phase 2 |
| 6 | Left panel config — inline below layers or dedicated bottom section? | Phase 5 |
| 7 | Multiple screens as editor tabs or one at a time? | Phase 5 |
| 8 | Canvas block visual style — bordered boxes, chips, or mini-cards? | Phase 5 |
| 9 | What starter templates ship with the builder in v1? | Phase 4 |
