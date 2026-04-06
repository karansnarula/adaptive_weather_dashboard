import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final String description;
  final String icon;

  const Weather({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.icon,
  });

  @override
  List<Object> get props => [
    cityName,
    temperature,
    feelsLike,
    humidity,
    windSpeed,
    description,
    icon,
  ];
}