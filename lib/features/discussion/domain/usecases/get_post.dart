import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/post.dart';
import '../repositories/discussion_repository.dart';

@injectable
class GetPost {
  final DiscussionRepository _repository;

  const GetPost(this._repository);

  Future<Either<Failure, Post>> call(String postId) =>
      _repository.getPost(postId);
}
