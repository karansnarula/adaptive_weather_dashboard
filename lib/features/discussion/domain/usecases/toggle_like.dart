import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/post.dart';
import '../repositories/discussion_repository.dart';

@injectable
class ToggleLike {
  final DiscussionRepository _repository;

  const ToggleLike(this._repository);

  Future<Either<Failure, Post>> call(String postId) =>
      _repository.toggleLike(postId);
}
