// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherModel _$WeatherModelFromJson(Map<String, dynamic> json) => WeatherModel(
  name: json['name'] as String,
  main: MainModel.fromJson(json['main'] as Map<String, dynamic>),
  wind: WindModel.fromJson(json['wind'] as Map<String, dynamic>),
  weather: (json['weather'] as List<dynamic>)
      .map((e) => WeatherInfoModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  coord: CoordModel.fromJson(json['coord'] as Map<String, dynamic>),
  timezone: (json['timezone'] as num).toInt(),
);

Map<String, dynamic> _$WeatherModelToJson(WeatherModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'main': instance.main,
      'wind': instance.wind,
      'weather': instance.weather,
      'coord': instance.coord,
      'timezone': instance.timezone,
    };

CoordModel _$CoordModelFromJson(Map<String, dynamic> json) => CoordModel(
  lat: (json['lat'] as num).toDouble(),
  lon: (json['lon'] as num).toDouble(),
);

Map<String, dynamic> _$CoordModelToJson(CoordModel instance) =>
    <String, dynamic>{'lat': instance.lat, 'lon': instance.lon};

MainModel _$MainModelFromJson(Map<String, dynamic> json) => MainModel(
  temp: (json['temp'] as num).toDouble(),
  feelsLike: (json['feels_like'] as num).toDouble(),
  humidity: (json['humidity'] as num).toInt(),
);

Map<String, dynamic> _$MainModelToJson(MainModel instance) => <String, dynamic>{
  'temp': instance.temp,
  'feels_like': instance.feelsLike,
  'humidity': instance.humidity,
};

WindModel _$WindModelFromJson(Map<String, dynamic> json) =>
    WindModel(speed: (json['speed'] as num).toDouble());

Map<String, dynamic> _$WindModelToJson(WindModel instance) => <String, dynamic>{
  'speed': instance.speed,
};

WeatherInfoModel _$WeatherInfoModelFromJson(Map<String, dynamic> json) =>
    WeatherInfoModel(
      description: json['description'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$WeatherInfoModelToJson(WeatherInfoModel instance) =>
    <String, dynamic>{
      'description': instance.description,
      'icon': instance.icon,
    };
