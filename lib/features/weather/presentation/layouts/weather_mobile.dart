import 'package:flutter/material.dart';

import '../../domain/entities/weather.dart';
import '../../domain/entities/forecast.dart';
import '../widgets/city_search_bar.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_list.dart';

class WeatherMobile extends StatelessWidget {
  final Weather weather;
  final Forecast forecast;

  const WeatherMobile({
    super.key,
    required this.weather,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CitySearchBar(),
          const SizedBox(height: 16),
          WeatherCard(weather: weather),
          const SizedBox(height: 16),
          ForecastList(forecast: forecast),
        ],
      ),
    );
  }
}