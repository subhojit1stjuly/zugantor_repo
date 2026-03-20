# SDUI — Core Architecture

## The Three-Layer Stack

```
┌─────────────────────────────────────────────────────────────┐
│                     Layer 3: Layout                          │
│                                                              │
│   Local layout templates (JSON files)                        │
│   Bundled as Flutter assets → synced to local storage        │
│   Describe structure + component types + bind expressions    │
└──────────────────────────────┬──────────────────────────────┘
                               │  template map
┌──────────────────────────────▼──────────────────────────────┐
│                     Layer 2: Renderer                        │
│                                                              │
│   SduiRenderer(template: layoutMap, data: dataMap)           │
│   Pure function → Widget tree                                │
│   Component registry lookup + token resolution              │
│   Binding engine (JSONPath) + error boundaries               │
└──────────────────────────────┬──────────────────────────────┘
                               │  data map
┌──────────────────────────────▼──────────────────────────────┐
│                     Layer 1: Data                            │
│                                                              │
│   zugantor_data fetches from API                             │
│   Returns typed response as Map<String, dynamic>             │
│   SDUI engine has zero network dependency                    │
└─────────────────────────────────────────────────────────────┘
```

---

## Template + Data Separation

This is the defining architectural decision. Templates and data are **never merged into a single payload**.

| Concern | Source | Format |
|---|---|---|
| Layout structure | Local file (synced from CDN) | JSON |
| Component types | Local file | JSON |
| Static props | Local file | JSON |
| Bind expressions | Local file | JSONPath strings |
| Content data | API response | `Map<String, dynamic>` |
| Business data | API response | `Map<String, dynamic>` |

### Why Not Data-in-Payload?

Sending both layout and data in one API response (Philosophy A, rejected) has these problems:
- You need a deployment whenever layout changes
- Every API call must know what the screen looks like
- Layout and data have different cache TTLs (layout is stable, data is live)
- You cannot A/B test layouts without changing the API contract

### Why Not Client Templates + Separate Fetch?

Having the client fetch both the template and data on screen open (Philosophy B, rejected) has these problems:
- Two network calls on every screen open
- If the template fetch fails, the whole screen fails
- No offline-first guarantee

### Our Approach (Philosophy C)

Templates live locally. They are **always available**. Data flows from the API as it always did.

```
Screen opens
    │
    ├── Template: already on device (asset bundle or local storage)
    │
    └── Data: fetch from API (with cache)
                     │
                     ▼
             SduiRenderer(template, data)
                     │
                     ▼
              Widget tree rendered
```

---

## The Rendering Model

`SduiRenderer` is a **pure function** widget. It takes two maps and outputs a widget tree. It makes no network calls, has no side effects, and can be tested with any two maps.

```dart
// Conceptual API
SduiRenderer(
  template: layoutMap,   // from local file
  data: apiResponseMap,  // from API / cache
)
```

Internally, `SduiRenderer` recursively walks the component node tree:

1. Look up the component type in the registry → get the builder function
2. Resolve `props` values (including design token refs like `@colors.primary`)
3. Resolve `bind` expressions against the data map using JSONPath
4. Merge resolved props into the builder function → Widget
5. Recursively render children
6. Wrap with `Semantics` if `semantics` field is present
7. Wrap with an error boundary that catches render exceptions per node

---

## Component Node Structure

Every element in a layout template is a `SduiComponentNode`:

```json
{
  "type": "zds.card",
  "key": "transaction_card_1",
  "props": {
    "elevation": "medium",
    "padding": "@spacing.m"
  },
  "bind": {
    "title": "$.transaction.label",
    "subtitle": "$.transaction.date"
  },
  "semantics": {
    "label": "Transaction card",
    "is_button": false
  },
  "children": [
    {
      "type": "zds.text",
      "bind": { "text": "$.transaction.amount" }
    }
  ]
}
```

| Field | Required | Description |
|---|---|---|
| `type` | ✅ | Component registry key (e.g. `zds.card`, `layout.column`) |
| `key` | ❌ | Stable widget key for diffing and animation |
| `props` | ❌ | Static config — values never change at runtime |
| `bind` | ❌ | Dynamic config — JSONPath expressions resolved at render time |
| `semantics` | ❌ | Accessibility metadata |
| `children` | ❌ | Nested component nodes (recursive) |
| `visibility` | ❌ | JSONPath expression that resolves to bool — hides node if false |

---

