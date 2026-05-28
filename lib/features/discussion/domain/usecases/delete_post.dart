import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/discussion_repository.dart';

@injectable
class DeletePost {
  final DiscussionRepository _repository;

  const DeletePost(this._repository);

  Future<Either<Failure, Unit>> call(String postId) =>
      _repository.deletePost(postId);
}
