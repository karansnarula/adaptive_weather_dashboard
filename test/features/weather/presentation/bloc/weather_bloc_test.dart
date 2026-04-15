import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_weather_dashboard/core/error/failures.dart';
import 'package:adaptive_weather_dashboard/features/weather/domain/entities/weather.dart';
import 'package:adaptive_weather_dashboard/features/weather/domain/entities/forecast.dart';
import 'package:adaptive_weather_dashboard/features/weather/domain/usecases/get_current_weather.dart';
import 'package:adaptive_weather_dashboard/features/weather/domain/usecases/get_forecast.dart';
import 'package:adaptive_weather_dashboard/features/weather/presentation/bloc/weather_bloc.dart';
import 'package:adaptive_weather_dashboard/features/weather/presentation/bloc/weather_event.dart';
import 'package:adaptive_weather_dashboard/features/weather/presentation/bloc/weather_state.dart';

class MockGetCurrentWeather extends Mock implements GetCurrentWeather {}

class MockGetForecast extends Mock implements GetForecast {}

void main() {
  late WeatherBloc bloc;
  late MockGetCurrentWeather mockGetCurrentWeather;
  late MockGetForecast mockGetForecast;

  setUp(() {
    mockGetCurrentWeather = MockGetCurrentWeather();
    mockGetForecast = MockGetForecast();
    bloc = WeatherBloc(mockGetCurrentWeather, mockGetForecast);
  });

  tearDown(() {
    bloc.close();
  });

  const testWeather = Weather(
    cityName: 'Bangkok',
    temperature: 32.0,
    feelsLike: 36.0,
    humidity: 74,
    windSpeed: 3.6,
    description: 'clear sky',
    icon: '01d',
  );

  const testForecast = Forecast(
    cityName: 'Bangkok',
    days: [testWeather],
  );

  test('initial state should be WeatherInitial', () {
    expect(bloc.state, const WeatherInitial());
  });

  test('should emit [Loading, Loaded] when search succeeds', () {
    // Arrange
    when(() => mockGetCurrentWeather('Bangkok', units: 'metric'))
        .thenAnswer((_) async => const Right(testWeather));
    when(() => mockGetForecast('Bangkok', units: 'metric'))
        .thenAnswer((_) async => const Right(testForecast));

    // Assert later
    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<WeatherLoading>(),
        isA<WeatherLoaded>(),
      ]),
    );

    // Act
    bloc.add(const SearchCity('Bangkok'));
  });

  test('should emit [Loading, Error] when weather fetch fails', () {
    // Arrange
    when(() => mockGetCurrentWeather('InvalidCity', units: 'metric'))
        .thenAnswer((_) async => const Left(ServerFailure('City not found.')));

    // Assert later
    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<WeatherLoading>(),
        isA<WeatherError>(),
      ]),
    );

    // Act
    bloc.add(const SearchCity('InvalidCity'));
  });

  test('should emit [Loading, Error] when forecast fetch fails', () {
    // Arrange
    when(() => mockGetCurrentWeather('Bangkok', units: 'metric'))
        .thenAnswer((_) async => const Right(testWeather));
    when(() => mockGetForecast('Bangkok', units: 'metric'))
        .thenAnswer((_) async => const Left(ServerFailure()));

    // Assert later
    expectLater(
      bloc.stream,
      emitsInOrder([
        isA<WeatherLoading>(),
        isA<WeatherError>(),
      ]),
    );

    // Act
    bloc.add(const SearchCity('Bangkok'));
  });
}