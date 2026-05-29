import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/datasources/discussion_remote_data_source.dart';
import '../../../domain/usecases/add_comment.dart';
import '../../../domain/usecases/delete_comment.dart';
import '../../../domain/usecases/delete_post.dart';
import '../../../domain/usecases/get_comments.dart';
import '../../../domain/usecases/get_post.dart';
import '../../../domain/usecases/toggle_like.dart';
import 'detail_event.dart';
import 'detail_state.dart';

@injectable
class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final GetPost _getPost;
  final GetComments _getComments;
  final ToggleLike _toggleLike;
  final AddComment _addComment;
  final DeletePost _deletePost;
  final DeleteComment _deleteComment;
  final DiscussionRemoteDataSource _remote;

  String? _postId;

  DetailBloc(
    this._getPost,
    this._getComments,
    this._toggleLike,
    this._addComment,
    this._deletePost,
    this._deleteComment,
    this._remote,
  ) : super(const DetailState()) {
    on<LoadDetail>(_onLoad);
    on<RefreshDetail>(_onRefresh);
    on<ToggleLikeOnDetail>(_onToggleLike);
    on<SubmitComment>(_onSubmitComment);
    on<DeleteCurrentPost>(_onDeletePost);
    on<DeleteOneComment>(_onDeleteComment);
  }

  Future<void> _onLoad(LoadDetail event, Emitter<DetailState> emit) async {
    _postId = event.postId;
    emit(state.copyWith(status: DetailStatus.loading));
    await _fetch(emit);
  }

  Future<void> _onRefresh(
    RefreshDetail event,
    Emitter<DetailState> emit,
  ) async {
    await _fetch(emit);
  }

  Future<void> _fetch(Emitter<DetailState> emit) async {
    final postId = _postId;
    if (postId == null) return;

    // Sequential fetches keep the types precise (`Future.wait` on
    // heterogeneous `Either` types collapses to `Object` and forces ugly
    // casts). The extra ~50ms over parallel is negligible for two small
    // Firestore reads.
    final postResult = await _getPost(postId);
    final commentsResult = await _getComments(postId);

    postResult.fold(
      (failure) => emit(
        state.copyWith(
          status: DetailStatus.error,
          errorMessage: failure.message,
        ),
      ),
      (post) {
        commentsResult.fold(
          (failure) => emit(
            state.copyWith(
              status: DetailStatus.error,
              errorMessage: failure.message,
            ),
          ),
          (comments) => emit(
            DetailState(
              status: DetailStatus.ready,
              post: post,
              comments: comments,
              currentUserId: _remote.currentUserId,
            ),
          ),
        );
      },
    );
  }

  Future<void> _onToggleLike(
    ToggleLikeOnDetail event,
    Emitter<DetailState> emit,
  ) async {
    final post = state.post;
    final uid = state.currentUserId;
    if (post == null || uid == null) return;

    // Optimistic toggle.
    final liked = post.likedBy.contains(uid);
    final optimistic = post.copyWith(
      likedBy: liked
          ? post.likedBy.where((id) => id != uid).toList(growable: false)
          : [...post.likedBy, uid],
    );
    emit(state.copyWith(post: optimistic, clearTransientError: true));

    final result = await _toggleLike(post.id);
    result.fold(
      (failure) {
        // Roll back optimistic change on hard failure.
        emit(state.copyWith(post: post, transientError: failure.message));
      },
      (updated) => emit(state.copyWith(post: updated)),
    );
  }

  Future<void> _onSubmitComment(
    SubmitComment event,
    Emitter<DetailState> emit,
  ) async {
    final post = state.post;
    if (post == null) return;
    final trimmed = event.text.trim();
    if (trimmed.isEmpty) return;
    if (state.status == DetailStatus.submittingComment) return;

    emit(state.copyWith(
      status: DetailStatus.submittingComment,
      clearTransientError: true,
    ));

    final result = await _addComment(postId: post.id, text: trimmed);
    result.fold(
      (failure) => emit(state.copyWith(
        status: DetailStatus.ready,
        transientError: failure.message,
      )),
      (comment) => emit(state.copyWith(
        status: DetailStatus.ready,
        comments: [...state.comments, comment],
        post: post.copyWith(commentCount: post.commentCount + 1),
      )),
    );
  }

  Future<void> _onDeletePost(
    DeleteCurrentPost event,
    Emitter<DetailState> emit,
  ) async {
    final post = state.post;
    if (post == null) return;
    final result = await _deletePost(post.id);
    result.fold(
      (failure) =>
          emit(state.copyWith(transientError: failure.message)),
      (_) => emit(state.copyWith(status: DetailStatus.deleted)),
    );
  }

  Future<void> _onDeleteComment(
    DeleteOneComment event,
    Emitter<DetailState> emit,
  ) async {
    final post = state.post;
    if (post == null) return;
    final result = await _deleteComment(
      postId: post.id,
      commentId: event.commentId,
    );
    result.fold(
      (failure) =>
          emit(state.copyWith(transientError: failure.message)),
      (_) => emit(state.copyWith(
        comments: state.comments
            .where((c) => c.id != event.commentId)
            .toList(growable: false),
        post: post.copyWith(
          commentCount: post.commentCount > 0 ? post.commentCount - 1 : 0,
        ),
      )),
    );
  }
}
