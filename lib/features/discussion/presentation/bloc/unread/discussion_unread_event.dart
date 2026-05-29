import 'package:equatable/equatable.dart';

sealed class DiscussionUnreadEvent extends Equatable {
  const DiscussionUnreadEvent();

  @override
  List<Object> get props => [];
}

/// Fetch the latest count from Firestore. Dispatched on successful
/// city search (i.e. when [WeatherBloc] transitions to `WeatherLoaded`).
class LoadUnreadCount extends DiscussionUnreadEvent {
  const LoadUnreadCount();
}

/// Record that the user just opened (or closed) the discussion feed.
/// Optimistically zeroes the local count for instant badge feedback,
/// then writes the new `last_discussion_visit` to Firestore.
class MarkAsVisited extends DiscussionUnreadEvent {
  const MarkAsVisited();
}

/// Reset to the empty/unauthenticated state. Dispatched on sign-out so
/// the next user doesn't briefly see the previous user's badge before
/// the first refresh.
class ResetUnreadCount extends DiscussionUnreadEvent {
  const ResetUnreadCount();
}
