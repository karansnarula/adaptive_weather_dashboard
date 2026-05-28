import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_weather_dashboard/core/error/failures.dart';
import 'package:adaptive_weather_dashboard/features/discussion/domain/entities/post.dart';
import 'package:adaptive_weather_dashboard/features/discussion/domain/entities/weather_event_type.dart';
import 'package:adaptive_weather_dashboard/features/discussion/domain/repositories/discussion_repository.dart';
import 'package:adaptive_weather_dashboard/features/discussion/domain/usecases/create_post.dart';

class MockDiscussionRepository extends Mock implements DiscussionRepository {}

void main() {
  late CreatePost useCase;
  late MockDiscussionRepository mockRepository;

  setUp(() {
    mockRepository = MockDiscussionRepository();
    useCase = CreatePost(mockRepository);
  });

  final fixedNow = DateTime(2026, 5, 28, 9, 0);
  final fakePost = Post(
    id: 'p1',
    title: 'Storm in Bangkok',
    eventType: WeatherEventType.storm,
    city: 'Bangkok',
    imageUrl: '',
    description: 'Heavy rain incoming.',
    authorId: 'u1',
    authorName: 'Karan',
    createdAt: fixedNow,
    likedBy: const [],
    commentCount: 0,
  );

  test('forwards all fields to repository.createPost', () async {
    when(() => mockRepository.createPost(
          title: any(named: 'title'),
          eventType: any(named: 'eventType'),
          city: any(named: 'city'),
          imageUrl: any(named: 'imageUrl'),
          description: any(named: 'description'),
        )).thenAnswer((_) async => Right(fakePost));

    final result = await useCase(
      title: 'Storm in Bangkok',
      eventType: WeatherEventType.storm,
      city: 'Bangkok',
      imageUrl: '',
      description: 'Heavy rain incoming.',
    );

    expect(result, Right(fakePost));
    verify(() => mockRepository.createPost(
          title: 'Storm in Bangkok',
          eventType: WeatherEventType.storm,
          city: 'Bangkok',
          imageUrl: '',
          description: 'Heavy rain incoming.',
        )).called(1);
  });

  test('surfaces repository failures', () async {
    when(() => mockRepository.createPost(
          title: any(named: 'title'),
          eventType: any(named: 'eventType'),
          city: any(named: 'city'),
          imageUrl: any(named: 'imageUrl'),
          description: any(named: 'description'),
        )).thenAnswer((_) async => const Left(ServerFailure('nope')));

    final result = await useCase(
      title: 'X',
      eventType: null,
      city: 'Bangkok',
      imageUrl: '',
      description: '',
    );

    expect(result, const Left(ServerFailure('nope')));
  });
}
