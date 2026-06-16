import 'package:cross_file/cross_file.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_weather_dashboard/features/profile/domain/failures/profile_failure.dart';
import 'package:adaptive_weather_dashboard/features/profile/domain/usecases/remove_profile_image.dart'
    as uc_remove;
import 'package:adaptive_weather_dashboard/features/profile/domain/usecases/upload_profile_image.dart'
    as uc_upload;
import 'package:adaptive_weather_dashboard/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:adaptive_weather_dashboard/features/profile/presentation/bloc/profile_event.dart';
import 'package:adaptive_weather_dashboard/features/profile/presentation/bloc/profile_state.dart';

class MockUploadProfileImage extends Mock
    implements uc_upload.UploadProfileImage {}

class MockRemoveProfileImage extends Mock
    implements uc_remove.RemoveProfileImage {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUser extends Mock implements User {}

class _FakeXFile extends Fake implements XFile {}

void main() {
  late ProfileBloc bloc;
  late MockUploadProfileImage mockUpload;
  late MockRemoveProfileImage mockRemove;
  late MockFirebaseAuth mockAuth;
  late MockUser mockUser;

  const testUid = 'test-user-123';
  const testUrl = 'https://example.com/users/test-user-123/profile.jpg';
  final fakeFile = _FakeXFile();

  setUpAll(() {
    registerFallbackValue(_FakeXFile());
  });

  setUp(() {
    mockUpload = MockUploadProfileImage();
    mockRemove = MockRemoveProfileImage();
    mockAuth = MockFirebaseAuth();
    mockUser = MockUser();
    bloc = ProfileBloc(mockUpload, mockRemove, mockAuth);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is idle with no error code', () {
    expect(bloc.state.status, ProfileStatus.idle);
    expect(bloc.state.errorCode, isNull);
  });

  group('UploadProfileImage', () {
    test('emits [uploading, success] when the use case succeeds', () async {
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(testUid);
      when(() => mockUpload(
            uid: any(named: 'uid'),
            imageFile: any(named: 'imageFile'),
          )).thenAnswer((_) async => const Right(testUrl));

      final future = expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<ProfileState>((s) => s.status == ProfileStatus.uploading),
          predicate<ProfileState>((s) => s.status == ProfileStatus.success),
        ]),
      );

      bloc.add(UploadProfileImage(fakeFile));
      await future;

      verify(() => mockUpload(uid: testUid, imageFile: fakeFile)).called(1);
    });

    test('emits [uploading, error] with the failure code on Left',
        () async {
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(testUid);
      when(() => mockUpload(
            uid: any(named: 'uid'),
            imageFile: any(named: 'imageFile'),
          )).thenAnswer(
        (_) async => const Left(ProfileFailure(ProfileErrorCode.permissionDenied)),
      );

      final future = expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<ProfileState>((s) => s.status == ProfileStatus.uploading),
          predicate<ProfileState>((s) =>
              s.status == ProfileStatus.error &&
              s.errorCode == ProfileErrorCode.permissionDenied),
        ]),
      );

      bloc.add(UploadProfileImage(fakeFile));
      await future;
    });

    test('short-circuits with notSignedIn code when no user is signed in',
        () async {
      when(() => mockAuth.currentUser).thenReturn(null);

      final future = expectLater(
        bloc.stream,
        emits(
          predicate<ProfileState>((s) =>
              s.status == ProfileStatus.error &&
              s.errorCode == ProfileErrorCode.notSignedIn),
        ),
      );

      bloc.add(UploadProfileImage(fakeFile));
      await future;

      verifyNever(() => mockUpload(
            uid: any(named: 'uid'),
            imageFile: any(named: 'imageFile'),
          ));
    });
  });

  group('RemoveProfileImage', () {
    test('emits [uploading, success] when the use case succeeds', () async {
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(testUid);
      when(() => mockRemove(uid: any(named: 'uid')))
          .thenAnswer((_) async => const Right(unit));

      final future = expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<ProfileState>((s) => s.status == ProfileStatus.uploading),
          predicate<ProfileState>((s) => s.status == ProfileStatus.success),
        ]),
      );

      bloc.add(const RemoveProfileImage());
      await future;

      verify(() => mockRemove(uid: testUid)).called(1);
    });

    test('emits [uploading, error] when the use case returns Left', () async {
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.uid).thenReturn(testUid);
      when(() => mockRemove(uid: any(named: 'uid'))).thenAnswer(
        (_) async => const Left(ProfileFailure(ProfileErrorCode.permissionDenied)),
      );

      final future = expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<ProfileState>((s) => s.status == ProfileStatus.uploading),
          predicate<ProfileState>((s) =>
              s.status == ProfileStatus.error &&
              s.errorCode == ProfileErrorCode.permissionDenied),
        ]),
      );

      bloc.add(const RemoveProfileImage());
      await future;
    });

    test('short-circuits with notSignedIn code when no user is signed in',
        () async {
      when(() => mockAuth.currentUser).thenReturn(null);

      final future = expectLater(
        bloc.stream,
        emits(
          predicate<ProfileState>((s) =>
              s.status == ProfileStatus.error &&
              s.errorCode == ProfileErrorCode.notSignedIn),
        ),
      );

      bloc.add(const RemoveProfileImage());
      await future;

      verifyNever(() => mockRemove(uid: any(named: 'uid')));
    });
  });

  group('ClearProfileError', () {
    test('returns the state to idle after an error', () async {
      when(() => mockAuth.currentUser).thenReturn(null);

      final future = expectLater(
        bloc.stream,
        emitsInOrder([
          predicate<ProfileState>((s) => s.status == ProfileStatus.error),
          predicate<ProfileState>((s) => s.status == ProfileStatus.idle),
        ]),
      );

      bloc.add(UploadProfileImage(fakeFile));
      bloc.add(const ClearProfileError());

      await future;
    });
  });
}
