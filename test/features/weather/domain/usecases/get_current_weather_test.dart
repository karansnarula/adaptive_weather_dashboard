import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_weather_dashboard/core/error/failures.dart';
import 'package:adaptive_weather_dashboard/features/weather/domain/entities/weather.dart';
import 'package:adaptive_weather_dashboard/features/weather/domain/repositories/weather_repository.dart';
import 'package:adaptive_weather_dashboard/features/weather/domain/usecases/get_current_weather.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main() {
  late GetCurrentWeather useCase;
  late MockWeatherRepository mockRepository;

  setUp(() {
    mockRepository = MockWeatherRepository();
    useCase = GetCurrentWeather(mockRepository);
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

  test('should return Weather from repository on success', () async {
    // Arrange
    when(() => mockRepository.getCurrentWeather('Bangkok'))
        .thenAnswer((_) async => const Right(testWeather));

    // Act
    final result = await useCase('Bangkok');

    // Assert
    expect(result, const Right(testWeather));
    verify(() => mockRepository.getCurrentWeather('Bangkok')).called(1);
  });

  test('should return Failure from repository on error', () async {
    // Arrange
    when(() => mockRepository.getCurrentWeather('InvalidCity'))
        .thenAnswer((_) async => const Left(ServerFailure('City not found.')));

    // Act
    final result = await useCase('InvalidCity');

    // Assert
    expect(result, const Left(ServerFailure('City not found.')));
    verify(() => mockRepository.getCurrentWeather('InvalidCity')).called(1);
  });
}