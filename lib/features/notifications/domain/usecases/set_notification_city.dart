import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/notification_repository.dart';

@injectable
class SetNotificationCity {
  final NotificationRepository _repository;

  const SetNotificationCity(this._repository);

  Future<Either<Failure, void>> call(String uid, String cityName) {
    return _repository.setNotificationCity(uid, cityName);
  }
}