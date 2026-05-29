import 'package:equatable/equatable.dart';

/// Drives the red badge on the Discussion shortcut.
///
/// Kept deliberately flat — a single integer plus an `isLoading` flag.
/// The UI doesn't care about success/failure variants here: a failed
/// fetch just leaves the previous count in place, which is far less
/// annoying than a flashing error badge.
class DiscussionUnreadState extends Equatable {
  final int count;
  final bool isLoading;

  const DiscussionUnreadState({
    this.count = 0,
    this.isLoading = false,
  });

  DiscussionUnreadState copyWith({int? count, bool? isLoading}) {
    return DiscussionUnreadState(
      count: count ?? this.count,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [count, isLoading];
}
