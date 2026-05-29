import 'package:injectable/injectable.dart';

import '../entities/chat_quota.dart';
import '../repositories/chatbot_repository.dart';

@injectable
class GetQuota {
  final ChatbotRepository _repository;

  const GetQuota(this._repository);

  Future<ChatQuota> call() => _repository.getQuota();
}
