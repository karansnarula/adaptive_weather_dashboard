import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/post.dart';
import '../repositories/discussion_repository.dart';

@injectable
class GetPosts {
  final DiscussionRepository _repository;

  const GetPosts(this._repository);

  Future<Either<Failure, List<Post>>> call() => _repository.getPosts();
}
