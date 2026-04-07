import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_current_weather.dart';
import '../../domain/usecases/get_forecast.dart';
import 'weather_event.dart';
import 'weather_state.dart';

@injectable
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeather _getCurrentWeather;
  final GetForecast _getForecast;

  WeatherBloc(this._getCurrentWeather, this._getForecast)
      : super(const WeatherInitial()) {
    on<SearchCity>(_onSearchCity);
  }

  Future<void> _onSearchCity(
      SearchCity event,
      Emitter<WeatherState> emit,
      ) async {
    emit(const WeatherLoading());

    final weatherResult = await _getCurrentWeather(event.city);

    await weatherResult.fold(
          (failure) async => emit(WeatherError(failure.message)),
          (weather) async {
        final forecastResult = await _getForecast(event.city);

        forecastResult.fold(
              (failure) => emit(WeatherError(failure.message)),
              (forecast) => emit(WeatherLoaded(
            weather: weather,
            forecast: forecast,
          )),
        );
      },
    );
  }
}