# Zugantor Repo — Documentation

This folder contains the architectural design documents for the Zugantor platform.

---

## Product Roadmap

| Document | Description |
|---|---|
| [Product Roadmap](PRODUCT_ROADMAP.md) | Vision, locked architectural decisions, phased delivery plan (Phase 0–8) |

---

## Contents

### Zugantor Build (Visual Screen Authoring Tool)

| Document | Description |
|---|---|
| [Overview & Index](zugantor_build/README.md) | All screens, features, and key design decisions |
| [Requirements](zugantor_build/requirements.md) | Full PRD — personas, tech stack, NFRs, open questions |
| [Home Screen](zugantor_build/screens/home_screen.md) | Dashboard layout — sidebar + card grid |
| [Editor Screen](zugantor_build/screens/editor_screen.md) | 5-zone authoring workspace |
| [New Project Dialog](zugantor_build/screens/new_project_dialog.md) | Blank or template-based project creation |
| [Export Dialog](zugantor_build/screens/export_dialog.md) | Export as SDUI JSON, Dart, or Flutter project zip |
| [Canvas](zugantor_build/features/canvas.md) | Drag-and-drop structural block editor |
| [JSON Editor](zugantor_build/features/json_editor.md) | Raw SDUI JSON code editor with sync |
| [Live Preview](zugantor_build/features/live_preview.md) | Phone-frame preview via `SduiRenderer` |
| [Mock Data Editor](zugantor_build/features/mock_data_editor.md) | Editable data map for preview |
| [AI Prompt Bar](zugantor_build/features/ai_prompt_bar.md) | Natural-language Generate / Modify / Explain |
| [Project Storage & Sync](zugantor_build/features/project_storage_sync.md) | Local-first + Git-model cloud sync |
| [Status Bar](zugantor_build/features/status_bar.md) | Screen context, sync state, Export action |

---

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
