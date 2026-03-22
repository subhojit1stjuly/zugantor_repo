# ADR-002 — Design Tokens: Separate Files, `@` References

| Field | Value |
|---|---|
| Status | **Accepted** |
| Date | March 2026 |
| Supersedes | — |

---

## Context

If screen JSON files contain hard-coded values (`"color": "#6C63FF"`, `"padding": 24`), changing
the design system requires editing every screen file. This is unmaintainable at scale and makes
theming and white-labelling impossible.

---

## Decision

All design constants live in **separate token files** inside `design/`. Screen JSON files
**never contain hard-coded design values** — they only contain `@token` references.

### Token Files

| File | Prefix | Resolves to |
|---|---|---|
| `design/colors.json` | `@colors.<name>` | Hex string, e.g. `#6C63FF` |
| `design/typography.json` | `@typography.<name>` | `{family, size, weight, height}` |
| `design/spacing.json` | `@spacing.<name>` | Number (logical pixels) |
| `design/radius.json` | `@radius.<name>` | Number (logical pixels) |

### `@` Reference Syntax

```
@<token_type>.<token_name>
```

Examples: `@colors.primary`, `@spacing.lg`, `@typography.heading_1`, `@radius.md`

### Two-tier color structure

`colors.json` has two layers — raw `palette` and semantic `semantic` aliases:

```json
{
  "palette":  { "purple_500": "#6C63FF" },
  "semantic": { "primary": "@palette.purple_500" }
}
```

Screens reference semantic tokens only (`@colors.primary`), never palette tokens directly.

### Token resolution order

`TokenResolver` resolves references at render/codegen time:
1. Look up the token file by prefix (`colors`, `spacing`, etc.)
2. Follow any `@palette.*` indirection within the token file
3. Return the concrete value

### What MAY be hard-coded in screen JSON

Only non-design structural values that are screen-specific and not part of the design system:
- `id` strings
- `bind` JSONPath expressions
- String content (`"value": "Welcome back"`)
- `type` slugs

---

## Consequences

- **Enables:** Single-file theme changes that propagate to all screens instantly.
- **Enables:** White-labelling — swap `design/colors.json`, all screens reflect the new brand.
- **Enables:** The builder's Design panel can edit token files and update all screen previews live.
- **Constrains:** `TokenResolver` must run before any render or code generation step.
- **Constrains:** Screens with unresolved `@` references must fail validation with a clear error.
