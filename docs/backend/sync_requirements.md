# Sync Requirements

## What This Document Covers

This document describes how the frontend keeps its local layout templates up to date — without requiring the user to update the app — and what it needs in order to do so.

---

## Why Templates Are Stored Locally

Layout templates are JSON files. When the user opens a screen for the first time, the frontend downloads the template and saves it to local storage on the device. On all subsequent visits to that screen, the locally stored copy is used immediately — no waiting for a network round-trip before the screen can begin rendering.

This means:

- The template is fetched once, not on every view
- Screen load feels instant (data is the only network dependency at render time)
- The app can display screens even when offline (using the last-known template + gracefully-degraded data)

The tradeoff is that the frontend must have a way to find out when its locally stored templates are out of date, and fetch newer versions when they are.

---

## How the Sync Process Works (Frontend Side)

The frontend performs the following sync steps:

1. **On app startup** (or at a configured interval), the frontend requests a **manifest** — a list of all known screen IDs with a version identifier for each one.
2. The frontend compares the server manifest against its local record of which template version it has stored for each screen.
3. For any screen where the server's version differs from the local version, the frontend fetches the new template file.
4. Downloaded templates are stored locally and the local version record is updated.

This entire process happens **in the background**. The user is never blocked by it. If the user opens a screen during a sync, the existing local template is used for that visit, and the new template takes effect on the next visit.

---

## What the Frontend Needs

### 1. A Manifest

The frontend needs to be able to request a manifest that tells it the current version of every available template.

**The minimum a manifest entry must contain:**

| Field | Description |
|---|---|
| `screen_id` | The stable screen identifier (e.g. `transaction_detail`) |
| `version` | A value that changes whenever the template changes. This can be a hash, a number, a timestamp string, or any opaque identifier — the frontend does not parse it, it only checks equality. |

**Example manifest shape** (the actual format is the architect's decision):

```json
{
  "generated_at": "2025-07-14T10:00:00Z",
  "templates": [
    { "screen_id": "transaction_detail", "version": "a1b2c3d4" },
    { "screen_id": "home_dashboard", "version": "e5f6a7b8" },
    { "screen_id": "profile_summary", "version": "c9d0e1f2" }
  ]
}
```

The `generated_at` field is optional but useful for debugging.

### 2. A Way to Fetch an Individual Template

Given a `screen_id`, the frontend needs to be able to fetch the full template JSON for that screen.

The frontend does this once per version change, not on every screen load.

### 3. Predictable Timing of Manifest Updates

The frontend does not need real-time push notifications about template changes. It checks the manifest at startup or on a schedule. However, there should be a reasonable expectation that when a new template is published, it will appear in the manifest within a short window (seconds to a few minutes, not hours).

The exact interval at which the frontend polls is configurable and can be agreed with the architect. The default is "on every app cold start."

---

## What the Frontend Sends When Requesting a Manifest

The frontend can include context with its manifest request so the backend can return the appropriate set of templates:

| Field | Purpose |
|---|---|
| **Platform** | `android`, `ios`, `web`, `windows`, `macos`, `linux` — in case templates are platform-specific |
| **App schema version** | The maximum schema version the installed app can understand — the backend can use this to avoid returning a template the app cannot parse |
| **Locale** | The active locale — in case templates are locale-specific |
| **User segment** | An optional segment identifier — see [ab_testing_requirements.md](ab_testing_requirements.md) |
| **Known versions** | The current locally-stored version for each `screen_id` — the backend can use this to return only what has changed, rather than the full manifest |

The architect decides how much of this context to use. The frontend sends it regardless.

---

## Scenarios the Architect Should Consider

### Scenario A: One template per screen, all platforms

The simplest approach. One manifest. Each `screen_id` has a single version. All platforms receive the same template.

The frontend is happy with this. The template format supports responsive layout, so a single template can adapt to different screen sizes.

### Scenario B: Platform-specific templates

The same `screen_id` returns a different template for `web` vs. `mobile`. In this case the manifest is filtered by platform before being returned to the frontend.

The frontend handles this naturally because it always sends its platform in the request. The `screen_id` does not change on the frontend side — only the content of the returned template differs.

### Scenario C: Locale-specific templates

If strings are embedded directly in the template (rather than all content being bound from the data map), the architect may choose to maintain one version of each template per locale. The frontend sends its locale in every manifest request.

See [localization_requirements.md](localization_requirements.md) for the localization contract.

### Scenario D: Partial updates (delta sync)

If the template library is large, the architect may choose to implement delta sync — returning only templates that have changed since the last known version rather than the full manifest every time. The frontend can support this if the protocol is agreed upon in advance.

### Scenario E: Offline-first with no background sync

For environments where background network access is restricted (certain enterprise/MDM scenarios), the frontend could operate entirely on a bundled set of "seed" templates shipped inside the app binary. Sync would only happen when the user actively opens the app in the foreground. The frontend engine supports this configuration.

---

## Failure Handling (Frontend Side)

The frontend handles sync failures gracefully:

- If the manifest fetch fails, the frontend continues using its currently stored templates. It retries on the next startup.
- If a template fetch fails for a specific screen, that screen continues to use its old local template. The frontend retries on the next sync cycle.
- If the frontend has **no** local template for a screen (first install, or local storage was cleared), and the fetch fails, the screen falls back to a hardcoded layout baked into the app binary.
- The frontend never shows a broken screen due to a sync failure.

---

## Open Questions for the Architect

- How will templates be published? Is there an admin tool, a CI/CD pipeline, a manual process?
- Should the manifest response indicate whether a template is experimental/in A/B testing, or is that managed separately (see [ab_testing_requirements.md](ab_testing_requirements.md))?
- Is there a need to support **rollback** — reverting a template to a previous version if the new one has issues? If so, should the frontend be able to receive a "rollback" signal, or would rollback simply mean publishing the old version again (which the frontend handles naturally)?
- How are deletions handled? If a `screen_id` is removed from the manifest, should the frontend delete its local copy, or keep it as a fallback? The architect should define the convention.
- Should there be a mechanism to **force-refresh** a template immediately (e.g. for a critical fix), rather than waiting for the next scheduled sync? The frontend can be designed to respond to a push signal if one is available.
