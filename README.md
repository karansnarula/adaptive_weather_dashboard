# Adaptive Weather Dashboard

A production-grade multi-platform weather application built with Flutter, demonstrating clean architecture, responsive design, and scalable project infrastructure.

**Live Demo:** [https://adaptive-weather-dashboard.web.app](https://adaptive-weather-dashboard.web.app)

---

## Overview

Adaptive Weather Dashboard is a portfolio project showcasing production-level Flutter engineering practices. The app searches for cities, displays current weather and a 5-day forecast, allows saving favorite cities, and supports language switching between English and Thai.

While the feature set is intentionally minimal, the underlying architecture demonstrates the skills required to build and maintain a large-scale Flutter application across five platforms from a single codebase.

## Platforms

- iOS
- Android
- Web
- macOS
- Windows

All platforms share the same codebase with adaptive UI that automatically adjusts navigation patterns and layouts based on screen size.

## Tech Stack

| Concern | Package | Rationale |
|---|---|---|
| State Management | `flutter_bloc` | Event-driven, testable, scales well for complex apps |
| Dependency Injection | `injectable` + `get_it` | Auto-generated DI eliminates manual registration at scale |
| Networking | `dio` + `retrofit` | Retrofit generates clean API clients from annotations |
| Functional Error Handling | `fpdart` | Explicit `Either<Failure, Success>` eliminates try-catch sprawl |
| Navigation | `go_router` | URL-based routing works natively for web, official Flutter team package |
| Local Storage | `hive_ce` | Fast, type-safe key-value storage that works across all platforms |
| Preferences | `shared_preferences` | Standard solution for simple user preferences |
| Localization | `flutter_localizations` + ARB | Compile-time safe translations with IDE autocomplete |

## Architecture

The project follows **clean architecture** with three distinct layers per feature:

```
lib/
├── core/                           ← Shared infrastructure
│   ├── config/                     ← Environment configuration
│   ├── constants/                  ← API endpoints, shared constants
│   ├── error/                      ← Failure and exception classes
│   ├── l10n/                       ← Localization files (.arb)
│   ├── layout/                     ← AdaptiveScaffold
│   ├── responsive/                 ← Breakpoints, ResponsiveBuilder
│   ├── router/                     ← go_router configuration
│   └── theme/                      ← Light and dark themes
├── features/                       ← Feature modules
│   ├── weather/
│   │   ├── data/                   ← Data sources, models, repository impl
│   │   ├── domain/                 ← Entities, repository interface, use cases
│   │   └── presentation/           ← BloC, pages, layouts, widgets
│   ├── favorites/                  ← Same three-layer structure
│   └── settings/                   ← Presentation only (no data layer needed)
├── di/                             ← Dependency injection configuration
└── main.dart                       ← Single entry point
```

### Layer Responsibilities

**Domain layer** — business entities, abstract repository interfaces, and use cases. No dependencies on Flutter, Dio, or any external framework. Pure Dart.

**Data layer** — concrete repository implementations, API models with JSON serialization, remote and local data sources. Depends only on the domain layer for contracts.

**Presentation layer** — BloCs, pages, responsive layouts, and widgets. Depends on the domain layer for use cases and entities.

Data flows inward: UI → BloC → Use Case → Repository (abstract) → Repository Implementation → Data Source → API/Storage. Each layer knows only about the layer directly below it, which is why the codebase is easy to test and evolve.

## Key Architectural Decisions

### Single `main.dart` with `--dart-define-from-file`

Rather than the common pattern of separate entry points (`main_dev.dart`, `main_stg.dart`, `main_prod.dart`), this project uses a single `main.dart` with environment values injected at compile time via `--dart-define-from-file`. This avoids duplicate initialization code and keeps all environment logic in a single `AppConfig` class.

Secrets live in gitignored JSON files in `config/`. CI/CD injects them at build time from GitHub secrets. The compiled binary contains only the values needed for that specific build.

### ResponsiveBuilder for Multi-Platform UI

Business logic and shared widgets have zero platform awareness. Only layout files (`*_mobile.dart`, `*_tablet.dart`, `*_desktop.dart`) know the screen size. A `ResponsiveBuilder` widget picks the right layout at runtime based on breakpoints defined in `AppBreakpoints`.

The same pattern applies to navigation via `AdaptiveScaffold`, which switches between bottom navigation bar (mobile), navigation rail (tablet), and navigation drawer (desktop) — all powered by the same `go_router` configuration.

### `fpdart` for Error Handling

Every repository method returns `Future<Either<Failure, T>>`. Try-catch exists only in the data layer where external errors (Dio, Hive exceptions) are converted into `Failure` objects. The domain and presentation layers deal exclusively with `Either` — no exceptions bubble up, and every call site is forced to handle both success and failure.

### `@module` for Third-Party Dependencies

Classes you own get annotated with `@injectable`, `@singleton`, or `@lazySingleton`. Third-party classes like `Dio`, `SharedPreferences`, and Hive boxes that you can't annotate are registered in `AppModule` with `@module`. This keeps the DI setup centralized and scalable.

### Feature-First Folder Structure

Features are self-contained modules with their own `data/`, `domain/`, and `presentation/` folders. Shared infrastructure lives in `core/`. This makes it easy to locate feature-specific code and enforces clean boundaries between features.

## Git Strategy

- `main` — Production releases, tagged with version numbers (e.g. `v1.0.0`)
- `develop` — Active development, QA builds
- `feature/*` — Short-lived branches created off `develop`

Feature freeze is applied to `develop` during UAT to avoid unintended features landing in production. UAT builds are manually triggered from `develop` via CI/CD when needed. Production builds trigger automatically when a tag is pushed to `main`.

## Flavors

Three environments with separate application IDs and display names:

| Flavor | Android Application ID | iOS Bundle ID | Display Name |
|---|---|---|---|
| dev | `com.example.adaptive_weather_dashboard.dev` | `com.example.adaptiveWeatherDashboard.dev` | Weather Dev |
| stg | `com.example.adaptive_weather_dashboard.stg` | `com.example.adaptiveWeatherDashboard.stg` | Weather STG |
| prod | `com.example.adaptive_weather_dashboard` | `com.example.adaptiveWeatherDashboard` | Weather Dashboard |

All three can be installed side by side on the same device.

## CI/CD

Two GitHub Actions workflows:

**`ci.yml`** — runs on every pull request and every push to `develop`. Installs dependencies, generates code, runs lint analysis, and executes tests. Prevents broken code from reaching the main branches.

**`build.yml`** — triggered when a version tag is pushed (e.g. `v1.0.0`). Builds Android APK, iOS IPA (unsigned), and web bundle for the production flavor. API credentials are injected from GitHub repository secrets.

## Testing

Tests are written at each clean architecture layer:

- **Domain layer** — use case tests with mocked repositories
- **Data layer** — repository tests with mocked data sources, verifying model-to-entity mapping and error handling
- **Presentation layer** — BloC tests verifying state emission sequences for both success and failure paths

## Getting Started

### Prerequisites

- Flutter SDK 3.9+
- An OpenWeatherMap API key (free tier): [https://openweathermap.org/api](https://openweathermap.org/api)
- Xcode (for iOS/macOS builds)
- Android Studio (for Android builds)

### Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/adaptive_weather_dashboard.git
   cd adaptive_weather_dashboard
   ```

2. Create your config files by copying the examples:
   ```bash
   cp config/dev.json.example config/dev.json
   cp config/dev.json.example config/stg.json
   cp config/dev.json.example config/prod.json
   ```

3. Add your OpenWeatherMap API key to each config file.

4. Install dependencies:
   ```bash
   flutter pub get
   ```

5. Run code generation:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

6. Generate localization files:
   ```bash
   flutter gen-l10n
   ```

## Running the App

```bash
# Development (mobile)
flutter run --flavor dev --dart-define-from-file=config/dev.json

# Staging (mobile)
flutter run --flavor stg --dart-define-from-file=config/stg.json

# Production (mobile)
flutter run --flavor prod --dart-define-from-file=config/prod.json

# Web
flutter run -d chrome --dart-define-from-file=config/dev.json

# macOS
flutter run -d macos --dart-define-from-file=config/dev.json

# Windows
flutter run -d windows --dart-define-from-file=config/dev.json
```

## Building

```bash
# Android APK
flutter build apk --flavor prod --dart-define-from-file=config/prod.json

# iOS (unsigned)
flutter build ios --flavor prod --dart-define-from-file=config/prod.json --no-codesign

# Web
flutter build web --dart-define-from-file=config/prod.json

# macOS
flutter build macos --dart-define-from-file=config/prod.json

# Windows
flutter build windows --dart-define-from-file=config/prod.json
```

## Running Tests

```bash
flutter test
```

## Deployment

The web build is deployed to Firebase Hosting. To deploy your own:

```bash
flutter build web --dart-define-from-file=config/prod.json
firebase deploy --only hosting
```

## What This Project Demonstrates

- Clean architecture with strict layer separation
- State management at scale with BloC
- Dependency injection patterns for a growing codebase
- Multi-platform responsive design without platform-specific features in business logic
- Functional error handling with `fpdart`
- Environment configuration without hardcoded secrets
- CI/CD pipeline for multi-flavor builds
- Testing strategy across all architecture layers
- Localization with compile-time safety
- Production-ready project structure suitable for long-term maintenance