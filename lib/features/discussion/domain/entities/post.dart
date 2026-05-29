import 'package:equatable/equatable.dart';

import 'weather_event_type.dart';

/// A community-feed post about a weather event. Lives in the
/// `discussions/{postId}` Firestore collection.
class Post extends Equatable {
  final String id;
  final String title;

  /// Null when the user typed a fully custom title (didn't tap a chip).
  final WeatherEventType? eventType;

  final String city;

  /// May be empty if the user didn't supply an image URL.
  final String imageUrl;
  final String description;
  final String authorId;
  final String authorName;
  final DateTime createdAt;

  /// User IDs that have liked this post. The length is the like count.
  final List<String> likedBy;

  /// Denormalised count of the `comments/` subcollection, maintained by
  /// the data layer via atomic ±1 updates.
  final int commentCount;

  const Post({
    required this.id,
    required this.title,
    required this.eventType,
    required this.city,
    required this.imageUrl,
    required this.description,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    required this.likedBy,
    required this.commentCount,
  });

  int get likeCount => likedBy.length;

  bool isLikedBy(String? uid) => uid != null && likedBy.contains(uid);

  Post copyWith({
    String? id,
    String? title,
    WeatherEventType? eventType,
    String? city,
    String? imageUrl,
    String? description,
    String? authorId,
    String? authorName,
    DateTime? createdAt,
    List<String>? likedBy,
    int? commentCount,
  }) => Post(
    id: id ?? this.id,
    title: title ?? this.title,
    eventType: eventType ?? this.eventType,
    city: city ?? this.city,
    imageUrl: imageUrl ?? this.imageUrl,
    description: description ?? this.description,
    authorId: authorId ?? this.authorId,
    authorName: authorName ?? this.authorName,
    createdAt: createdAt ?? this.createdAt,
    likedBy: likedBy ?? this.likedBy,
    commentCount: commentCount ?? this.commentCount,
  );

  @override
  List<Object?> get props => [
    id,
    title,
    eventType,
    city,
    imageUrl,
    description,
    authorId,
    authorName,
    createdAt,
    likedBy,
    commentCount,
  ];
}
