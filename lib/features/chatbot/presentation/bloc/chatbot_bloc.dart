import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/get_quota.dart';
import '../../domain/usecases/send_message.dart';
import 'chatbot_event.dart';
import 'chatbot_state.dart';

@injectable
class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  final SendMessage _sendMessage;
  final GetQuota _getQuota;

  ChatbotBloc(this._sendMessage, this._getQuota)
      : super(const ChatbotState()) {
    on<InitChat>(_onInit);
    on<SendUserMessage>(_onSendUserMessage);
  }

  Future<void> _onInit(InitChat event, Emitter<ChatbotState> emit) async {
    final quota = await _getQuota();
    emit(
      ChatbotState(
        status: quota.isExhausted
            ? ChatbotStatus.quotaExceeded
            : ChatbotStatus.ready,
        messages: const [],
        quota: quota,
        city: event.city,
      ),
    );
  }

  Future<void> _onSendUserMessage(
    SendUserMessage event,
    Emitter<ChatbotState> emit,
  ) async {
    final trimmed = event.text.trim();
    if (trimmed.isEmpty) return;
    if (state.status == ChatbotStatus.sending) return;
    if (state.status == ChatbotStatus.quotaExceeded) return;

    final userMessage = ChatMessage(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      role: ChatRole.user,
      text: trimmed,
      timestamp: DateTime.now(),
    );

    final history = List<ChatMessage>.from(state.messages);

    emit(
      state.copyWith(
        status: ChatbotStatus.sending,
        messages: [...history, userMessage],
        clearTransientError: true,
      ),
    );

    final result = await _sendMessage(
      userMessage: trimmed,
      history: history,
      city: state.city,
    );

    await result.fold(
      (failure) async {
        final isQuota = failure is QuotaExceededFailure;
        final freshQuota = await _getQuota();
        emit(
          state.copyWith(
            status: isQuota ? ChatbotStatus.quotaExceeded : ChatbotStatus.ready,
            quota: freshQuota,
            transientError: isQuota ? null : failure.message,
          ),
        );
      },
      (assistantMessage) async {
        final freshQuota = await _getQuota();
        emit(
          state.copyWith(
            status: freshQuota.isExhausted
                ? ChatbotStatus.quotaExceeded
                : ChatbotStatus.ready,
            messages: [...state.messages, assistantMessage],
            quota: freshQuota,
            clearTransientError: true,
          ),
        );
      },
    );
  }
}
