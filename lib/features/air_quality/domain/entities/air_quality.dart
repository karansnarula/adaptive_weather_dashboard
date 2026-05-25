class AirQuality {
  final int aqi;
  final double co;
  final double no2;
  final double o3;
  final double so2;
  final double pm25;
  final double pm10;

  const AirQuality({
    required this.aqi,
    required this.co,
    required this.no2,
    required this.o3,
    required this.so2,
    required this.pm25,
    required this.pm10,
  });

  String get aqiLabel => switch (aqi) {
    1 => 'Good',
    2 => 'Fair',
    3 => 'Moderate',
    4 => 'Poor',
    5 => 'Very Poor',
    _ => 'Unknown',
  };
}