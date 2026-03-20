# SDUI — Key Decisions

These are the 15 finalized architectural decisions for the Zugantor SDUI system. Each decision is locked. If any needs to be revisited, it should be treated as a breaking change to the architecture and documented as such.

---

## Architecture

### Decision 1 — Template + Data Separation

**Decision:** Layout templates (JSON files) are stored locally on the device. Data comes from separate API calls. They are **never merged into a single payload**.

**Rejected alternatives:**
- A: Data-in-payload (server sends layout + data together in one API response)
- B: Client fetches template from server at screen open, then fetches data separately

**Rationale:** Local templates are always available (no network dependency for layout). Templates update independently of data. Updates are deployment-free. Cache TTLs differ: layout is stable, data is live.

---

### Decision 2 — Rendering Model

**Decision:** `SduiRenderer(template: layoutMap, data: apiResponseMap) → Widget`

The renderer is a **pure function**: it takes two maps, returns a widget tree. It makes no network calls, has no side effects, and stores no state. It can be tested with any two maps.

**Rationale:** Purity makes the renderer trivially testable, predictable, and debuggable. The screen widget handles all I/O; the renderer handles only presentation.

---

### Decision 3 — Binding Syntax

**Decision:** Explicit `props` (static) + `bind` (dynamic JSONPath) separation. They are separate JSON fields on each component node.

```json
{
  "type": "zds.text",
  "props": { "style": "@typography.bodyMedium" },
  "bind": { "text": "$.user.display_name" }
}
```

**Rejected alternative:** Mustache-style interpolation (`"text": "Hello {{user.display_name}}"`) — mixing static and dynamic values in a single string is ambiguous, hard to type, and complicates non-string bindings (booleans, numbers, colors).

**Rationale:** The `props`/`bind` split is explicit and unambiguous. The component builder receives one merged map and doesn't need to know where values came from.

---

### Decision 4 — BFF Pattern for Data

**Decision:** The SDUI engine (`zugantor_sdui`) makes **zero network calls**. The screen widget fetches data via `zugantor_data` and passes the result map into `SduiRenderer`.

**Rationale:** This enforces the dependency law. `zugantor_sdui` and `zugantor_data` never depend on each other. The screen is the composition layer. Testing the renderer requires no network infrastructure.

---

### Decision 5 — Data Philosophy

**Decision:** Philosophy C — own hybrid approach. Local layout files + separate data API + binding engine.

This is our own pattern, distinct from standard SDUI approaches:
- Netflix/AirBnB SDUI: server sends complete layout + data in one response
- Pure template approach: client fetches template on open, then fetches data

Our approach combines the offline-first guarantee of local templates with the freshness of live data APIs.

---

## Scope

### Decision 6 — SDUI Scope Boundary

**Decision:** SDUI applies to **authenticated app screens only.** The following screens are hardcoded Flutter and will never be SDUI:

- Splash screen
- Onboarding flow
- Login / OTP / SSO
- Biometrics / PIN / security challenge screens
- Offline / no-network fallback screens
- Force-update gate screen

**Rationale:** These screens must work before authentication, in degraded network conditions, or involve security requirements that cannot tolerate server-controlled layout.

---

### Decision 7 — Universal Screen Model

**Decision:** Every SDUI screen — regardless of archetype — is represented as a **scrollable column of typed sections**. There is no special schema per screen type.

All 8 screen archetypes (feed, detail, dashboard, form, empty state, settings, confirmation, search results) map to the same JSON container model. The difference is in the sections and components, not the root shape.

---

### Decision 8 — Action Scope v1

**Decision:** v1 supports only: `navigate`, `update_state`, `analytics`, `chain`, `no_op`.

`api_call` is **deferred to v2.** Reasons: it introduces network dependency into the renderer, requires error/retry UI to be specified in the schema, and significantly increases complexity.

---

### Decision 9 — Layout File Lifecycle

**Decision:**
1. Layout files are bundled as Flutter assets in the app binary (always available fallback)
2. `SduiLayoutManager` checks for newer versions from the CDN on app startup (silent background sync)
3. On screen open: use local storage version if it is newer than the asset bundle; otherwise use the asset bundle
4. If sync fails: the current version continues to work with no user-visible impact

---

### Decision 10 — Missing Binding Values

**Decision:** If a `bind` expression resolves to null or points to a missing path in the data map, that prop renders nothing (empty string, hidden widget, zero value). **The renderer never crashes due to a missing bind value.**

This is consistent with the error boundary principle: a single missing piece of data should not take down the whole screen.

---

## AI Authoring

### Decision 11 — AI Vocabulary = ZDS Registry

**Decision:** AI can only compose components that are registered in `ZdsComponentRegistry`. It cannot reference types outside the whitelist. It authors layout templates (static props + bind expressions). It never authors data, business logic, or custom code.

**Rationale:** The registry is the safety boundary. If a type is not in the registry, it cannot appear in a rendered screen — regardless of what the AI generates.

---

### Decision 12 — Schema is the Safety Gate

**Decision:** All AI-generated and server-delivered layout files must pass JSON Schema validation (`sdui_schema.json`) before being persisted to local storage. Invalid payloads are rejected and logged. The previous valid version is retained.

---

## Localization

### Decision 13 — Two-Mechanism Localization

**Decision:** Static app strings (hardcoded screens) use Flutter's `l10n` ARB files. SDUI content strings are **pre-localized by the server** — the server returns strings in the correct language for the requesting locale. These two mechanisms are never conflated.

**Rationale:** Sending translation keys in SDUI payloads would require the client to run a lookup for every string. Server-side pre-localization is simpler for v1 and keeps the client stateless with respect to translations.

---

## State

### Decision 14 — State Scope

**Decision:** `SduiStateStore` is screen-scoped. It is created when `SduiScreen` is initialized and reset (fully cleared) when `SduiScreen` is disposed (user navigates away).

Cross-screen state (user session, preferences, cart, etc.) uses the app's own state management. It is explicitly not SDUI's concern.

---

### Decision 15 — Unknown Component Behavior

**Decision:**
- Dev mode (`kDebugMode`): visible red bordered placeholder widget showing the unknown type string, plus a `dart:developer` log entry at severity WARNING
- Prod mode (`kReleaseMode`): `SizedBox.shrink()` — invisible, silent, no crash

**Rationale:** Dev mode failures must be loud so engineers catch registry mismatches immediately. Prod failures must be silent so users are never shown broken UI — a missing widget is better than an error screen.
