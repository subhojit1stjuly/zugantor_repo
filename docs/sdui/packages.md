# SDUI — Package Structure

## The Five Packages

```
packages/
    zugantor_design_system/     Phase 0 — DONE
    zugantor_sdui/              Phase 1 — next
    zugantor_data/              Phase 2
    zugantor_charts/            Phase 3
    zugantor_notifications/     Phase 3
```

---

## Package Responsibilities

### `zugantor_design_system`

**Status:** Complete. API frozen.

**Responsibility:** The ZDS component library. Every UI primitive the app uses. This is the **vocabulary** for the SDUI system — AI and the renderer can only use what is in this package.

**Contains:**
- All ZDS widgets (`ZDSButton`, `ZDSCard`, `ZDSTextInput`, `ZDSAccordion`, etc.)
- Theme extension types (`ZDSColors`, `ZDSTypography`, `ZDSSpacing`, `ZDSShapes`)
- `ZDSTheme` — the central theme accessor

**Depends on:** `flutter` only. Nothing else.

---

### `zugantor_sdui`

**Status:** To be created. Phase 1.

**Responsibility:** The SDUI rendering engine. Takes a template map and a data map, outputs a widget tree.

**Contains:**

```
lib/src/
    models/         SduiScreenPayload, SduiComponentNode, SduiAction (sealed), SduiProps, SduiSemantics
    binding/        SduiTokenResolver (interface), ZdsTokenResolver (impl), JSONPath engine
    registry/       SduiComponentRegistry, ZdsComponentRegistry (pre-wired), SduiWidgetBuilder typedef
    renderer/       SduiRenderer, _SduiNodeRenderer, SduiChildrenRenderer, _SduiErrorBoundary
    actions/        SduiActionResolver, SduiActionHandler typedef, SduiActionContext, default handlers
    state/          SduiStateStore, SduiStateScope, SduiStateful
    layout_manager/ SduiLayoutManager — loads layout files from asset bundle or local storage
```

**Depends on:** `zugantor_design_system`, `flutter`, `json_annotation`, `go_router`

**Does NOT depend on:** `zugantor_data`, any HTTP client, any database

---

### `zugantor_data`

**Status:** Phase 2. Not yet started.

**Responsibility:** Offline-first data layer. Fetches from API, persists to local DB, syncs files.

**Contains:**
- Offline database (Drift / SQLite)
- API client (Dio)
- Sync engine for layout template files
- Repository abstractions for app data

**Depends on:** `flutter`, `drift`, `dio`, `shared_preferences`

**Does NOT depend on:** `zugantor_sdui`. It returns `Map<String, dynamic>` — plain data. SDUI is the consumer.

---

### `zugantor_charts`

**Status:** Phase 3. Planned.

**Responsibility:** Custom chart and data visualization components.

**Contains:**
- Line charts, bar charts, pie charts
- Mini sparkline widgets
- Chart theme integration with ZDSColors

**Depends on:** `zugantor_design_system`, `flutter`

**Does NOT depend on:** `zugantor_sdui`, `zugantor_data`

---

### `zugantor_notifications`

**Status:** Phase 3. Planned.

**Responsibility:** Push notifications and in-app notification center.

**Contains:**
- Push notification service (Firebase / APNs)
- In-app notification banner / overlay
- Notification history screen data model

**Depends on:** `zugantor_design_system`, `flutter`

**Does NOT depend on:** `zugantor_sdui`, `zugantor_data`

---

## The Dependency Law

This is a law, not a suggestion.

```
zugantor_data         does NOT know SDUI exists
zugantor_sdui         does NOT know how data is stored or fetched
zugantor_charts       does NOT know about sync or SDUI
zugantor_notifications does NOT know about data or SDUI

Apps wire all packages together.
Packages communicate only through typed interfaces.
```

### Dependency Matrix

| Package | design_system | sdui | data | charts | notifications |
|---|:---:|:---:|:---:|:---:|:---:|
| `zugantor_design_system` | — | ✗ | ✗ | ✗ | ✗ |
| `zugantor_sdui` | ✅ | — | ✗ | ✗ | ✗ |
| `zugantor_data` | ✗ | ✗ | — | ✗ | ✗ |
| `zugantor_charts` | ✅ | ✗ | ✗ | — | ✗ |
| `zugantor_notifications` | ✅ | ✗ | ✗ | ✗ | — |
| App (consumer) | ✅ | ✅ | ✅ | ✅ | ✅ |

✅ = allowed dependency &emsp; ✗ = forbidden

---

## `zugantor_sdui` Internal Directory Layout

```
packages/zugantor_sdui/
    pubspec.yaml
    analysis_options.yaml
    lib/
        zugantor_sdui.dart          ← barrel export
        src/
            models/
                sdui_screen_payload.dart
                sdui_screen_payload.g.dart
                sdui_section.dart
                sdui_section.g.dart
                sdui_component_node.dart
                sdui_component_node.g.dart
                sdui_action.dart
                sdui_action.g.dart
                sdui_props.dart
                sdui_semantics.dart
                sdui_metadata.dart
            binding/
                sdui_token_resolver.dart    ← abstract interface
                zds_token_resolver.dart     ← ZDSTheme implementation
                sdui_binding_engine.dart    ← JSONPath resolution
            registry/
                sdui_component_registry.dart
                zds_component_registry.dart ← pre-wired ZDS adapters
                sdui_render_context.dart
            renderer/
                sdui_renderer.dart
                sdui_node_renderer.dart
                sdui_error_boundary.dart
                sdui_children_renderer.dart
            actions/
                sdui_action_resolver.dart
                sdui_action_context.dart
                handlers/
                    navigate_action_handler.dart
                    update_state_action_handler.dart
                    analytics_action_handler.dart
                    chain_action_handler.dart
                    no_op_action_handler.dart
            state/
                sdui_state_store.dart
                sdui_state_scope.dart
                sdui_stateful.dart
            layout_manager/
                sdui_layout_manager.dart
    test/
        models/
        binding/
        registry/
        actions/
        renderer/
        state/
        integration/
        helpers/
            sdui_test_payload_builder.dart
            fake_sdui_repository.dart
```

---

## Melos Configuration Addition

When creating `zugantor_sdui`, add it to `melos.yaml`:

```yaml
packages:
  - packages/**
  - apps/**
```

This glob already covers the new package if placed at `packages/zugantor_sdui/`. No change needed to `melos.yaml` unless the structure changes.
