# SDUI — Engineering Sub-Problems

The SDUI system is broken into 12 bounded engineering sub-problems. Each has a clear input, output, and set of dependencies. They are designed to be implemented in parallel where possible.

---

## Dependency Graph

```
Sub-Problem 0 (prerequisites)
    └── Sub-Problem 1: JSON Schema Design
            └── Sub-Problem 2: Data Models
                    ├── Sub-Problem 3: Token Resolver
                    ├── Sub-Problem 4: Action System
                    │       └── Sub-Problem 5: Component Registry
                    │               └── Sub-Problem 7: State Bridge
                    ├── Sub-Problem 8: Networking & Caching
                    │       └── Sub-Problem 9: Navigation Integration
                    │               └── Sub-Problem 10: A/B Testing
                    └── Sub-Problem 6: SDUI Renderer (depends on 3, 4, 5)
```

Sub-Problems 11 (Testing) and 12 (DX) can start in parallel after Sub-Problem 2.

---

## Sub-Problem 0: Prerequisites

Before writing any SDUI code, these decisions must be locked:

- [x] ZDS naming standardized (`ZDS*` prefix on all components) — **DONE**
- [ ] Localization strategy chosen: **server sends pre-localized strings** (v1)
- [ ] Schema version strategy: integer in root `{ "schema_version": 1 }`
- [ ] `packages/zugantor_sdui` Melos package created
- [ ] `packages/zugantor_sdui` added to `melos.yaml` workspace

---

## Sub-Problem 1: JSON Schema Design

**Goal:** Define the canonical JSON payload shape. This is the contract between the server/AI and the Flutter renderer. Everything downstream depends on this.

**Outputs:**
- `docs/sdui/sdui_schema.json` — JSON Schema file for IDE validation and server-side validation
- Finalized field names (snake_case), required vs optional fields, nested structure

**Key design points:**
- Root: `screen_id`, `schema_version` (int), `metadata`, `sections[]`
- Section: `id`, `type`, `component` (one root component node)
- Component node: `type` (registry key), `key?`, `props?`, `bind?`, `children?`, `semantics?`, `visibility?`
- Action: sealed union on `type` field — `navigate | update_state | analytics | chain | no_op`
- Design token refs: `"@namespace.token"` format in props values

**No Dart code dependencies.** This can be written before any package exists.

---

## Sub-Problem 2: SDUI Data Models

**Goal:** Dart classes that represent the JSON schema. All classes are immutable, null-safe, and generated with `json_serializable`.

**Outputs (in `packages/zugantor_sdui/lib/src/models/`):**

| Class | Description |
|---|---|
| `SduiScreenPayload` | Top-level deserialized screen |
| `SduiSection` | A typed section within a screen |
| `SduiComponentNode` | A single component node (recursive via `children`) |
| `SduiProps` | Typed accessor wrapper over `Map<String, dynamic>` — `getString()`, `getBool()`, `getInt()`, `getDouble()`, `getColor()`, `getAction()`, `getList()` |
| `SduiSemantics` | Accessibility metadata: `label`, `hint`, `isButton`, `isHeader`, `excludeSemantics` |
| `SduiMetadata` | Screen metadata: `title`, `variantId`, `experimentId`, `cacheTtlSeconds` |

**Sealed action hierarchy:**

```dart
sealed class SduiAction { ... }

class SduiNavigateAction extends SduiAction {
  final String path;
  final bool push;
}

class SduiUpdateStateAction extends SduiAction {
  final String key;
  final dynamic value;
}

class SduiAnalyticsAction extends SduiAction {
  final String event;
  final Map<String, dynamic> params;
}

class SduiChainAction extends SduiAction {
  final List<SduiAction> actions;
}

class SduiNoOpAction extends SduiAction { }
```

**Build requirements**: `json_serializable` + `json_annotation` as dependencies, `build_runner` as dev dependency. All fields use `FieldRename.snake`.

---

## Sub-Problem 3: Token Resolver

**Goal:** Resolve `@namespace.token` references in props to real Flutter values using the active `ZDSTheme`.

**Outputs (in `packages/zugantor_sdui/lib/src/binding/`):**

```dart
abstract interface class SduiTokenResolver {
  Color? resolveColor(BuildContext context, String ref);
  double? resolveDouble(BuildContext context, String ref);
  TextStyle? resolveTextStyle(BuildContext context, String ref);
  ShapeBorder? resolveShapeBorder(BuildContext context, String ref);
}
```

- `ZdsTokenResolver` — concrete implementation using `ZDSTheme.of(context)`
- Namespaces: `@colors.*`, `@typography.*`, `@spacing.*`, `@shapes.*`
- If the value is not a token ref (no `@` prefix): return null and pass the raw value through
- If the token ref is unknown: return null (graceful degradation)

