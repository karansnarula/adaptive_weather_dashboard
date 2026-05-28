import 'package:equatable/equatable.dart';

/// A single news article surfaced on the news page. Lightweight feature:
/// no model class, no `fromJson` factory — parsing happens inline in the
/// service (mirroring `air_quality_service`'s pattern). The entity stays
/// platform-agnostic.
class NewsArticle extends Equatable {
  final String title;
  final String description;
  final String url;

  /// May be null when the upstream article has no associated image.
  final String? imageUrl;

  /// Display name of the publisher (e.g. "BBC News"). Empty string if
  /// missing from the upstream payload.
  final String sourceName;
  final DateTime publishedAt;

  const NewsArticle({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.sourceName,
    required this.publishedAt,
  });

  @override
  List<Object?> get props => [
    title,
    description,
    url,
    imageUrl,
    sourceName,
    publishedAt,
  ];
}
