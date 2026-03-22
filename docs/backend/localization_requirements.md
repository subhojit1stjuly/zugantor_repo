# Localization Requirements

## What This Document Covers

This document describes what the frontend expects regarding language and localized strings in SDUI content — what it sends, what it expects to receive, and where the responsibility boundary between frontend and backend sits.

---

## The Core Principle: Strings Arrive Ready to Display

The frontend **does not translate strings at runtime**. It does not look up a string key and resolve it to a human-readable label. It does not have a translation bundle for SDUI content.

This means:

- All human-readable strings in a layout template must already be in the correct language and format for the user who will see them.
- All human-readable strings in a data map must already be in the correct language and format.
- The frontend is simply a renderer. It displays what it receives.

The responsibility for delivering localized content lies entirely with the backend.

---

## What the Frontend Sends

The frontend sends its active locale with every request — both template requests and data requests:

| Field | Format | Examples |
|---|---|---|
| `locale` | BCP 47 language tag | `en-GB`, `de-DE`, `fr-FR`, `ar-SA`, `zh-Hant-TW` |

The locale is determined by:

1. The user's explicit language preference (if the app has a language setting)
2. If no preference is set: the device system locale
3. If the system locale is unsupported: the app's configured fallback locale (currently `en-GB`)

The frontend sends the full tag, including region code where relevant. The architect should not assume that a language tag will always be two characters.

---

## What the Frontend Expects to Receive

### In a Layout Template

All static string values in `props` fields must be in the language corresponding to the requested locale.

For example, a button with a static label should not arrive with:

```json
"props": { "label": "CONFIRM_TRANSFER_BUTTON" }
```

It should arrive with:

```json
"props": { "label": "Transfer bestätigen" }
```

...if the locale is `de-DE`.

If the architect's system stores templates with translation keys internally, the resolution from key to display string should happen **before the template is returned**, not by the frontend at render time.

### In a Data Map

All display-ready strings in the data map should also be in the appropriate locale. This includes:

- Formatted amounts (see [data_requirements.md](data_requirements.md))
- Date and time strings
- Status labels
- Category names
- Any other string the frontend will display without further transformation

---

## Right-to-Left (RTL) Languages

The Flutter framework handles RTL layout direction automatically when the app locale is an RTL language (e.g. Arabic `ar`, Hebrew `he`, Persian `fa`). Widgets mirror correctly without any changes to the template.

However, the architect should be aware that:

- String values in templates must be in the RTL language
- Numbers formatted with Western Arabic digits are fine; Eastern Arabic digits (`٠١٢...`) should be used if the locale convention requires them
- Punctuation and directionality in mixed-direction strings (e.g. a label containing both Arabic text and an English brand name) should be handled so the string reads correctly when Flutter renders it

---

## Locale Fallback Chain

When the frontend sends a locale and the backend does not have a translation for that exact locale, the frontend expects a reasonable fallback. The architect should define and implement a fallback chain. A suggested approach (not a requirement) is:

1. Try the exact locale (`fr-CH`)
2. Try the language without region (`fr`)
3. Try the app's default locale (`en-GB`)

The frontend does not need to be informed about which fallback was used — it simply renders what it receives. But if the string arrives in an unexpected language, the frontend will display it as-is and the user will see the wrong language. There is no error visible to the frontend.

---

## Number, Currency, and Date Formatting

As noted in [data_requirements.md](data_requirements.md), the frontend expects all numbers, currencies, and dates to arrive as pre-formatted display strings, not as raw numeric or ISO values.

Locale-correct formatting is the backend's responsibility. Examples:

| Locale | Amount | Expected string |
|---|---|---|
| `en-GB` | 1250.00 GBP | `£1,250.00` |
| `de-DE` | 1250.00 EUR | `1.250,00 €` |
| `fr-FR` | 1250.00 EUR | `1 250,00 €` |
| `ar-SA` | 1250.00 SAR | `١٬٢٥٠٫٠٠ ﷼` (or localized equivalent) |

The frontend does not choose formatting conventions. Whatever string the backend provides will be displayed.

---

## Static App UI vs. SDUI Content

This document only covers SDUI content (layout templates and data maps). The app's own static UI (navigation labels, hardcoded button labels, onboarding copy, etc.) is localized separately using the standard Flutter `l10n` / `intl` package approach with ARB files. That is entirely a frontend concern and does not involve the backend.

---

## Scenarios the Architect Should Consider

### Scenario A: Locale-specific template files

The architect maintains one version of each template per locale. When the frontend requests a template with locale `de-DE`, it receives the German version.

The manifest (see [sync_requirements.md](sync_requirements.md)) would need to return locale-specific version identifiers so the frontend knows when its locally stored `de-DE` template for a screen has been updated.

### Scenario B: Templates with keys, translation resolved server-side before delivery

Templates are authored with string keys (`confirm_button_label`), and a translation layer resolves the keys into display strings before the template is sent to the frontend. The frontend receives a fully resolved template and never sees the keys.

This is transparent to the frontend.

### Scenario C: Templates with embedded English, data map carries localized strings

Static template strings are always in English, and any user-facing content is bound from the data map using bind expressions. The data map is localized server-side before being returned.

The frontend handles this naturally. The template's static props (e.g. structural labels, button text) would need to be in English only in this scenario, which may be acceptable if all user-facing content comes through the data layer.

### Scenario D: Runtime locale switching

The user changes their language preference while the app is open. The frontend updates its locale and re-fetches affected data. It may also trigger a template re-sync if templates are locale-specific. The architect should consider whether locale changes invalidate the locally cached templates.

---

## Open Questions for the Architect

- Is the architect planning to maintain separate templates per locale, or will all localization go through the data map? This affects how the template library scales with language coverage.
- How are translated strings stored and managed on the backend? Is there a dedicated localization service, a translation management tool, or strings embedded in the template store?
- What happens when a new template is published in one locale (e.g. English) but translations for other locales are not yet ready? Does the backend serve the English version as a fallback, block the release, or handle this another way?
- Does the app need to support locales where the number/currency formatting follows non-Latin conventions (Eastern Arabic numerals, etc.), and if so, which locales are in scope?
- Is there a need for the frontend to send a user-preferred currency (separate from locale), or will currency selection be determined purely from the user's account data?
