import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/notification_repository.dart';

@injectable
class ClearNotificationCity {
  final NotificationRepository _repository;

  const ClearNotificationCity(this._repository);

  Future<Either<Failure, void>> call(String uid) {
    return _repository.clearNotificationCity(uid);
  }
}