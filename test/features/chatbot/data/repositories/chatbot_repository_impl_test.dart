import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_weather_dashboard/core/error/failures.dart';
import 'package:adaptive_weather_dashboard/features/chatbot/data/datasources/chat_quota_local_data_source.dart';
import 'package:adaptive_weather_dashboard/features/chatbot/data/datasources/gemini_remote_data_source.dart';
import 'package:adaptive_weather_dashboard/features/chatbot/data/models/gemini_request_model.dart';
import 'package:adaptive_weather_dashboard/features/chatbot/data/models/gemini_response_model.dart';
import 'package:adaptive_weather_dashboard/features/chatbot/data/repositories/chatbot_repository_impl.dart';
import 'package:adaptive_weather_dashboard/features/chatbot/domain/entities/chat_message.dart';

class MockGeminiRemoteDataSource extends Mock
    implements GeminiRemoteDataSource {}

class MockChatQuotaLocalDataSource extends Mock
    implements ChatQuotaLocalDataSource {}

class _FakeGeminiRequest extends Fake implements GeminiRequestModel {}

void main() {
  late ChatbotRepositoryImpl repository;
  late MockGeminiRemoteDataSource mockRemote;
  late MockChatQuotaLocalDataSource mockQuota;

  setUpAll(() {
    registerFallbackValue(_FakeGeminiRequest());
  });

  setUp(() {
    mockRemote = MockGeminiRemoteDataSource();
    mockQuota = MockChatQuotaLocalDataSource();
    repository = ChatbotRepositoryImpl(mockRemote, mockQuota);
  });

  GeminiResponseModel buildResponse(String text) => GeminiResponseModel(
        candidates: [
          GeminiCandidate(
            content: GeminiContent(
              role: 'model',
              parts: [GeminiPart(text: text)],
            ),
          ),
        ],
      );

  test('returns Right(ChatMessage) on successful Gemini response', () async {
    when(() => mockRemote.generateContent(any()))
        .thenAnswer((_) async => buildResponse('Sunny and warm.'));

    final result = await repository.sendMessage(
      userMessage: 'How is it?',
      history: const [],
      city: 'Bangkok',
    );

    expect(result.isRight(), isTrue);
    result.fold(
      (_) => fail('expected Right'),
      (msg) {
        expect(msg.text, 'Sunny and warm.');
        expect(msg.role, ChatRole.assistant);
      },
    );
  });

  test('returns Left(ServerFailure) when response text is empty', () async {
    when(() => mockRemote.generateContent(any()))
        .thenAnswer((_) async => buildResponse(''));

    final result = await repository.sendMessage(
      userMessage: 'How is it?',
      history: const [],
      city: null,
    );

    expect(result, const Left(ServerFailure()));
  });

  test('maps DioException connection errors to NetworkFailure', () async {
    when(() => mockRemote.generateContent(any())).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
      ),
    );

    final result = await repository.sendMessage(
      userMessage: 'How is it?',
      history: const [],
      city: null,
    );

    expect(result, const Left(NetworkFailure()));
  });

  test('maps unknown DioException to ServerFailure', () async {
    when(() => mockRemote.generateContent(any())).thenThrow(
      DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 500,
        ),
      ),
    );

    final result = await repository.sendMessage(
      userMessage: 'How is it?',
      history: const [],
      city: null,
    );

    expect(result, const Left(ServerFailure()));
  });
}
