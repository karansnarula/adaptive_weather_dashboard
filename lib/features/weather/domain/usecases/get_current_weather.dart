import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/weather.dart';
import '../repositories/weather_repository.dart';

@injectable
class GetCurrentWeather {
  final WeatherRepository _repository;

  const GetCurrentWeather(this._repository);

  Future<Either<Failure, Weather>> call(String city, {String units = 'metric'}) {
    return _repository.getCurrentWeather(city, units: units);
  }
}