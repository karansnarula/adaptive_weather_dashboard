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
        constraints: const BoxConstraints(maxWidth: AppDimens.desktopMaxWidth),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.space3xl),
          child: Column(
            children: [
              const WelcomeHeader(),
              const SizedBox(height: AppDimens.space3xl),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: AppDimens.contentMaxWidthSm),
                child: const CitySearchBar(),
              ),
              const SizedBox(height: AppDimens.space3xl),
              CityTimeCard(weather: weather),
              const SizedBox(height: AppDimens.space3xl),
              const ShortcutBar(),
              const SizedBox(height: AppDimens.space3xl),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: WeatherCard(weather: weather),
                  ),
                  const SizedBox(width: AppDimens.space3xl),
                  Expanded(
                    flex: 3,
                    child: ForecastList(forecast: forecast),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.space3xl),
              WeatherMap(weather: weather),
            ],
          ),
        ),
      ),
    );
  }
}