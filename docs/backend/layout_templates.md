# Layout Templates

## What This Document Covers

This document describes what a layout template is, its exact JSON format, and what the frontend needs in order to receive the right template for a given screen.

---

## What a Layout Template Is

A layout template is a **JSON file** that describes the visual structure of a screen. It tells the frontend renderer:

- Which UI components to render
- In what order and hierarchy
- What static values to apply to each component
- Where to expect live data to be bound in (via bind expressions)
- What actions should happen when a user interacts with the screen

A layout template contains **no live user data**. It does not contain a user's name, balance, transaction list, or any other personalized content. Those come from the data map separately (see [data_requirements.md](data_requirements.md)).

Because the template is not personalized, the same file can be stored and reused for all users on the same screen.

---

## The Full Template Format

Below is an annotated description of every field in a layout template.

### Top-Level Object

```json
{
  "schema_version": 1,
  "screen_id": "transaction_detail",
  "metadata": { ... },
  "root": { ... }
}
```

| Field | Type | Required | Description |
|---|---|---|---|
| `schema_version` | integer | yes | The version of the template schema. The frontend uses this to check compatibility. If the schema version is higher than what the installed app supports, the frontend will fall back to a hardcoded screen or show a graceful error. |
| `screen_id` | string | yes | The stable identifier for this screen. Must match what the frontend uses when it requests a template. |
| `metadata` | object | no | An arbitrary key-value map for tracking purposes. The frontend does not use this to render anything — it logs it with analytics events. The architect can add `variant_id`, `experiment_id`, `template_version`, `authored_by`, or any other tracking field here. The frontend passes all metadata keys through to its analytics layer. |
| `root` | object | yes | The root component node. This is the top-level widget of the screen. It must be a layout component (column, row, or container) in practice. |

---

### Component Node

Every component in the tree (including the root) is a node with this shape:

```json
{
  "type": "zds_column",
  "id": "main_column",
  "props": {
    "cross_axis_alignment": "start",
    "padding": { "top": 16, "horizontal": 16 }
  },
  "bind": {},
  "actions": [],
  "children": [ ... ]
}
```

| Field | Type | Required | Description |
|---|---|---|---|
| `type` | string | yes | The component type. Must be a value from the frontend's component registry. If the type is unknown, the frontend renders a safe empty placeholder widget. |
| `id` | string | no | A stable identifier for this node within the screen. Used internally for state management and analytics events. Not required, but recommended for any interactive node. |
| `props` | object | no | Static configuration values for this component. These are applied directly without any data lookup. Keys and value types are specific to each component type. See the Component Props Reference below. |
| `bind` | object | no | Dynamic values that are resolved from the data map at render time. Each key is a prop name (same as in `props`), and each value is a JSONPath expression pointing to a field in the data map (e.g. `"$.user.display_name"`). At render time, the frontend looks up the path in the data map and uses the resolved value as the prop value. If a bind expression cannot be resolved, the component renders its default/empty state for that prop. |
| `actions` | array | no | A list of action descriptors. See the Actions section below. |
| `children` | array | no | An ordered list of child component nodes. Only valid on components that accept children (layout containers). |

---

### Props — Common Values

Props are component-specific. The following are common across many components:

**Padding** (object):
```json
{ "top": 8, "bottom": 8, "left": 16, "right": 16 }
```
Shorthand keys are also accepted:
```json
{ "vertical": 8, "horizontal": 16 }
```
Or a single all-sides value:
```json
{ "all": 12 }
```

**Text styles** (object):
```json
{ "style": "body_medium", "weight": "bold", "color": "#1A1A2E" }
```
`style` maps to the app's text theme scale: `display_large`, `title_large`, `title_medium`, `body_large`, `body_medium`, `label_small`.

**Colors** (string): hex color strings (`#RRGGBB` or `#AARRGGBB`), or semantic color tokens from the design system: `primary`, `on_primary`, `surface`, `on_surface`, `error`, `on_error`.

**Alignment**:
- Main axis: `start`, `end`, `center`, `space_between`, `space_around`, `space_evenly`
- Cross axis: `start`, `end`, `center`, `stretch`, `baseline`

---

### Actions

Actions describe what should happen when a user interacts with a component (e.g. taps a button).

```json
{
  "trigger": "on_tap",
  "type": "navigate",
  "payload": {
    "route": "/details",
    "params": {
      "id": "$.transaction.id"
    }
  }
}
```

| Field | Type | Required | Description |
|---|---|---|---|
| `trigger` | string | yes | The user interaction that fires the action. Supported triggers: `on_tap`, `on_long_press`. |
| `type` | string | yes | The action type. Supported types: `navigate`, `open_url`, `dismiss`, `log_event`. Unknown action types are silently ignored. |
| `payload` | object | yes | The payload for the action. Shape depends on `type`. |

**`navigate` payload:**

```json
{
  "route": "/transaction_detail",
  "params": {
    "transaction_id": "$.transaction.id"
  }
}
```

`params` values can be literal strings or `$.path` bind expressions — the value is resolved from the data map before navigation occurs. The frontend validates the route against an internal allowlist before navigating. The architect **does not** control which routes are allowed.

**`open_url` payload:**

```json
{
  "url": "https://zugantor.com/help"
}
```

The URL is opened in the system browser. The frontend validates the URL against a configured domain allowlist before opening.

**`log_event` payload:**

```json
{
  "event": "button_clicked",
  "properties": {
    "button_label": "$.cta.label"
  }
}
```

---

## Component Props Reference

A condensed reference of accepted `props` keys by component type. Bind expressions in the `bind` object use the same key names.

