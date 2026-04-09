import 'package:equatable/equatable.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class SearchCity extends WeatherEvent {
  final String city;
  final String units;

  const SearchCity(this.city, {this.units = 'metric'});

  @override
  List<Object> get props => [city, units];
}

class RefreshWeather extends WeatherEvent {
  final String units;

  const RefreshWeather({this.units = 'metric'});

  @override
  List<Object> get props => [units];
}