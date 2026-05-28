import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/weather_event_type.dart';
import '../../../domain/usecases/create_post.dart';
import 'create_post_event.dart';
import 'create_post_state.dart';

/// Builds the `EventType in city` auto-title.
String _titleForChip(WeatherEventType type, String city) {
  // Capitalise the enum name: e.g. "storm" -> "Storm".
  final raw = type.name;
  final capitalised = raw[0].toUpperCase() + raw.substring(1);
  return '$capitalised in $city';
}

@injectable
class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final CreatePost _createPost;

  /// City must be locked in at construction — the form's UX requires it
  /// (chip auto-titles, "post under [city]" gating).
  CreatePostBloc(
    this._createPost, {
    @factoryParam required String city,
  }) : super(CreatePostState(city: city)) {
    on<TitleChanged>(
      (e, emit) => emit(state.copyWith(title: e.title, clearError: true)),
    );
    on<ImageUrlChanged>(
      (e, emit) => emit(state.copyWith(imageUrl: e.imageUrl)),
    );
    on<DescriptionChanged>(
      (e, emit) => emit(state.copyWith(description: e.description)),
    );
    on<EventChipTapped>(_onChipTapped);
    on<SubmitNewPost>(_onSubmit);
  }

  void _onChipTapped(EventChipTapped event, Emitter<CreatePostState> emit) {
    emit(state.copyWith(
      title: _titleForChip(event.eventType, state.city),
      eventType: event.eventType,
      clearError: true,
    ));
  }

  Future<void> _onSubmit(
    SubmitNewPost event,
    Emitter<CreatePostState> emit,
  ) async {
    if (!state.canSubmit) return;

    emit(state.copyWith(
      status: CreatePostStatus.submitting,
      clearError: true,
    ));

    final result = await _createPost(
      title: state.title.trim(),
      eventType: state.eventType,
      city: state.city,
      imageUrl: state.imageUrl.trim(),
      description: state.description.trim(),
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: CreatePostStatus.failure,
        errorMessage: failure.message,
      )),
      (post) => emit(state.copyWith(
        status: CreatePostStatus.success,
        createdPost: post,
      )),
    );
  }
}
