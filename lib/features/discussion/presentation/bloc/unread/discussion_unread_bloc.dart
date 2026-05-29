import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/repositories/discussion_repository.dart';
import 'discussion_unread_event.dart';
import 'discussion_unread_state.dart';

/// Drives the red unread badge on the Discussion shortcut in the
/// weather page's shortcut bar.
///
/// Lives in `main.dart`'s global `MultiBlocProvider` because the
/// shortcut bar (weather branch) and the discussion feed page
/// (`/discussion` ShellRoute branch) both read/write it, and they're
/// in different StatefulShellRoute navigators. Same justification as
/// FavoritesBloc / NotificationBloc.
@injectable
class DiscussionUnreadBloc
    extends Bloc<DiscussionUnreadEvent, DiscussionUnreadState> {
  final DiscussionRepository _repository;

  DiscussionUnreadBloc(this._repository)
      : super(const DiscussionUnreadState()) {
    on<LoadUnreadCount>(_onLoad);
    on<MarkAsVisited>(_onMarkAsVisited);
    on<ResetUnreadCount>(_onReset);
  }

  Future<void> _onLoad(
    LoadUnreadCount event,
    Emitter<DiscussionUnreadState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await _repository.getUnreadCount();
    result.fold(
      // Silently swallow failures — leaving the previous count in place
      // is a better UX than a flashing error badge.
      (_) => emit(state.copyWith(isLoading: false)),
      (count) => emit(DiscussionUnreadState(count: count, isLoading: false)),
    );
  }

  Future<void> _onMarkAsVisited(
    MarkAsVisited event,
    Emitter<DiscussionUnreadState> emit,
  ) async {
    // Optimistic local reset — the badge disappears instantly. The
    // Firestore write happens in the background; even if it fails, the
    // next LoadUnreadCount on the next city search will re-derive the
    // correct count from the server-stored timestamp.
    emit(state.copyWith(count: 0));
    await _repository.markDiscussionVisit();
  }

  void _onReset(
    ResetUnreadCount event,
    Emitter<DiscussionUnreadState> emit,
  ) {
    emit(const DiscussionUnreadState());
  }
}
