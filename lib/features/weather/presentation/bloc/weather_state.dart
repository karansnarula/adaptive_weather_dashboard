import 'package:equatable/equatable.dart';

import '../../domain/entities/weather.dart';
import '../../domain/entities/forecast.dart';

sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  final Forecast forecast;

  const WeatherLoaded({
    required this.weather,
    required this.forecast,
  });

  @override
  List<Object> get props => [weather, forecast];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object> get props => [message];
}