### `zds_text`
| Key | Type | Description |
|---|---|---|
| `text` | string | The string to display. Usually bound from data. |
| `style` | string | Text theme scale name. Default: `body_medium`. |
| `weight` | string | `normal`, `medium`, `bold`. |
| `color` | string | Hex or semantic color token. |
| `max_lines` | integer | Maximum lines before truncation. |
| `overflow` | string | `ellipsis`, `fade`, `clip`. |
| `text_align` | string | `start`, `center`, `end`. |

### `zds_button`
| Key | Type | Description |
|---|---|---|
| `label` | string | Button label text. |
| `variant` | string | `filled`, `outlined`, `text`. |
| `icon` | string | Optional icon name from the design system icon set. |
| `disabled` | boolean | Whether the button is non-interactive. Can be bound. |

### `zds_card`
| Key | Type | Description |
|---|---|---|
| `padding` | object | Inner padding. |
| `elevation` | number | Shadow elevation. |
| `color` | string | Background color. |

### `zds_avatar`
| Key | Type | Description |
|---|---|---|
| `image_url` | string | Image URL. Usually bound from data. |
| `initials` | string | Fallback text if image is unavailable. |
| `size` | number | Diameter in logical pixels. |

### `zds_chip`
| Key | Type | Description |
|---|---|---|
| `label` | string | Chip text. Usually bound from data. |
| `color` | string | Background color. |
| `text_color` | string | Label color. |
| `icon` | string | Optional leading icon. |

### `zds_icon`
| Key | Type | Description |
|---|---|---|
| `name` | string | Icon name from the design system icon set. |
| `size` | number | Size in logical pixels. |
| `color` | string | Icon color. |

### `zds_list_tile`
| Key | Type | Description |
|---|---|---|
| `title` | string | Primary text. Usually bound. |
| `subtitle` | string | Secondary text. Usually bound. |
| `leading_icon` | string | Icon name for the left slot. |
| `trailing_text` | string | Text on the right side. Usually bound. |
| `trailing_icon` | string | Icon name for the right slot. |
| `dense` | boolean | Compact variant. |

### `zds_divider`
| Key | Type | Description |
|---|---|---|
| `indent` | number | Left indent. |
| `end_indent` | number | Right indent. |
| `thickness` | number | Thickness in logical pixels. |
| `color` | string | Line color. |

### `zds_spacer`
| Key | Type | Description |
|---|---|---|
| `height` | number | Vertical space in logical pixels. |
| `width` | number | Horizontal space in logical pixels. |

### `zds_column` / `zds_row`
| Key | Type | Description |
|---|---|---|
| `main_axis_alignment` | string | Alignment along main axis. |
| `cross_axis_alignment` | string | Alignment along cross axis. |
| `main_axis_size` | string | `min` or `max`. |
| `padding` | object | Padding around the container. |

### `zds_container`
| Key | Type | Description |
|---|---|---|
| `padding` | object | Inner padding. |
| `color` | string | Background color. |
| `border_radius` | number | Corner radius in logical pixels. |
| `width` | number | Fixed width. |
| `height` | number | Fixed height. |

---

## A Full Template Example

```json
{
  "schema_version": 1,
  "screen_id": "transaction_detail",
  "metadata": {
    "template_version": "1.0.0",
    "authored_by": "design_team"
  },
  "root": {
    "type": "zds_column",
    "props": {
      "padding": { "all": 16 },
      "cross_axis_alignment": "start"
    },
    "children": [
      {
        "type": "zds_text",
        "props": { "style": "title_large", "weight": "bold" },
        "bind": { "text": "$.transaction.merchant_name" }
      },
      {
        "type": "zds_spacer",
        "props": { "height": 8 }
      },
      {
        "type": "zds_text",
        "props": { "style": "display_large", "color": "primary" },
        "bind": { "text": "$.transaction.formatted_amount" }
      },
      {
        "type": "zds_chip",
        "props": { "color": "#E8F5E9", "text_color": "#2E7D32" },
        "bind": { "label": "$.transaction.status_label" }
      },
      {
        "type": "zds_divider",
        "props": { "thickness": 1 }
      },
      {
        "type": "zds_list_tile",
        "props": { "leading_icon": "calendar_today" },
        "bind": {
          "title": "$.transaction.date_label",
          "subtitle": "$.transaction.time_label"
        }
      },
      {
        "type": "zds_button",
        "props": { "label": "Report an Issue", "variant": "outlined" },
        "actions": [
          {
            "trigger": "on_tap",
            "type": "navigate",
            "payload": {
              "route": "/support_ticket",
              "params": { "transaction_id": "$.transaction.id" }
            }
          }
        ]
      }
    ]
  }
}
```

---

## What the Frontend Needs — Summary

The frontend needs to be able to:

1. **Receive a layout template by screen ID** — given a `screen_id`, get the correct template file.
2. **Receive the template at startup or on-demand** — the first time a screen is accessed, or when a sync check detects a newer version.
3. **Know which template version it currently has** — so it can ask "is there something newer?" without re-downloading everything.

See [sync_requirements.md](sync_requirements.md) for how the frontend checks and syncs.

---

## Open Questions for the Architect

- How are layout templates authored and stored? Is there a tool, a file system, or a database on the backend?
- How does the architect want to handle platform-specific variations? Should the same `screen_id` return different templates for mobile vs. web vs. desktop, or is one template used across all platforms?
- What should happen when the schema version in a template exceeds what the installed app supports? The frontend will fall back gracefully, but should the backend detect this and serve a compatible version instead?
- Will templates be environment-specific (staging, production), and how will the frontend know which environment it is pointing to?
- Who has authority to publish a template? Is there an approval or review process?
