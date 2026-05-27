import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/chat_quota.dart';

/// Persists the daily chatbot message quota in [SharedPreferences].
///
/// Two keys are managed:
/// * [_countKey] — messages consumed in the current 24-hour window.
/// * [_resetAtKey] — millis-since-epoch when the window resets.
///
/// On every read, if the wall clock has passed [_resetAtKey] the window is
/// rolled forward and the count is reset to zero before returning.
@lazySingleton
class ChatQuotaLocalDataSource {
  static const _countKey = 'chatbot_message_count';
  static const _resetAtKey = 'chatbot_quota_reset_at';
  static const Duration _window = Duration(hours: 24);

  final SharedPreferences _prefs;

  const ChatQuotaLocalDataSource(this._prefs);

  Future<ChatQuota> read() async {
    final now = DateTime.now();
    final storedResetMillis = _prefs.getInt(_resetAtKey) ?? 0;
    var resetAt = DateTime.fromMillisecondsSinceEpoch(storedResetMillis);
    var used = _prefs.getInt(_countKey) ?? 0;

    if (storedResetMillis == 0 || !now.isBefore(resetAt)) {
      resetAt = now.add(_window);
      used = 0;
      await _prefs.setInt(_resetAtKey, resetAt.millisecondsSinceEpoch);
      await _prefs.setInt(_countKey, used);
    }

    return ChatQuota(used: used, resetAt: resetAt);
  }

  Future<ChatQuota> increment() async {
    final current = await read();
    final next = current.copyWith(used: current.used + 1);
    await _prefs.setInt(_countKey, next.used);
    return next;
  }
}
