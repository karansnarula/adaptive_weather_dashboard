import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/weather.dart';
import '../../domain/entities/forecast.dart';
import '../../domain/repositories/weather_repository.dart';
import '../datasources/weather_remote_data_source.dart';

@LazySingleton(as: WeatherRepository)
class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDataSource _remoteDataSource;

  const WeatherRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, Weather>> getCurrentWeather(String city, {String units = 'metric'}) async {
    try {
      final result = await _remoteDataSource.getCurrentWeather(city, units);
      return right(result.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return left(const ServerFailure('City not found.'));
      }
      return left(const ServerFailure());
    } catch (e) {
      return left(const ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Forecast>> getForecast(String city, {String units = 'metric'}) async {
    try {
      final result = await _remoteDataSource.getForecast(city, units);
      return right(result.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return left(const ServerFailure('City not found.'));
      }
      return left(const ServerFailure());
    } catch (e) {
      return left(const ServerFailure());
    }
  }
}