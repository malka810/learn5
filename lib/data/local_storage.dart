import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _learnedKey = 'learned_words';
  static const _streakKey = 'learn_streak_date';

  static Future<void> saveLearnedWords(List<String> ids) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setStringList(_learnedKey, ids);
  }

  static Future<List<String>> loadLearnedWords() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getStringList(_learnedKey) ?? [];
  }

  static Future<void> addLearnedWord(String id) async {
    final list = await loadLearnedWords();
    if (!list.contains(id)) {
      list.add(id);
      await saveLearnedWords(list);
    }
  }

  static Future<void> removeLearnedWord(String id) async {
    final list = await loadLearnedWords();
    if (list.contains(id)) {
      list.remove(id);
      await saveLearnedWords(list);
    }
  }

  static Future<void> updateStreakIfNeeded() async {}
}
