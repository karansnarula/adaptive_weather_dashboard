import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/forecast.dart';
import '../../domain/entities/weather.dart';
import 'weather_model.dart';

part 'forecast_model.g.dart';

@JsonSerializable()
class ForecastModel {
  final CityModel city;
  final List<ForecastItemModel> list;

  const ForecastModel({
    required this.city,
    required this.list,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) =>
      _$ForecastModelFromJson(json);

  Map<String, dynamic> toJson() => _$ForecastModelToJson(this);

  Forecast toEntity() {
    // OpenWeatherMap returns 3-hour intervals
    // Group by day and take one entry per day
    final dailyMap = <String, ForecastItemModel>{};
    for (final item in list) {
      final date = item.dtTxt.split(' ').first;
      dailyMap.putIfAbsent(date, () => item);
    }

    return Forecast(
      cityName: city.name,
      days: dailyMap.values
          .take(5)
          .map((item) => Weather(
        cityName: city.name,
        temperature: item.main.temp,
        feelsLike: item.main.feelsLike,
        humidity: item.main.humidity,
        windSpeed: item.wind.speed,
        description: item.weather.first.description,
        icon: item.weather.first.icon,
      ))
          .toList(),
    );
  }
}

@JsonSerializable()
class CityModel {
  final String name;

  const CityModel({required this.name});

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);

  Map<String, dynamic> toJson() => _$CityModelToJson(this);
}

@JsonSerializable()
class ForecastItemModel {
  final MainModel main;
  final WindModel wind;
  final List<WeatherInfoModel> weather;
  @JsonKey(name: 'dt_txt')
  final String dtTxt;

  const ForecastItemModel({
    required this.main,
    required this.wind,
    required this.weather,
    required this.dtTxt,
  });

  factory ForecastItemModel.fromJson(Map<String, dynamic> json) =>
      _$ForecastItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ForecastItemModelToJson(this);
}