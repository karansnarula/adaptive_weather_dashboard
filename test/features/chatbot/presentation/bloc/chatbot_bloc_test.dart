import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:adaptive_weather_dashboard/core/error/failures.dart';
import 'package:adaptive_weather_dashboard/features/chatbot/domain/entities/chat_message.dart';
import 'package:adaptive_weather_dashboard/features/chatbot/domain/entities/chat_quota.dart';
import 'package:adaptive_weather_dashboard/features/chatbot/domain/usecases/get_quota.dart';
import 'package:adaptive_weather_dashboard/features/chatbot/domain/usecases/send_message.dart';
import 'package:adaptive_weather_dashboard/features/chatbot/presentation/bloc/chatbot_bloc.dart';
import 'package:adaptive_weather_dashboard/features/chatbot/presentation/bloc/chatbot_event.dart';
import 'package:adaptive_weather_dashboard/features/chatbot/presentation/bloc/chatbot_state.dart';

class MockSendMessage extends Mock implements SendMessage {}

class MockGetQuota extends Mock implements GetQuota {}

void main() {
  late ChatbotBloc bloc;
  late MockSendMessage mockSendMessage;
  late MockGetQuota mockGetQuota;

  final fixedNow = DateTime(2026, 5, 27, 12, 0);
  final freshQuota = ChatQuota(used: 0, resetAt: fixedNow);
  final exhaustedQuota = ChatQuota(
    used: kChatbotDailyMessageLimit,
    resetAt: fixedNow,
  );

  final assistantReply = ChatMessage(
    id: 'msg-1',
    role: ChatRole.assistant,
    text: 'Pleasant.',
    timestamp: fixedNow,
  );

  setUp(() {
    mockSendMessage = MockSendMessage();
    mockGetQuota = MockGetQuota();
    bloc = ChatbotBloc(mockSendMessage, mockGetQuota);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state is empty ChatbotState', () {
    expect(bloc.state, const ChatbotState());
  });

  test('InitChat loads quota and transitions to ready', () async {
    when(() => mockGetQuota()).thenAnswer((_) async => freshQuota);

    final future = expectLater(
      bloc.stream,
      emits(
        predicate<ChatbotState>(
          (s) =>
              s.status == ChatbotStatus.ready &&
              s.quota == freshQuota &&
              s.city == 'Bangkok',
        ),
      ),
    );

    bloc.add(const InitChat(city: 'Bangkok'));
    await future;
  });

  test('InitChat transitions to quotaExceeded when quota is exhausted',
      () async {
    when(() => mockGetQuota()).thenAnswer((_) async => exhaustedQuota);

    final future = expectLater(
      bloc.stream,
      emits(
        predicate<ChatbotState>(
          (s) => s.status == ChatbotStatus.quotaExceeded,
        ),
      ),
    );

    bloc.add(const InitChat());
    await future;
  });

  test('SendUserMessage emits [sending, ready] on success', () async {
    when(() => mockGetQuota()).thenAnswer((_) async => freshQuota);
    when(() => mockSendMessage(
          userMessage: any(named: 'userMessage'),
          history: any(named: 'history'),
          city: any(named: 'city'),
        )).thenAnswer((_) async => Right(assistantReply));

    bloc.add(const InitChat(city: 'Bangkok'));
    await Future<void>.delayed(Duration.zero);

    final future = expectLater(
      bloc.stream,
      emitsInOrder([
        predicate<ChatbotState>(
          (s) => s.status == ChatbotStatus.sending && s.messages.length == 1,
        ),
        predicate<ChatbotState>(
          (s) => s.status == ChatbotStatus.ready && s.messages.length == 2,
        ),
      ]),
    );

    bloc.add(const SendUserMessage('How is it?'));
    await future;
  });

  test('SendUserMessage emits quotaExceeded when use case rejects', () async {
    when(() => mockGetQuota()).thenAnswer((_) async => freshQuota);
    when(() => mockSendMessage(
          userMessage: any(named: 'userMessage'),
          history: any(named: 'history'),
          city: any(named: 'city'),
        )).thenAnswer((_) async => const Left(QuotaExceededFailure()));

    bloc.add(const InitChat());
    await Future<void>.delayed(Duration.zero);

    final future = expectLater(
      bloc.stream,
      emitsInOrder([
        predicate<ChatbotState>((s) => s.status == ChatbotStatus.sending),
        predicate<ChatbotState>(
          (s) => s.status == ChatbotStatus.quotaExceeded,
        ),
      ]),
    );

    bloc.add(const SendUserMessage('How is it?'));
    await future;
  });

  test('SendUserMessage surfaces transientError on generic failure',
      () async {
    when(() => mockGetQuota()).thenAnswer((_) async => freshQuota);
    when(() => mockSendMessage(
          userMessage: any(named: 'userMessage'),
          history: any(named: 'history'),
          city: any(named: 'city'),
        )).thenAnswer((_) async => const Left(ServerFailure('boom')));

    bloc.add(const InitChat());
    await Future<void>.delayed(Duration.zero);

    final future = expectLater(
      bloc.stream,
      emitsInOrder([
        predicate<ChatbotState>((s) => s.status == ChatbotStatus.sending),
        predicate<ChatbotState>(
          (s) =>
              s.status == ChatbotStatus.ready && s.transientError == 'boom',
        ),
      ]),
    );

    bloc.add(const SendUserMessage('How is it?'));
    await future;
  });

  test('SendUserMessage ignores empty input', () async {
    when(() => mockGetQuota()).thenAnswer((_) async => freshQuota);

    bloc.add(const InitChat());
    await Future<void>.delayed(Duration.zero);
    bloc.add(const SendUserMessage('   '));
    await Future<void>.delayed(Duration.zero);

    verifyNever(() => mockSendMessage(
          userMessage: any(named: 'userMessage'),
          history: any(named: 'history'),
          city: any(named: 'city'),
        ));
  });
}
