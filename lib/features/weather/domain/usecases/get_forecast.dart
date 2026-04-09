import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/forecast.dart';
import '../repositories/weather_repository.dart';

@injectable
class GetForecast {
  final WeatherRepository _repository;

  const GetForecast(this._repository);

  Future<Either<Failure, Forecast>> call(String city, {String units = 'metric'}) {
    return _repository.getForecast(city, units: units);
  }
}