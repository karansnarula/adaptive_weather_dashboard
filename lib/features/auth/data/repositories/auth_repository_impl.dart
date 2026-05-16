import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/auth_failures.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  const AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, AppUser>> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final result = await _remoteDataSource.signUp(
        email: email,
        password: password,
        displayName: displayName,
      );
      return right(result.toEntity());
    } on FirebaseAuthException catch (e) {
      return left(AuthFailure(
        code: e.code,
        message: e.message ?? 'An unexpected error occurred.',
      ));
    } catch (e) {
      return left(const ServerFailure());
    }
  }

  @override
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );
      return right(result.toEntity());
    } on FirebaseAuthException catch (e) {
      return left(AuthFailure(
        code: e.code,
        message: e.message ?? 'An unexpected error occurred.',
      ));
    } catch (e) {
      return left(const ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return right(null);
    } catch (e) {
      return left(const ServerFailure('Failed to sign out.'));
    }
  }

  @override
  Stream<AppUser?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map(
          (model) => model?.toEntity(),
    );
  }
}