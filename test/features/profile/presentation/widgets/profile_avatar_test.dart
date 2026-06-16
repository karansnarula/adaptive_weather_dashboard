import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:adaptive_weather_dashboard/features/profile/presentation/widgets/profile_avatar.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('renders fallback account_circle icon when photoUrl is null',
      (tester) async {
    await tester.pumpWidget(_wrap(const ProfileAvatar(photoUrl: null)));

    expect(find.byIcon(Icons.account_circle), findsOneWidget);
  });

  testWidgets('renders fallback account_circle icon when photoUrl is empty',
      (tester) async {
    await tester.pumpWidget(_wrap(const ProfileAvatar(photoUrl: '')));

    expect(find.byIcon(Icons.account_circle), findsOneWidget);
  });

  testWidgets('renders fallback account_circle icon when photoUrl is whitespace',
      (tester) async {
    await tester.pumpWidget(_wrap(const ProfileAvatar(photoUrl: '   ')));

    expect(find.byIcon(Icons.account_circle), findsOneWidget);
  });

  testWidgets('wraps avatar in InkWell when onTap is provided', (tester) async {
    await tester.pumpWidget(
      _wrap(ProfileAvatar(photoUrl: null, onTap: () {})),
    );

    expect(find.byType(InkWell), findsOneWidget);
  });

  testWidgets('does not wrap avatar in InkWell when onTap is null',
      (tester) async {
    await tester.pumpWidget(_wrap(const ProfileAvatar(photoUrl: null)));

    expect(find.byType(InkWell), findsNothing);
  });

  testWidgets('tap on tappable avatar fires onTap callback', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(ProfileAvatar(photoUrl: null, onTap: () => taps++)),
    );

    await tester.tap(find.byType(ProfileAvatar));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('respects the requested size', (tester) async {
    await tester.pumpWidget(
      _wrap(const ProfileAvatar(photoUrl: null, size: 96)),
    );

    final sizedBox = tester.widget<SizedBox>(
      find.descendant(
        of: find.byType(ClipOval),
        matching: find.byType(SizedBox),
      ).first,
    );
    expect(sizedBox.width, 96);
    expect(sizedBox.height, 96);
  });
}
