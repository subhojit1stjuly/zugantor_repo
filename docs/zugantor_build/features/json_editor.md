# JSON Editor

> Feature: Structured SDUI JSON code editor · Zone: Centre (Tab 2 of 2)

---

## Overview

The JSON Editor is the raw-text view of the current screen's SDUI template. It is a full-featured
code editor that allows developers to author and inspect the SDUI JSON directly. It is kept in
bidirectional sync with the [Canvas](canvas.md).

---

## Package

Built on `flutter_code_editor` with the `highlight` package for Dart/JSON syntax highlighting.

---

## Layout

```
┌──────────────────────────────────────────────────────────────┐
│  [Canvas]  [JSON]                   [🔧 Format]  [⚠ 2 errors] │
│  ──────────────────────────────────────────────────────────── │
│  1  {                                                         │
│  2    "screen_id": "profile_screen",                         │
│  3    "schema_version": "1",                                  │
│  4    "layout": {                                             │
│  5      "type": "zds.column",                                │
│  6      "id": "root_column",                                 │
│  7      "props": {},                                          │
│  8      "children": [                                         │
│  ...                                                          │
└──────────────────────────────────────────────────────────────┘
```

---

## Features

### Syntax Highlighting

- JSON syntax highlighting (keys, strings, numbers, booleans, null).
- SDUI-specific known keys (`type`, `id`, `props`, `bind`, `children`) are given extra emphasis.

### Line Numbers

- Guttered line numbers on the left.

### Error Gutter

- Parse errors and schema validation failures are shown as red circles in the line gutter.
- Hovering a gutter error shows a tooltip with the error message.

### Format Button

- `[🔧 Format]` button in the editor toolbar.
- Runs JSON pretty-print (4-space indent) on the current content.
- Equivalent to `Ctrl/Cmd+Shift+F`.

### Error Counter

- `[⚠ N errors]` badge in the toolbar shows the current count of JSON parse and schema errors.
- Clicking it scrolls to the first error.
- Badge is hidden when there are no errors.

---

## Sync Behaviour

| Direction | Trigger | Behaviour |
|---|---|---|
| JSON → Canvas | 500 ms debounce after last keystroke | Parse → diff by `id` → rebuild canvas |
| Canvas → JSON | Any canvas mutation | JSON updated instantly, cursor position preserved |

### Invalid JSON Handling

- If the JSON fails to parse (syntax error):
  - The JSON editor shows a red bottom border.
  - The canvas is **not** updated (it remains at the last valid state).
  - A parse error annotation appears in the gutter at the offending line.
- When the user corrects the JSON and the debounce fires again:
  - If now valid, the canvas updates normally.

### Schema Validation

- After a successful JSON parse, the content is also validated against the SDUI schema.
- Schema errors do not block the canvas — the canvas updates with the best-effort tree.
- Schema errors are shown as gutter warnings (yellow) rather than errors (red).

---

## Scroll Sync

- When the user selects a node on the [Canvas](canvas.md), the JSON editor scrolls to the
  `id` field of that node's JSON object.
- When the user clicks inside the JSON editor, the nearest enclosing node's `id` is detected and
  the corresponding canvas block is selected (if identifiable).

---

## Copy / Paste

- Standard OS copy/paste works within the editor.
- Pasting valid SDUI JSON fragments into the children array is supported.
- Pasting triggers the same 500 ms debounce and validation cycle.

---

## Keyboard Shortcuts (inside JSON editor)

| Shortcut | Action |
|---|---|
| `Ctrl/Cmd + Z` | Undo within text editor |
| `Ctrl/Cmd + Shift + Z` | Redo within text editor |
| `Ctrl/Cmd + Shift + F` | Format JSON |
| `Ctrl/Cmd + /` | Toggle line comment |
| `Ctrl/Cmd + F` | Find within editor |
