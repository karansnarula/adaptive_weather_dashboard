import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../domain/entities/news_article.dart';
import '../domain/entities/news_category.dart';

/// Lightweight Firestore-free service that fetches articles from
/// NewsAPI.org. Mirrors the `air_quality_service` pattern — raw Dio,
/// inline parsing, no model classes, no Retrofit code generation.
///
/// Each [NewsCategory] maps to a different `q=` query against the
/// `/everything` endpoint. The `@Named('newsDio')` binding (in
/// `app_module.dart`) injects the NewsAPI base URL + apiKey query
/// param so neither leaks across to OpenWeather or Gemini.
@lazySingleton
class NewsService {
  /// Maximum articles per category. NewsAPI bills per response, so a
  /// small page size is also a cost-saver against the 100/day free
  /// tier.
  static const int _pageSize = 10;

  final Dio _dio;

  const NewsService(@Named('newsDio') this._dio);

  Future<List<NewsArticle>> getNews(
    String city,
    NewsCategory category,
  ) async {
    final query = _queryFor(city, category);

    final response = await _dio.get(
      '/everything',
      queryParameters: {
        'q': query,
        'language': 'en',
        'sortBy': 'publishedAt',
        'pageSize': _pageSize,
      },
    );

    final articles = (response.data['articles'] as List?) ?? const [];
    return articles
        .whereType<Map<String, dynamic>>()
        .map(_parseArticle)
        .toList(growable: false);
  }

  String _queryFor(String city, NewsCategory category) {
    return switch (category) {
      NewsCategory.weather => 'weather $city',
      NewsCategory.general => city,
      NewsCategory.travel => 'travel $city',
    };
  }

  NewsArticle _parseArticle(Map<String, dynamic> json) {
    final imageUrl = json['urlToImage'] as String?;
    return NewsArticle(
      title: (json['title'] as String?) ?? '',
      description: (json['description'] as String?) ?? '',
      url: (json['url'] as String?) ?? '',
      imageUrl: (imageUrl != null && imageUrl.trim().isNotEmpty)
          ? imageUrl
          : null,
      sourceName: (json['source'] as Map?)?['name'] as String? ?? '',
      publishedAt:
          DateTime.tryParse((json['publishedAt'] as String?) ?? '') ??
              DateTime.now(),
    );
  }
}
