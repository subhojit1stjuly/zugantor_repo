# Zugantor Repository

A Flutter monorepo using Melos for package management.

## Prerequisites

- Flutter SDK
- Dart SDK
- Git

## Setup

### Windows
```batch
.\setup.bat
```

### macOS/Linux
```bash
chmod +x setup.sh
./setup.sh
```

## Project Structure

```
zugantor_repo/
├── apps/
│   ├── app_zugantor/    # Main application
│   └── app_admin/       # Admin dashboard
├── features/
│   ├── auth/           # Authentication feature module
│   ├── theme/          # Shared theming module
│   └── networking/     # API and networking module
└── packages/
    └── zugantor_core/  # Core shared functionality
```

## Available Commands

Run these commands using `melos run <command>`:

- `analyze` - Run analyzer on all packages
- `format` - Format all packages
- `test` - Run tests across all packages
- `build:apps` - Build all Flutter applications
- `build:packages` - Build all shared packages
- `dependencies` - Get dependencies for all packages
- `coverage` - Run tests with coverage

## Development

This project uses Riverpod for dependency injection and state management. Key features:

- Modular architecture with feature-based packages
- Shared core functionality
- Environment-based configuration
- Comprehensive testing setup
- Code generation for immutable models

### Creating a New Feature

1. Create a new directory under `features/`
2. Copy the basic structure from existing features
3. Add the feature to your app's dependencies

### Adding a New App

1. Create a new directory under `apps/`
2. Use the naming convention `app_*`
3. Add required feature dependencies

## Testing

Each package contains its own tests. Run all tests with:

```bash
melos run test
```

## Code Generation

After making changes to any file with annotations, run:

```bash
melos exec -c 1 -- "dart run build_runner build --delete-conflicting-outputs"
```

## Troubleshooting

If you encounter any issues during setup:

1. Try cleaning the workspace:
   ```bash
   melos clean
   melos bootstrap
   ```

2. Ensure all dependencies are up to date:
   ```bash
   melos run dependencies
   ```

3. Check that code generation is up to date:
   ```bash
   melos exec -c 1 -- "dart run build_runner build --delete-conflicting-outputs"
   ```
