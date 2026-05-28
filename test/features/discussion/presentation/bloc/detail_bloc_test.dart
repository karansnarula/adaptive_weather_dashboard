import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_weather_dashboard/features/discussion/data/datasources/discussion_remote_data_source.dart';
import 'package:adaptive_weather_dashboard/features/discussion/domain/entities/comment.dart';
import 'package:adaptive_weather_dashboard/features/discussion/domain/entities/post.dart';
import 'package:adaptive_weather_dashboard/features/discussion/domain/usecases/add_comment.dart';
import 'package:adaptive_weather_dashboard/features/discussion/domain/usecases/delete_comment.dart';
import 'package:adaptive_weather_dashboard/features/discussion/domain/usecases/delete_post.dart';
import 'package:adaptive_weather_dashboard/features/discussion/domain/usecases/get_comments.dart';
import 'package:adaptive_weather_dashboard/features/discussion/domain/usecases/get_post.dart';
import 'package:adaptive_weather_dashboard/features/discussion/domain/usecases/toggle_like.dart';
import 'package:adaptive_weather_dashboard/features/discussion/presentation/bloc/detail/detail_bloc.dart';
import 'package:adaptive_weather_dashboard/features/discussion/presentation/bloc/detail/detail_event.dart';
import 'package:adaptive_weather_dashboard/features/discussion/presentation/bloc/detail/detail_state.dart';

class MockGetPost extends Mock implements GetPost {}

class MockGetComments extends Mock implements GetComments {}

class MockToggleLike extends Mock implements ToggleLike {}

class MockAddComment extends Mock implements AddComment {}

class MockDeletePost extends Mock implements DeletePost {}

class MockDeleteComment extends Mock implements DeleteComment {}

class MockRemote extends Mock implements DiscussionRemoteDataSource {}

Post buildPost({
  String id = 'p1',
  int commentCount = 0,
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
    commentCount: commentCount,
  );
}

Comment buildComment({String id = 'c1'}) => Comment(
  id: id,
  postId: 'p1',
  text: 'Nice!',
  authorId: 'u-current',
  authorName: 'Tom',
  createdAt: DateTime(2026, 5, 28, 8, 1),
);

void main() {
  late DetailBloc bloc;
  late MockGetPost mockGetPost;
  late MockGetComments mockGetComments;
  late MockToggleLike mockToggleLike;
  late MockAddComment mockAddComment;
  late MockDeletePost mockDeletePost;
  late MockDeleteComment mockDeleteComment;
  late MockRemote mockRemote;

  setUp(() {
    mockGetPost = MockGetPost();
    mockGetComments = MockGetComments();
    mockToggleLike = MockToggleLike();
    mockAddComment = MockAddComment();
    mockDeletePost = MockDeletePost();
    mockDeleteComment = MockDeleteComment();
    mockRemote = MockRemote();
    when(() => mockRemote.currentUserId).thenReturn('u-current');
    bloc = DetailBloc(
      mockGetPost,
      mockGetComments,
      mockToggleLike,
      mockAddComment,
      mockDeletePost,
      mockDeleteComment,
      mockRemote,
    );
  });

  tearDown(() => bloc.close());

  test('LoadDetail loads post and comments and emits ready', () async {
    when(() => mockGetPost('p1'))
        .thenAnswer((_) async => Right(buildPost()));
    when(() => mockGetComments('p1'))
        .thenAnswer((_) async => Right([buildComment()]));

    final done = expectLater(
      bloc.stream,
      emitsThrough(predicate<DetailState>((s) =>
          s.status == DetailStatus.ready &&
          s.post?.id == 'p1' &&
          s.comments.length == 1 &&
          s.currentUserId == 'u-current')),
    );

    bloc.add(const LoadDetail('p1'));
    await done;
  });

  test('SubmitComment appends comment and increments count', () async {
    when(() => mockGetPost('p1'))
        .thenAnswer((_) async => Right(buildPost(commentCount: 0)));
    when(() => mockGetComments('p1'))
        .thenAnswer((_) async => const Right([]));
    when(() => mockAddComment(postId: 'p1', text: 'Hi'))
        .thenAnswer((_) async => Right(buildComment(id: 'cNew')));

    bloc.add(const LoadDetail('p1'));
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final done = expectLater(
      bloc.stream,
      emitsThrough(predicate<DetailState>((s) =>
          s.status == DetailStatus.ready &&
          s.comments.length == 1 &&
          s.post!.commentCount == 1)),
    );

    bloc.add(const SubmitComment('Hi'));
    await done;
  });

  test('DeleteCurrentPost emits deleted on success', () async {
    when(() => mockGetPost('p1'))
        .thenAnswer((_) async => Right(buildPost()));
    when(() => mockGetComments('p1'))
        .thenAnswer((_) async => const Right([]));
    when(() => mockDeletePost('p1')).thenAnswer((_) async => const Right(unit));

    bloc.add(const LoadDetail('p1'));
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final done = expectLater(
      bloc.stream,
      emitsThrough(predicate<DetailState>(
        (s) => s.status == DetailStatus.deleted,
      )),
    );

    bloc.add(const DeleteCurrentPost());
    await done;
  });

  test('DeleteOneComment removes comment and decrements count', () async {
    when(() => mockGetPost('p1'))
        .thenAnswer((_) async => Right(buildPost(commentCount: 1)));
    when(() => mockGetComments('p1'))
        .thenAnswer((_) async => Right([buildComment(id: 'cX')]));
    when(() => mockDeleteComment(postId: 'p1', commentId: 'cX'))
        .thenAnswer((_) async => const Right(unit));

    bloc.add(const LoadDetail('p1'));
    await Future<void>.delayed(Duration.zero);
    await Future<void>.delayed(Duration.zero);

    final done = expectLater(
      bloc.stream,
      emitsThrough(predicate<DetailState>(
        (s) => s.comments.isEmpty && s.post?.commentCount == 0,
      )),
    );

    bloc.add(const DeleteOneComment('cX'));
    await done;
  });
}
