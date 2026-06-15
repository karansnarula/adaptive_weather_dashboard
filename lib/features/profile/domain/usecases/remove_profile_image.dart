import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/profile_repository.dart';

@injectable
class RemoveProfileImage {
  final ProfileRepository _repository;

  const RemoveProfileImage(this._repository);

  Future<Either<Failure, Unit>> call({required String uid}) =>
      _repository.removeProfileImage(uid: uid);
}
