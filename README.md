# Zugantor Design System

A monorepo containing the **Zugantor Design System (ZDS)** — a versatile,
themeable Flutter component library — and a **Storybook** showcase app.

---

## Relationship with [component.gallery](https://component.gallery/)

[component.gallery](https://component.gallery/) is a curated, up-to-date
reference catalog of 60+ interface component patterns (Accordion, Alert, Badge,
Button, Card, Checkbox, Tabs, etc.) gathered from 90+ real-world design systems
(Atlassian, GitHub Primer, Shopify Polaris, and many more).

**The Zugantor Design System is a Flutter implementation of the same standard
component patterns that component.gallery catalogs.** Each ZDS widget directly
corresponds to a well-defined component type documented on component.gallery,
giving teams a shared vocabulary and a clear benchmark for what each component
should look and behave like.

### Component coverage map

| component.gallery pattern | ZDS widget | Status |
|---------------------------|------------|--------|
| [Button](https://component.gallery/components/button/) | `ZDSButton` (primary / secondary / text / icon variants) | ✅ Implemented |
| [Card](https://component.gallery/components/card/) | `AppCard` | ✅ Implemented |
| [Checkbox](https://component.gallery/components/checkbox/) | `AppCheckbox` | ✅ Implemented |
| [Radio button](https://component.gallery/components/radio-button/) | `AppRadioGroup` / `AppRadioItem` | ✅ Implemented |
| [Switch / Toggle](https://component.gallery/components/toggle/) | `AppSwitch` | ✅ Implemented |
| [Select / Dropdown](https://component.gallery/components/select/) | `AppDropdown` | ✅ Implemented |
| [Text input](https://component.gallery/components/text-input/) | `AppTextInput` | ✅ Implemented |
| [Date picker](https://component.gallery/components/date-picker/) | `AppDatePicker` | ✅ Implemented |
| [Alert / Banner](https://component.gallery/components/alert/) | `Alert` (info / success / warning / error) | ✅ Implemented |
| [Tabs](https://component.gallery/components/tabs/) | `ZDSTabs` / `ZDSTabItem` | ✅ Implemented |
| [Accordion](https://component.gallery/components/accordion/) | `Accordion` / `AccordionItem` | ✅ Implemented |
| [Badge](https://component.gallery/components/badge/) | `ZDSBadge` (filled / outlined / soft + overlay) | ✅ Implemented |
| [Dialog / Modal](https://component.gallery/components/dialog/) | — | 🔜 Planned |
| [Pagination](https://component.gallery/components/pagination/) | — | 🔜 Planned |
| [Progress indicator](https://component.gallery/components/progress-indicator/) | — | 🔜 Planned |
| [Tooltip](https://component.gallery/components/tooltip/) | — | 🔜 Planned |
| [Avatar](https://component.gallery/components/avatar/) | — | 🔜 Planned |
| [Slider](https://component.gallery/components/slider/) | — | 🔜 Planned |

> component.gallery serves as the **specification reference** for ZDS. When
> designing or reviewing a component, consult its component.gallery entry for
> naming conventions, expected variants, accessibility notes, and real-world
> implementations from other design systems.

---

## Repository structure

```
zugantor_repo/
├── apps/
│   └── storybook/          # Flutter app that showcases all ZDS components
└── packages/
    └── zugantor_design_system/
        └── lib/
            └── src/
                ├── theme/          # Colors, typography, spacing, shapes, ZDSTheme
                ├── utils/          # BuildContext extensions (context.colors, etc.)
                └── widgets/
                    ├── buttons/    # ZDSButton
                    ├── display/    # ZDSBadge
                    ├── feedback/   # Alert
                    ├── forms/      # AppCheckbox, AppDropdown, AppDatePicker, …
                    ├── layout/     # AppCard, Section, Spacing, PaddedContainer
                    └── navigation/ # ZDSTabs, Accordion
```

## Getting started

```bash
# Bootstrap the monorepo (requires melos)
dart pub global activate melos
melos bootstrap

# Run the storybook
cd apps/storybook
flutter run
```

## Architecture

See [PROJECT_GOALS.md](PROJECT_GOALS.md) for the architectural principles and
[REFACTORING_ANALYSIS.md](REFACTORING_ANALYSIS.md) for the current state
assessment and improvement roadmap.
