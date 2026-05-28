import 'package:equatable/equatable.dart';

import '../../../domain/entities/post.dart';
import '../../../domain/entities/weather_event_type.dart';

enum CreatePostStatus { editing, submitting, success, failure }

class CreatePostState extends Equatable {
  /// City the post is being authored under — locked in from the route
  /// query param. Required because the form gates on "city must be set
  /// before posting" (UX decision).
  final String city;

  final String title;
  final String imageUrl;
  final String description;

  /// Non-null when the user has tapped a chip. Cleared by typing a new
  /// title... actually no — we keep the structured type even after edits,
  /// so the post is still attributable to the category. See spec.
  final WeatherEventType? eventType;

  final CreatePostStatus status;

  /// Populated on submit failure for the sheet to surface as a SnackBar.
  final String? errorMessage;

  /// The freshly-created post — emitted on success so the parent feed
  /// can prepend it without a refresh round-trip.
  final Post? createdPost;

  const CreatePostState({
    required this.city,
    this.title = '',
    this.imageUrl = '',
    this.description = '',
    this.eventType,
    this.status = CreatePostStatus.editing,
    this.errorMessage,
    this.createdPost,
  });

  /// The "submit" button gate: title must be present and we must not
  /// already be submitting.
  bool get canSubmit =>
      title.trim().isNotEmpty && status != CreatePostStatus.submitting;

  CreatePostState copyWith({
    String? city,
    String? title,
    String? imageUrl,
    String? description,
    WeatherEventType? eventType,
    CreatePostStatus? status,
    String? errorMessage,
    Post? createdPost,
    bool clearError = false,
  }) => CreatePostState(
    city: city ?? this.city,
    title: title ?? this.title,
    imageUrl: imageUrl ?? this.imageUrl,
    description: description ?? this.description,
    eventType: eventType ?? this.eventType,
    status: status ?? this.status,
    errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    createdPost: createdPost ?? this.createdPost,
  );

  @override
  List<Object?> get props => [
    city,
    title,
    imageUrl,
    description,
    eventType,
    status,
    errorMessage,
    createdPost,
  ];
}
