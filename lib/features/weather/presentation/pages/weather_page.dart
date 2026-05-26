import 'package:adaptive_weather_dashboard/core/l10n/l10n_extension.dart';
import 'package:adaptive_weather_dashboard/features/weather/presentation/widgets/shortcut_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/responsive/responsive_builder.dart';
import '../../../../core/constants/app_dimens.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_state.dart';
import '../layouts/weather_mobile.dart';
import '../layouts/weather_tablet.dart';
import '../layouts/weather_desktop.dart';
import '../widgets/city_search_bar.dart';
import '../widgets/welcome_header.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.navWeather)),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          return switch (state) {
            WeatherInitial() => _buildInitial(context),
            WeatherLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            WeatherLoaded(:final weather, :final forecast) =>
                ResponsiveBuilder(
                  mobile: (context) =>
                      WeatherMobile(weather: weather, forecast: forecast),
                  tablet: (context) =>
                      WeatherTablet(weather: weather, forecast: forecast),
                  desktop: (context) =>
                      WeatherDesktop(weather: weather, forecast: forecast),
                ),
            WeatherError(:final message) => _buildError(context, message),
          };
        },
      ),
    );
  }

  Widget _buildInitial(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.space2xl),
      child: Column(
        children: [
          const WelcomeHeader(),
          const SizedBox(height: AppDimens.space7xl),
          Icon(
            Icons.cloud_outlined,
            size: AppDimens.imageHeightSm,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppDimens.space2xl),
          Text(
            context.l10n.searchPrompt,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppDimens.space2xl),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppDimens.formMaxWidth),
            child: const CitySearchBar(),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          const ShortcutBar(),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimens.space2xl),
      child: Column(
        children: [
          const WelcomeHeader(),
          const SizedBox(height: AppDimens.space7xl),
          Icon(
            Icons.error_outline,
            size: AppDimens.iconLogo,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: AppDimens.spaceLg),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimens.space2xl),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: AppDimens.formMaxWidth),
            child: const CitySearchBar(),
          ),
          const SizedBox(height: AppDimens.spaceLg),
          const ShortcutBar(),
        ],
      ),
    );
  }
}