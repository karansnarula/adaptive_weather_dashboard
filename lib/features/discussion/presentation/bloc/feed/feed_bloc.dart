import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/datasources/discussion_remote_data_source.dart';
import '../../../domain/usecases/get_posts.dart';
import '../../../domain/usecases/toggle_like.dart';
import 'feed_event.dart';
import 'feed_state.dart';

@injectable
class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final GetPosts _getPosts;
  final ToggleLike _toggleLike;
  // The data source is used purely to read the current user's uid so the
  // feed can compute `isLikedByMe` for each post. We deliberately avoid
  // injecting FirebaseAuth here — it's already wrapped behind the data
  // source, no need to leak the Firebase dependency into the BLoC.
  final DiscussionRemoteDataSource _remote;

  FeedBloc(this._getPosts, this._toggleLike, this._remote)
      : super(const FeedInitial()) {
    on<LoadFeed>(_onLoad);
    on<RefreshFeed>(_onRefresh);
    on<ToggleLikeFromFeed>(_onToggleLike);
    on<PrependPost>(_onPrepend);
    on<RemovePostFromFeed>(_onRemove);
    on<SyncPostInFeed>(_onSyncPost);
  }

  Future<void> _onLoad(LoadFeed event, Emitter<FeedState> emit) async {
    emit(const FeedLoading());
    final result = await _getPosts();
    result.fold(
      (failure) => emit(FeedError(failure.message)),
      (posts) => emit(
        FeedLoaded(posts: posts, currentUserId: _remote.currentUserId),
      ),
    );
  }

  Future<void> _onRefresh(RefreshFeed event, Emitter<FeedState> emit) async {
    final current = state;
    if (current is FeedLoaded) {
      emit(current.copyWith(isRefreshing: true));
    }
    final result = await _getPosts();
    result.fold(
      (failure) => emit(FeedError(failure.message)),
      (posts) => emit(
        FeedLoaded(posts: posts, currentUserId: _remote.currentUserId),
      ),
    );
  }

  /// Optimistic toggle — we flip the heart in the local list immediately
  /// and fire the server call in the background. If the server call
  /// fails the next pull-to-refresh corrects the discrepancy.
  Future<void> _onToggleLike(
    ToggleLikeFromFeed event,
    Emitter<FeedState> emit,
  ) async {
    final current = state;
    if (current is! FeedLoaded) return;
    final uid = current.currentUserId;
    if (uid == null) return;

    final updated = current.posts.map((p) {
      if (p.id != event.postId) return p;
      final liked = p.likedBy.contains(uid);
      return p.copyWith(
        likedBy: liked
            ? (p.likedBy.where((id) => id != uid).toList(growable: false))
            : ([...p.likedBy, uid]),
      );
    }).toList(growable: false);

    emit(current.copyWith(posts: updated));

    // Fire-and-forget; failures are tolerated and corrected on next refresh.
    await _toggleLike(event.postId);
  }

  void _onPrepend(PrependPost event, Emitter<FeedState> emit) {
    final current = state;
    final uid = _remote.currentUserId;
    if (current is FeedLoaded) {
      emit(current.copyWith(posts: [event.post, ...current.posts]));
    } else {
      emit(FeedLoaded(posts: [event.post], currentUserId: uid));
    }
  }

  void _onRemove(RemovePostFromFeed event, Emitter<FeedState> emit) {
    final current = state;
    if (current is! FeedLoaded) return;
    emit(
      current.copyWith(
        posts: current.posts
            .where((p) => p.id != event.postId)
            .toList(growable: false),
      ),
    );
  }

  void _onSyncPost(SyncPostInFeed event, Emitter<FeedState> emit) {
    final current = state;
    if (current is! FeedLoaded) return;
    final updated = current.posts
        .map((p) => p.id == event.post.id ? event.post : p)
        .toList(growable: false);
    emit(current.copyWith(posts: updated));
  }
}
