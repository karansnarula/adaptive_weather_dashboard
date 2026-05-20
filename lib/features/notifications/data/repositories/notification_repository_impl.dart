import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/notification_city.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

@LazySingleton(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  const NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, NotificationCity?>> getNotificationCity(String uid) async {
    try {
      final cityName = await _remoteDataSource.getNotificationCity(uid);
      if (cityName == null) return right(null);
      return right(NotificationCity(cityName: cityName, uid: uid));
    } catch (e) {
      return left(const ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> setNotificationCity(String uid, String cityName) async {
    try {
      await _remoteDataSource.setNotificationCity(uid, cityName);
      return right(null);
    } catch (e) {
      return left(const ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> clearNotificationCity(String uid) async {
    try {
      await _remoteDataSource.clearNotificationCity(uid);
      return right(null);
    } catch (e) {
      return left(const ServerFailure());
    }
  }
}