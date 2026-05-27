import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/constants/api_constants.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';

part 'weather_remote_data_source.g.dart';

@RestApi()
@lazySingleton
abstract class WeatherRemoteDataSource {
  @factoryMethod
  factory WeatherRemoteDataSource(@Named('weatherDio') Dio dio) =
      _WeatherRemoteDataSource;

  @GET(ApiConstants.currentWeather)
  Future<WeatherModel> getCurrentWeather(
      @Query('q') String city,
      @Query('units') String units,
      );

  @GET(ApiConstants.forecast)
  Future<ForecastModel> getForecast(
      @Query('q') String city,
      @Query('units') String units,
      );
}