# ADR-005 — Backend = Dummy Mock Data in v1

| Field | Value |
|---|---|
| Status | **Accepted** |
| Date | March 2026 |
| Supersedes | — |

---

## Context

The long-term vision includes a full backend design surface (API spec, endpoint definitions,
request/response schema). Building this in v1 would block the UI authoring toolchain for months.
A simpler stand-in is needed that satisfies the core use case: seeing a screen rendered with
realistic data in the builder preview.

---

## Decision

In v1, there is **no API spec, no endpoint schema, and no network calls** in the builder.

Each screen has a companion mock data file:

```
screens/
  home_screen.json            ← UIDL template
  home_screen.mock.json       ← free-form JSON object
```

### Mock data file format

```json
{
  "user": {
    "name": "Ada Lovelace",
    "is_premium": true,
    "avatar_url": "https://..."
  },
  "products": [
    { "title": "Running Shoes", "price": 89.99 }
  ]
}
```

- No schema. No types. Any valid JSON is accepted.
- Authored by the user in the Mock Data Editor panel.
- Auto-scaffolded when a screen is first created (inferred from `bind` expressions).
- Saved alongside the screen JSON. **Not included in any export format.**

### Bind expression resolution

`bind` expressions use JSONPath syntax:
- `$.user.name` — top-level field access
- `$.products` — array (used as `source` in `data.list`)
- `$.item.title` — item-level access inside a `data.list` loop (`$item` is the loop variable)

The `TokenResolver` resolves `@token` references. A separate `BindResolver` resolves `$` paths
against the mock data map.

### v1+ Backend Design Surface

Future phase will introduce a proper API spec layer. When added, the mock data file is replaced
by the API response shape defined in the spec. The bind expression syntax is identical — no
screen templates need to change.

---

## Consequences

- **Enables:** The builder preview is fully functional in v1 without any backend infrastructure.
- **Enables:** Designers can author screens with realistic data immediately.
- **Constrains:** No validation that a bind path actually exists in a real API response in v1.
- **Constrains:** Mock data must be manually maintained when the screen's bind expressions change.
