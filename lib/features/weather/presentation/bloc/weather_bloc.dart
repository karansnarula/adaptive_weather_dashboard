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
  String _lastCity = '';

  WeatherBloc(this._getCurrentWeather, this._getForecast)
      : super(const WeatherInitial()) {
    on<SearchCity>(_onSearchCity);
    on<RefreshWeather>(_onRefreshWeather);
  }

  Future<void> _onSearchCity(
      SearchCity event,
      Emitter<WeatherState> emit,
      ) async {
    _lastCity = event.city;
    emit(const WeatherLoading());

    final weatherResult = await _getCurrentWeather(event.city, units: event.units);

    await weatherResult.fold(
          (failure) async => emit(WeatherError(failure.message)),
          (weather) async {
        final forecastResult = await _getForecast(event.city, units: event.units);

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

  Future<void> _onRefreshWeather(
      RefreshWeather event,
      Emitter<WeatherState> emit,
      ) async {
    if (_lastCity.isNotEmpty) {
      add(SearchCity(_lastCity, units: event.units));
    }
  }
}