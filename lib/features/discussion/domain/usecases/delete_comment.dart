import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../repositories/discussion_repository.dart';

@injectable
class DeleteComment {
  final DiscussionRepository _repository;

  const DeleteComment(this._repository);

  Future<Either<Failure, Unit>> call({
    required String postId,
    required String commentId,
  }) => _repository.deleteComment(postId: postId, commentId: commentId);
}
