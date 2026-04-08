import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/responsive_builder.dart';
import '../../../weather/presentation/bloc/weather_bloc.dart';
import '../../../weather/presentation/bloc/weather_event.dart';
import '../bloc/favorites_bloc.dart';
import '../bloc/favorites_event.dart';
import '../bloc/favorites_state.dart';
import '../layouts/favorites_mobile.dart';
import '../layouts/favorites_tablet.dart';
import '../layouts/favorites_desktop.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          return switch (state) {
            FavoritesInitial() => const SizedBox.shrink(),
            FavoritesLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            FavoritesLoaded(:final favorites) => favorites.isEmpty
                ? _buildEmpty(context)
                : ResponsiveBuilder(
              mobile: (context) => FavoritesMobile(
                favorites: favorites,
                onCityTap: (city) => _onCityTap(context, city),
                onRemove: (city) => _onRemove(context, city),
              ),
              tablet: (context) => FavoritesTablet(
                favorites: favorites,
                onCityTap: (city) => _onCityTap(context, city),
                onRemove: (city) => _onRemove(context, city),
              ),
              desktop: (context) => FavoritesDesktop(
                favorites: favorites,
                onCityTap: (city) => _onCityTap(context, city),
                onRemove: (city) => _onRemove(context, city),
              ),
            ),
            FavoritesError(:final message) => Center(
              child: Text(message),
            ),
          };
        },
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            size: 80,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No favorite cities yet',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Search for a city and tap the heart to save it',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _onCityTap(BuildContext context, String city) {
    context.read<WeatherBloc>().add(SearchCity(city));
    context.go('/weather');
  }

  void _onRemove(BuildContext context, String city) {
    context.read<FavoritesBloc>().add(RemoveFavoriteCity(city));
  }
}