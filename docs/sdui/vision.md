# SDUI — Vision & Scope

## The Core Idea

The goal is a system where **authenticated app screens can be updated without deploying a new app version**. Layout templates are updated silently over-the-air. Data flows from the API as it always has. The Flutter app renders whatever the template describes.

This is not about sending raw JSON over the wire and hoping the client can handle it. It is a structured, schema-validated, whitelist-only system where the server (or AI) composes known components into new arrangements.

---

## The Platform SDK Vision

Instead of thinking about this as "one app with SDUI", think of it as a **platform SDK** that any future app in this monorepo can adopt.

```
zugantor_design_system   ← ZDS components (the vocabulary)
zugantor_sdui            ← Layout engine (the grammar)
zugantor_data            ← Data layer (the facts)
zugantor_charts          ← Chart components (phase 3)
zugantor_notifications   ← Push + in-app notifications (phase 3)
```

Each package is independently useful. Apps wire them together.

---

## AI Authoring Model

The ZDS component registry is the AI's vocabulary. AI cannot invent new components — it can only compose components that exist in the registry.

```
AI generates layout JSON
        │
        ▼
JSON Schema Validator (safety gate)
        │
   pass ▼          fail
SduiLayoutManager  ──→  reject (log + alert)
        │
        ▼
SduiRenderer → Widget tree
```

**AI authors layout templates** — it decides which components appear, in what order, with what static props and what bind expressions. It never authors data, business logic, or custom code.

This means: a product manager can describe a screen in plain language → AI generates the layout JSON → schema validator accepts it → screen is live. **No deployment needed.**

---

## What IS SDUI

These screen types are SDUI candidates — they can be partially or fully driven by layout templates:

| Archetype | Description | SDUI Fit |
|---|---|---|
| **Feed / List** | Scrollable list of homogeneous or mixed items | Excellent |
| **Detail** | Single item with rich content sections | Excellent |
| **Dashboard** | Metrics, charts, quick actions, status summary | Excellent |
| **Form** | Collect user input, validation, submission | Good |
| **Empty State** | Placeholder when content is missing | Good |
| **Settings / Profile** | Account info, preferences, toggles | Good |
| **Confirmation** | Result screen after an action (success/error) | Good |
| **Search Results** | Query-driven list view | Good |

All of these follow the same structure: **a scrollable column of typed sections**.

---

## What Is NEVER SDUI

These screens are hardcoded in Flutter. They must NOT be server-driven.

| Screen | Reason |
|---|---|
| **Splash screen** | Must render instantly, before any network call |
| **Onboarding flow** | Static, intentionally authored experience |
| **Login / OTP / SSO** | Security-critical, must be audited code |
| **Biometrics / PIN entry** | Cannot have layout changed over the wire |
| **Offline / error fallback** | Must work when network is unreachable |
| **Force-update gate** | Must survive unknown schema changes |

**Rule:** If the screen is a prerequisite for the user reaching authenticated state, it is hardcoded.

---

## Deployment-Free Content Updates

The lifecycle of a layout update:

1. Product team (or AI) authors a new layout template JSON file
2. Template passes schema validation
3. Template is published to the layout CDN / backend
4. App silently syncs the new file to local storage in the background
5. On next screen open: new template is used
6. No app release. No user action.

Data is completely separate — it comes from the same API endpoints that always existed.

---

## What This System Is NOT

- It is **not** a low-code platform. There is no visual drag-and-drop editor (yet).
- It is **not** arbitrary code execution. The server cannot run Dart code on the client.
- It is **not** a replacement for the design system. ZDS is what makes this safe — the registry only exposes ZDS components.
- It is **not** a CMS. It does not manage content. It manages layout and structure.

---

## Single Universal Screen Model

Every SDUI screen — regardless of archetype — is represented as:

```json
{
  "screen_id": "home_dashboard",
  "schema_version": 1,
  "metadata": { "title": "Dashboard", "cache_ttl_seconds": 60 },
  "sections": [
    {
      "id": "hero",
      "type": "header",
      "component": { ... }
    },
    {
      "id": "recent_transactions",
      "type": "list",
      "component": { ... }
    }
  ]
}
```

**The screen model is a scrollable column of sections.** Each section has a type, an id, and a root component node. The root component node may contain children recursively.

This single model covers all 8 archetypes. There is no special schema per screen type.
