import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/comment.dart';
import '../entities/post.dart';
import '../entities/weather_event_type.dart';

/// Boundary between domain and the concrete Firestore wiring in the
/// data layer. Every method returns `Either<Failure, T>` — no exceptions
/// cross this line.
abstract class DiscussionRepository {
  /// All posts, newest first. Pull-to-refresh re-invokes this.
  Future<Either<Failure, List<Post>>> getPosts();

  /// A single post by id. Used by the detail page on open and after
  /// like / comment-count mutations to refresh local state.
  Future<Either<Failure, Post>> getPost(String postId);

  /// All comments on a post, oldest first (chronological reading order).
  Future<Either<Failure, List<Comment>>> getComments(String postId);

  /// Create a new post authored by the currently signed-in user.
  /// `imageUrl` may be empty. `eventType` is null when the user typed a
  /// fully custom title without tapping a chip.
  Future<Either<Failure, Post>> createPost({
    required String title,
    required WeatherEventType? eventType,
    required String city,
    required String imageUrl,
    required String description,
  });

  /// Add a comment under [postId]. Also atomically increments the parent
  /// post's `commentCount` via a Firestore batch.
  Future<Either<Failure, Comment>> addComment({
    required String postId,
    required String text,
  });

  /// Toggle the current user's like on [postId]. Adds the uid to
  /// `likedBy` if absent, removes it if present. Returns the updated post.
  Future<Either<Failure, Post>> toggleLike(String postId);

  /// Delete a post the current user authored, cascading all of its
  /// comments in a single batch.
  Future<Either<Failure, Unit>> deletePost(String postId);

  /// Delete a comment. Permitted to the comment author OR the parent
  /// post's author. Atomically decrements the post's `commentCount`.
  Future<Either<Failure, Unit>> deleteComment({
    required String postId,
    required String commentId,
  });
}
