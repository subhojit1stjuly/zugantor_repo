# New Project Dialog

> Component: Modal Dialog · Triggered from: Home Screen, Projects Screen

---

## Overview

The New Project dialog allows users to create a new project either from scratch or from a starter
template. It is a focused, two-step modal that collects the minimum required information before
opening the editor.

---

## Trigger Points

| Location | Trigger |
|---|---|
| Home Screen header | `[+ New Project]` button |
| Home Screen card grid | Clicking the special "+" card |
| Projects Screen header | `[+ New Project]` button |

---

## Layout

```
┌──────────────────────────────────────────┐
│  New Project                        [✕]  │
│  ────────────────────────────────────── │
│  ○  Start blank                          │
│  ○  Start from template  ▼              │
│       ┌─────────────────────────────┐   │
│       │  [Template thumbnail grid]  │   │
│       └─────────────────────────────┘   │
│                                          │
│  Project name *                          │
│  ┌──────────────────────────────────┐   │
│  │                                  │   │
│  └──────────────────────────────────┘   │
│                                          │
│  Description (optional)                  │
│  ┌──────────────────────────────────┐   │
│  │                                  │   │
│  └──────────────────────────────────┘   │
│                                          │
│  [Cancel]                    [Create →]  │
└──────────────────────────────────────────┘
```

---

## Step 1 — Start Mode

The user picks one of two options (radio buttons or toggle cards):

### Option A — Start Blank
- No template preselected.
- A single empty screen named "Screen 1" is created.
- Jump straight to the name/description fields.

### Option B — Start from Template
- Reveals a horizontal scrollable grid of starter template thumbnails.
- Each thumbnail shows a preview image, template name, and a brief tag line.
- Selecting a template highlights it with a border.
- The template contents are cloned into the new project on creation.

---

## Step 2 — Project Details

| Field | Required | Validation |
|---|---|---|
| Project name | Yes | Non-empty, ≤ 60 chars, no `/\:*?"<>|` |
| Description | No | ≤ 200 chars |

- Project name defaults to `"Untitled Project"` (auto-selected so user can type immediately).
- Real-time inline validation — error message appears below the field on blur.

---

## Actions

| Button | Behaviour |
|---|---|
| **Cancel** | Closes dialog, no changes made |
| **Create →** | Validates, creates project on disk, opens editor at the new blank screen |

- `[Create →]` is disabled until the project name is valid.
- If a template is selected and that template has multiple screens, the editor opens at the first screen.

---

## Data Created

When the user confirms:

```
project/
  project.zbuild          ← project metadata (name, description, created_at, screen list)
  screens/
    screen_1.json         ← empty or template-derived SDUI JSON
```

---

## Open Questions

- What starter templates ship in v1? Candidates: blank, profile screen, list + detail, login form, settings page.
- Should template thumbnails be user-supplied (loaded from a local bundle) or fetched from a
  remote registry?
