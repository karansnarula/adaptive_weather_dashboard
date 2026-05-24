import 'package:flutter/material.dart';

import '../../domain/entities/weather.dart';
import '../../domain/entities/forecast.dart';
import '../widgets/city_search_bar.dart';
import '../widgets/city_time_card.dart';
import '../widgets/shortcut_bar.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_list.dart';
import '../widgets/weather_map.dart';
import '../widgets/welcome_header.dart';

class WeatherDesktop extends StatelessWidget {
  final Weather weather;
  final Forecast forecast;

  const WeatherDesktop({
    super.key,
    required this.weather,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              const WelcomeHeader(),
              const SizedBox(height: 32),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: const CitySearchBar(),
              ),
              const SizedBox(height: 32),
              CityTimeCard(weather: weather),
              const SizedBox(height: 32),
              const ShortcutBar(),
              const SizedBox(height: 32),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: WeatherCard(weather: weather),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    flex: 3,
                    child: ForecastList(forecast: forecast),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              WeatherMap(weather: weather),
            ],
          ),
        ),
      ),
    );
  }
}