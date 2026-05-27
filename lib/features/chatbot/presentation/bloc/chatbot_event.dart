import 'package:equatable/equatable.dart';

sealed class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object?> get props => [];
}

/// Fired once when the chatbot page opens. Carries the optional city context
/// from the route query parameter and triggers the initial quota read.
class InitChat extends ChatbotEvent {
  final String? city;

  const InitChat({this.city});

  @override
  List<Object?> get props => [city];
}

/// User tapped the send button (or pressed Enter on desktop).
class SendUserMessage extends ChatbotEvent {
  final String text;

  const SendUserMessage(this.text);

  @override
  List<Object> get props => [text];
}
