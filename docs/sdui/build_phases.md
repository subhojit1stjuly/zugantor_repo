# SDUI — Build Phases

This document defines the execution plan for building the SDUI system. Phases are sequential at a high level, but many tasks within each phase can run in parallel.

---

## Overview

| Phase | Name | Status |
|---|---|---|
| Phase 0 | Prerequisites & Decisions | Partially done |
| Phase 1 | Foundation — Schema + Models | Not started |
| Phase 2 | Resolution Layer | Not started |
| Phase 3 | Renderer | Not started |
| Phase 4 | Integration | Not started |
| Phase 5 | Quality & DX | Not started |

---

## Phase 0 — Prerequisites & Decisions

> These must be complete before any Phase 1 code is written.

| Task | Status | Notes |
|---|---|---|
| P0.1 — ZDS naming standardized (`ZDS*` prefix on all components) | ✅ Done | All App* → ZDS* renames complete |
| P0.2 — Localization strategy chosen | ✅ Decided | Server sends pre-localized strings (v1) |
| P0.3 — Schema version format chosen | ✅ Decided | Integer in root: `{ "schema_version": 1 }` |
| P0.4 — Create `packages/zugantor_sdui` package | ❌ Todo | `pubspec.yaml`, `analysis_options.yaml`, `lib/` structure |
| P0.5 — Verify `packages/zugantor_sdui` is covered by `melos.yaml` glob | ❌ Todo | Check `packages/**` glob covers it |

---

## Phase 1 — Foundation

> Can be run in parallel: P1.1 (no Dart deps) and P1.2 can start at the same time.

### P1.1 — JSON Schema Design (Sub-Problem 1)

- [ ] Write `docs/sdui/sdui_schema.json` — full JSON Schema for `SduiScreenPayload`
- [ ] Define all field names (snake_case), required vs optional
- [ ] Define component node shape: `type`, `key`, `props`, `bind`, `semantics`, `visibility`, `children`
- [ ] Define `SduiAction` sealed union schema
- [ ] Define design token ref format: `"@namespace.token"`
- [ ] Validate the schema compiles and IDE tooling picks it up

### P1.2 — SDUI Data Models (Sub-Problem 2)

- [ ] Add `json_annotation` to dependencies, `build_runner` + `json_serializable` to dev dependencies
- [ ] Implement `SduiScreenPayload`
- [ ] Implement `SduiSection`
- [ ] Implement `SduiComponentNode` (recursive `children` list)
- [ ] Implement `SduiMetadata`
- [ ] Implement `SduiSemantics`
- [ ] Implement `SduiProps` (typed accessor wrapper)
- [ ] Implement sealed `SduiAction` hierarchy (5 types)
- [ ] Run `dart run build_runner build --delete-conflicting-outputs`
- [ ] Write unit tests: JSON fixtures → model deserialization for all types

---

## Phase 2 — Resolution Layer

> P2.1, P2.2, and P2.3 can all run in parallel.

### P2.1 — Token Resolver (Sub-Problem 3)

- [ ] Define `SduiTokenResolver` abstract interface
- [ ] Implement `ZdsTokenResolver` using `ZDSTheme.of(context)`
- [ ] Support all 4 namespaces: `@colors.*`, `@typography.*`, `@spacing.*`, `@shapes.*`
- [ ] Handle non-token refs by returning null (pass-through)
- [ ] Write unit tests: all namespaces, unknown token, non-token passthrough

### P2.2 — Action System (Sub-Problem 4)

- [ ] Define `SduiActionHandler` typedef and `SduiActionContext`
- [ ] Implement `SduiActionResolver` (registry + `resolve()` method)
- [ ] Implement `NavigateActionHandler` (uses GoRouter)
- [ ] Implement `UpdateStateActionHandler`
- [ ] Implement `AnalyticsActionHandler` (pluggable backend)
- [ ] Implement `ChainActionHandler` (sequential execution)
- [ ] Implement `NoOpActionHandler`
- [ ] Write unit tests for each handler

### P2.3 — Component Registry (Sub-Problem 5)

- [ ] Define `SduiWidgetBuilder` typedef and `SduiRenderContext`
- [ ] Implement `SduiComponentRegistry` (register + build)
- [ ] Implement `ZdsComponentRegistry` (pre-register all ZDS components)
- [ ] Register all layout primitives (`layout.column`, `layout.row`, etc.)
- [ ] Implement `SduiUnknownComponentWidget` (dev/prod variants)
- [ ] Write unit tests: known key lookups, unknown key fallback (dev + prod)

---

