import 'package:adaptive_weather_dashboard/core/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/entities/weather.dart';

class WeatherMap extends StatelessWidget {
  final Weather weather;

  const WeatherMap({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    final mapUrl = 'https://maps.googleapis.com/maps/api/staticmap'
        '?center=${weather.latitude},${weather.longitude}'
        '&zoom=12'
        '&size=600x300'
        '&scale=2'
        '&markers=color:red%7C${weather.latitude},${weather.longitude}'
        '&key=${AppConfig.instance.mapsApiKey}';

    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            mapUrl,
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stack) => SizedBox(
              height: 200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 48,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      context.l10n.mapUnavailable,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              '${weather.cityName} (${weather.latitude.toStringAsFixed(2)}, ${weather.longitude.toStringAsFixed(2)})',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}