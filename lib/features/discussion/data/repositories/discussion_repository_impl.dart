import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/post.dart';
import '../../domain/entities/weather_event_type.dart';
import '../../domain/repositories/discussion_repository.dart';
import '../datasources/discussion_remote_data_source.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';

@LazySingleton(as: DiscussionRepository)
class DiscussionRepositoryImpl implements DiscussionRepository {
  final DiscussionRemoteDataSource _remote;

  const DiscussionRepositoryImpl(this._remote);

  Failure _mapFirebaseError(FirebaseException e) {
    // Permission-denied surfaces as ServerFailure with a helpful message
    // rather than a NetworkFailure, since the request reached the server
    // and was explicitly rejected by the rules.
    if (e.code == 'permission-denied') {
      return const ServerFailure('You don\'t have permission for that action.');
    }
    if (e.code == 'unavailable' || e.code == 'cancelled') {
      return const NetworkFailure();
    }
    return const ServerFailure();
  }

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() body) async {
    try {
      return Right(await body());
    } on NotSignedInException {
      return const Left(ServerFailure('You must be signed in.'));
    } on FirebaseException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getPosts() => _guard(() async {
    final docs = await _remote.getPosts();
    return docs.map(PostModel.fromSnapshot).toList(growable: false);
  });

  @override
  Future<Either<Failure, Post>> getPost(String postId) => _guard(() async {
    final doc = await _remote.getPost(postId);
    if (!doc.exists) {
      throw FirebaseException(plugin: 'cloud_firestore', code: 'not-found');
    }
    return PostModel.fromSnapshot(doc);
  });

  @override
  Future<Either<Failure, List<Comment>>> getComments(String postId) =>
      _guard(() async {
        final docs = await _remote.getComments(postId);
        return docs
            .map((d) => CommentModel.fromSnapshot(d, postId: postId))
            .toList(growable: false);
      });

  @override
  Future<Either<Failure, Post>> createPost({
    required String title,
    required WeatherEventType? eventType,
    required String city,
    required String imageUrl,
    required String description,
  }) => _guard(() async {
    final payload = PostModel.toCreateMap(
      title: title,
      eventType: eventType,
      city: city,
      imageUrl: imageUrl,
      description: description,
    );
    final doc = await _remote.createPost(payload);
    return PostModel.fromSnapshot(doc);
  });

  @override
  Future<Either<Failure, Comment>> addComment({
    required String postId,
    required String text,
  }) => _guard(() async {
    final doc = await _remote.addComment(postId: postId, text: text);
    return CommentModel.fromSnapshot(doc, postId: postId);
  });

  @override
  Future<Either<Failure, Post>> toggleLike(String postId) => _guard(() async {
    final doc = await _remote.toggleLike(postId);
    return PostModel.fromSnapshot(doc);
  });

  @override
  Future<Either<Failure, Unit>> deletePost(String postId) => _guard(() async {
    await _remote.deletePost(postId);
    return unit;
  });

  @override
  Future<Either<Failure, Unit>> deleteComment({
    required String postId,
    required String commentId,
  }) => _guard(() async {
    await _remote.deleteComment(postId: postId, commentId: commentId);
    return unit;
  });

  @override
  Future<Either<Failure, int>> getUnreadCount() => _guard(() async {
    final lastVisit = await _remote.getLastDiscussionVisit();
    // null lastVisit (first-time user) means "everything is new" — count
    // every post in the collection. The first markDiscussionVisit (fired
    // when they open the feed) sets the anchor, and subsequent loads
    // count only posts created after it.
    return _remote.countPostsSince(lastVisit);
  });

  @override
  Future<Either<Failure, Unit>> markDiscussionVisit() => _guard(() async {
    await _remote.markDiscussionVisit();
    return unit;
  });
}
