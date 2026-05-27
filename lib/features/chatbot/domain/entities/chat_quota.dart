import 'package:equatable/equatable.dart';

/// Daily message limit applied to the free chatbot tier. The future paid
/// tier (per the README roadmap) will lift this gate.
const int kChatbotDailyMessageLimit = 3;

/// Snapshot of the user's chatbot quota for the current 24-hour window.
class ChatQuota extends Equatable {
  /// Messages already sent in the current window.
  final int used;

  /// Wall-clock instant when the window resets and [used] returns to zero.
  final DateTime resetAt;

  const ChatQuota({required this.used, required this.resetAt});

  int get remaining {
    final left = kChatbotDailyMessageLimit - used;
    return left < 0 ? 0 : left;
  }

  bool get isExhausted => remaining <= 0;

  ChatQuota copyWith({int? used, DateTime? resetAt}) => ChatQuota(
    used: used ?? this.used,
    resetAt: resetAt ?? this.resetAt,
  );

  @override
  List<Object> get props => [used, resetAt];
}
