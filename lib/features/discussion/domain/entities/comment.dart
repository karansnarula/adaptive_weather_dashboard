import 'package:equatable/equatable.dart';

/// A single comment on a discussion post. Lives in the
/// `discussions/{postId}/comments/{commentId}` subcollection.
class Comment extends Equatable {
  final String id;
  final String postId;
  final String text;
  final String authorId;
  final String authorName;

  /// Stored for chronological ordering only — the UI does **not** render
  /// comment dates (intentional, per UX spec).
  final DateTime createdAt;

  const Comment({
    required this.id,
    required this.postId,
    required this.text,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, postId, text, authorId, authorName, createdAt];
}
