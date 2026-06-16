import 'package:cross_file/cross_file.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_weather_dashboard/core/error/failures.dart';
import 'package:adaptive_weather_dashboard/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:adaptive_weather_dashboard/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:adaptive_weather_dashboard/features/profile/domain/failures/profile_failure.dart';

class MockProfileRemoteDataSource extends Mock
    implements ProfileRemoteDataSource {}

class _FakeXFile extends Fake implements XFile {}

void main() {
  late ProfileRepositoryImpl repository;
  late MockProfileRemoteDataSource mockRemote;

  const testUid = 'test-user-123';
  const testUrl = 'https://example.com/users/test-user-123/profile.jpg';
  final fakeFile = _FakeXFile();

  setUpAll(() {
    registerFallbackValue(_FakeXFile());
  });

  setUp(() {
    mockRemote = MockProfileRemoteDataSource();
    repository = ProfileRepositoryImpl(mockRemote);
  });

  group('uploadProfileImage', () {
    test('returns Right(url) on success', () async {
      when(() => mockRemote.uploadProfileImage(
            uid: any(named: 'uid'),
            imageFile: any(named: 'imageFile'),
          )).thenAnswer((_) async => testUrl);

      final result = await repository.uploadProfileImage(
        uid: testUid,
        imageFile: fakeFile,
      );

      expect(result, const Right<Failure, String>(testUrl));
    });

    test('maps `unauthorized` FirebaseException to permissionDenied code',
        () async {
      when(() => mockRemote.uploadProfileImage(
            uid: any(named: 'uid'),
            imageFile: any(named: 'imageFile'),
          )).thenThrow(
        FirebaseException(plugin: 'storage', code: 'unauthorized'),
      );

      final result = await repository.uploadProfileImage(
        uid: testUid,
        imageFile: fakeFile,
      );

      expect(
        result,
        const Left<Failure, String>(
          ProfileFailure(ProfileErrorCode.permissionDenied),
        ),
      );
    });

    test('maps `quota-exceeded` FirebaseException to quotaExceeded code',
        () async {
      when(() => mockRemote.uploadProfileImage(
            uid: any(named: 'uid'),
            imageFile: any(named: 'imageFile'),
          )).thenThrow(
        FirebaseException(plugin: 'storage', code: 'quota-exceeded'),
      );

      final result = await repository.uploadProfileImage(
        uid: testUid,
        imageFile: fakeFile,
      );

      expect(
        result,
        const Left<Failure, String>(
          ProfileFailure(ProfileErrorCode.quotaExceeded),
        ),
      );
    });

    test('returns ProfileFailure(unknown) on non-Firebase exceptions',
        () async {
      when(() => mockRemote.uploadProfileImage(
            uid: any(named: 'uid'),
            imageFile: any(named: 'imageFile'),
          )).thenThrow(Exception('boom'));

      final result = await repository.uploadProfileImage(
        uid: testUid,
        imageFile: fakeFile,
      );

      expect(
        result,
        const Left<Failure, String>(
          ProfileFailure(ProfileErrorCode.unknown),
        ),
      );
    });
  });

  group('removeProfileImage', () {
    test('returns Right(unit) on success', () async {
      when(() => mockRemote.removeProfileImage(uid: any(named: 'uid')))
          .thenAnswer((_) async {});

      final result = await repository.removeProfileImage(uid: testUid);

      expect(result, right(unit));
    });

    test('maps `object-not-found` FirebaseException to notFound code',
        () async {
      when(() => mockRemote.removeProfileImage(uid: any(named: 'uid')))
          .thenThrow(
        FirebaseException(plugin: 'storage', code: 'object-not-found'),
      );

      final result = await repository.removeProfileImage(uid: testUid);

      expect(
        result,
        const Left<Failure, Unit>(
          ProfileFailure(ProfileErrorCode.notFound),
        ),
      );
    });

    test('returns ProfileFailure(unknown) on non-Firebase exceptions',
        () async {
      when(() => mockRemote.removeProfileImage(uid: any(named: 'uid')))
          .thenThrow(Exception('boom'));

      final result = await repository.removeProfileImage(uid: testUid);

      expect(
        result,
        const Left<Failure, Unit>(
          ProfileFailure(ProfileErrorCode.unknown),
        ),
      );
    });
  });
}
