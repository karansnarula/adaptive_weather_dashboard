import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/notification_city.dart';

abstract class NotificationRepository {
  Future<Either<Failure, NotificationCity?>> getNotificationCity(String uid);
  Future<Either<Failure, void>> setNotificationCity(String uid, String cityName);
  Future<Either<Failure, void>> clearNotificationCity(String uid);
}