import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/comment.dart';
import '../repositories/discussion_repository.dart';

@injectable
class GetComments {
  final DiscussionRepository _repository;

  const GetComments(this._repository);

  Future<Either<Failure, List<Comment>>> call(String postId) =>
      _repository.getComments(postId);
}
