import 'package:equatable/equatable.dart';

import '../../../domain/entities/comment.dart';
import '../../../domain/entities/post.dart';

enum DetailStatus {
  /// Quota has not been loaded yet — render a spinner.
  initial,

  /// Initial fetch in flight.
  loading,

  /// Post + comments are loaded and the user can interact.
  ready,

  /// `SubmitComment` is in flight — disable the input.
  submittingComment,

  /// The current post has been deleted by the user. The UI listens for
  /// this and pops back to the feed.
  deleted,

  /// Initial fetch failed.
  error,
}

class DetailState extends Equatable {
  final DetailStatus status;
  final Post? post;
  final List<Comment> comments;
  final String? currentUserId;

  /// Non-null exactly when a transient operation (like, delete, comment
  /// submit) fails. The UI reads it once via [BlocListener] and the
  /// next emit clears it.
  final String? transientError;

  /// Holds the message when [status] == [DetailStatus.error].
  final String? errorMessage;

  const DetailState({
    this.status = DetailStatus.initial,
    this.post,
    this.comments = const [],
    this.currentUserId,
    this.transientError,
    this.errorMessage,
  });

  DetailState copyWith({
    DetailStatus? status,
    Post? post,
    List<Comment>? comments,
    String? currentUserId,
    String? transientError,
    String? errorMessage,
    bool clearTransientError = false,
  }) => DetailState(
    status: status ?? this.status,
    post: post ?? this.post,
    comments: comments ?? this.comments,
    currentUserId: currentUserId ?? this.currentUserId,
    transientError:
        clearTransientError ? null : (transientError ?? this.transientError),
    errorMessage: errorMessage ?? this.errorMessage,
  );

  @override
  List<Object?> get props => [
    status,
    post,
    comments,
    currentUserId,
    transientError,
    errorMessage,
  ];
}
