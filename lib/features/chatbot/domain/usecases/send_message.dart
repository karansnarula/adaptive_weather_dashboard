import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/error/failures.dart';
import '../entities/chat_message.dart';
import '../repositories/chatbot_repository.dart';

/// Failure emitted when the user has hit their daily message quota. The
/// repository is never even called — the use case short-circuits.
class QuotaExceededFailure extends Failure {
  const QuotaExceededFailure([
    super.message = 'Daily message limit reached.',
  ]);
}

@injectable
class SendMessage {
  final ChatbotRepository _repository;

  const SendMessage(this._repository);

  Future<Either<Failure, ChatMessage>> call({
    required String userMessage,
    required List<ChatMessage> history,
    required String? city,
  }) async {
    final quota = await _repository.getQuota();
    if (quota.isExhausted) {
      return const Left(QuotaExceededFailure());
    }

    final result = await _repository.sendMessage(
      userMessage: userMessage,
      history: history,
      city: city,
    );

    if (result.isRight()) {
      await _repository.incrementQuota();
    }
    return result;
  }
}
