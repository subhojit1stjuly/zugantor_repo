# ADR-003 — Renderer and Code Generator Are Independent

| Field | Value |
|---|---|
| Status | **Accepted** |
| Date | March 2026 |
| Supersedes | — |

---

## Context

Two different consumers need the UIDL JSON: the live preview panel in the builder (needs Flutter
widgets) and the export dialog (needs source code strings). These concerns have completely
different dependencies — the renderer needs Flutter, the code generator needs none of it.
Coupling them would bloat packages and complicate the multi-platform code generation story.

---

## Decision

`zugantor_renderer` and `zugantor_codegen` are **separate packages** with no dependency on
each other. Both depend only on `zugantor_uidl`.

```
zugantor_uidl      (pure Dart — shared data model + contracts)
      │
      ├── zugantor_renderer   (Flutter — UIDL JSON → Widget tree)
      │
      └── zugantor_codegen    (pure Dart — UIDL JSON → source code strings)
```

### `zugantor_renderer`

- Input: `UidlNode`, `DesignTokens`, `ComponentRegistry`, data map
- Output: Flutter `Widget`
- Has Flutter dependency
- Has no knowledge of code generation

### `zugantor_codegen`

- Input: `ScreenTemplate`, `DesignTokens`, `ComponentRegistry`
- Output: `String` (Dart / Swift / Kotlin / TSX source)
- Pure Dart — zero Flutter dependency
- Has no knowledge of the renderer
- Pluggable via `CodeGenerator` interface — one implementation per target platform

### `zugantor_uidl`

- Pure Dart — no Flutter dependency
- Owns: `UidlNode`, `ScreenTemplate`, `DesignTokens`, `ComponentDefinition`,
  `ComponentRegistry`, `TokenResolver`, `UidlValidator`
- This is the **single source of truth** for the data contract

---

## Consequences

- **Enables:** `zugantor_codegen` can run as a CLI tool with zero Flutter dependency.
- **Enables:** Adding a new code generation target (e.g. SwiftUI) without touching the renderer.
- **Enables:** The renderer can be updated (new widget, bug fix) without any risk to codegen output.
- **Constrains:** Any data class shared between renderer and codegen must live in `zugantor_uidl`.
  Do not duplicate data classes across packages.
