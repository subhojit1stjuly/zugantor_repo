# Frontend Overview

> Read this document first. It provides the context the architect needs to understand all the other documents in this folder.

---

## What the Zugantor App Is

Zugantor is a Flutter application that runs on mobile (iOS and Android), web, and desktop (Windows, macOS, Linux). It is packaged and deployed as a standard app.

The core idea is that screens in the app are driven by layout instructions that arrive from outside the app binary — not by code hard-baked into a release. This means a screen's structure can change or a new screen can be added without asking users to update the app. We call this approach **Server-Driven UI (SDUI)**.

---

## Two Things That Make a Screen

Every screen the frontend renders is composed of two separate things:

### 1. A Layout Template

A JSON file that describes the *structure* of the screen.

It answers: "What components are on this screen? In what order? What are their configuration values?"

It contains no live user data. A layout template is the same for every user who sees it (unless A/B variants are in play — see [ab_testing_requirements.md](ab_testing_requirements.md)).

### 2. A Data Map

A response from the backend that contains the *live content* for that screen and that user.

It answers: "What are the values that go into the placeholders in the layout template?"

It is user-specific. The same layout template could display a different user's name, balance, or transaction list depending on which data map is paired with it.

---

## How the Frontend Renders a Screen

The frontend rendering process, in plain terms:

1. The frontend decides which screen to show (via navigation).
2. It loads the layout template for that screen from its **local storage**. If no local copy exists, it fetches one and stores it.
3. It fetches the live data for that screen from wherever data comes from.
4. It passes both the template and the data to a **renderer**, which produces a Flutter widget tree.
5. The renderer resolves `bind` expressions in the template against the data map to fill in live values.
6. The screen is displayed.

The frontend does not build the widget tree server-side, and it does not receive HTML, XML, or pre-rendered content. It receives JSON. It builds native Flutter widgets locally.

---

## What the Renderer Does

The renderer is a pure function:

```
render(layoutTemplate, dataMap) → FlutterWidget
```

It walks the component tree in the layout template. For each node, it:

- Looks up the component by `type` in its local registry of known UI components
- Applies `props` as static configuration values
- Resolves `bind` expressions against the data map
- Recursively renders child nodes

If a component type is not in its registry (e.g. a new component that was added after the app binary was compiled), the renderer uses a safe fallback widget and does not crash.

---

## What Is and Is Not Server-Driven

Not everything in the app needs to be SDUI. The current scope:

| Type of screen | SDUI? |
|---|---|
| Screens that display information, cards, lists, summaries | Yes |
| Detail views for transactions, profiles, entities | Yes |
| Dashboards | Yes |
| Authentication (login, registration) | No — hardcoded |
| Settings | No — hardcoded |
| Custom transaction flows with complex validation | Likely partial |

---

## The Component Registry

The frontend maintains a fixed registry of UI components it can render. This registry does not change at runtime — it changes only when the app binary is updated. The current component types include (but are not limited to):

- `zds_text` — text with configurable style, weight, size
- `zds_button` — tappable button with an action
- `zds_card` — an elevated container card
- `zds_avatar` — circular image/initial avatar
- `zds_chip` — small label/badge chip
- `zds_divider` — horizontal separator
- `zds_icon` — icon from the design system icon set
- `zds_list_tile` — a list row with leading/trailing slots
- `zds_spacer` — vertical/horizontal spacing
- `zds_column`, `zds_row` — layout containers
- `zds_container` — generic padding/decoration container

The architect does not control this list. New component types can only be added when the app binary is updated.

---

## How Layout Template Files Are Stored

The frontend downloads layout template files and stores them locally on the device. On subsequent launches, the stored local version is used immediately (no waiting for a network round-trip). In the background, the frontend checks whether a newer version of the template is available and updates the local copy silently if so.

This means:

- Templates are served **once per update**, not on every screen load
- A single template file can be shared across many users; it is not personalized
- The data map is fetched fresh on every screen load

---

## What the Frontend Sends When Requesting a Template

When the frontend requests a layout template, it can include context about itself:

- **Platform**: `android`, `ios`, `web`, `windows`, `macos`, `linux`
- **App version**: the semantic version of the installed app (e.g. `2.1.0`)
- **Schema version** the frontend currently supports
- **Locale**: the active locale (e.g. `en-GB`, `de-DE`)
- **User segment**: an optional segment identifier, if the app has received one previously

The architect decides whether to use any of this to vary what template is returned.

---

## Package Structure (Frontend)

For context, the frontend is organized into Flutter packages:

| Package | Purpose |
|---|---|
| `zugantor_design_system` | All UI components (frozen API — changes only on major releases) |
| `zugantor_sdui` | SDUI engine: models, renderer, registry, sync, action handler |
| `zugantor_data` | Data layer: fetching and modeling live data per screen |
| `zugantor_charts` | Chart/graph components for dashboard screens |
| `zugantor_notifications` | Push notification handling |

The architect primarily interacts with two of these: `zugantor_sdui` (for layout templates) and `zugantor_data` (for screen data).

---

## Open Questions for the Architect

- Where are layout templates authored? Is there a content management tool, an admin panel, or are they created manually?
- How does the architect intend to version templates — by screen, globally, or per platform?
- Is there a single source of templates or will there be multiple environments (staging, production)?
- Will the same template serve all platforms, or will mobile and web/desktop receive different templates for the same screen ID?
