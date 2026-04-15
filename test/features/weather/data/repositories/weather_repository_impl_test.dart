import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_weather_dashboard/core/error/failures.dart';
import 'package:adaptive_weather_dashboard/features/weather/data/datasources/weather_remote_data_source.dart';
import 'package:adaptive_weather_dashboard/features/weather/data/models/weather_model.dart';
import 'package:adaptive_weather_dashboard/features/weather/data/repositories/weather_repository_impl.dart';
import 'package:adaptive_weather_dashboard/features/weather/domain/entities/weather.dart';

class MockWeatherRemoteDataSource extends Mock
    implements WeatherRemoteDataSource {}

void main() {
  late WeatherRepositoryImpl repository;
  late MockWeatherRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockWeatherRemoteDataSource();
    repository = WeatherRepositoryImpl(mockDataSource);
  });

  const testWeatherModel = WeatherModel(
    name: 'Bangkok',
    main: MainModel(temp: 32.0, feelsLike: 36.0, humidity: 74),
    wind: WindModel(speed: 3.6),
    weather: [WeatherInfoModel(description: 'clear sky', icon: '01d')],
  );

  const testWeatherEntity = Weather(
    cityName: 'Bangkok',
    temperature: 32.0,
    feelsLike: 36.0,
    humidity: 74,
    windSpeed: 3.6,
    description: 'clear sky',
    icon: '01d',
  );

  group('getCurrentWeather', () {
    test('should return Weather entity when data source succeeds', () async {
      // Arrange
      when(() => mockDataSource.getCurrentWeather('Bangkok', 'metric'))
          .thenAnswer((_) async => testWeatherModel);

      // Act
      final result = await repository.getCurrentWeather('Bangkok');

      // Assert
      expect(result, const Right(testWeatherEntity));
      verify(() => mockDataSource.getCurrentWeather('Bangkok', 'metric'))
          .called(1);
    });

    test('should return ServerFailure when city not found', () async {
      // Arrange
      when(() => mockDataSource.getCurrentWeather('InvalidCity', 'metric'))
          .thenThrow(DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 404,
        ),
      ));

      // Act
      final result = await repository.getCurrentWeather('InvalidCity');

      // Assert
      expect(result, const Left(ServerFailure('City not found.')));
    });

    test('should return ServerFailure when unexpected error occurs', () async {
      // Arrange
      when(() => mockDataSource.getCurrentWeather('Bangkok', 'metric'))
          .thenThrow(Exception('unexpected'));

      // Act
      final result = await repository.getCurrentWeather('Bangkok');

      // Assert
      expect(result, const Left(ServerFailure()));
    });
  });
}