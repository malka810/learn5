import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import '../api/words_api.dart';
import '../models/word.dart';

class DailyWordsManager {
  final FirestoreService _fs = FirestoreService();

  String todayId() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  Future<List<Word>> getOrCreateTodayWords({int count = 5}) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final uid = user.uid;
    final id = todayId();

    final existing = await _fs.loadDailyWords(uid, id);
    if (existing.isNotEmpty) return existing;

    final apiResults = await WordsApi.fetchDailyWords(count: count);

    final words = apiResults.map<Word>((item) {
      final wordText = item['word']?.toString() ?? '';

      String meaning = '';
      String example = '';
      List<String> syn = [];
      List<String> ant = [];

      try {
        final meanings = item['meanings'] as List<dynamic>?;
        if (meanings != null && meanings.isNotEmpty) {
          final firstMeaning = meanings.first as Map<String, dynamic>?;
          if (firstMeaning != null) {
            final defs = firstMeaning['definitions'] as List<dynamic>?;
            if (defs != null && defs.isNotEmpty) {
              final def = defs.first as Map<String, dynamic>?;
              if (def != null) {
                meaning = def['definition']?.toString() ?? '';
                example = def['example']?.toString() ?? '';
                final synList = def['synonyms'];
                if (synList is List)
                  syn = synList.map((e) => e.toString()).toList();
                final antList = def['antonyms'];
                if (antList is List)
                  ant = antList.map((e) => e.toString()).toList();
              }
            }
          }
        }
      } catch (_) {}

      return Word(
        id: wordText,
        word: wordText,
        meaning: meaning,
        example: example,
        synonyms: syn,
        antonyms: ant,
      );
    }).toList();

    await _fs.saveDailyWords(uid, id, words);
    return words;
  }
}
