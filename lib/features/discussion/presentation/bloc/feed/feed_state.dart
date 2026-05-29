import 'package:equatable/equatable.dart';

import '../../../domain/entities/post.dart';

sealed class FeedState extends Equatable {
  const FeedState();

  @override
  List<Object?> get props => [];
}

class FeedInitial extends FeedState {
  const FeedInitial();
}

class FeedLoading extends FeedState {
  const FeedLoading();
}

class FeedLoaded extends FeedState {
  final List<Post> posts;
  final String? currentUserId;

  /// True while a `RefreshFeed` is in flight. Drives the spinner inside
  /// `RefreshIndicator`.
  final bool isRefreshing;

  const FeedLoaded({
    required this.posts,
    required this.currentUserId,
    this.isRefreshing = false,
  });

  FeedLoaded copyWith({
    List<Post>? posts,
    String? currentUserId,
    bool? isRefreshing,
  }) => FeedLoaded(
    posts: posts ?? this.posts,
    currentUserId: currentUserId ?? this.currentUserId,
    isRefreshing: isRefreshing ?? this.isRefreshing,
  );

  @override
  List<Object?> get props => [posts, currentUserId, isRefreshing];
}

class FeedError extends FeedState {
  final String message;

  const FeedError(this.message);

  @override
  List<Object> get props => [message];
}
