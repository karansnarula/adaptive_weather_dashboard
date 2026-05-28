import 'package:equatable/equatable.dart';

import '../../../domain/entities/weather_event_type.dart';

sealed class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object?> get props => [];
}

class TitleChanged extends CreatePostEvent {
  final String title;

  const TitleChanged(this.title);

  @override
  List<Object> get props => [title];
}

/// Tapping a chip replaces the title with `EventType in city` and records
/// the structured event type on the form.
class EventChipTapped extends CreatePostEvent {
  final WeatherEventType eventType;

  const EventChipTapped(this.eventType);

  @override
  List<Object> get props => [eventType];
}

class ImageUrlChanged extends CreatePostEvent {
  final String imageUrl;

  const ImageUrlChanged(this.imageUrl);

  @override
  List<Object> get props => [imageUrl];
}

class DescriptionChanged extends CreatePostEvent {
  final String description;

  const DescriptionChanged(this.description);

  @override
  List<Object> get props => [description];
}

class SubmitNewPost extends CreatePostEvent {
  const SubmitNewPost();
}
