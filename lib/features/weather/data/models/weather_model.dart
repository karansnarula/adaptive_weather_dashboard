import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/weather.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class WeatherModel {
  final String name;
  final MainModel main;
  final WindModel wind;
  final List<WeatherInfoModel> weather;

  const WeatherModel({
    required this.name,
    required this.main,
    required this.wind,
    required this.weather,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);

  Weather toEntity() => Weather(
    cityName: name,
    temperature: main.temp,
    feelsLike: main.feelsLike,
    humidity: main.humidity,
    windSpeed: wind.speed,
    description: weather.first.description,
    icon: weather.first.icon,
  );
}

@JsonSerializable()
class MainModel {
  final double temp;
  @JsonKey(name: 'feels_like')
  final double feelsLike;
  final int humidity;

  const MainModel({
    required this.temp,
    required this.feelsLike,
    required this.humidity,
  });

  factory MainModel.fromJson(Map<String, dynamic> json) =>
      _$MainModelFromJson(json);

  Map<String, dynamic> toJson() => _$MainModelToJson(this);
}

@JsonSerializable()
class WindModel {
  final double speed;

  const WindModel({required this.speed});

  factory WindModel.fromJson(Map<String, dynamic> json) =>
      _$WindModelFromJson(json);

  Map<String, dynamic> toJson() => _$WindModelToJson(this);
}

@JsonSerializable()
class WeatherInfoModel {
  final String description;
  final String icon;

  const WeatherInfoModel({
    required this.description,
    required this.icon,
  });

  factory WeatherInfoModel.fromJson(Map<String, dynamic> json) =>
      _$WeatherInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherInfoModelToJson(this);
}