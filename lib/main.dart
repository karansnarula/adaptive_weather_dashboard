import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_ce_flutter/adapters.dart';

import 'core/config/app_config.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/l10n/app_localizations.dart';
import 'features/favorites/presentation/bloc/favorites_bloc.dart';
import 'features/favorites/presentation/bloc/favorites_event.dart';
import 'di/injection.dart';
import 'features/weather/presentation/bloc/weather_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppConfig.initialize();

  await Hive.initFlutter();

  await configureDependencies();

  runApp(const WeatherDashboardApp());
}

class WeatherDashboardApp extends StatelessWidget {
  const WeatherDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
          getIt<WeatherBloc>(),
        ),
        BlocProvider(
          create: (context) =>
              getIt<FavoritesBloc>()..add(const LoadFavorites()),
        ),
      ],
      child: MaterialApp.router(
        title: AppConfig.instance.appName,
        debugShowCheckedModeBanner: false,

        // Theme
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,

        // Routing
        routerConfig: AppRouter.router,

        // Localization
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('th')],
      ),
    );
  }
}