## Binding Syntax

The binding engine resolves `bind` expressions against the data map.

### JSONPath Expressions

```json
"bind": {
  "text":       "$.user.display_name",
  "subtitle":   "$.account.last_four",
  "badge_count":"$.notifications.unread_count"
}
```

- `$` refers to the root of the data map
- `.field` accesses a key in the current object
- `[0]` accesses an array element

### Design Token References in Props

Props can reference ZDS theme tokens using the `@namespace.token` format:

```json
"props": {
  "text_color":     "@colors.primary",
  "text_style":     "@typography.bodyMedium",
  "corner_radius":  "@shapes.card",
  "padding":        "@spacing.m"
}
```

Token namespaces: `@colors.*`, `@typography.*`, `@spacing.*`, `@shapes.*`

The `SduiTokenResolver` resolves these at render time using the active `ZDSTheme` from `BuildContext`. This means the layout respects dark/light mode and theming automatically.

### Props vs Bind — Which to Use

| Use `props` when... | Use `bind` when... |
|---|---|
| The value is the same for all users | The value changes per user or per response |
| It is a design decision (spacing, color) | It is a data decision (name, amount, count) |
| You know the value at template authoring time | You don't know the value until runtime |

---

## Layout File Lifecycle

```
App first install
    │
    └── layout files bundled as Flutter assets (always available)

App running
    │
    ├── On startup: SduiLayoutManager checks CDN for newer versions
    │   └── If newer: download silently, save to local storage
    │
    └── Screen opens:
        ├── Local storage version exists and is newer than asset bundle?
        │   └── Use local storage version
        └── Otherwise:
            └── Use asset bundle version
```

**Key guarantees:**
- The app always has a template. It never fails due to a missing template.
- Updates are silent — users never see a loading screen for layout changes.
- If a sync fails, the old template continues to work.

---

## Error Handling & Graceful Degradation

### Missing Bind Values

If `$.field` resolves to null or the path does not exist in the data map:
- That specific prop renders nothing (empty string, hidden widget, etc.)
- The rest of the component renders normally
- **Never crash** on a missing bind value

### Unknown Component Types

If the registry does not know a component type:
- Dev mode: visible red placeholder widget showing the unknown type name
- Prod mode: `SizedBox.shrink()` — invisible, no crash

### Render Exceptions

Each component node is wrapped in an error boundary:
- If rendering a node throws: that subtree shows a placeholder
- Sibling and parent nodes continue to render normally

### Schema Validation Failures

If a layout file fails JSON schema validation (e.g. after a sync):
- The invalid file is not saved to local storage
- The previous valid version (or asset bundle) continues to be used
- The failure is logged

---

## Action System

Actions replace callbacks in the JSON schema. An action is a plain data descriptor:

```json
{
  "type": "navigate",
  "path": "/details/$.item.id",
  "push": true
}
```

### Action Types (v1)

| Type | Description |
|---|---|
| `navigate` | Call `context.go()` or `context.push()` via GoRouter |
| `update_state` | Set a key in the screen's `SduiStateStore` |
| `analytics` | Fire an analytics event with a name and params map |
| `chain` | Execute a list of actions sequentially |
| `no_op` | Do nothing (placeholder / disabled state) |

### Deferred to v2

`api_call` — trigger a network request from a user action. Deferred because it introduces network dependency into the renderer, which we want to avoid in v1.

---

## State Management

SDUI uses a screen-scoped `SduiStateStore` for ephemeral local state:

- Accordion open/closed
- Tab index
- Form field values
- Toggle state

```
SduiStateScope (InheritedWidget)
    └── provides SduiStateStore (ChangeNotifier)
            └── Map<String, dynamic> _state
            └── get<T>(key, defaultValue) → T
            └── set<T>(key, value) → notifies listeners
            └── reset() → called on screen disposal
```

**Scope rule:** `SduiStateStore` is screen-scoped. It is reset when the user navigates away. Cross-screen state management uses the app's own state management, not SDUI.

---

## Security

The component registry is a **whitelist**. The server cannot instantiate an arbitrary Flutter widget. It can only reference types that are explicitly registered.

Additional safeguards:
- All layout files pass through JSON Schema validation before being persisted
- Navigation actions are validated against an allowlist of route patterns
- Raw payload contents are never logged in production (may contain PII)
- Layout files are served over HTTPS with integrity verification
- The SDUI engine never evaluates arbitrary code from server payloads
