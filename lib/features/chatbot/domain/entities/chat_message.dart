import 'package:equatable/equatable.dart';

/// Author of a chat message.
enum ChatRole { user, assistant }

/// A single message exchanged with the AI weather chatbot.
///
/// Messages live only in memory while the chatbot page is open — they are
/// **not** persisted. Each page visit starts a fresh conversation.
class ChatMessage extends Equatable {
  final String id;
  final ChatRole role;
  final String text;
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.timestamp,
  });

  bool get isUser => role == ChatRole.user;
  bool get isAssistant => role == ChatRole.assistant;

  @override
  List<Object> get props => [id, role, text, timestamp];
}
