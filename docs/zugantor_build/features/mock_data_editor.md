# Mock Data Editor

> Feature: Editable JSON data map for Live Preview · Zone: Right Panel (bottom half)

---

## Overview

The Mock Data Editor provides an editable JSON object that represents the `data` map passed to
`SduiRenderer` at preview time. It allows users to see how the screen looks with different data
values without needing a live API endpoint.

---

## Layout

```
┌──────────────────────────────────────────┐
│  Mock Data                   [Reset] [?] │
│  ──────────────────────────────────────  │
│  1  {                                    │
│  2    "user": {                          │
│  3      "display_name": "Ada Lovelace",  │
│  4      "avatar_url": "https://..."      │
│  5    }                                  │
│  6  }                                    │
│                                          │
└──────────────────────────────────────────┘
```

---

## Behaviour

### Live Re-render on Change

- Any valid change to the mock data JSON triggers an immediate re-render of the [Live Preview](live_preview.md).
- Invalid JSON (parse error): preview holds the last valid render. The editor shows a red border.

### Default Mock Data

- When a screen is loaded for the first time, the mock data editor is pre-populated with a
  skeleton object inferred from the `bind` expressions found in the template.
- Example: if the template contains `"bind": {"text": "$.user.display_name"}`, the initial
  mock data will include:
  ```json
  {
    "user": {
      "display_name": "Sample Text"
    }
  }
  ```

### Reset

- `[Reset]` button restores the mock data to the auto-inferred skeleton.
- A confirmation is shown if the user has manually edited the mock data.

### Persistence

- Mock data is saved per-screen alongside the screen's SDUI JSON.
- It is **not** included in SDUI export formats — it is a development-only artefact.

---

## Editor Features

- JSON syntax highlighting (same `flutter_code_editor` stack as the JSON Editor).
- Line numbers.
- Gutter error indicators for parse errors.
- No schema validation — any valid JSON is accepted.

---

## Relationship to Bind Expressions

Bind expressions in the template use JSONPath syntax:

```json
"bind": {
  "text": "$.user.display_name"
}
```

The `$` root refers to the mock data object. The Live Preview resolves these paths against the
mock data at render time, exactly as the runtime engine does against the real API response.

---

## Help Tooltip (`[?]`)

Clicking `[?]` opens a small inline tooltip explaining:

> "This data is passed to the preview renderer. It simulates what your API would return.
> Use `$.path.to.value` syntax in bind expressions to reference values here."