**Depends on:** `ZDSTheme` token classes from `zugantor_design_system`

---

## Sub-Problem 4: Action System

**Goal:** A registry of handlers that execute `SduiAction` descriptors in a Flutter context.

**Outputs (in `packages/zugantor_sdui/lib/src/actions/`):**

```dart
typedef SduiActionHandler = Future<void> Function(
  SduiAction action,
  SduiActionContext context,
);

class SduiActionContext {
  final BuildContext buildContext;
  final GoRouter? router;
  final SduiStateStore stateStore;
  final Map<String, dynamic> extra;
}

class SduiActionResolver {
  void register(String type, SduiActionHandler handler);
  Future<void> resolve(SduiAction action, SduiActionContext context);
}
```

**Default handlers provided out of the box:**

| Action Type | Handler Behavior |
|---|---|
| `navigate` | Calls `router?.go(path)` or `router?.push(path)` |
| `update_state` | Calls `stateStore.set(key, value)` |
| `analytics` | Fires analytics event (pluggable backend) |
| `chain` | Executes each action in the list sequentially |
| `no_op` | Does nothing |

Apps can register custom handlers by calling `resolver.register('my_action', handler)`.

---

## Sub-Problem 5: Component Registry

**Goal:** A two-layer registry mapping string keys to widget builder functions. All ZDS components are pre-registered.

**Outputs (in `packages/zugantor_sdui/lib/src/registry/`):**

```dart
typedef SduiWidgetBuilder = Widget Function(
  BuildContext context,
  SduiComponentNode node,
  SduiRenderContext renderContext,
);

class SduiComponentRegistry {
  void register(String type, SduiWidgetBuilder builder);
  Widget build(BuildContext context, SduiComponentNode node, SduiRenderContext renderContext);
}

class SduiRenderContext {
  final SduiTokenResolver tokenResolver;
  final SduiActionResolver actionResolver;
  final SduiStateStore stateStore;
  final SduiComponentRegistry registry;  // for recursive child rendering
}
```

**Pre-registered ZDS keys:**

```
zds.button.primary      zds.button.secondary    zds.button.text
zds.button.icon         zds.badge               zds.badge.overlay
zds.alert               zds.checkbox            zds.date_picker
zds.dropdown            zds.radio               zds.radio_group
zds.switch              zds.text_input          zds.card
zds.padded_container    zds.section             zds.section_list
zds.spacing.vertical    zds.spacing.horizontal  zds.accordion
zds.tabs                zds.text                zds.image
```

**Pre-registered layout primitives:**

```
layout.column           layout.row              layout.stack
layout.wrap             layout.expanded         layout.flexible
layout.sized_box        layout.padding          layout.center
layout.align            layout.scroll_view      layout.list_view
```

**Unknown type behavior:** Dev mode → red placeholder with type name + log. Prod mode → `SizedBox.shrink()`.

---

## Sub-Problem 6: SDUI Renderer

**Goal:** The recursive widget that walks a `SduiComponentNode` tree and produces a Flutter widget tree.

**Outputs (in `packages/zugantor_sdui/lib/src/renderer/`):**

```
SduiRenderer (StatelessWidget, public API)
    └── _SduiNodeRenderer (private, recursive)
            ├── registry.build(type, context, node, renderContext)
            ├── wraps with Key(node.key) if key is present
            ├── wraps with Semantics if node.semantics is present
            └── wraps with _SduiErrorBoundary (catches render exceptions)
```

Usage:

```dart
SduiRenderer(
  template: layoutMap,
  data: dataMap,
  registry: ZdsComponentRegistry.instance,
  tokenResolver: ZdsTokenResolver(),
  actionResolver: actionResolver,
)
```

The renderer merges `props` (static) and resolved `bind` (dynamic) before calling each component's builder. The component builder receives a single merged props map — it does not know whether a value came from `props` or `bind`.

---

## Sub-Problem 7: State Bridge

**Goal:** Provide screen-scoped ephemeral state for interactive components (forms, accordions, tabs, toggles).

**Outputs (in `packages/zugantor_sdui/lib/src/state/`):**

```dart
class SduiStateStore extends ChangeNotifier {
  T get<T>(String key, T defaultValue);
  void set<T>(String key, T value); // notifies listeners
  void reset(); // clears all state
}

class SduiStateScope extends InheritedWidget {
  static SduiStateStore of(BuildContext context);
}
```

Component registry entries for interactive components (e.g. `ZDSCheckbox` adapter) read their initial value from `SduiStateStore` and write changes back on user interaction.

`SduiStateStore.reset()` is called when the `SduiScreen` widget is disposed (user navigates away).

---

## Sub-Problem 8: Networking & Caching

