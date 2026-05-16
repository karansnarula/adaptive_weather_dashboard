import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

@injectable
class SignOut {
  final AuthRepository _repository;

  const SignOut(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.signOut();
  }
}