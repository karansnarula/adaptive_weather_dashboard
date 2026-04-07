import 'package:equatable/equatable.dart';

sealed class WeatherEvent extends Equatable {
  const WeatherEvent();

  @override
  List<Object> get props => [];
}

class SearchCity extends WeatherEvent {
  final String city;

  const SearchCity(this.city);

  @override
  List<Object> get props => [city];
}