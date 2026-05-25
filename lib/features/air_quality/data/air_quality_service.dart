import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../core/constants/api_constants.dart';
import '../domain/entities/air_quality.dart';

@lazySingleton
class AirQualityService {
  final Dio _dio;

  const AirQualityService(this._dio);

  Future<AirQuality> getAirQuality(double lat, double lon) async {
    final response = await _dio.get(
      ApiConstants.airPollution,
      queryParameters: {
        'lat': lat,
        'lon': lon,
      },
    );

    final data = response.data;
    final components = data['list'][0]['components'];
    final aqi = data['list'][0]['main']['aqi'] as int;

    return AirQuality(
      aqi: aqi,
      co: (components['co'] as num).toDouble(),
      no2: (components['no2'] as num).toDouble(),
      o3: (components['o3'] as num).toDouble(),
      so2: (components['so2'] as num).toDouble(),
      pm25: (components['pm2_5'] as num).toDouble(),
      pm10: (components['pm10'] as num).toDouble(),
    );
  }
}