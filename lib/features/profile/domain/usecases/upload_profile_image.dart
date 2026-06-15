import 'package:cross_file/cross_file.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/profile_repository.dart';

@injectable
class UploadProfileImage {
  final ProfileRepository _repository;

  const UploadProfileImage(this._repository);

  Future<Either<Failure, String>> call({
    required String uid,
    required XFile imageFile,
  }) =>
      _repository.uploadProfileImage(uid: uid, imageFile: imageFile);
}
