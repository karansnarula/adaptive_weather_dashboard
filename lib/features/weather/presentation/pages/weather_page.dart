import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/responsive/responsive_builder.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_state.dart';
import '../layouts/weather_mobile.dart';
import '../layouts/weather_tablet.dart';
import '../layouts/weather_desktop.dart';
import '../widgets/city_search_bar.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather'),
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          return switch (state) {
            WeatherInitial() => _buildInitial(context),
            WeatherLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            WeatherLoaded(:final weather, :final forecast) =>
                ResponsiveBuilder(
                  mobile: (context) => WeatherMobile(
                    weather: weather,
                    forecast: forecast,
                  ),
                  tablet: (context) => WeatherTablet(
                    weather: weather,
                    forecast: forecast,
                  ),
                  desktop: (context) => WeatherDesktop(
                    weather: weather,
                    forecast: forecast,
                  ),
                ),
            WeatherError(:final message) => _buildError(context, message),
          };
        },
      ),
    );
  }

  Widget _buildInitial(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_outlined,
              size: 100,
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Search for a city to see the weather',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: const CitySearchBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: const CitySearchBar(),
            ),
          ],
        ),
      ),
    );
  }
}