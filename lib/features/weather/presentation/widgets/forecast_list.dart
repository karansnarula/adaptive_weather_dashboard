import 'package:adaptive_weather_dashboard/core/l10n/l10n_extension.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../domain/entities/forecast.dart';

class ForecastList extends StatelessWidget {
  final Forecast forecast;

  const ForecastList({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.l10n.fiveDayForecast,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimens.spaceMd),
            ...forecast.days.map((day) => Padding(
              padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceSm),
              child: Row(
                children: [
                  Image.network(
                    'https://openweathermap.org/img/wn/${day.icon}@2x.png',
                    width: AppDimens.avatarMd,
                    height: AppDimens.avatarMd,
                    errorBuilder: (context, error, stack) =>
                    const Icon(Icons.cloud, size: AppDimens.avatarMd),
                  ),
                  const SizedBox(width: AppDimens.spaceMd),
                  Expanded(
                    child: Text(
                      day.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Text(
                    '${day.temperature.round()}°',
                    style:
                    Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}