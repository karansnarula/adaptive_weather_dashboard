import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/notification_city.dart';
import '../repositories/notification_repository.dart';

@injectable
class GetNotificationCity {
  final NotificationRepository _repository;

  const GetNotificationCity(this._repository);

  Future<Either<Failure, NotificationCity?>> call(String uid) {
    return _repository.getNotificationCity(uid);
  }
}