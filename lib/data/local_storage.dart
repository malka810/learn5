import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _learnedKey = 'learned_words_v1';
  static const _streakKey = 'streak_count';
  static const _lastActiveKey = 'last_active_day';

  static Future<void> saveLearnedWords(List<String> words) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_learnedKey, words);
  }

  static Future<List<String>> loadLearnedWords() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_learnedKey) ?? [];
  }

  static Future<int> updateStreakIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final last = prefs.getString(_lastActiveKey);
    int streak = prefs.getInt(_streakKey) ?? 0;

    if (last == today) {
      return streak;
    }

    if (last == null) {
      streak = 1;
    } else {
      final yesterday = DateTime.now()
          .subtract(const Duration(days: 1))
          .toIso8601String()
          .substring(0, 10);
      if (last == yesterday) {
        streak = streak + 1;
      } else {
        streak = 1;
      }
    }
    await prefs.setString(_lastActiveKey, today);
    await prefs.setInt(_streakKey, streak);
    return streak;
  }

  static Future<int> getStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_streakKey) ?? 0;
  }
}
