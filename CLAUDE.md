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

`config/*.json` are gitignored. `config/dev.json.example` is the template. Required keys: `ENV`, `APP_NAME`, `API_BASE_URL`, `API_KEY`, `MAPS_API_KEY`, `GEMINI_API_URL`, `GEMINI_API_KEY`, `NEWS_API_URL`, `NEWS_API_KEY`. CI's `build.yml` constructs `config/prod.json` from GitHub secrets — if you add a new config key, update `build.yml` too.

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

### Flavors + Firebase projects

Two flavors — `dev` and `prod` — each backed by a **separate Firebase project**:

| Flavor | Android applicationId | iOS bundle ID | Firebase project |
|---|---|---|---|
| `dev` | `com.example.adaptive_weather_dashboard.dev` | `com.example.adaptiveWeatherDashboard.dev` | `adaptive-weather-dashboard-dev` |
| `prod` | `com.example.adaptive_weather_dashboard` | `com.example.adaptiveWeatherDashboard` | `adaptive-weather-dashboard` |

Both install side-by-side on a single device (different applicationId/bundleId), with their own independent Auth pools, Firestore data, Storage buckets, FCM tokens, and Crashlytics dashboards. Dev testers can sign up and post freely without polluting prod metrics.

**Per-flavor Firebase config files** (generated by `flutterfire configure`):

- **Android** — `android/app/src/<flavor>/google-services.json`. Gradle's `com.google.gms.google-services` plugin picks the right one automatically based on the active flavor.
- **iOS** — `ios/Runner/Firebase/<flavor>/GoogleService-Info.plist`. Selected at build time by a custom **Run Script build phase** in Xcode (named "Copy GoogleService-Info.plist for flavor") that reads `${CONFIGURATION}` and copies the matching plist into the app bundle. Must run AFTER "Copy Bundle Resources" in the Build Phases list.
- **Web + Dart** — `lib/firebase_options_dev.dart` and `lib/firebase_options_prod.dart`. `main.dart` switches on `AppConfig.instance.environment` to pick the right one.

**Firebase init quirk** — on Android and iOS, the native Firebase SDK auto-initializes from the platform config file BEFORE Dart `main()` runs. Calling `Firebase.initializeApp()` again from Dart throws `[core/duplicate-app]`. `main.dart` therefore guards the Dart-side init with `if (Firebase.apps.isEmpty)` — web genuinely needs the Dart init (no auto-init exists), mobile already has it.

**Deploying Firestore + Storage rules per project** — `.firebaserc` defines aliases (`firebase use dev` / `firebase use prod`). Rules deployments are scoped to whichever project is active:

```bash
firebase use dev
firebase deploy --only firestore:rules,storage:rules
firebase use prod
firebase deploy --only firestore:rules,storage:rules
```

### Push notifications

FCM tokens are stored per-user in Firestore. The Firebase Cloud Function in `functions/index.js` runs daily at 08:00 Asia/Bangkok, reads each user's `notification_city` + `fcm_token`, fetches weather, and sends a notification. The Flutter side handles all three states (foreground via `flutter_local_notifications`, background, terminated) in `FcmService`. Tapping a notification triggers `onNotificationTapped` (wired in `main.dart`) which dispatches a `SearchCity` event and navigates to `/weather`. Note FCM tokens are per-(app + Firebase project), so a token from the dev build will never deliver from the prod project's Cloud Messaging console (and vice versa).

### Localization

ARB files live in `lib/core/l10n/` (`app_en.arb`, `app_th.arb`). `flutter gen-l10n` generates `app_localizations.dart`. Always access strings via `context.l10n.<key>` (the extension in `l10n_extension.dart`) — never hardcode user-facing text. Adding a key: edit both ARB files, then run `flutter gen-l10n`.

## CI

`ci.yml` runs on PRs to `develop`/`main` and pushes to `develop`: pub get → build_runner → gen-l10n → analyze → test → analyze again with warnings non-fatal. The second analyze pass is intentional — the first catches errors, the second is informational. Don't bypass either.

`build.yml` runs only on `v*` tag pushes and produces Android APK and Web bundle for the **prod** flavor. iOS builds were intentionally removed — we don't distribute iOS (no Apple Developer Program / TestFlight) and Flutter's `--no-codesign` now requires a Development Team since recent versions. Add the job back if/when you sign up for the Developer Program.

## Git

- `main` — production, version-tagged (`v1.1.0`, etc.)
- `develop` — active development, default base for PRs
- Tag push to `v*` triggers prod builds
