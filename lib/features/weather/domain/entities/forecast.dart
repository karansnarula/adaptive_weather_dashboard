import 'package:equatable/equatable.dart';

import 'weather.dart';

class Forecast extends Equatable {
  final String cityName;
  final List<Weather> days;

  const Forecast({
    required this.cityName,
    required this.days,
  });

  @override
  List<Object> get props => [cityName, days];
}