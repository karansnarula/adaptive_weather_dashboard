import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/chat_message.dart';
import '../entities/chat_quota.dart';

/// Boundary between the chatbot's domain layer and any concrete LLM /
/// persistence wiring in the data layer.
abstract class ChatbotRepository {
  /// Send the latest user message (plus all prior in-memory [history] for
  /// context) to the LLM and return the assistant's reply.
  ///
  /// [city] is the user's most recently searched city, when one is known.
  /// When `null`, the chatbot operates as a generic weather assistant.
  Future<Either<Failure, ChatMessage>> sendMessage({
    required String userMessage,
    required List<ChatMessage> history,
    required String? city,
  });

  /// Load the current daily message quota, rolling the 24-hour window
  /// forward if the previous one has expired.
  Future<ChatQuota> getQuota();

  /// Atomically increment the used-message count for the current window.
  /// Called from the use case after a successful LLM response.
  Future<ChatQuota> incrementQuota();
}
