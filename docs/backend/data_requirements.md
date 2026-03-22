# Data Requirements

## What This Document Covers

This document describes what **live data** the frontend needs for each screen, the shape it expects the data to arrive in, and how the frontend binds that data to the layout template at render time.

---

## How the Frontend Uses Data

Once the frontend has a layout template for a screen, it fetches the live data for that screen separately. It passes both the template and the data to the renderer:

```
renderer(layoutTemplate, dataMap) → FlutterWidget
```

The `dataMap` is a key-value structure (a JSON object). The renderer walks the template tree and wherever it encounters a `bind` expression like `"$.transaction.formatted_amount"`, it follows that path through the data map and substitutes the resolved value as the prop value for that component.

**The data map is user-specific and fetched fresh on every screen load.** Unlike layout templates, it is not cached for reuse across users or sessions.

---

## What the Data Map Must Contain

The data map must contain all the fields that the layout template's bind expressions reference. If a bind expression cannot be resolved from the data map, the component renders its empty/default state for that prop — the app does not crash.

The architect authors and provides the data map. The bind expressions in the layout template are the **contract** between the template author and the data provider. They must agree.

### How to Read Bind Expressions

Given this bind expression in a template:

```json
"bind": {
  "text": "$.transaction.formatted_amount"
}
```

The frontend expects the data map to have this structure:

```json
{
  "transaction": {
    "formatted_amount": "£1,250.00"
  }
}
```

The path `$.transaction.formatted_amount` means: start at the root (`$`), enter the `transaction` key, then read the `formatted_amount` key.

### Nested Paths

Bind expressions support arbitrarily deep nesting:

```json
"bind": { "text": "$.user.profile.address.city" }
```

The data map must have the corresponding nested structure:

```json
{
  "user": {
    "profile": {
      "address": {
        "city": "Berlin"
      }
    }
  }
}
```

### Array Items

Bind expressions within a repeated component (e.g. a list row inside a list) reference each item's fields using relative paths pointed at the item's context. The details of this depend on how list rendering is implemented in `zugantor_sdui` — the architect should confirm with the frontend team which path convention is used for list item data.

---

## Data Contracts by Screen

Below is the set of known bind expressions from each screen's current layout templates. These represent the fields the data map **must contain** for that screen. This table will grow as screens are added.

> **Note:** These are derived from the template bind expressions. If the template is updated by the content team, the data contract may change. The architect should treat these as living contracts that need to stay synchronized with the templates.

---

### `transaction_detail`

The detail screen for a single transaction.

| Bind path | Expected type | Example value |
|---|---|---|
| `$.transaction.id` | string | `"txn_abc123"` |
| `$.transaction.merchant_name` | string | `"Spotify AB"` |
| `$.transaction.formatted_amount` | string | `"£12.99"` |
| `$.transaction.status_label` | string | `"Completed"` |
| `$.transaction.date_label` | string | `"14 July 2025"` |
| `$.transaction.time_label` | string | `"09:41 AM"` |
| `$.transaction.category_label` | string | `"Entertainment"` |
| `$.transaction.category_icon` | string | `"music_note"` |
| `$.transaction.reference` | string | `"REF-00192"` |
| `$.transaction.note` | string or null | `"Monthly subscription"` |
| `$.account.name` | string | `"Main Account"` |
| `$.account.masked_number` | string | `"•••• 4821"` |

---

### `home_dashboard`

The main dashboard screen shown after login.

| Bind path | Expected type | Example value |
|---|---|---|
| `$.user.display_name` | string | `"Julia"` |
| `$.user.greeting` | string | `"Good morning"` |
| `$.balance.total_formatted` | string | `"£4,302.15"` |
| `$.balance.currency_symbol` | string | `"£"` |
| `$.balance.change_label` | string | `"+£120 this week"` |
| `$.balance.trend` | string | `"up"` or `"down"` or `"neutral"` |
| `$.recent_transactions` | array | see list item contract below |
| `$.recent_transactions[*].id` | string | `"txn_abc123"` |
| `$.recent_transactions[*].merchant_name` | string | `"Tesco"` |
| `$.recent_transactions[*].formatted_amount` | string | `"−£8.50"` |
| `$.recent_transactions[*].date_short` | string | `"Today"` |
| `$.recent_transactions[*].category_icon` | string | `"shopping_cart"` |
| `$.quick_actions` | array | see list item contract below |
| `$.quick_actions[*].label` | string | `"Transfer"` |
| `$.quick_actions[*].icon` | string | `"swap_horiz"` |
| `$.quick_actions[*].route` | string | `"/transfer"` |

---

### (Future screens to be added here)

As new screens are added to the template library, their bind paths should be documented in this table.

---

## Data Formatting Responsibilities

The frontend expects the data map to contain **display-ready strings** where display formatting is needed.

This is important. The frontend does not format numbers, dates, currencies, or durations. The architect is responsible for producing the formatted string in the data layer before the response is returned.

**Examples of what the frontend expects:**

| What the frontend needs | Correct | Incorrect |
|---|---|---|
| A currency amount for display | `"£1,250.00"` | `125000` (not formatted) |
| A date for display | `"14 July 2025"` | `"2025-07-14T09:41:00Z"` |
| A time for display | `"09:41 AM"` | `1752564060` (timestamp) |
| A relative date | `"3 days ago"` | `"2025-07-11"` |
| A large number for display | `"4,302"` | `4302` |

The architect should ensure the data layer formats values according to the locale in the request (see [localization_requirements.md](localization_requirements.md)).

---

## What the Frontend Sends When Requesting Data

When the frontend requests data for a screen, it can include:

- **Screen ID** — `transaction_detail`, `home_dashboard`, etc.
- **Context identifiers** — e.g. a transaction ID, an account ID, whatever is needed to construct that screen's data
- **Locale** — the active locale (see [localization_requirements.md](localization_requirements.md))
- **Authentication context** — whatever credential the frontend has been issued (the architect decides the authentication mechanism; the frontend passes it)

The frontend does not know how the backend assembles the data map. It may come from one source or many. It may be real-time or cached. The frontend only cares that the resulting object contains the expected bind paths.

---

## Error States and Missing Data

The frontend handles absent data gracefully:

- If a bind expression cannot be resolved, the component renders its empty/placeholder state. For a `zds_text` node, this means an empty string. For an avatar, this means initials fallback. For a list, this means an empty list.
- If the data map itself is absent (e.g. the fetch failed entirely), the screen renders an error state using a hardcoded fallback layout — not the SDUI template.
- The frontend does not show partial data in a state that could be misleading (e.g. showing a balance field with no value next to a unit label). The template author must design defensively by accounting for null/empty states in the component config.

---

## Open Questions for the Architect

- How does the backend know which context identifiers to expect for each screen? The frontend will pass what it has (e.g. `transaction_id`), but does the backend need a mapping of which screens take which parameters?
- Where does the data come from? One internal service, multiple? Real-time or cached? This affects how quickly the data map can be assembled per screen load.
- Who is responsible for formatting — the data layer that assembles the map, or the API gateway that returns it? There should be a single agreed responsibility.
- How should the backend handle a screen request where some data is unavailable (e.g. a third-party service is down)? Should it return a partial map with nulls, return an error, or return a fallback map? The frontend can handle any of these — the architect decides the convention.
- How often will the bind contracts change as templates evolve? A process to keep template authors and data layer owners synchronized would prevent silent rendering failures.
