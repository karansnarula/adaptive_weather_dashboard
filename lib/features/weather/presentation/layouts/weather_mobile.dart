import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../domain/entities/weather.dart';
import '../../domain/entities/forecast.dart';
import '../widgets/city_search_bar.dart';
import '../widgets/city_time_card.dart';
import '../widgets/shortcut_bar.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_list.dart';
import '../widgets/weather_map.dart';
import '../widgets/welcome_header.dart';

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
      padding: const EdgeInsets.all(AppDimens.spaceLg),
      child: Column(
        children: [
          const WelcomeHeader(),
          const SizedBox(height: AppDimens.spaceLg),
          const CitySearchBar(),
          const SizedBox(height: AppDimens.spaceLg),
          CityTimeCard(weather: weather),
          const SizedBox(height: AppDimens.spaceLg),
          const ShortcutBar(),
          const SizedBox(height: AppDimens.spaceLg),
          WeatherCard(weather: weather),
          const SizedBox(height: AppDimens.spaceLg),
          ForecastList(forecast: forecast),
          const SizedBox(height: AppDimens.spaceLg),
          WeatherMap(weather: weather),
        ],
      ),
    );
  }
}