import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_weather_dashboard/core/error/failures.dart';
import 'package:adaptive_weather_dashboard/features/chatbot/domain/entities/chat_message.dart';
import 'package:adaptive_weather_dashboard/features/chatbot/domain/entities/chat_quota.dart';
import 'package:adaptive_weather_dashboard/features/chatbot/domain/repositories/chatbot_repository.dart';
import 'package:adaptive_weather_dashboard/features/chatbot/domain/usecases/send_message.dart';

class MockChatbotRepository extends Mock implements ChatbotRepository {}

void main() {
  late SendMessage useCase;
  late MockChatbotRepository mockRepository;

  setUp(() {
    mockRepository = MockChatbotRepository();
    useCase = SendMessage(mockRepository);
  });

  final fixedNow = DateTime(2026, 5, 27, 12, 0);

  final freshQuota = ChatQuota(used: 1, resetAt: fixedNow);
  final exhaustedQuota = ChatQuota(
    used: kChatbotDailyMessageLimit,
    resetAt: fixedNow,
  );

  final assistantReply = ChatMessage(
    id: 'msg-1',
    role: ChatRole.assistant,
    text: 'It is sunny in Bangkok today.',
    timestamp: fixedNow,
  );

  test('short-circuits with QuotaExceededFailure when quota is exhausted',
      () async {
    when(() => mockRepository.getQuota()).thenAnswer((_) async => exhaustedQuota);

    final result = await useCase(
      userMessage: 'How is the weather?',
      history: const [],
      city: 'Bangkok',
    );

    expect(result, const Left(QuotaExceededFailure()));
    verify(() => mockRepository.getQuota()).called(1);
    verifyNever(() => mockRepository.sendMessage(
          userMessage: any(named: 'userMessage'),
          history: any(named: 'history'),
          city: any(named: 'city'),
        ));
    verifyNever(() => mockRepository.incrementQuota());
  });

  test('forwards to repository and increments quota on success', () async {
    when(() => mockRepository.getQuota()).thenAnswer((_) async => freshQuota);
    when(() => mockRepository.sendMessage(
          userMessage: any(named: 'userMessage'),
          history: any(named: 'history'),
          city: any(named: 'city'),
        )).thenAnswer((_) async => Right(assistantReply));
    when(() => mockRepository.incrementQuota())
        .thenAnswer((_) async => freshQuota.copyWith(used: 2));

    final result = await useCase(
      userMessage: 'How is the weather?',
      history: const [],
      city: 'Bangkok',
    );

    expect(result, Right(assistantReply));
    verify(() => mockRepository.incrementQuota()).called(1);
  });

  test('does NOT increment quota when LLM call fails', () async {
    when(() => mockRepository.getQuota()).thenAnswer((_) async => freshQuota);
    when(() => mockRepository.sendMessage(
          userMessage: any(named: 'userMessage'),
          history: any(named: 'history'),
          city: any(named: 'city'),
        )).thenAnswer((_) async => const Left(ServerFailure()));

    final result = await useCase(
      userMessage: 'How is the weather?',
      history: const [],
      city: null,
    );

    expect(result, const Left(ServerFailure()));
    verifyNever(() => mockRepository.incrementQuota());
  });
}
