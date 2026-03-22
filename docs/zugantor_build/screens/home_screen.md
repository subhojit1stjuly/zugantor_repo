# Home Screen

> Screen ID: `home` · Route: `/` · Layout: Direction 2 — Sidebar + Card Grid

---

## Overview

The Home screen is the entry point of Zugantor Build. It provides an at-a-glance view of recent
projects and quick access to create, open, or manage projects. It follows a persistent sidebar +
main content grid layout.

---

## Layout

```
┌─────────────────────────────────────────────────────────────┐
│  SIDEBAR         │  MAIN CONTENT                            │
│  ──────────────  │  ──────────────────────────────────────  │
│  🏠 Home         │  [+ New Project]           [📂 Open]     │
│  📁 Projects     │                                          │
│  📐 Templates    │  Recent Projects                         │
│  ⚙  Settings     │  ┌──────────┐ ┌──────────┐ ┌──────────┐ │
│                  │  │ Project  │ │ Project  │ │    +     │ │
│                  │  │ Card     │ │ Card     │ │  New     │ │
│                  │  └──────────┘ └──────────┘ └──────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## Sidebar

| Item | Icon | Navigation Target |
|---|---|---|
| Home | `Icons.home_outlined` | Home screen (current) |
| Projects | `Icons.folder_outlined` | Projects list screen |
| Templates | `Icons.dashboard_customize_outlined` | Templates browser |
| Settings | `Icons.settings_outlined` | Settings screen |

- Sidebar is fixed — it does not collapse in the desktop layout.
- Selected item is highlighted with the primary color indicator.
- App logo / wordmark displayed at the top of the sidebar.

---

## Main Content

### Header Bar
- **Title:** "Recent Projects" (or "All Projects" when the user navigates to Projects)
- **Top-right actions:**
  - `[+ New Project]` — opens the [New Project Dialog](new_project_dialog.md)
  - `[📂 Open]` — opens a file picker to load an existing `.zbuild` project

### Project Card Grid

- Displayed as a responsive `GridView` — adjusts columns based on available width.
- Cards show:
  - Project thumbnail (screenshot of last edited screen, or placeholder)
  - Project name
  - Last modified timestamp (relative, e.g. "2 days ago")
  - Number of screens in the project
- Clicking a card opens the [Editor Screen](editor_screen.md) for that project.
- Right-click (or long-press on touch) shows a context menu: **Open · Rename · Duplicate · Delete**

### "+" New Project Card

- The last card in the grid is always a special "New Project" card.
- Tapping it is equivalent to clicking `[+ New Project]`.

---

## Empty State

When no projects exist yet, the grid is replaced with a centered empty state:

```
[Illustration]
No projects yet.
Start by creating your first screen.
  [+ New Project]
```

---

## Data & State

| State | Type | Notes |
|---|---|---|
| `projectList` | `List<ProjectSummary>` | Loaded from local storage on screen init |
| `isLoading` | `bool` | True while project list is being read from disk |
| `sortOrder` | `SortOrder` | Default: `lastModifiedDesc` |

---

## Actions

| Action | Trigger | Result |
|---|---|---|
| New project | Button or "+" card | Opens [New Project Dialog](new_project_dialog.md) |
| Open project | `[📂 Open]` button | File picker → load project → open editor |
| Open recent | Click project card | Open project in editor directly |
| Rename project | Context menu → Rename | Inline rename on the card |
| Duplicate project | Context menu → Duplicate | Clone to new name, add to grid |
| Delete project | Context menu → Delete | Confirmation dialog → remove from list + disk |

---

## Open Questions

- Should "Projects" sidebar item show a full browsable library (all-time, sorted/filtered), distinct from the "Recent" home view? Or are they the same list?
- Should the grid support drag-to-reorder for pinning favourite projects?
