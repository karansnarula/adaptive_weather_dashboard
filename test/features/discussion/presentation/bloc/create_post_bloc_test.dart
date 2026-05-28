import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_weather_dashboard/core/error/failures.dart';
import 'package:adaptive_weather_dashboard/features/discussion/domain/entities/post.dart';
import 'package:adaptive_weather_dashboard/features/discussion/domain/entities/weather_event_type.dart';
import 'package:adaptive_weather_dashboard/features/discussion/domain/usecases/create_post.dart';
import 'package:adaptive_weather_dashboard/features/discussion/presentation/bloc/create_post/create_post_bloc.dart';
import 'package:adaptive_weather_dashboard/features/discussion/presentation/bloc/create_post/create_post_event.dart';
import 'package:adaptive_weather_dashboard/features/discussion/presentation/bloc/create_post/create_post_state.dart';

class MockCreatePost extends Mock implements CreatePost {}

void main() {
  late CreatePostBloc bloc;
  late MockCreatePost mockCreatePost;

  final samplePost = Post(
    id: 'p1',
    title: 'Storm in Bangkok',
    eventType: WeatherEventType.storm,
    city: 'Bangkok',
    imageUrl: '',
    description: '',
    authorId: 'u',
    authorName: 'Karan',
    createdAt: DateTime(2026, 5, 28),
    likedBy: const [],
    commentCount: 0,
  );

  setUp(() {
    mockCreatePost = MockCreatePost();
    bloc = CreatePostBloc(mockCreatePost, city: 'Bangkok');
  });

  tearDown(() => bloc.close());

  test('initial state holds the locked-in city and empty form', () {
    expect(bloc.state.city, 'Bangkok');
    expect(bloc.state.title, '');
    expect(bloc.state.eventType, isNull);
    expect(bloc.state.canSubmit, isFalse);
  });

  test('EventChipTapped fills in "<Type> in <city>" title', () async {
    final done = expectLater(
      bloc.stream,
      emits(predicate<CreatePostState>(
        (s) =>
            s.title == 'Storm in Bangkok' &&
            s.eventType == WeatherEventType.storm,
      )),
    );
    bloc.add(const EventChipTapped(WeatherEventType.storm));
    await done;
  });

  test('SubmitNewPost emits submitting then success', () async {
    when(() => mockCreatePost(
          title: any(named: 'title'),
          eventType: any(named: 'eventType'),
          city: any(named: 'city'),
          imageUrl: any(named: 'imageUrl'),
          description: any(named: 'description'),
        )).thenAnswer((_) async => Right(samplePost));

    bloc.add(const TitleChanged('Storm in Bangkok'));
    await Future<void>.delayed(Duration.zero);

    final done = expectLater(
      bloc.stream,
      emitsInOrder([
        predicate<CreatePostState>(
          (s) => s.status == CreatePostStatus.submitting,
        ),
        predicate<CreatePostState>(
          (s) =>
              s.status == CreatePostStatus.success &&
              s.createdPost?.id == 'p1',
        ),
      ]),
    );

    bloc.add(const SubmitNewPost());
    await done;
  });

  test('SubmitNewPost emits failure with errorMessage on Left', () async {
    when(() => mockCreatePost(
          title: any(named: 'title'),
          eventType: any(named: 'eventType'),
          city: any(named: 'city'),
          imageUrl: any(named: 'imageUrl'),
          description: any(named: 'description'),
        )).thenAnswer((_) async => const Left(ServerFailure('boom')));

    bloc.add(const TitleChanged('X'));
    await Future<void>.delayed(Duration.zero);

    final done = expectLater(
      bloc.stream,
      emitsThrough(predicate<CreatePostState>(
        (s) =>
            s.status == CreatePostStatus.failure &&
            s.errorMessage == 'boom',
      )),
    );

    bloc.add(const SubmitNewPost());
    await done;
  });

  test('SubmitNewPost ignored when title is empty', () async {
    bloc.add(const SubmitNewPost());
    await Future<void>.delayed(Duration.zero);
    verifyNever(() => mockCreatePost(
          title: any(named: 'title'),
          eventType: any(named: 'eventType'),
          city: any(named: 'city'),
          imageUrl: any(named: 'imageUrl'),
          description: any(named: 'description'),
        ));
  });
}
