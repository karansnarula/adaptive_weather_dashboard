import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:adaptive_weather_dashboard/features/news/domain/entities/news_article.dart';
import 'package:adaptive_weather_dashboard/features/news/presentation/widgets/news_article_card.dart';

NewsArticle _article({
  String title = 'Heat wave grips Bangkok',
  String description = 'Temperatures hit 42°C across the city.',
  String sourceName = 'BBC News',
  String? imageUrl,
}) => NewsArticle(
      title: title,
      description: description,
      url: 'https://example.com/article',
      imageUrl: imageUrl,
      sourceName: sourceName,
      publishedAt: DateTime.utc(2026, 6, 1, 12),
    );

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('renders title, source name, and description', (tester) async {
    await tester.pumpWidget(
      _wrap(NewsArticleCard(article: _article(), onTap: () {})),
    );

    expect(find.text('Heat wave grips Bangkok'), findsOneWidget);
    expect(find.text('BBC News'), findsOneWidget);
    expect(find.text('Temperatures hit 42°C across the city.'), findsOneWidget);
  });

  testWidgets('omits source row when sourceName is empty', (tester) async {
    await tester.pumpWidget(
      _wrap(
        NewsArticleCard(
          article: _article(sourceName: ''),
          onTap: () {},
        ),
      ),
    );

    expect(find.text('BBC News'), findsNothing);
    // Title still renders.
    expect(find.text('Heat wave grips Bangkok'), findsOneWidget);
  });

  testWidgets('omits description block when description is empty',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        NewsArticleCard(
          article: _article(description: ''),
          onTap: () {},
        ),
      ),
    );

    expect(
      find.text('Temperatures hit 42°C across the city.'),
      findsNothing,
    );
  });

  testWidgets('omits image section when imageUrl is null', (tester) async {
    await tester.pumpWidget(
      _wrap(
        NewsArticleCard(
          article: _article(imageUrl: null),
          onTap: () {},
        ),
      ),
    );

    expect(find.byType(AspectRatio), findsNothing);
  });

  testWidgets('tap fires onTap callback', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        NewsArticleCard(article: _article(), onTap: () => taps++),
      ),
    );

    await tester.tap(find.byType(NewsArticleCard));
    await tester.pump();

    expect(taps, 1);
  });
}
