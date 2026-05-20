import 'package:equatable/equatable.dart';

class NotificationCity extends Equatable {
  final String cityName;
  final String uid;

  const NotificationCity({
    required this.cityName,
    required this.uid,
  });

  @override
  List<Object> get props => [cityName, uid];
}