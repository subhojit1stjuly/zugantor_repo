# Status Bar

> Feature: Contextual editor metadata and quick actions · Zone: Bottom (full width)

---

## Overview

The Status Bar sits at the very bottom of the [Editor Screen](../screens/editor_screen.md). It
provides at-a-glance context about the current screen and project state, and exposes the most
frequently used quick actions.

---

## Layout

```
┌────────────────────────────────────────────────────────────────────────────┐
│  screen_id: home_screen  │  schema v1  │  ✓ Synced  │             [Export] │
└────────────────────────────────────────────────────────────────────────────┘
```

Left-aligned items provide context. Right-aligned `[Export]` is the primary action.

---

## Left Section — Context Chips

### Screen ID

- Displays the `screen_id` of the currently open screen.
- Format: `screen_id: home_screen`
- Clicking it opens an inline rename input.

### Schema Version

- Displays the SDUI schema version used by the current template.
- Format: `schema v1`
- Read-only. Version is set automatically based on the project setting.

### Sync Status

Displays the current sync state of the project. See
[Project Storage & Sync](project_storage_sync.md#sync-status-states) for all states.

| State | Display |
|---|---|
| Fully synced | `✓ Synced` (muted green) |
| Pushing | `↑ Pushing…` (animated, blue) |
| Pulling | `↓ Pulling…` (animated, blue) |
| Conflict on current screen | `⚠ Conflict` (orange) — clickable, opens conflict panel |
| Sync error | `✗ Sync error` (red) — hovering shows tooltip with message |
| No remote configured | _(not shown)_ |

### Unsaved Changes Indicator

- When `isDirty` is true, a small `●` dot appears next to the screen ID.
- `Ctrl/Cmd+S` saves and clears the dot.

---

## Right Section — Quick Actions

### `[Export]` Button

- Opens the [Export Dialog](../screens/export_dialog.md).
- This is a primary action button (filled, accent color).
- Keyboard shortcut: `Ctrl/Cmd+E`.

### Sync Manual Trigger (when remote configured)

- `[↑ Push]` — visible when there are local changes not yet pushed.
- `[↓ Pull]` — visible when the remote has changes not yet pulled.
- Only shown when sync mode is set to Manual in Settings.

---

## Error / Warning Count

- If the current screen's JSON has validation errors or schema warnings, a count badge appears:
  - `⚠ 2 warnings` (yellow)
  - `✗ 1 error` (red)
- Clicking the badge jumps to the JSON editor tab and scrolls to the first issue.

---

## Height & Style

- Fixed height: 28 px.
- Background: slightly elevated surface (1dp above editor background).
- Font: monospace, 11px, secondary text color.
- Dividers between chips are thin vertical separators.
