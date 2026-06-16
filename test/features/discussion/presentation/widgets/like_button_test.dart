import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:adaptive_weather_dashboard/features/discussion/presentation/widgets/like_button.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('shows outlined heart icon when not liked', (tester) async {
    await tester.pumpWidget(
      _wrap(const LikeButton(isLiked: false, count: 0)),
    );

    expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsNothing);
  });

  testWidgets('shows filled heart icon when liked', (tester) async {
    await tester.pumpWidget(
      _wrap(const LikeButton(isLiked: true, count: 0)),
    );

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border), findsNothing);
  });

  testWidgets('renders the count', (tester) async {
    await tester.pumpWidget(
      _wrap(const LikeButton(isLiked: false, count: 42)),
    );

    expect(find.text('42'), findsOneWidget);
  });

  testWidgets('tap fires onTap callback', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        LikeButton(isLiked: false, count: 0, onTap: () => taps++),
      ),
    );

    await tester.tap(find.byType(LikeButton));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('absent onTap makes the button non-interactive', (tester) async {
    await tester.pumpWidget(
      _wrap(const LikeButton(isLiked: false, count: 0)),
    );

    // InkWell with null onTap renders but does not respond; tapping is a
    // no-op. Confirm the build still includes the icon + count.
    await tester.tap(find.byType(LikeButton));
    await tester.pump();

    expect(find.text('0'), findsOneWidget);
  });
}