## Phase 3 — Renderer

> P3.1 must complete before P3.2 (state is a dependency of the registry entries used by the renderer).

### P3.1 — State Bridge (Sub-Problem 7)

- [ ] Implement `SduiStateStore` (ChangeNotifier, get/set/reset)
- [ ] Implement `SduiStateScope` (InheritedWidget)
- [ ] Implement `SduiStateful<T>` (helper widget for listening to a single key)
- [ ] Update interactive ZDS component adapters to use `SduiStateStore`
- [ ] Write widget tests: set/get/reset, ListenableBuilder triggers

### P3.2 — SDUI Renderer (Sub-Problem 6)

- [ ] Implement `SduiRenderer` (public entry point StatelessWidget)
- [ ] Implement `_SduiNodeRenderer` (private recursive widget)
- [ ] Implement `SduiChildrenRenderer` (renders `List<SduiComponentNode>`)
- [ ] Implement `_SduiErrorBoundary` (per-node error catch)
- [ ] Add `Semantics` wrapping when `node.semantics` is present
- [ ] Add `Key` wrapping when `node.key` is present
- [ ] Merge `props` + resolved `bind` before calling builder
- [ ] Write widget tests: mock JSON → correct ZDS widgets rendered
- [ ] Write golden tests: snapshot per ZDS component type

---

## Phase 4 — Integration

> P4.1, P4.2 and P4.3 can run in parallel.

### P4.1 — Networking & Caching (Sub-Problem 8)

> Note: this layer lives in `zugantor_data` or in the screen widget, not inside `zugantor_sdui`.

- [ ] Define `SduiRepository` abstract interface
- [ ] Implement `SduiHttpRepository` (Dio, platform headers, compute() isolate parsing)
- [ ] Implement `SduiCacheLayer` (L1 in-memory, L2 disk/SharedPreferences)
- [ ] Implement `SduiCachedRepository` (wraps HTTP + cache, stale-while-revalidate policy)
- [ ] Define typed exceptions: `SduiNetworkException`, `SduiParseException`, `SduiNotFoundError`
- [ ] Write unit tests: cache hit/miss, stale-while-revalidate behavior

### P4.2 — Navigation Integration (Sub-Problem 9)

- [ ] Implement `SduiScreen` (fetches + renders + error/loading states)
- [ ] Add shimmer / skeleton loading state
- [ ] Add `SduiErrorView` with retry button
- [ ] Add `SduiStateScope` wrapping around `SduiRenderer` on success
- [ ] Define GoRoute at `/sdui/:screenId`
- [ ] Document URL aliasing pattern for clean route names
- [ ] Write integration test: `FakeSduiRepository` → `SduiScreen` renders correct layout

### P4.3 — A/B Testing (Sub-Problem 10)

- [ ] Add `X-Platform`, `X-App-Version`, `X-User-Segment`, `Accept-Language` headers to every SDUI fetch
- [ ] Ensure `SduiMetadata` carries `variant_id` and `experiment_id`
- [ ] Auto-fire render analytics event on first `SduiScreen` build
- [ ] Document: server chooses variant, client renders whatever it receives

---

## Phase 5 — Quality & DX

> Can run in parallel with Phase 4.

### P5.1 — Testing Infrastructure (Sub-Problem 11)

- [ ] Create test fixture JSON files for all common screen archetypes
- [ ] Implement `SduiTestPayloadBuilder` (fluent test helper)
- [ ] Implement `FakeSduiRepository` (in-memory fixture loader)
- [ ] Ensure golden test suite runs in CI
- [ ] Achieve >80% line coverage across `zugantor_sdui`

### P5.2 — Developer Experience (Sub-Problem 12)

- [ ] Implement `SduiDebugOverlay` (colored borders + type/key labels in dev mode)
- [ ] Set up `dart:developer` structured logging throughout the engine
- [ ] Create `SduiStoryWrapper` for Widgetbook — drives stories from JSON fixtures
- [ ] Add Widgetbook stories for key SDUI demo screens in `apps/storybook`
- [ ] Confirm `docs/sdui/sdui_schema.json` is linked in backend + IDE editor settings

---

## Cross-Cutting: What Not to Forget

- All public Dart APIs must have `///` dartdoc comments
- All new packages must have `analysis_options.yaml` inheriting from `package:flutter_lints/flutter.yaml`
- Run `dart format` and `dart fix` before every commit
- `zugantor_sdui` must pass `flutter analyze` with zero errors before Phase 2 begins
- Component registry keys must never be renamed after v1 ships (add deprecation aliases if needed)
