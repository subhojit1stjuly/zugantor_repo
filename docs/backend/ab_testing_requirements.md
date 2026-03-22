# A/B Testing Requirements

## What This Document Covers

This document describes the frontend's role in A/B testing of layout templates — what context it sends, what it expects to receive, and how it tracks experiment exposure.

---

## The Frontend's Mental Model of Variants

The frontend does not have a concept of "variants" at the rendering layer. It simply renders whatever layout template it receives. If the layout template for screen `home_dashboard` is variant A for one user and variant B for another, the frontend does not know or care — it just renders the template it was given.

This means:

- **Variant assignment is entirely a backend/infrastructure concern.** The frontend defers all decisions about which user sees which template to whatever system serves the templates.
- **The frontend renders one template per screen.** It does not hold two versions of a template and decide between them.
- **The frontend tracks that it rendered a variant**, by reading the `metadata` fields in the template (see below).

---

## What Context the Frontend Sends

When the frontend requests a layout template (or the manifest), it sends the following context. The architect can use any combination of these to make variant assignment decisions:

| Field | Type | Description |
|---|---|---|
| `platform` | string | `android`, `ios`, `web`, `windows`, `macos`, `linux` |
| `app_version` | string | The semantic version of the installed app binary (e.g. `2.1.0`) |
| `locale` | string | The active locale (e.g. `en-GB`, `de-DE`) |
| `user_segment` | string or null | An opaque segment identifier that the backend may have previously assigned to this user. The frontend stores whatever segment string it receives and sends it back on subsequent requests. If the app has never received one, this is null. |
| `device_id` | string | A stable per-device identifier (not a user identifier — a rehashed device fingerprint). Can be used for sticky assignment when the user is not authenticated. |
| `schema_version` | integer | The maximum SDUI schema version this app binary supports. Useful for not serving templates that use features the app cannot understand. |

The frontend does not know what these fields are used for. It sends them as a request header or in a request payload. The architect decides the transport mechanism.

---

## What the Frontend Expects to Receive

The frontend expects to receive a **single layout template** for the requested screen. It does not expect to be told "this is variant A" — it just renders the template.

However, the frontend **does read the `metadata` field** of every template it renders, specifically for analytics purposes. The architect should populate the following metadata keys when templates are part of an experiment:

| Metadata key | Type | Purpose |
|---|---|---|
| `experiment_id` | string | An identifier for the experiment this template belongs to. |
| `variant_id` | string | An identifier for which variant of the experiment this is (e.g. `control`, `treatment_1`). |

These keys are optional. If absent, the analytics event for this screen will not include experiment dimensions.

**Example template metadata with experiment context:**

```json
{
  "schema_version": 1,
  "screen_id": "home_dashboard",
  "metadata": {
    "template_version": "1.3.0",
    "experiment_id": "exp_hero_layout_q3",
    "variant_id": "treatment_hero_above_balance"
  },
  "root": { ... }
}
```

---

## What the Frontend Logs

On the **first render** of a screen using a given template, the frontend fires an analytics event. If the template's metadata contains experiment fields, those are included:

```
Event: screen_rendered
Properties:
  screen_id: "home_dashboard"
  template_version: "1.3.0"            (from metadata, if present)
  experiment_id: "exp_hero_layout_q3"  (from metadata, if present)
  variant_id: "treatment_hero_above_balance" (from metadata, if present)
  platform: "android"
  app_version: "2.1.0"
```

The analytics layer is a separate concern — it receives this event and does what it does with it. The frontend's responsibility is only to emit the event with the available fields.

"First render" means: once per session per screen, not once per app install. If the user navigates to the same screen twice in one session, the event fires once.

---

## Variant Stickiness

The frontend expects that once a user has been assigned to a variant, they will continue to see that same variant until the experiment ends or the user moves between segments. The mechanism for achieving this is the architect's decision.

The frontend does support receiving a `user_segment` string from the backend and persisting it locally. On subsequent requests, it sends this segment back. This can be used as the stickiness mechanism if the architect chooses.

If the segment changes (e.g. the backend returns a different segment value), the frontend updates its stored value and begins sending the new one. This may result in the user seeing a different variant on subsequent template syncs — the architect should account for this in their experiment design.

---

## Scenarios the Architect Should Consider

### Scenario A: Server-side variant assignment per request

The backend decides which template to return based on the context fields in each request. The returned template has `experiment_id` and `variant_id` in its metadata. Stickiness is managed server-side.

The frontend handles this naturally. However, because templates are cached locally (see [sync_requirements.md](sync_requirements.md)), the variant will not change on every screen load — only on the next sync cycle. The architect should factor this into experiment design.

### Scenario B: Segment-based assignment

The backend assigns users to segments and stores the assignment. When the frontend requests a template, it sends its `user_segment`. The backend returns the template appropriate for that segment.

In this scenario, the segment assignment is external to the frontend (it happens when the user authenticates or registers). The frontend only stores and echoes back whatever segment it was told it belongs to.

### Scenario C: Bundled variants with client-side selection

The backend returns multiple template variants to the frontend at sync time, and a separately fetched "assignment" tells the frontend which one to use. The frontend then selects locally without a further network round-trip.

The frontend can support this if agreed in advance — it would require changes to the sync and template storage layer that are not currently implemented. This would need to be designed before development of that feature begins.

### Scenario D: No A/B testing

The `metadata` fields are not populated. The analytics event fires without experiment dimensions. Everything still works — the experiment infrastructure is optional.

---

## Open Questions for the Architect

- What is the mechanism for segment assignment? When does the frontend first receive a segment identifier, and how is it delivered?
- Should variant assignment be logged server-side (independent of the analytics event the frontend fires), or is the frontend's analytics event the primary record of exposure?
- How should the experiment end? When an experiment concludes and one variant becomes the default, should the losing variant templates simply stop appearing in the manifest? The frontend will sync the new "winner" template naturally on its next sync cycle.
- Is there a need for the frontend to know *ahead of rendering* that it is about to render an experiment variant? Currently the frontend reads this only after the template is loaded. If there are any pre-render requirements (e.g. consent checks), the architect should flag these.
- How will multivariate tests (more than two variants) be handled? The `variant_id` field is a string with no constraints, so any number of variants can be identified — but the assignment and routing logic is the architect's responsibility.
