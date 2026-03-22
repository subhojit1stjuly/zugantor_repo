# Canvas

> Feature: Visual drag-and-drop authoring surface · Zone: Centre (Tab 1 of 2)

---

## Overview

The Canvas is the main visual editing surface inside the [Editor Screen](../screens/editor_screen.md).
It displays the current screen's layout as a tree of structural blocks. It is **not** a live
ZDS-rendered view — it renders simplified structural representations so the user can understand the
hierarchy and configure components.

---

## What the Canvas Is (and Is Not)

| The Canvas IS | The Canvas is NOT |
|---|---|
| A structural, drag-reorder widget tree | A pixel-perfect preview |
| Synchronised with the JSON editor (bidirectional) | A live `SduiRenderer` output |
| The source of truth for drag + selection | A Figma-style free-form canvas |

Live rendered output is shown separately in the [Live Preview](live_preview.md) panel.

---

## Block Visual Style

Each node in the widget tree is rendered as a block. The block shows:

- **Component icon** (from ZDS component registry)
- **Component type** (e.g. `zds.text`, `zds.column`)
- **`id`** value (e.g. `heading_1`)
- **Selection state**: highlighted border + primary color tint when selected

Children are indented under their parent. Layout containers (`column`, `row`, `stack`) show a
drop zone between children when hovering during a drag.

> **Open question:** Block visual style — bordered boxes, chips, or mini-cards?
> Decision pending — see [requirements.md](../requirements.md#7-open-questions).

---

## Interactions

### Drag from Palette

1. User drags a component from the Palette tab.
2. As the drag moves over the canvas, a drop indicator shows the insertion point.
3. On drop, the node is inserted at that position in the tree.
4. A new `id` is auto-assigned (format: `<type_slug>_<incremental_int>`, e.g. `text_3`).
5. The JSON editor updates instantly.

### Select

- Single click → selects the node.
- The selected node is highlighted on canvas and in the Layers tree.
- The property panel (inline or bottom section — TBD) shows that node's props.

### Reorder

- Drag a block up/down to reorder within its parent.
- Drag into a container block to nest it.
- JSON updates instantly on drop.

### Delete

- `Delete` / `Backspace` key when a node is selected.
- Also accessible via right-click context menu.
- Confirmation is NOT required (undo is available via `Ctrl/Cmd+Z`).

### Duplicate

- `Ctrl/Cmd+D` or context menu.
- Inserts the duplicate immediately below the original.
- A new unique `id` is assigned to the duplicate (and all descendants).

### Collapse / Expand

- Container nodes have a chevron to collapse their children.
- Collapsed state is cosmetic only — does not affect the JSON.

---

## Bidirectional Sync with JSON Editor

| Direction | Trigger | Behaviour |
|---|---|---|
| Canvas → JSON | Any mutation (drop, reorder, delete, prop change) | JSON updated instantly |
| JSON → Canvas | 500 ms debounce after last keystroke in JSON editor | JSON parsed; canvas rebuilt via diff |

### JSON → Canvas Diff Algorithm

1. Parse the new JSON.
2. Compare against current canvas tree, keyed by `id`.
3. Nodes with matching `id` and unchanged props are kept in place (no flicker).
4. New nodes (by `id`) are inserted.
5. Removed nodes are removed.
6. If JSON is invalid (parse error): canvas is untouched, JSON editor shows a red border.

---

## Auto ID Assignment

When a node is added to the canvas without an explicit `id`:

```
<type_slug>_<next_available_int>
```

Examples: `text_1`, `column_2`, `image_3`.

If the incoming JSON already contains an `id`, it is preserved as-is.

---

## Undo / Redo

- Every structural mutation (drop, reorder, delete, prop change) pushes a snapshot to the undo stack.
- Undo: `Ctrl/Cmd+Z` — pops the last snapshot and restores the canvas + JSON.
- Redo: `Ctrl/Cmd+Shift+Z` — replays the last undone action.
- The undo stack is in-memory only (cleared on project load or app restart).
- Maximum undo stack depth: 100 operations.
