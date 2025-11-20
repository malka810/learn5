import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/word.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DocumentReference userDoc(String uid) => _db.collection('users').doc(uid);

  // get all words
  Future<List<Word>> getWords() async {
    final snapshot = await _db.collection('words').get();

    return snapshot.docs.map((doc) {
      return Word.fromFirestore(doc.id, doc.data());
    }).toList();
  }

  //save daily words
  Future<void> saveDailyWords(
    String uid,
    String dateId,
    List<Word> words,
  ) async {
    final doc = userDoc(uid).collection('dailyWords').doc(dateId);
    await doc.set({
      'generatedAt': FieldValue.serverTimestamp(),
      'words': words.map((w) => w.toMap()).toList(),
    });
  }

  //load daily words
  Future<List<Word>> loadDailyWords(String uid, String dateId) async {
    final snap = await userDoc(uid).collection('dailyWords').doc(dateId).get();
    if (!snap.exists) return [];
    final data = snap.data()!;
    final list = (data['words'] as List<dynamic>? ?? []);
    return list.map((e) {
      final map = Map<String, dynamic>.from(e);
      return Word.fromMap(Map<String, dynamic>.from(e));
    }).toList();
  }

  //mark word learned
  Future<void> markWordLearned(String uid, Word word) async {
    final learnedRef = userDoc(uid).collection('learned').doc(word.id);

    await learnedRef.set({
      'word': word.word,
      'meaning': word.meaning,
      'learnedAt': FieldValue.serverTimestamp(),
    });
  }

  //unmark word learned
  Future<void> unmarkWordLearned(String uid, String id) async {
    await userDoc(uid).collection('learned').doc(id).delete();
  }

  //get learned words
  Future<List<String>> getLearnedWords(String uid) async {
    final snap = await userDoc(uid).collection('learned').get();
    return snap.docs.map((d) => (d.data()['word'] as String)).toList();
  }

  Future<List<Map<String, dynamic>>> queryHistory(
    String uid,
    DateTime start,
    DateTime end,
  ) async {
    final snap = await userDoc(uid)
        .collection('history')
        .where('ts', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('ts', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .orderBy('ts', descending: true)
        .get();
    return snap.docs.map((d) => d.data() as Map<String, dynamic>).toList();
  }

  Future<int> countLearnedInRange(
    String uid,
    DateTime start,
    DateTime end,
  ) async {
    final snap = await userDoc(uid)
        .collection('history')
        .where('action', isEqualTo: 'learned')
        .where('ts', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('ts', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .get();
    return snap.docs.length;
  }

  Future<void> recordTranslationViewed(
    String uid,
    String word,
    String lang,
  ) async {
    final ref = _db.collection('users').doc(uid).collection('history').doc();
    await ref.set({
      'word': word,
      'action': 'translation_view',
      'lang': lang,
      'ts': FieldValue.serverTimestamp(),
    });
  }

  Future<void> toggleLearned(String uid, Word word) async {
    final learnedRef = userDoc(uid).collection('learned').doc(word.word);
    final doc = await learnedRef.get();

    if (doc.exists) {
      await learnedRef.delete();
    } else {
      await learnedRef.set({
        'word': word.word,
        'meaning': word.meaning,
        'learnedAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> updateWordExample(
    String uid,
    String dateId,
    Word word,
    String newExample,
  ) async {
    final doc = userDoc(uid).collection('dailyWords').doc(dateId);

    await doc.update({
      'words': FieldValue.arrayRemove([word.toMap()]),
    });

    final updated = word.copyWith(example: newExample);

    await doc.update({
      'words': FieldValue.arrayUnion([updated.toMap()]),
    });
  }
}
