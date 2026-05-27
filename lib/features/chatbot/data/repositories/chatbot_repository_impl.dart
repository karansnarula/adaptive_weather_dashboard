import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_quota.dart';
import '../../domain/repositories/chatbot_repository.dart';
import '../datasources/chat_quota_local_data_source.dart';
import '../datasources/gemini_remote_data_source.dart';
import '../models/gemini_request_model.dart';

/// Persona + city-context system prompt sent on every request.
String _buildSystemPrompt(String? city) {
  final base =
      'You are a friendly, knowledgeable weather assistant. Answer questions '
      'about weather, climate, and atmospheric phenomena. Keep responses '
      'concise (2-4 sentences). If a question is unrelated to weather, '
      'politely steer the user back to weather topics.';
  if (city == null || city.trim().isEmpty) {
    return '$base The user has not selected a city yet.';
  }
  return '$base The user is currently viewing weather for $city.';
}

@LazySingleton(as: ChatbotRepository)
class ChatbotRepositoryImpl implements ChatbotRepository {
  final GeminiRemoteDataSource _remoteDataSource;
  final ChatQuotaLocalDataSource _quotaDataSource;

  const ChatbotRepositoryImpl(this._remoteDataSource, this._quotaDataSource);

  @override
  Future<Either<Failure, ChatMessage>> sendMessage({
    required String userMessage,
    required List<ChatMessage> history,
    required String? city,
  }) async {
    try {
      final contents = <GeminiContent>[
        for (final m in history)
          GeminiContent(
            role: m.isUser ? 'user' : 'model',
            parts: [GeminiPart(text: m.text)],
          ),
        GeminiContent(
          role: 'user',
          parts: [GeminiPart(text: userMessage)],
        ),
      ];

      final request = GeminiRequestModel(
        systemInstruction: GeminiContent(
          parts: [GeminiPart(text: _buildSystemPrompt(city))],
        ),
        contents: contents,
      );

      final response = await _remoteDataSource.generateContent(request);
      final text = response.firstText;
      if (text.isEmpty) {
        return const Left(ServerFailure());
      }

      return Right(
        ChatMessage(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          role: ChatRole.assistant,
          text: text,
          timestamp: DateTime.now(),
        ),
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const Left(NetworkFailure());
      }
      return const Left(ServerFailure());
    } catch (_) {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<ChatQuota> getQuota() => _quotaDataSource.read();

  @override
  Future<ChatQuota> incrementQuota() => _quotaDataSource.increment();
}
