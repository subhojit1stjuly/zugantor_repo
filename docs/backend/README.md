# Zugantor — Backend Requirements

## Purpose

This folder contains requirement documents for the backend architect. Each document describes what the **frontend does** and what it **needs to receive** — not how the backend should be built.

These documents intentionally avoid prescribing a tech stack, framework, infrastructure choice, or architectural pattern. The architect has full freedom to decide how to fulfill the stated needs.

---

## How to Read These Documents

Every document is structured as:

1. **What the frontend does** — so the architect understands the context
2. **What the frontend needs** — the concrete requirement
3. **What the frontend sends** — context the backend can use if it wants to
4. **Open questions** — things the architect needs to decide and communicate back

---

## Documents

| Document | Topic |
|---|---|
| [frontend_overview.md](frontend_overview.md) | How the whole frontend system works — read this first |
| [layout_templates.md](layout_templates.md) | What layout template files are and what the frontend needs to receive them |
| [data_requirements.md](data_requirements.md) | What data the frontend needs per screen and what shape it can work with |
| [sync_requirements.md](sync_requirements.md) | How the frontend keeps layout templates up to date without redeployment |
| [ab_testing_requirements.md](ab_testing_requirements.md) | What the frontend sends as context and what it expects back for A/B testing |
| [localization_requirements.md](localization_requirements.md) | What the frontend expects regarding language and localized strings |
| [security_requirements.md](security_requirements.md) | What the frontend depends on for safe and trusted delivery of content |

---

## The One-Line Contract

> The frontend maintains layout structure locally. It fetches live data separately. It never merges them server-side. The backend's job is to provide both independently.

---

## Key Vocabulary

These terms appear throughout the documents. Understanding them prevents confusion.

| Term | Meaning |
|---|---|
| **Layout template** | A JSON file that describes the structure of a screen — which components appear, in what order, with what configuration. It contains no live data. |
| **Data map** | A response from the backend that contains the live content (names, amounts, dates, etc.) for a specific screen and user. |
| **Bind expression** | A JSONPath-like string in the layout template (e.g. `$.user.name`) that points to a field in the data map. The frontend resolves these at render time. |
| **Component registry** | The frontend's whitelist of known UI components. The layout template can only reference components in this list. |
| **Screen ID** | A stable string identifier for a screen (e.g. `transaction_detail`, `home_dashboard`). Used by the frontend to request the correct layout template and data. |
| **Schema version** | An integer in the layout template that tells the frontend which version of the format to expect. The frontend uses this to decide if it can render the file. |
