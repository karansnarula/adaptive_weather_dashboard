import 'package:equatable/equatable.dart';

import '../../../domain/entities/post.dart';

sealed class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

/// Fired once when the feed page opens. Triggers the initial load.
class LoadFeed extends FeedEvent {
  const LoadFeed();
}

/// Pull-to-refresh re-fetches the entire list.
class RefreshFeed extends FeedEvent {
  const RefreshFeed();
}

/// User tapped a heart on a feed card. Optimistically toggles in the
/// local list and fires the server-side toggle in the background.
class ToggleLikeFromFeed extends FeedEvent {
  final String postId;

  const ToggleLikeFromFeed(this.postId);

  @override
  List<Object> get props => [postId];
}

/// Inject a freshly-created post at the top of the list without a full
/// refresh. Used by the create-post sheet so the new post appears
/// immediately.
class PrependPost extends FeedEvent {
  final Post post;

  const PrependPost(this.post);

  @override
  List<Object> get props => [post];
}

/// Remove a post from the local list — used after the detail page
/// reports a successful delete so the user returns to a consistent feed.
class RemovePostFromFeed extends FeedEvent {
  final String postId;

  const RemovePostFromFeed(this.postId);

  @override
  List<Object> get props => [postId];
}

/// Replace the post with [post.id] in the local list with the supplied
/// version. Dispatched by [DetailBloc] (via a UI-layer listener) so that
/// mutations made on the detail page — likes, new comments, deleted
/// comments — propagate to the shared feed without an extra round-trip
/// to Firestore.
class SyncPostInFeed extends FeedEvent {
  final Post post;

  const SyncPostInFeed(this.post);

  @override
  List<Object> get props => [post];
}
