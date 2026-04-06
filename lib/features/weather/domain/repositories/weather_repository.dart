import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/weather.dart';
import '../entities/forecast.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Weather>> getCurrentWeather(String city);
  Future<Either<Failure, Forecast>> getForecast(String city);
}