import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../di/injection.dart';
import '../../features/air_quality/presentation/pages/air_quality_page.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/chatbot/presentation/pages/chatbot_page.dart';
import '../../features/discussion/presentation/bloc/feed/feed_bloc.dart';
import '../../features/discussion/presentation/bloc/feed/feed_event.dart';
import '../../features/discussion/presentation/pages/discussion_detail_page.dart';
import '../../features/discussion/presentation/pages/discussion_feed_page.dart';
import '../../features/news/presentation/pages/news_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../features/weather/presentation/pages/weather_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../layout/adaptive_scaffold.dart';
import '../l10n/l10n_extension.dart';

abstract class AppRouter {
  static GoRouter router(AuthBloc authBloc) => GoRouter(
    initialLocation: '/splash',
    refreshListenable: _GoRouterAuthNotifier(authBloc),
    /// "redirect" runs on every navigation. It checks if the user is authenticated.
    /// If not authenticated and trying to access a protected page → redirect to /login.
    /// If authenticated and on login/register → redirect to /weather. Otherwise → let them through.
    redirect: (context, state) {
      // The splash route handles its own navigation (auth-aware) once
      // it finishes animating and playing its sound. Bypass the redirect
      // so it isn't kicked off-route immediately.
      if (state.matchedLocation == '/splash') return null;

      final isAuthenticated = authBloc.state is Authenticated;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      if (!isAuthenticated && !isAuthRoute) {
        return '/login';
      }

      if (isAuthenticated && isAuthRoute) {
        return '/weather';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/air-quality/:city',
        builder: (context, state) {
          final city = state.pathParameters['city'] ?? '';
          final lat = double.tryParse(state.uri.queryParameters['lat'] ?? '') ?? 0;
          final lon = double.tryParse(state.uri.queryParameters['lon'] ?? '') ?? 0;
          return AirQualityPage(
            cityName: city,
            latitude: lat,
            longitude: lon,
          );
        },
      ),
      GoRoute(
        path: '/chatbot',
        builder: (context, state) {
          final city = state.uri.queryParameters['city'];
          final trimmed = (city == null || city.trim().isEmpty) ? null : city;
          return ChatbotPage(city: trimmed);
        },
      ),
      GoRoute(
        path: '/news/:city',
        builder: (context, state) {
          final city = state.pathParameters['city'] ?? '';
          return NewsPage(cityName: city);
        },
      ),
      // /discussion + /discussion/:postId share a single FeedBloc instance
      // via this ShellRoute. The detail page can patch the feed directly
      // (via UI-layer BlocListeners) instead of needing a refresh-on-pop
      // workaround.
      ShellRoute(
        builder: (context, state, child) {
          return BlocProvider<FeedBloc>(
            create: (_) => getIt<FeedBloc>()..add(const LoadFeed()),
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/discussion',
            builder: (context, state) {
              final city = state.uri.queryParameters['city'];
              final trimmed =
                  (city == null || city.trim().isEmpty) ? null : city;
              return DiscussionFeedPage(city: trimmed);
            },
            routes: [
              GoRoute(
                path: ':postId',
                builder: (context, state) {
                  final postId = state.pathParameters['postId'] ?? '';
                  return DiscussionDetailPage(postId: postId);
                },
              ),
            ],
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => AdaptiveScaffold(
          currentIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.cloud_outlined),
              selectedIcon: const Icon(Icons.cloud),
              label: context.l10n.navWeather,
            ),
            NavigationDestination(
              icon: const Icon(Icons.favorite_outline),
              selectedIcon: const Icon(Icons.favorite),
              label: context.l10n.navFavorites,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              selectedIcon: const Icon(Icons.settings),
              label: context.l10n.navSettings,
            ),
          ],
          body: navigationShell,
        ),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/weather',
                builder: (context, state) => const WeatherPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favorites',
                builder: (context, state) => const FavoritesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _GoRouterAuthNotifier extends ChangeNotifier {
  _GoRouterAuthNotifier(AuthBloc authBloc) {
    authBloc.stream.listen((_) {
      notifyListeners();
    });
  }
}