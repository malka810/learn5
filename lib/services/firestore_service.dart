import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/word.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DocumentReference userDoc(String uid) => _db.collection('users').doc(uid);

  Future<List<Word>> getWords() async {
    final snapshot = await _db.collection('words').get();
    return snapshot.docs
        .map((doc) => Word.fromFirestore(doc.id, doc.data()))
        .toList();
  }

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

  Future<List<Word>> loadDailyWords(String uid, String dateId) async {
    final snap = await userDoc(uid).collection('dailyWords').doc(dateId).get();
    if (!snap.exists) return [];
    final data = snap.data()!;
    final list = (data['words'] as List<dynamic>? ?? []);
    return list.map((e) {
      final map = Map<String, dynamic>.from(e);
      return Word.fromMap(map);
    }).toList();
  }

  Future<void> markWordLearned(String uid, Word word, {String? example}) async {
    final learnedRef = userDoc(uid).collection('learned').doc(word.id);
    await learnedRef.set({
      'word': word.word,
      'meaning': word.meaning,
      'example': example ?? word.example,
      'learnedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> unmarkWordLearned(String uid, String id) async {
    await userDoc(uid).collection('learned').doc(id).delete();
  }

  Future<List<String>> getLearnedWords(String uid) async {
    final snap = await userDoc(uid).collection('learned').get();
    return snap.docs.map((d) => d.id).toList();
  }

  Future<void> addHistoryItem(String uid, String word, String action) async {
    final ref = userDoc(uid).collection('history');
    await ref.add({
      'word': word,
      'action': action,
      'ts': FieldValue.serverTimestamp(),
    });
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
    final ref = userDoc(uid).collection('history').doc();
    await ref.set({
      'word': word,
      'action': 'translation_view',
      'lang': lang,
      'ts': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateWordExample(
    String uid,
    String dateId,
    Word word,
    String newExample,
  ) async {
    final docRef = userDoc(uid).collection('dailyWords').doc(dateId);

    final oldMap = word.toMap();
    final updated = word.copyWith(example: newExample);
    final updatedMap = updated.toMap();

    await docRef.update({
      'words': FieldValue.arrayRemove([oldMap]),
    });

    await docRef.update({
      'words': FieldValue.arrayUnion([updatedMap]),
    });
  }
}
