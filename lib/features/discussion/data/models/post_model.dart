import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/post.dart';
import '../../domain/entities/weather_event_type.dart';

/// Firestore-shaped representation of a discussion post. Centralises every
/// field name so the repository never sprinkles raw string keys around.
class PostModel {
  static const collection = 'discussions';

  static const fTitle = 'title';
  static const fEventType = 'eventType';
  static const fCity = 'city';
  static const fImageUrl = 'imageUrl';
  static const fDescription = 'description';
  static const fAuthorId = 'authorId';
  static const fAuthorName = 'authorName';
  static const fCreatedAt = 'createdAt';
  static const fLikedBy = 'likedBy';
  static const fCommentCount = 'commentCount';

  /// Build the document payload for a fresh post create. Author identity
  /// fields are NOT included here — the data source stamps them from the
  /// currently signed-in [FirebaseAuth] user. Server-generated timestamp
  /// keeps the ordering field tamper-proof.
  static Map<String, dynamic> toCreateMap({
    required String title,
    required WeatherEventType? eventType,
    required String city,
    required String imageUrl,
    required String description,
  }) => <String, dynamic>{
    fTitle: title,
    fEventType: eventType?.name,
    fCity: city,
    fImageUrl: imageUrl,
    fDescription: description,
    fCreatedAt: FieldValue.serverTimestamp(),
    fLikedBy: <String>[],
    fCommentCount: 0,
  };

  static Post fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snap) {
    final data = snap.data() ?? const <String, dynamic>{};
    final createdAtRaw = data[fCreatedAt];
    final createdAt = createdAtRaw is Timestamp
        ? createdAtRaw.toDate()
        // Local writes briefly see a null serverTimestamp before the
        // server resolves it — fall back to now so the UI can still render.
        : DateTime.now();

    return Post(
      id: snap.id,
      title: (data[fTitle] as String?) ?? '',
      eventType: WeatherEventType.fromName(data[fEventType] as String?),
      city: (data[fCity] as String?) ?? '',
      imageUrl: (data[fImageUrl] as String?) ?? '',
      description: (data[fDescription] as String?) ?? '',
      authorId: (data[fAuthorId] as String?) ?? '',
      authorName: (data[fAuthorName] as String?) ?? '',
      createdAt: createdAt,
      likedBy: ((data[fLikedBy] as List?) ?? const [])
          .map((e) => e.toString())
          .toList(growable: false),
      commentCount: (data[fCommentCount] as num?)?.toInt() ?? 0,
    );
  }
}
