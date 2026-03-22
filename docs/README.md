# Zugantor Repo — Documentation

This folder contains the architectural design documents for the Zugantor platform.

---

## Contents

### Server-Driven UI (SDUI)

| Document | Description |
|---|---|
| [Vision & Scope](sdui/vision.md) | Why SDUI, what it covers, what is intentionally excluded, AI authoring model |
| [Architecture](sdui/architecture.md) | Template + Data separation, rendering model, binding syntax, offline-first lifecycle |
| [Sub-Problems](sdui/sub_problems.md) | All 12 engineering sub-problems with detailed specifications |
| [Package Structure](sdui/packages.md) | The 5 packages, their responsibilities, and the dependency law |
| [Key Decisions](sdui/decisions.md) | 15 finalized architectural decisions, one per topic |
| [Build Phases](sdui/build_phases.md) | Execution plan — Phase 0 through Phase 5, with individual tasks |

---

## Quick Reference

### Core Rendering Model

```
SduiRenderer(template: layoutMap, data: apiResponseMap) → Widget
```

- `template` — loaded from local file (bundled asset, synced silently)
- `data` — fetched by the screen via `zugantor_data`
- `SduiRenderer` — a pure function, no network calls, no side effects

### Binding Syntax

```json
{
  "type": "zds.text",
  "props": {
    "style": "@typography.bodyMedium"
  },
  "bind": {
    "text": "$.user.display_name"
  }
}
```

- `props` — static values, authored once, never change at runtime
- `bind` — JSONPath expressions resolved against the data map at render time

### What is NEVER SDUI

- Splash screen
- Onboarding flow
- Login / authentication screens
- Security-critical screens (biometrics, PIN entry)
- Offline / error fallback screens

---

### Backend Requirements

These documents are written for the backend architect. They describe what the frontend does and what it needs — without prescribing how the backend should implement anything.

| Document | Description |
|---|---|
| [Overview](backend/README.md) | Index and key vocabulary — read this first |
| [Frontend Overview](backend/frontend_overview.md) | What the frontend is, how SDUI works, package structure |
| [Layout Templates](backend/layout_templates.md) | Template format, every field, component props reference, full example |
| [Data Requirements](backend/data_requirements.md) | Data map shape, bind contracts per screen, formatting responsibilities |
| [Sync Requirements](backend/sync_requirements.md) | How the frontend keeps templates current without app updates |
| [A/B Testing Requirements](backend/ab_testing_requirements.md) | Context the frontend sends, metadata it reads, analytics events it fires |
| [Localization Requirements](backend/localization_requirements.md) | Locale context sent, string formatting expectations, RTL support |
| [Security Requirements](backend/security_requirements.md) | Frontend defenses, what the backend must provide, open security questions |

---

## Related Files

- [PROJECT_GOALS.md](../PROJECT_GOALS.md) — Design system goals and principles
- [packages/zugantor_design_system](../packages/zugantor_design_system/) — ZDS component library (AI vocabulary)
- [melos.yaml](../melos.yaml) — Monorepo package configuration
