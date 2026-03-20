# Setup & Getting Started

This guide explains how to check out the latest changes and run the storybook
app locally.

---

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) **≥ 3.10.0**
- [Dart SDK](https://dart.dev/get-dart) **≥ 3.10.4** (bundled with Flutter)
- [Melos](https://melos.invertase.dev/) (optional — for monorepo scripts)

---

## 1. Clone and check out the branch

```bash
# Clone the repository (skip if already cloned)
git clone https://github.com/subhojit1stjuly/zugantor_repo.git
cd zugantor_repo

# Fetch and switch to the PR branch
git fetch origin
git checkout copilot/analyze-website-repo-relationship
```

---

## 2. Install dependencies

```bash
# Install dependencies for both packages
cd packages/zugantor_design_system
flutter pub get
cd ../..

cd apps/storybook
flutter pub get
cd ../..
```

> **Using Melos (optional):**
> ```bash
> dart pub global activate melos
> melos bootstrap
> ```

---

## 3. Run the storybook

```bash
cd apps/storybook

# Run on your preferred platform:
flutter run -d chrome          # web
flutter run -d macos           # macOS desktop
flutter run -d linux           # Linux desktop
flutter run -d windows         # Windows desktop
flutter run                    # connected mobile device / emulator
```

The storybook showcases all components, including the four new ones added in
this branch:

| Section | Component |
|---------|-----------|
| Alerts | `Alert.info / .success / .warning / .error` |
| Accordion | `Accordion` with expand/collapse |
| Tabs | `ZDSTabs` with icon and disabled-tab support |
| Badges | `ZDSBadge` (filled / outlined / soft) and `ZDSBadge.overlay` |

---

## 4. Using the new components in your own app

Add the design system as a dependency in your `pubspec.yaml`:

```yaml
dependencies:
  zugantor_design_system:
    path: ../../packages/zugantor_design_system   # adjust path as needed
```

Then import and use:

```dart
import 'package:zugantor_design_system/zugantor_design_system.dart';

// Alert
Alert.success(title: 'Saved', message: 'Your profile has been updated.')
Alert.error(title: 'Error', message: 'Something went wrong.', onClose: () {})

// Accordion
Accordion(items: [
  AccordionItem(title: 'FAQ', content: Text('Answer goes here.')),
])

// Tabs
ZDSTabs(tabs: [
  ZDSTabItem(label: 'Overview', content: Text('Overview content')),
  ZDSTabItem(label: 'Details', content: Text('Details content')),
])

// Badge
ZDSBadge(label: 'New', variant: BadgeVariant.soft)
ZDSBadge.overlay(count: 5, child: Icon(Icons.notifications))
```

---

## 5. Merge the PR

The PR is currently in **draft** mode. To merge it into `main`:

1. Open the PR on GitHub:
   <https://github.com/subhojit1stjuly/zugantor_repo/pull/3>
2. Click **"Ready for review"** to move it out of draft status.
3. Review and click **"Merge pull request"**.

---

## Troubleshooting

| Problem | Fix |
|---------|-----|
| `flutter: command not found` | Add Flutter's `bin/` directory to your `PATH`. |
| `pub get` fails with version errors | Run `flutter upgrade` to get the latest stable SDK. |
| `ZDSTheme not found` | Ensure `ZDSThemeFactory.light()` is passed to `MaterialApp.theme`. |
| `No ZDSTheme found in the context` | The `ZDSThemeFactory` creates a `ThemeData` with the ZDS extension. Pass it to `MaterialApp`. |
