import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/word.dart';
import '../../services/daily_words_manager.dart';
import '../../services/firestore_service.dart';
import '../../data/words_data.dart';
import '../../widgets/word_card.dart';
import 'word_detail_screen.dart';
import '../../theme.dart';
import '../../data/local_storage.dart';

class WordsScreen extends StatefulWidget {
  const WordsScreen({super.key});

  @override
  State<WordsScreen> createState() => _WordsScreenState();
}

class _WordsScreenState extends State<WordsScreen> {
  final DailyWordsManager _dailyManager = DailyWordsManager();
  final FirestoreService _fs = FirestoreService();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    LocalStorage.updateStreakIfNeeded();
    _load();
  }

  Future<void> _load() async {
    setState(() => isLoading = true);
    final words = await _dailyManager.getOrCreateTodayWords();

    final localLearned = await LocalStorage.loadLearnedWords();

    for (var w in words) {
      if (localLearned.contains(w.word)) {
        w.learned = true;
      }
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final learned = await _fs.getLearnedWords(uid);
      for (var w in words) {
        if (learned.contains(w.word)) w.learned = true;
      }
    }

    WordsData.todayWords = words;
    setState(() => isLoading = false);
  }

  Future<void> _markLearned(Word w) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sign in to save progress')));
      return;
    }

    if (w.learned) return;

    setState(() => w.learned = true);
    //save locally
    final list = await LocalStorage.loadLearnedWords();
    if (!list.contains(w.word)) {
      list.add(w.word);
      await LocalStorage.saveLearnedWords(list);
    }
    //save to cloud
    await _fs.markWordLearned(uid, w);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Marked as learned ✅')));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Daily 5 Words',
            style: TextStyle(
              color: AppTheme.textDark,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              shadows: [
                Shadow(
                  blurRadius: 10,
                  color: Colors.black54,
                  offset: Offset(2, 2),
                ),
              ],
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 227, 255, 113).withOpacity(0.4),
                  const Color.fromARGB(255, 55, 65, 15).withOpacity(0.2),
                ],
                begin: Alignment.topCenter,
                end: Alignment.topRight,
              ),
            ),
          ),
          elevation: 0,
          iconTheme: const IconThemeData(color: AppTheme.primaryDark),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh, color: AppTheme.primaryDark),
              onPressed: _load,
            ),
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryDark),
              )
            : RefreshIndicator(
                color: AppTheme.primaryDark,
                onRefresh: _load,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: WordsData.todayWords.length,
                  itemBuilder: (context, i) {
                    final w = WordsData.todayWords[i];
                    return WordCard(
                      word: w,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                WordDetailScreen(word: w, lang: 'si'),
                          ),
                        ).then((_) => _load());
                      },
                      onMarkLearned: () => _markLearned(w),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
