import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/comment.dart';

/// Firestore-shaped representation of a comment under a post.
class CommentModel {
  static const subcollection = 'comments';

  static const fText = 'text';
  static const fAuthorId = 'authorId';
  static const fAuthorName = 'authorName';
  static const fCreatedAt = 'createdAt';

  static Map<String, dynamic> toCreateMap({
    required String text,
    required String authorId,
    required String authorName,
  }) => <String, dynamic>{
    fText: text,
    fAuthorId: authorId,
    fAuthorName: authorName,
    fCreatedAt: FieldValue.serverTimestamp(),
  };

  static Comment fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snap, {
    required String postId,
  }) {
    final data = snap.data() ?? const <String, dynamic>{};
    final createdAtRaw = data[fCreatedAt];
    final createdAt = createdAtRaw is Timestamp
        ? createdAtRaw.toDate()
        : DateTime.now();

    return Comment(
      id: snap.id,
      postId: postId,
      text: (data[fText] as String?) ?? '',
      authorId: (data[fAuthorId] as String?) ?? '',
      authorName: (data[fAuthorName] as String?) ?? '',
      createdAt: createdAt,
    );
  }
}
