import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AppUser>> signUp({
    required String email,
    required String password,
    String? displayName,
  });

  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signOut();

  Stream<AppUser?> get authStateChanges;

  /// Forces a server reload of the current user and returns the
  /// refreshed entity, or `null` if no user is signed in. Used after
  /// profile mutations to make sure the avatar reflects the change.
  Future<AppUser?> refreshCurrentUser();
}