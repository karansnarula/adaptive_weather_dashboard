# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

All `flutter run` / `flutter build` commands **must** pass `--dart-define-from-file` pointing at a `config/<env>.json` file — there is no fallback. Mobile builds (Android/iOS) additionally require `--flavor`. Web/macOS/Windows do not use flavors.

```bash
# Install deps + generate code + generate localizations (run after pubspec or annotation changes)
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n

# Run
flutter run --flavor dev --dart-define-from-file=config/dev.json          # Android/iOS
flutter run -d chrome --dart-define-from-file=config/dev.json             # Web (no flavor)
flutter run -d macos --dart-define-from-file=config/dev.json              # macOS (no flavor)

# Test
flutter test                                          # all tests
flutter test test/features/weather/...                # single file
flutter test --name "WeatherBloc emits"               # match by test name

# Lint (matches CI)
flutter analyze --no-fatal-infos
flutter analyze --no-fatal-infos --no-fatal-warnings  # CI's second pass — warnings are non-fatal

# Build prod
flutter build apk    --flavor prod --dart-define-from-file=config/prod.json
flutter build ios    --flavor prod --dart-define-from-file=config/prod.json --no-codesign
flutter build web                  --dart-define-from-file=config/prod.json
```

`config/*.json` are gitignored. `config/dev.json.example` is the template. Required keys: `ENV`, `APP_NAME`, `API_BASE_URL`, `API_KEY`, `MAPS_API_KEY`, `GEMINI_API_URL`, `GEMINI_API_KEY`. CI's `build.yml` constructs `config/prod.json` from GitHub secrets — if you add a new config key, update `build.yml` too.

## Architecture

Clean architecture with three layers per feature (`data/`, `domain/`, `presentation/`) under `lib/features/`. Shared infrastructure lives in `lib/core/`. **Not every feature uses all three layers** — see "Lightweight vs full architecture" below.

### Layer rules (enforced by convention, not lint)

- **Domain** — Pure Dart entities, abstract repository interfaces, use cases. No Flutter/Dio/Firebase imports.
- **Data** — Concrete repository implementations, API/Hive models, data sources. The only layer that uses try-catch — external exceptions are converted into `Failure` objects here.
- **Presentation** — BLoCs, pages, layouts, widgets. Depends on domain only.

Every repository method returns `Future<Either<Failure, T>>` (`fpdart`). No exceptions cross layer boundaries.

### Lightweight vs full architecture

`air_quality` is intentionally **not** full clean architecture — it's a single read-only API call rendered with `FutureBuilder` + an `AirQualityService` that fetches and parses in one class. Apply the same judgment for new features: full BLoC + repository + use case stack is appropriate when there's state mutation, caching, or cross-feature interaction; otherwise prefer the lightweight pattern.

`settings/` is presentation-only — it reads/writes `SharedPreferences` directly via the BLoC, no repository abstraction.

### Dependency injection

`injectable` + `get_it`. `@injectable`/`@lazySingleton`/`@singleton` annotations generate `lib/di/injection.config.dart` via build_runner. Cross-cutting singletons (Dio, FirebaseAuth, Firestore, Hive box, SharedPreferences) are registered in `lib/di/app_module.dart`. **After adding/removing any `@injectable`-annotated class, you must re-run `dart run build_runner build --delete-conflicting-outputs`** or DI resolution will fail at runtime.

### Responsive UI pattern

Layout files (`*_mobile.dart`, `*_tablet.dart`, `*_desktop.dart`) are the **only** files allowed to know screen size. `ResponsiveBuilder` (`lib/core/responsive/responsive_builder.dart`) picks one at runtime based on `AppBreakpoints`. BLoCs, use cases, entities, and shared widgets must remain platform-agnostic. The same `go_router` config powers all form factors; `AdaptiveScaffold` switches between bottom nav / nav rail / nav drawer.

### Routing + auth guard

`AppRouter` (`lib/core/router/app_router.dart`) wires a `redirect` against `AuthBloc.state`. `_GoRouterAuthNotifier` re-runs `redirect` on every auth state change. When adding a protected route, just add it under the `StatefulShellRoute` — the guard handles it. Auth routes (`/login`, `/register`) and the deep-linked `/air-quality/:city` route sit **outside** the shell.

### Push notifications

FCM tokens are stored per-user in Firestore. The Firebase Cloud Function in `functions/index.js` runs daily at 08:00 Asia/Bangkok, reads each user's `notification_city` + `fcm_token`, fetches weather, and sends a notification. The Flutter side handles all three states (foreground via `flutter_local_notifications`, background, terminated) in `FcmService`. Tapping a notification triggers `onNotificationTapped` (wired in `main.dart`) which dispatches a `SearchCity` event and navigates to `/weather`.

### Localization

ARB files live in `lib/core/l10n/` (`app_en.arb`, `app_th.arb`). `flutter gen-l10n` generates `app_localizations.dart`. Always access strings via `context.l10n.<key>` (the extension in `l10n_extension.dart`) — never hardcode user-facing text. Adding a key: edit both ARB files, then run `flutter gen-l10n`.

## CI

`ci.yml` runs on PRs to `develop`/`main` and pushes to `develop`: pub get → build_runner → gen-l10n → analyze → test → analyze again with warnings non-fatal. The second analyze pass is intentional — the first catches errors, the second is informational. Don't bypass either.

`build.yml` runs only on `v*` tag pushes and produces Android APK, iOS IPA (unsigned), and Web bundle for the **prod** flavor. iOS deployment target is patched to 15.0 via `sed` in the workflow because the local Podfile/xcconfig values aren't sufficient for the CI image — if you change iOS deployment targets, update `build.yml` too.

## Git

- `main` — production, version-tagged (`v1.1.0`, etc.)
- `develop` — active development, default base for PRs
- Tag push to `v*` triggers prod builds
