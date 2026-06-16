import 'package:cross_file/cross_file.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/failures/profile_failure.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remote;

  const ProfileRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, String>> uploadProfileImage({
    required String uid,
    required XFile imageFile,
  }) async {
    try {
      final url = await _remote.uploadProfileImage(
        uid: uid,
        imageFile: imageFile,
      );
      return right(url);
    } on FirebaseException catch (e) {
      return left(ProfileFailure(_mapStorageError(e)));
    } catch (_) {
      return left(const ProfileFailure(ProfileErrorCode.unknown));
    }
  }

  @override
  Future<Either<Failure, Unit>> removeProfileImage({
    required String uid,
  }) async {
    try {
      await _remote.removeProfileImage(uid: uid);
      return right(unit);
    } on FirebaseException catch (e) {
      return left(ProfileFailure(_mapStorageError(e)));
    } catch (_) {
      return left(const ProfileFailure(ProfileErrorCode.unknown));
    }
  }

  ProfileErrorCode _mapStorageError(FirebaseException e) {
    switch (e.code) {
      case 'unauthorized':
      case 'permission-denied':
        return ProfileErrorCode.permissionDenied;
      case 'object-not-found':
        return ProfileErrorCode.notFound;
      case 'canceled':
        return ProfileErrorCode.canceled;
      case 'quota-exceeded':
        return ProfileErrorCode.quotaExceeded;
      case 'invalid-argument':
        return ProfileErrorCode.invalidImage;
      default:
        return ProfileErrorCode.unknown;
    }
  }
}
