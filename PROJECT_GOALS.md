# Project Goals: Zugantor Design System

This document outlines the primary goals and architectural principles for the Zugantor Design System (ZDS). Its purpose is to serve as a guiding star for development, ensuring we stay on track and build a robust, scalable, and maintainable system.

## High-Level Vision

To create a versatile, themeable, and scalable design system within a monorepo. This system will serve as the foundational UI layer for a wide variety of business-related applications, enabling rapid development and ensuring brand consistency.

The system is intended for any application that does not require a real-time 3D gaming experience.

## Core Architectural Principles

### 1. Separation of Structure and Style

- **The Design System's Role:** The `zugantor_design_system` package provides the **structure** and **behavior** of the components (e.g., a `PrimaryButton` widget). It defines the "what" and the "how it works."
- **The Application's Role:** Each consuming application provides the **style** (the theme). It defines the "how it looks."

### 2. Complete Themability

Applications must have full and granular control over their visual identity. This is achieved through a custom theme extension (`ZDSTheme`). An app can define its own:

- **Colors:** A complete, semantic color palette (primary, secondary, success, warning, etc.).
- **Typography:** Font families, weights, and sizes for all text styles.
- **Shapes:** Border radii and shapes for components like cards, buttons, and dialogs.
- **Spacing:** A consistent scale for padding, margins, and layout spacing.

### 3. Localization at the App Level

The design system components will be "localization-agnostic." They will not contain any hardcoded user-facing strings. Instead, they will accept `String` or `Widget` parameters, and it is the responsibility of the consuming application to provide the localized text.

### 4. Scalability and Component Promotion

- **App-Specific Widgets:** Widgets that are unique to a single application should reside within that application's own `lib/` directory.
- **Promotion Path:** If a widget is duplicated across multiple projects, a clear and simple process should exist to "promote" it into the core design system. This involves moving the code, refactoring it to use the `ZDSTheme` for styling, and updating the apps to import it from the central package.

### 5. Naming Conventions

To ensure consistency and readability across the codebase, we will adhere to the following conventions:

- **Files & Directories:** `snake_case` (e.g., `primary_button.dart`).
- **Classes & Types:** `PascalCase` (e.g., `PrimaryButton`, `ZDSTheme`).
- **Methods & Variables:** `camelCase` (e.g., `calculateHeight`, `primaryColor`).
- **Core Theme Services:** A unique `ZDS` prefix will be used for core theme classes to avoid conflicts (e.g., `ZDSTheme`, `ZDSColors`).
- **Widgets:** No prefix will be used for widgets to keep their usage clean and simple (e.g., `PrimaryButton`, `AppCard`).

### 6. Future Vision: Server-Driven UI (SDUI)

While not an immediate priority, the design system should be architected in a way that it can serve as the rendering layer for a future server-driven UI engine. This implies that components should be addressable by a unique key and their properties should be serializable. This consideration will guide our component API design.
