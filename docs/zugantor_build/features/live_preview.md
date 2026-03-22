# Live Preview

> Feature: Real-time phone-frame rendered preview · Zone: Right Panel (top half)

---

## Overview

The Live Preview panel displays the current screen rendered inside a device phone frame, giving
users a pixel-accurate sense of how the screen will actually look at runtime. It uses the real
`SduiRenderer` — the same engine used in the Zugantor consumer app — to render the template.

---

## Current Status

> **⚠ BLOCKED** — The Live Preview is not functional until the `zugantor_sdui` rendering engine
> (Phases 1–3 of the SDUI build plan) is complete. A placeholder is shown in its place.

### Placeholder (before engine is ready)

```
┌──────────────────┐
│   [Phone Frame]  │
│                  │
│   ┌──────────┐   │
│   │  Preview │   │
│   │  coming  │   │
│   │  soon    │   │
│   └──────────┘   │
│                  │
└──────────────────┘
```

---

## When Functional (post-engine)

### Rendering

- `SduiRenderer(template: currentScreenJson, data: mockDataMap)` is called whenever:
  1. The canvas or JSON editor produces a new valid screen state.
  2. The [Mock Data Editor](mock_data_editor.md) is updated.
- The rendered output is displayed inside a `PhoneFrame` widget that simulates a device bezel.

### Phone Frame Options

- Frame selector dropdown: iPhone 14, Pixel 7, Generic 390×844.
- Orientation toggle: Portrait / Landscape.

### Sync Trigger

| Event | Re-render? |
|---|---|
| Canvas mutation | Yes — immediately after canvas→JSON sync |
| JSON editor change (valid, debounced) | Yes — after canvas rebuilds |
| Mock data change | Yes — immediately on mock data update |
| Invalid JSON state | No — last valid render is held |

### Scroll

- The preview is scrollable if the rendered screen content overflows the phone frame height.
- The scroll position resets when the screen is reloaded from a new schema state.

---

## Performance

- Rendering is done on the UI thread.
- If the screen is sufficiently complex, a `FutureBuilder` / `compute` approach will be used to
  offload the JSON-to-widget-tree conversion.
- Target: ≤ 100 ms from data change to first rendered frame.

---

## Interaction

- The preview is **read-only** — users cannot tap interactive widgets in the preview to navigate.
- Tapping a rendered component in the preview frame does **not** select it in the canvas.
  (May be added as a stretch goal in a later phase.)

---

## Dependency

Live Preview depends on:
- `zugantor_sdui` package (rendering engine)
- `zugantor_design_system` package (ZDS component implementations)

Both must be available as local path dependencies or published packages before this feature can be enabled.
