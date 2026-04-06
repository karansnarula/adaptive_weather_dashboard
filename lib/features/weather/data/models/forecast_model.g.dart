// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForecastModel _$ForecastModelFromJson(Map<String, dynamic> json) =>
    ForecastModel(
      city: CityModel.fromJson(json['city'] as Map<String, dynamic>),
      list: (json['list'] as List<dynamic>)
          .map((e) => ForecastItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ForecastModelToJson(ForecastModel instance) =>
    <String, dynamic>{'city': instance.city, 'list': instance.list};

CityModel _$CityModelFromJson(Map<String, dynamic> json) =>
    CityModel(name: json['name'] as String);

Map<String, dynamic> _$CityModelToJson(CityModel instance) => <String, dynamic>{
  'name': instance.name,
};

ForecastItemModel _$ForecastItemModelFromJson(Map<String, dynamic> json) =>
    ForecastItemModel(
      main: MainModel.fromJson(json['main'] as Map<String, dynamic>),
      wind: WindModel.fromJson(json['wind'] as Map<String, dynamic>),
      weather: (json['weather'] as List<dynamic>)
          .map((e) => WeatherInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      dtTxt: json['dt_txt'] as String,
    );

Map<String, dynamic> _$ForecastItemModelToJson(ForecastItemModel instance) =>
    <String, dynamic>{
      'main': instance.main,
      'wind': instance.wind,
      'weather': instance.weather,
      'dt_txt': instance.dtTxt,
    };
