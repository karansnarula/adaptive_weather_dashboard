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
      padding: const EdgeInsets.all(AppDimens.space2xl),
      child: Column(
        children: [
          const WelcomeHeader(),
          const SizedBox(height: AppDimens.space2xl),
          const CitySearchBar(),
          const SizedBox(height: AppDimens.space2xl),
          CityTimeCard(weather: weather),
          const SizedBox(height: AppDimens.space2xl),
          const ShortcutBar(),
          const SizedBox(height: AppDimens.space2xl),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: WeatherCard(weather: weather)),
              const SizedBox(width: AppDimens.space2xl),
              Expanded(child: ForecastList(forecast: forecast)),
            ],
          ),
          const SizedBox(height: AppDimens.space2xl),
          WeatherMap(weather: weather),
        ],
      ),
    );
  }
}