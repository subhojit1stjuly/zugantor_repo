# Zugantor Build — Product Requirements Document

> Status: In Progress · App: `apps/zugantor_build/` · Platforms: Web · Windows · macOS · Linux

---

## 1. What Is It

Zugantor Build is a visual screen authoring tool for the Zugantor platform. Designers and developers
compose Flutter app screens from ZDS (Zugantor Design System) components without writing Dart code.

**Primary output formats:**
- SDUI JSON templates (deployable over the air via `zugantor_sdui`)
- Dart widget code (copy-paste into any Flutter project)
- Flutter project zip (full standalone project export)

---

## 2. Who Uses It

| Persona | Primary Workflow |
|---|---|
| **Designer** | Drags components from the palette, configures props in the property panel, checks the phone-frame preview, and uses the AI bar to generate or refine layouts |
| **Developer** | Refines the raw SDUI JSON, wires `bind` expressions, audits schema validity, exports templates |
| **Product Manager** | Describes the desired screen in natural language via the AI prompt bar — never touches JSON directly |

---

## 3. Screens & Flows

| Screen | Doc |
|---|---|
| Home / Dashboard | [screens/home_screen.md](screens/home_screen.md) |
| Editor | [screens/editor_screen.md](screens/editor_screen.md) |
| New Project Dialog | [screens/new_project_dialog.md](screens/new_project_dialog.md) |
| Export Dialog | [screens/export_dialog.md](screens/export_dialog.md) |

---

## 4. Features

| Feature | Doc |
|---|---|
| Canvas | [features/canvas.md](features/canvas.md) |
| JSON Editor | [features/json_editor.md](features/json_editor.md) |
| Live Preview | [features/live_preview.md](features/live_preview.md) |
| Mock Data Editor | [features/mock_data_editor.md](features/mock_data_editor.md) |
| AI Prompt Bar | [features/ai_prompt_bar.md](features/ai_prompt_bar.md) |
| Project Storage & Sync | [features/project_storage_sync.md](features/project_storage_sync.md) |
| Status Bar | [features/status_bar.md](features/status_bar.md) |

---

## 5. Non-Functional Requirements

| Requirement | Target |
|---|---|
| Theme | Dark-first; user-toggleable light mode |
| Minimum window size | 1200 × 700 px |
| Canvas mutation latency | Instant (< 16 ms to next frame) |
| JSON→Canvas sync debounce | 500 ms after last keystroke |
| Canvas→JSON sync | Instant (every structural mutation) |
| API key storage | Platform secure storage (flutter_secure_storage) |
| Template validation | Schema-validated before save and before export |
| Offline support | Full offline — all local operations work without network |

---

## 6. Out of Scope (v1)

- Real-time collaboration with live cursors
- Mobile builder (iOS / Android target screen sizes)
- Auth / user management inside the builder
- Analytics or telemetry within the builder
- Custom component plugins / third-party component registry
- Full version history beyond in-session undo/redo

---

## 7. Open Questions

| # | Question | Impact |
|---|---|---|
| 1 | Left panel — property config inline below layers tree, or dedicated bottom section? | Editor layout |
| 2 | Multiple screens open as tabs in editor, or one screen at a time? | Navigation model |
| 3 | Canvas block visual style — bordered boxes, chips, or mini-cards? | Canvas component |
| 4 | "Open from file" — `.zbuild` project file, individual template JSON, or both? | Storage model |
| 5 | What starter templates ship in v1? | New project flow |

---

## 8. Tech Stack

| Concern | Package |
|---|---|
| Navigation | `go_router` |
| Resizable panels | `multi_split_view` |
| Code editor (JSON) | `flutter_code_editor` + `highlight` |
| File open/save | `file_picker` |
| Window management (desktop) | `window_manager` |
| Project zip export | `archive` |
| HTTP (AI / sync) | `dio` |
| Secure key storage | `flutter_secure_storage` |
| Fonts | `google_fonts` |
| Design system | `zugantor_design_system` (local path) |
