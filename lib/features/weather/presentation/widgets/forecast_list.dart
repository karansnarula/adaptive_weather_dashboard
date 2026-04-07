import 'package:flutter/material.dart';

import '../../domain/entities/forecast.dart';

class ForecastList extends StatelessWidget {
  final Forecast forecast;

  const ForecastList({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '5-Day Forecast',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...forecast.days.map((day) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Image.network(
                    'https://openweathermap.org/img/wn/${day.icon}@2x.png',
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stack) =>
                    const Icon(Icons.cloud, size: 40),
                  ),
                  const SizedBox(width: 12),
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