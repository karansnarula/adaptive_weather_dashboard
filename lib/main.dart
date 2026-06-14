import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_ce_flutter/adapters.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/router/app_routes.dart';
import 'core/l10n/app_localizations.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/discussion/presentation/bloc/unread/discussion_unread_bloc.dart';
import 'features/discussion/presentation/bloc/unread/discussion_unread_event.dart';
import 'features/favorites/presentation/bloc/favorites_bloc.dart';
import 'features/favorites/presentation/bloc/favorites_event.dart';
import 'features/notifications/data/services/fcm_service.dart';
import 'features/notifications/presentation/bloc/notification_bloc.dart';
import 'features/notifications/presentation/bloc/notification_event.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'features/settings/presentation/bloc/settings_event.dart';
import 'features/settings/presentation/bloc/settings_state.dart';
import 'features/weather/presentation/bloc/weather_bloc.dart';
import 'di/injection.dart';
import 'features/weather/presentation/bloc/weather_event.dart';
import 'firebase_options_dev.dart' as dev;
import 'firebase_options_prod.dart' as prod;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // AppConfig must initialize before Firebase so we know which flavor's
  // Firebase project to connect to.
  AppConfig.initialize();

  // On Android/iOS, the native Firebase SDK auto-initializes from the
  // per-flavor google-services.json / GoogleService-Info.plist before Dart
  // even runs. Re-initializing from Dart would throw [core/duplicate-app].
  // Web has no auto-init, so we still need to initialize there explicitly.
  if (Firebase.apps.isEmpty) {
    final firebaseOptions = switch (AppConfig.instance.environment) {
      Environment.dev => dev.DefaultFirebaseOptions.currentPlatform,
      Environment.prod => prod.DefaultFirebaseOptions.currentPlatform,
    };
    await Firebase.initializeApp(options: firebaseOptions);
  }

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await Hive.initFlutter();

  await configureDependencies();

  runApp(const WeatherDashboardApp());
}

class WeatherDashboardApp extends StatefulWidget {
  const WeatherDashboardApp({super.key});

  @override
  State<WeatherDashboardApp> createState() => _WeatherDashboardAppState();
}

class _WeatherDashboardAppState extends State<WeatherDashboardApp> {
  late final AuthBloc _authBloc;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    // AuthCheckRequested sets up the userChanges stream subscription so we
    // get sign-in/sign-out events. AuthRefreshRequested forces a one-shot
    // server reload right after — needed because FirebaseAuth.currentUser
    // restored from local storage on app launch has the photoUrl as it was
    // when the token was issued, not the current server value (so changes
    // made on another device won't show until the next sign-in unless we
    // explicitly reload).
    _authBloc = getIt<AuthBloc>()
      ..add(const AuthCheckRequested())
      ..add(const AuthRefreshRequested());
    _router = AppRouter.router(_authBloc);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _authBloc),
        BlocProvider(create: (context) => getIt<WeatherBloc>()),
        BlocProvider(
          create: (context) =>
          getIt<FavoritesBloc>()..add(const LoadFavorites()),
        ),
        BlocProvider(
          create: (context) => getIt<SettingsBloc>()..add(const LoadSettings()),
        ),
        BlocProvider(create: (context) => getIt<NotificationBloc>()),
        BlocProvider(create: (context) => getIt<DiscussionUnreadBloc>()),
        BlocProvider(create: (context) => getIt<ProfileBloc>()),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            context.read<NotificationBloc>().add(
              LoadNotificationCity(state.user.uid),
            );
            final fcmService = getIt<FcmService>();
            fcmService.initialize();
            fcmService.onNotificationTapped = (cityName) {
              final isCelsius = context.read<SettingsBloc>().state.isCelsius;
              final units = isCelsius ? 'metric' : 'imperial';
              context.read<WeatherBloc>().add(
                SearchCity(cityName, units: units),
              );
              _router.go(AppRoutes.weather);
            };
          } else if (state is Unauthenticated) {
            context.read<DiscussionUnreadBloc>().add(
              const ResetUnreadCount(),
            );
          }
        },
        child: BlocBuilder<SettingsBloc, SettingsState>(
          buildWhen: (previous, current) =>
          previous.languageCode != current.languageCode ||
              previous.themeMode != current.themeMode,
          builder: (context, settingsState) {
            return MaterialApp.router(
              title: AppConfig.instance.appName,
              debugShowCheckedModeBanner: false,

              // Theme
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: switch (settingsState.themeMode) {
                'light' => ThemeMode.light,
                'dark' => ThemeMode.dark,
                _ => ThemeMode.system,
              },

              // Routing
              routerConfig: _router,

              // Localization
              locale: Locale(settingsState.languageCode),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [Locale('en'), Locale('th')],
            );
          },
        ),
      ),
    );
  }
}