**Goal:** Fetch and cache `SduiScreenPayload` from the backend, with offline-first support.

> Note: in our architecture, `SduiRenderer` itself never makes network calls. This layer is separate and lives in `zugantor_data` or within the screen widget, not inside `zugantor_sdui`.

**Outputs:**

```dart
abstract interface class SduiRepository {
  Future<SduiScreenPayload> fetchScreen(
    String screenId, {
    Map<String, String> headers,
  });
}
```

**Platform headers sent with every request:**

| Header | Value |
|---|---|
| `X-Platform` | `ios` / `android` / `web` / `desktop` |
| `X-App-Version` | Current app version |
| `X-User-Segment` | User segment or tier |
| `Accept-Language` | Active locale |

**Cache strategy:**

| Policy | Behavior |
|---|---|
| `networkOnly` | Always fetch; never read cache |
| `cacheFirst` | Return cache if present; fetch only on miss |
| `staleWhileRevalidate` | Return cache immediately; refresh in background |

JSON parsing happens in a `compute()` isolate for large payloads to avoid blocking the UI thread.

**Typed exceptions:** `SduiNetworkException`, `SduiParseException`, `SduiNotFoundError`

---

## Sub-Problem 9: Navigation Integration

**Goal:** Connect the SDUI screen to GoRouter so server-driven screens are deep-linkable.

**Outputs:**

```dart
class SduiScreen extends StatefulWidget {
  const SduiScreen({required this.screenId, super.key});
  final String screenId;
}
```

Internal behavior:
1. `initState`: fetch `SduiScreenPayload` via `SduiRepository`
2. Loading state: shimmer / skeleton placeholders
3. Error state: `SduiErrorView` with retry button
4. Success state: `SduiStateScope` wrapping `SduiRenderer`

**GoRouter setup:**

```dart
GoRoute(
  path: '/sdui/:screenId',
  builder: (context, state) => SduiScreen(
    screenId: state.pathParameters['screenId']!,
  ),
)
```

Apps can alias clean URLs to SDUI routes:

```dart
GoRoute(path: '/home', redirect: (_, __) => '/sdui/home')
```

---

## Sub-Problem 10: A/B Testing & Feature Flags

**Goal:** Allow the server to serve different layouts per user segment, experiment, or feature flag — transparently to the client.

**Design:** The client sends context headers with every request. The server selects the appropriate variant and returns a single payload. The client renders whatever it receives — it has no concept of variants.

**SduiMetadata fields for analytics:**

```json
"metadata": {
  "title": "Dashboard",
  "variant_id": "v2_compact",
  "experiment_id": "exp_dashboard_q3",
  "cache_ttl_seconds": 60
}
```

The client fires a `SduiAnalyticsAction` automatically on first render, carrying `screen_id`, `variant_id`, and `experiment_id`. This feeds the experiment analytics pipeline.

Feature flags work the same way: the server simply includes or excludes component nodes based on whether the flag is enabled. The client renders whatever the template contains.

---

## Sub-Problem 11: Testing Infrastructure

**Goal:** Comprehensive test coverage for all SDUI layers.

**Structure:**

```
packages/zugantor_sdui/test/
    models/          Unit tests: JSON fixtures → model deserialization
    binding/         Unit tests: token resolver, JSONPath expressions
    registry/        Unit tests: known key lookups, unknown key fallback
    actions/         Unit tests: each action handler, chain handler
    renderer/        Widget tests: mock JSON → correct ZDS widgets rendered
    state/           Widget tests: set/get/reset, ListenableBuilder triggers
    golden/          Golden snapshots per ZDS component type
    integration/     FakeSduiRepository → SduiScreen renders correct layout
    helpers/         SduiTestPayloadBuilder (fluent), FakeSduiRepository
```

**Test helpers:**

```dart
// Fluent builder for constructing test payloads
SduiTestPayloadBuilder()
  .screen('home_dashboard')
  .section('hero', component: SduiTestPayloadBuilder.text('Hello'))
  .build();

// In-memory fake repository
FakeSduiRepository({
  'home_dashboard': loadFixture('test/fixtures/home_dashboard.json'),
})
```

---

## Sub-Problem 12: Developer Experience

**Goal:** Make SDUI easy to debug, author, and extend.

**Outputs:**

| Feature | Description |
|---|---|
| `SduiDebugOverlay` | Dev-mode InheritedWidget that draws colored borders around each component node with its type key and node key |
| `sdui_schema.json` | Published to `docs/sdui/` for backend and IDE JSON Schema validation |
| Widgetbook integration | `SduiStoryWrapper` — drives Widgetbook stories from JSON mock payloads |
| Structured logging | `dart:developer` logs for: registry misses, token failures, action failures, cache hits/misses |
| Error messages | Include component type, node key, and payload path for fast debugging |
