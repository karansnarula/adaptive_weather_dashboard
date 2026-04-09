import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../weather/presentation/bloc/weather_bloc.dart';
import '../../../weather/presentation/bloc/weather_event.dart';
import '../bloc/settings_bloc.dart';
import '../bloc/settings_event.dart';
import '../bloc/settings_state.dart';

class UnitSelector extends StatelessWidget {
  const UnitSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Temperature Unit',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  title: Text(state.isCelsius ? 'Celsius (°C)' : 'Fahrenheit (°F)'),
                  subtitle: Text(
                    state.isCelsius
                        ? 'Switch to Fahrenheit'
                        : 'Switch to Celsius',
                  ),
                  value: state.isCelsius,
                  onChanged: (value) {
                    context.read<SettingsBloc>().add(ChangeUnit(value));
                    final units = value ? 'metric' : 'imperial';
                    context.read<WeatherBloc>().add(RefreshWeather(units: units));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}