# Project Storage & Sync

> Feature: Local-first project storage with Git-model cloud sync

---

## Overview

Zugantor Build follows a **local-first, cloud-synced** storage model inspired by Git. Every project
lives as a local folder of files on the user's machine. The app works fully offline. When a remote
is configured, changes are pushed and pulled explicitly (or on a background schedule).

---

## Storage Model

```
Local disk (always present)
  └── .zugantor/
        └── projects/
              └── <project_id>/
                    project.zbuild          ← project metadata
                    screens/
                      <screen_id>.json      ← one SDUI JSON file per screen
                      ...
                    mock_data/
                      <screen_id>.mock.json ← mock data per screen (dev-only)

Cloud remote (optional)
  └── <remote_url>/<project_id>/            ← mirrors the local structure, per screen
```

---

## Key Properties

| Property | Value |
|---|---|
| Source of truth | Local copy |
| Offline support | Full — all read/write operations work without network |
| Sync unit | Individual screen (like a file in a Git repo) |
| Conflict unit | Per screen — two people edited the same screen |
| Conflict resolution | Side-by-side diff (deferred v1+) |

---

## `project.zbuild` Schema

```json
{
  "id": "uuid-v4",
  "name": "My App",
  "description": "A short description",
  "created_at": "2026-03-22T10:00:00Z",
  "updated_at": "2026-03-22T10:00:00Z",
  "schema_version": "1",
  "screens": [
    {
      "id": "home_screen",
      "name": "Home",
      "created_at": "...",
      "updated_at": "..."
    }
  ]
}
```

---

## Sync Flow

### Push (local → remote)

1. Detect which screens have local changes since last push (by comparing `updated_at`).
2. For each changed screen, upload the screen's JSON to the remote.
3. Update the remote `project.zbuild` metadata.
4. Status bar shows `↑ Pushing…` during upload, `✓ Synced` on success.

### Pull (remote → local)

1. Fetch remote `project.zbuild`.
2. Compare each screen's `updated_at` with local.
3. For each remote-newer screen:
   - If the local screen has **no** local changes: overwrite local with remote (auto-merge).
   - If the local screen **also** has local changes: **conflict**.

---

## Collaboration Model

Each collaborator has their own local copy of the project. There is no central locking.

### Conflict Detection

A conflict occurs when:
- Two collaborators have independently modified **the same screen** since their last sync.

### Conflict Resolution (v1 — Deferred)

In v1, when a conflict is detected on a screen:
- That screen is **locked** (read-only in the editor).
- A `⚠ Conflict` badge appears in the [Status Bar](status_bar.md).
- The user is prompted to resolve the conflict before continuing.

Full side-by-side diff UI is deferred to a later phase.

### Auto-Merge (no conflict)

If different collaborators edited **different screens**, their changes are automatically merged on
pull — each screen JSON file is independent, so there is no structural conflict.

---

## Remote Configuration

Remote sync is configured in the Settings screen:

| Setting | Description |
|---|---|
| Remote URL | Base URL of the sync backend (e.g. Zugantor Sync server or self-hosted) |
| Auth token | Bearer token for API auth (stored in platform secure storage) |
| Sync mode | Manual (push/pull buttons) or Auto (background, every N minutes) |

---

## Sync Status States

| State | Display |
|---|---|
| No remote configured | (no sync indicator) |
| Fully synced | `✓ Synced` |
| Pushing | `↑ Pushing…` |
| Pulling | `↓ Pulling…` |
| Conflict on current screen | `⚠ Conflict` (orange) |
| Sync error | `✗ Sync error` (red) with tooltip showing error message |

---

## File Operations

| Operation | Behaviour |
|---|---|
| Create project | Creates folder + `project.zbuild` + first screen JSON |
| Add screen | Creates new `<screen_id>.json` in `screens/` |
| Rename screen | Renames the JSON file; updates `project.zbuild` |
| Delete screen | Deletes the JSON file; updates `project.zbuild` |
| Delete project | Moves project folder to trash (not permanent delete) |
| Open from file | File picker → reads `.zbuild` folder or JSON directly |
