import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/comment.dart';
import '../repositories/discussion_repository.dart';

@injectable
class AddComment {
  final DiscussionRepository _repository;

  const AddComment(this._repository);

  Future<Either<Failure, Comment>> call({
    required String postId,
    required String text,
  }) => _repository.addComment(postId: postId, text: text);
}
