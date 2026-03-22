# Editor Screen

> Screen ID: `editor` · Route: `/projects/:projectId/screens/:screenId` · Layout: 5-Zone Split

---

## Overview

The Editor is the core authoring surface. It is a multi-panel workspace where users compose screens
visually on the canvas, inspect and edit the underlying SDUI JSON, and see a live phone-frame preview
of the rendered result.

---

## Layout (5 Zones)

```
┌────────────────────────────────────────────────────────────────────────────┐
│  AI PROMPT BAR  (top, full width, collapsible)                             │
├──────────────┬──────────────────────────────┬─────────────────────────────┤
│ LEFT PANEL   │  CENTRE                       │  RIGHT PANEL                │
│ ──────────── │  ──────────────────────────── │  ──────────────────────────│
│ [Palette]    │  [Canvas] [JSON]              │  ┌──────────────────────┐   │
│ [Layers]     │                               │  │  Live Preview        │   │
│ [Screens]    │  <canvas / json editor>       │  │  (phone frame)       │   │
│              │                               │  └──────────────────────┘   │
│              │                               │  ┌──────────────────────┐   │
│              │                               │  │  Mock Data Editor    │   │
│              │                               │  └──────────────────────┘   │
├──────────────┴──────────────────────────────┴─────────────────────────────┤
│  STATUS BAR  (bottom, full width)                                          │
└────────────────────────────────────────────────────────────────────────────┘
```

All panel dividers are resizable via drag handles (`multi_split_view`).

---

## Zones

| Zone | Doc |
|---|---|
| AI Prompt Bar | [features/ai_prompt_bar.md](../features/ai_prompt_bar.md) |
| Left Panel — Palette, Layers, Screens | See below |
| Centre — Canvas | [features/canvas.md](../features/canvas.md) |
| Centre — JSON Editor | [features/json_editor.md](../features/json_editor.md) |
| Right Panel — Live Preview | [features/live_preview.md](../features/live_preview.md) |
| Right Panel — Mock Data Editor | [features/mock_data_editor.md](../features/mock_data_editor.md) |
| Status Bar | [features/status_bar.md](../features/status_bar.md) |

---

## Left Panel

The left panel contains three tabs that share the same column:

### Palette Tab

- Lists all available ZDS components grouped by category (e.g. Layout, Typography, Input, Media).
- Each component shows its icon, name, and a tooltip with a short description.
- Components are drag-and-droppable onto the canvas.
- A search bar at the top filters the palette in real time.

### Layers Tab

- Shows the full widget tree of the current screen as a collapsible tree.
- Each node displays: component type icon + `id` (or inferred label).
- Selecting a node in the tree simultaneously selects it on the canvas and scrolls it into view.
- Nodes can be reordered by drag-and-drop within the tree.
- Right-click context menu: **Select · Duplicate · Delete · Add child**

### Screens Tab

- Lists all screens in the current project.
- Each row shows the screen name and a small thumbnail.
- `[+ Add Screen]` button at the bottom.
- Clicking a screen loads it into the centre editor zone.
- Right-click context menu: **Rename · Duplicate · Delete**

---

## Navigation

- The editor occupies the full window.
- A back arrow (top-left) returns to the Home/Projects screen.
- Unsaved changes prompt a confirmation dialog before leaving.

---

## Keyboard Shortcuts

| Shortcut | Action |
|---|---|
| `Ctrl/Cmd + Z` | Undo |
| `Ctrl/Cmd + Shift + Z` | Redo |
| `Ctrl/Cmd + S` | Save |
| `Ctrl/Cmd + E` | Open Export Dialog |
| `Delete` / `Backspace` | Delete selected node |
| `Ctrl/Cmd + D` | Duplicate selected node |
| `Escape` | Deselect |
| `Ctrl/Cmd + \`` | Toggle AI Prompt Bar |

---

## State

| State | Type | Notes |
|---|---|---|
| `currentScreen` | `ScreenModel` | The screen currently loaded in the editor |
| `selectedNodeId` | `String?` | ID of the selected canvas node; null if nothing selected |
| `activeLeftTab` | `LeftPanelTab` | `palette` / `layers` / `screens` |
| `activeCentreTab` | `CentreTab` | `canvas` / `json` |
| `isDirty` | `bool` | True when there are unsaved changes |
| `undoStack` | `List<ScreenModel>` | In-memory undo history |
| `redoStack` | `List<ScreenModel>` | In-memory redo history |

---

## Open Questions

- Should multiple screens be open as tabs in the editor simultaneously, or one at a time?
- Should the left panel show the property inspector inline (below the layers tree) 
  or in a separate bottom section?
