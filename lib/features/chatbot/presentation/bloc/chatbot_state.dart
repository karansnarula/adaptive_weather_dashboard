import 'package:equatable/equatable.dart';

import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_quota.dart';

enum ChatbotStatus {
  /// Quota has not been loaded yet — render an empty placeholder.
  initial,

  /// Idle, ready to accept input.
  ready,

  /// Awaiting a Gemini response — show the typing indicator and disable send.
  sending,

  /// User has hit the daily quota — block input, surface the upgrade message.
  quotaExceeded,
}

class ChatbotState extends Equatable {
  final ChatbotStatus status;
  final List<ChatMessage> messages;
  final ChatQuota? quota;
  final String? city;

  /// One-shot error message — when non-null the UI surfaces a SnackBar and
  /// then the BLoC clears it on the next emit so it doesn't re-fire.
  final String? transientError;

  const ChatbotState({
    this.status = ChatbotStatus.initial,
    this.messages = const [],
    this.quota,
    this.city,
    this.transientError,
  });

  ChatbotState copyWith({
    ChatbotStatus? status,
    List<ChatMessage>? messages,
    ChatQuota? quota,
    String? city,
    String? transientError,
    bool clearTransientError = false,
  }) => ChatbotState(
    status: status ?? this.status,
    messages: messages ?? this.messages,
    quota: quota ?? this.quota,
    city: city ?? this.city,
    transientError:
        clearTransientError ? null : (transientError ?? this.transientError),
  );

  @override
  List<Object?> get props => [status, messages, quota, city, transientError];
}
