import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_weather_dashboard/core/error/failures.dart';
import 'package:adaptive_weather_dashboard/features/discussion/data/datasources/discussion_remote_data_source.dart';
import 'package:adaptive_weather_dashboard/features/discussion/domain/entities/post.dart';
import 'package:adaptive_weather_dashboard/features/discussion/domain/usecases/get_posts.dart';
import 'package:adaptive_weather_dashboard/features/discussion/domain/usecases/toggle_like.dart';
import 'package:adaptive_weather_dashboard/features/discussion/presentation/bloc/feed/feed_bloc.dart';
import 'package:adaptive_weather_dashboard/features/discussion/presentation/bloc/feed/feed_event.dart';
import 'package:adaptive_weather_dashboard/features/discussion/presentation/bloc/feed/feed_state.dart';

class MockGetPosts extends Mock implements GetPosts {}

class MockToggleLike extends Mock implements ToggleLike {}

class MockRemote extends Mock implements DiscussionRemoteDataSource {}

Post buildPost({
  String id = 'p1',
  List<String> likedBy = const [],
}) {
  return Post(
    id: id,
    title: 'Storm in Bangkok',
    eventType: null,
    city: 'Bangkok',
    imageUrl: '',
    description: '',
    authorId: 'author',
    authorName: 'Karan',
    createdAt: DateTime(2026, 5, 28, 8, 0),
    likedBy: likedBy,
    commentCount: 0,
  );
}

void main() {
  late FeedBloc bloc;
  late MockGetPosts mockGetPosts;
  late MockToggleLike mockToggleLike;
  late MockRemote mockRemote;

  setUp(() {
    mockGetPosts = MockGetPosts();
    mockToggleLike = MockToggleLike();
    mockRemote = MockRemote();
    when(() => mockRemote.currentUserId).thenReturn('u-current');
    bloc = FeedBloc(mockGetPosts, mockToggleLike, mockRemote);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is FeedInitial', () {
    expect(bloc.state, const FeedInitial());
  });

  test('LoadFeed emits [Loading, Loaded] on success', () async {
    final posts = [buildPost(id: 'p1'), buildPost(id: 'p2')];
    when(() => mockGetPosts()).thenAnswer((_) async => Right(posts));

    final done = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<FeedLoading>(),
        predicate<FeedState>(
          (s) => s is FeedLoaded &&
              s.posts.length == 2 &&
              s.currentUserId == 'u-current',
        ),
      ]),
    );

    bloc.add(const LoadFeed());
    await done;
  });

  test('LoadFeed emits [Loading, Error] on failure', () async {
    when(() => mockGetPosts())
        .thenAnswer((_) async => const Left(ServerFailure('boom')));

    final done = expectLater(
      bloc.stream,
      emitsInOrder([
        isA<FeedLoading>(),
        predicate<FeedState>((s) => s is FeedError && s.message == 'boom'),
      ]),
    );

    bloc.add(const LoadFeed());
    await done;
  });

  test('ToggleLikeFromFeed optimistically adds current uid to likedBy',
      () async {
    final posts = [buildPost(id: 'p1', likedBy: const [])];
    when(() => mockGetPosts()).thenAnswer((_) async => Right(posts));
    when(() => mockToggleLike('p1'))
        .thenAnswer((_) async => Right(buildPost(id: 'p1', likedBy: const ['u-current'])));

    bloc.add(const LoadFeed());
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    bloc.add(const ToggleLikeFromFeed('p1'));
    await Future<void>.delayed(Duration.zero);

    final s = bloc.state as FeedLoaded;
    expect(s.posts.first.likedBy, ['u-current']);
  });

  test('PrependPost puts the new post at the top of the list', () async {
    final existing = buildPost(id: 'old');
    when(() => mockGetPosts()).thenAnswer((_) async => Right([existing]));
    bloc.add(const LoadFeed());
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final fresh = buildPost(id: 'new');
    bloc.add(PrependPost(fresh));
    await Future<void>.delayed(Duration.zero);

    final s = bloc.state as FeedLoaded;
    expect(s.posts.map((p) => p.id).toList(), ['new', 'old']);
  });

  test('RemovePostFromFeed removes the matching post', () async {
    when(() => mockGetPosts()).thenAnswer(
      (_) async => Right([buildPost(id: 'a'), buildPost(id: 'b')]),
    );
    bloc.add(const LoadFeed());
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    bloc.add(const RemovePostFromFeed('a'));
    await Future<void>.delayed(Duration.zero);

    final s = bloc.state as FeedLoaded;
    expect(s.posts.map((p) => p.id).toList(), ['b']);
  });

  test('SyncPostInFeed replaces the matching post with the supplied copy',
      () async {
    when(() => mockGetPosts()).thenAnswer(
      (_) async =>
          Right([buildPost(id: 'a'), buildPost(id: 'b', likedBy: const [])]),
    );
    bloc.add(const LoadFeed());
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final patched = buildPost(id: 'b', likedBy: const ['u-current']);
    bloc.add(SyncPostInFeed(patched));
    await Future<void>.delayed(Duration.zero);

    final s = bloc.state as FeedLoaded;
    expect(s.posts.length, 2);
    expect(s.posts.firstWhere((p) => p.id == 'b').likedBy, ['u-current']);
    // The other post is left untouched.
    expect(s.posts.firstWhere((p) => p.id == 'a').likedBy, isEmpty);
  });
}
