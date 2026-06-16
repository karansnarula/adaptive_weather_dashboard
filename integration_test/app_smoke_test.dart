// Integration smoke test for the adaptive_weather_dashboard app.
//
// Runs the full app — real DI, real routing, real BLoCs — and exercises
// the splash → sign-in navigation path. Verifies the boot pipeline is
// healthy: AppConfig + Hive + DI all initialize without throwing, the
// router lands on the right unauthenticated entry screen, and the
// localization is wired up so the form labels resolve.
//
// Run on a connected device or simulator with:
//   flutter test integration_test/app_smoke_test.dart \
//     --flavor dev --dart-define-from-file=config/dev.json
//
// This is a deliberately narrow smoke test, not the full
// "sign-up → search Bangkok → favorite" journey we want eventually.
// The full journey needs fake backends (fake_cloud_firestore for
// Firestore, a fake FirebaseAuth, a fake weather API client) so the
// test can run hermetically without real network. Setting up those
// fakes + a test-mode DI override is its own ~1-day feature — tracked
// for v1.4.0 alongside the Patrol setup for camera/permission flows.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:integration_test/integration_test.dart';

import 'package:adaptive_weather_dashboard/core/config/app_config.dart';
import 'package:adaptive_weather_dashboard/di/injection.dart';
import 'package:adaptive_weather_dashboard/firebase_options_dev.dart'
    as dev;
import 'package:adaptive_weather_dashboard/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    AppConfig.initialize();
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: dev.DefaultFirebaseOptions.currentPlatform,
      );
    }
    await Hive.initFlutter();
    await configureDependencies();

    // Sign out any persisted user so tests always start from the
    // unauthenticated entry path. Without this, FirebaseAuth restores
    // whoever was signed in on the device last and the tests land on
    // the weather page instead of the sign-in screen.
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {
      // Not signed in — signOut is a no-op.
    }
  });

  testWidgets(
    'app boots past splash and lands on the sign-in screen',
    (tester) async {
      await tester.pumpWidget(const WeatherDashboardApp());

      // Splash + auth check both resolve. pumpAndSettle waits until the
      // post-splash navigation finishes and the auth stream emits.
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Sign-in is the unauthenticated entry. The page shows the email
      // and password fields plus the "Sign up" navigation link.
      expect(find.byType(TextField), findsNWidgets(2));
      expect(
        find.text("Don't have an account? Sign Up"),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'tapping "Sign Up" link navigates to the register screen',
    (tester) async {
      await tester.pumpWidget(const WeatherDashboardApp());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      await tester.tap(find.text("Don't have an account? Sign Up"));
      await tester.pumpAndSettle();

      // The register page has 4 fields (name, email, password, confirm)
      // plus the "Already have an account? Sign In" back link.
      expect(find.byType(TextField), findsNWidgets(4));
      expect(
        find.text('Already have an account? Sign In'),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'sign-in form accepts text input',
    (tester) async {
      await tester.pumpWidget(const WeatherDashboardApp());
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final emailField = find.byType(TextField).first;
      final passwordField = find.byType(TextField).last;

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'hunter2');
      await tester.pump();

      expect(find.text('test@example.com'), findsOneWidget);
      // Password fields obscure their text, so we don't try to read it
      // back — verifying enterText completed without exception is
      // enough to confirm the field is wired.
    },
  );
}
