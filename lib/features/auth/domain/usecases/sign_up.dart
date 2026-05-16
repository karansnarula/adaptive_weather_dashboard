import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

@injectable
class SignUp {
  final AuthRepository _repository;

  const SignUp(this._repository);

  Future<Either<Failure, AppUser>> call({
    required String email,
    required String password,
    String? displayName,
  }) {
    return _repository.signUp(
      email: email,
      password: password,
      displayName: displayName,
    );
  }
}