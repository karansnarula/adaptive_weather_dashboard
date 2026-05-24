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

class WeatherTablet extends StatelessWidget {
  final Weather weather;
  final Forecast forecast;

  const WeatherTablet({
    super.key,
    required this.weather,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const WelcomeHeader(),
          const SizedBox(height: 24),
          const CitySearchBar(),
          const SizedBox(height: 24),
          CityTimeCard(weather: weather),
          const SizedBox(height: 24),
          const ShortcutBar(),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: WeatherCard(weather: weather)),
              const SizedBox(width: 24),
              Expanded(child: ForecastList(forecast: forecast)),
            ],
          ),
          const SizedBox(height: 24),
          WeatherMap(weather: weather),
        ],
      ),
    );
  }
}