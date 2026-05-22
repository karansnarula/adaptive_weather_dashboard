import 'package:adaptive_weather_dashboard/core/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/weather.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../favorites/presentation/bloc/favorites_bloc.dart';
import '../../../favorites/presentation/bloc/favorites_event.dart';
import '../../../favorites/presentation/bloc/favorites_state.dart';
import '../../../notifications/presentation/bloc/notification_bloc.dart';
import '../../../notifications/presentation/bloc/notification_event.dart';
import '../../../notifications/presentation/bloc/notification_state.dart';

class WeatherCard extends StatelessWidget {
  final Weather weather;

  const WeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 5,
          bottom: 24,
          right: 10,
          left: 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BlocBuilder<FavoritesBloc, FavoritesState>(
                  builder: (context, state) {
                    final isFavorite =
                        state is FavoritesLoaded &&
                        state.favorites.any((f) => f.name == weather.cityName);

                    return IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite
                            ? Theme.of(context).colorScheme.error
                            : null,
                      ),
                      onPressed: () {
                        if (isFavorite) {
                          context.read<FavoritesBloc>().add(
                            RemoveFavoriteCity(weather.cityName),
                          );
                        } else {
                          context.read<FavoritesBloc>().add(
                            AddFavoriteCity(weather.cityName),
                          );
                        }
                      },
                    );
                  },
                ),
                BlocBuilder<NotificationBloc, NotificationState>(
                  builder: (context, state) {
                    final isNotificationCity =
                        state is NotificationLoaded &&
                        state.city?.cityName == weather.cityName;

                    return IconButton(
                      icon: Icon(
                        isNotificationCity
                            ? Icons.notifications_active
                            : Icons.notifications_none,
                        color: isNotificationCity
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      onPressed: () {
                        final authState = context.read<AuthBloc>().state;
                        if (authState is! Authenticated) return;

                        final uid = authState.user.uid;

                        if (isNotificationCity) {
                          context.read<NotificationBloc>().add(
                            ClearNotificationCityEvent(uid),
                          );
                        } else {
                          context.read<NotificationBloc>().add(
                            SetNotificationCityEvent(
                              uid: uid,
                              cityName: weather.cityName,
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              weather.cityName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Image.network(
              'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
              width: 100,
              height: 100,
              errorBuilder: (context, error, stack) =>
                  const Icon(Icons.cloud, size: 100),
            ),
            Text(
              '${weather.temperature.round()}°',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              weather.description,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _InfoTile(
                  icon: Icons.thermostat,
                  label: context.l10n.feelsLikeLabel,
                  value: '${weather.feelsLike.round()}°',
                ),
                _InfoTile(
                  icon: Icons.water_drop,
                  label: context.l10n.humidity,
                  value: '${weather.humidity}%',
                ),
                _InfoTile(
                  icon: Icons.air,
                  label: context.l10n.windSpeed,
                  value: '${weather.windSpeed} m/s',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
