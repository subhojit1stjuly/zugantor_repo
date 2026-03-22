# Zugantor Build — Documentation

> App: `apps/zugantor_build/` · Platforms: Web · Windows · macOS · Linux

Zugantor Build is the visual screen authoring tool for the Zugantor platform. Users compose
Flutter app screens from ZDS components and export them as SDUI JSON templates, Dart widgets, or
full Flutter projects.

---

## Overview

| Document | Description |
|---|---|
| [Requirements](requirements.md) | Full PRD — personas, tech stack, non-functional requirements, open questions |

---

## Screens

| Screen | Description |
|---|---|
| [Home Screen](screens/home_screen.md) | Dashboard — sidebar + project card grid, entry point of the app |
| [Editor Screen](screens/editor_screen.md) | 5-zone authoring workspace — canvas, JSON editor, preview, AI bar |
| [New Project Dialog](screens/new_project_dialog.md) | Create blank or template-based project |
| [Export Dialog](screens/export_dialog.md) | Export as SDUI JSON, Dart widget, or Flutter project zip |

---

## Features

| Feature | Description |
|---|---|
| [Canvas](features/canvas.md) | Drag-and-drop structural widget tree editor (bidirectional sync with JSON) |
| [JSON Editor](features/json_editor.md) | Code editor for raw SDUI JSON with syntax highlighting and validation |
| [Live Preview](features/live_preview.md) | Phone-frame preview using real `SduiRenderer` (blocked until engine is ready) |
| [Mock Data Editor](features/mock_data_editor.md) | Editable JSON data map that drives the live preview |
| [AI Prompt Bar](features/ai_prompt_bar.md) | Natural-language Generate / Modify / Explain via OpenAI or Anthropic |
| [Project Storage & Sync](features/project_storage_sync.md) | Local-first storage + Git-model cloud sync + async collaboration |
| [Status Bar](features/status_bar.md) | Screen ID, schema version, sync state, and Export quick action |

---

## Key Design Decisions

| Decision | Choice |
|---|---|
| Home layout | Direction 2 — persistent sidebar + card grid |
| Storage model | Local copy is always the source of truth; cloud is an optional remote |
| Collaboration | Async — each person has their own local copy; sync is per-screen |
| Conflict resolution | Side-by-side diff (deferred to v1+); v1 locks the screen |
| Canvas rendering | Structural blocks (not live ZDS rendering) |
| Live preview engine | Actual `SduiRenderer` — blocked until `zugantor_sdui` engine is built |
| JSON sync | Canvas→JSON: instant; JSON→Canvas: 500 ms debounce, diff by `id` |
| AI providers | OpenAI (GPT-4o) + Anthropic (Claude 3.5 Sonnet); user-supplied API key |

---

## Open Questions

1. Left panel — property config inline (below layers tree) or dedicated bottom section?
2. Multiple screens as editor tabs, or one screen at a time?
3. Canvas block visual style — bordered boxes, chips, or mini-cards?
4. "Open from file" — `.zbuild` project, individual JSON, or both?
5. What starter templates ship in v1?
