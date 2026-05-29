import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_weather_dashboard/features/news/data/news_service.dart';
import 'package:adaptive_weather_dashboard/features/news/domain/entities/news_category.dart';

class MockDio extends Mock implements Dio {}

void main() {
  late NewsService service;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    service = NewsService(mockDio);
  });

  Response<dynamic> response(Map<String, dynamic> data) => Response(
    requestOptions: RequestOptions(path: '/everything'),
    data: data,
  );

  test('parses NewsAPI articles into NewsArticle entities', () async {
    when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) async => response({
          'articles': [
            {
              'title': 'Heavy rain hits Bangkok',
              'description': 'A short summary.',
              'url': 'https://example.com/article',
              'urlToImage': 'https://example.com/img.jpg',
              'source': {'name': 'BBC News'},
              'publishedAt': '2026-05-28T12:00:00Z',
            },
            {
              // Defensive: missing optional fields.
              'title': 'Untitled',
              'url': 'https://example.com/2',
              'source': {},
              'publishedAt': '2026-05-28T13:00:00Z',
            },
          ],
        }));

    final result = await service.getNews('Bangkok', NewsCategory.weather);

    expect(result.length, 2);

    expect(result.first.title, 'Heavy rain hits Bangkok');
    expect(result.first.description, 'A short summary.');
    expect(result.first.url, 'https://example.com/article');
    expect(result.first.imageUrl, 'https://example.com/img.jpg');
    expect(result.first.sourceName, 'BBC News');

    // Second article exercises the nullable / missing-field path.
    expect(result.last.title, 'Untitled');
    expect(result.last.description, '');
    expect(result.last.imageUrl, isNull);
    expect(result.last.sourceName, '');
  });

  test('returns empty list when payload has no articles', () async {
    when(() => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
        )).thenAnswer((_) async => response({'articles': []}));

    final result = await service.getNews('Bangkok', NewsCategory.weather);

    expect(result, isEmpty);
  });

  group('query construction', () {
    Map<String, dynamic> capturedQueryParams() {
      return verify(() => mockDio.get(
            any(),
            queryParameters: captureAny(named: 'queryParameters'),
          )).captured.single as Map<String, dynamic>;
    }

    setUp(() {
      when(() => mockDio.get(
            any(),
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => response({'articles': []}));
    });

    test('weather category sends "weather <city>" query', () async {
      await service.getNews('Bangkok', NewsCategory.weather);
      final params = capturedQueryParams();
      expect(params['q'], 'weather Bangkok');
      expect(params['pageSize'], 10);
      expect(params['language'], 'en');
    });

    test('general category sends just the city as query', () async {
      await service.getNews('Bangkok', NewsCategory.general);
      expect(capturedQueryParams()['q'], 'Bangkok');
    });

    test('travel category sends "travel <city>" query', () async {
      await service.getNews('Bangkok', NewsCategory.travel);
      expect(capturedQueryParams()['q'], 'travel Bangkok');
    });
  });
}
