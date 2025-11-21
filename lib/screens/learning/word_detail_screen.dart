import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/word.dart';
import '../../services/firestore_service.dart';
import '../../api/translate_api.dart';
import '../../data/local_storage.dart';
import '../../theme.dart';

class WordDetailScreen extends StatefulWidget {
  final Word word;
  final String lang;

  const WordDetailScreen({super.key, required this.word, required this.lang});

  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  late Word word;
  late String selectedLang;
  String translatedMeaning = '';
  TextEditingController exampleController = TextEditingController();
  bool savingExample = false;
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    word = widget.word;
    exampleController.text = word.example;
    selectedLang = widget.lang;
    _translateWord();
  }

  Future<void> _translateWord() async {
    try {
      final t = await TranslateAPI.translate(word.meaning, selectedLang);
      setState(() => translatedMeaning = t);
    } catch (_) {
      setState(() => translatedMeaning = 'Translation failed');
    }
  }

  Future<void> _toggleLearned() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sign in to save progress')));
      return;
    }

    final localLearned = await LocalStorage.loadLearnedWords();

    if (word.learned) {
      await FirestoreService().unmarkWordLearned(uid, word.id);
      await LocalStorage.removeLearnedWord(word.id);
    } else {
      await FirestoreService().markWordLearned(
        uid,
        word,
        example: exampleController.text,
      );
      await LocalStorage.addLearnedWord(word.id);
      await FirestoreService().addHistoryItem(uid, word.word, 'learned');
    }

    setState(() => word = word.copyWith(learned: !word.learned));
  }

  Future<void> _saveExample() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Sign in to save progress')));
      return;
    }

    if (exampleController.text.isEmpty) return;

    setState(() => savingExample = true);
    try {
      final dateId = DateTime.now().toIso8601String().substring(0, 10);
      await FirestoreService().updateWordExample(
        uid,
        dateId,
        word,
        exampleController.text,
      );

      setState(() {
        word = word.copyWith(example: exampleController.text);
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Example saved!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to save example')));
    } finally {
      setState(() => savingExample = false);
    }
  }

  Future<void> _speak(String text) async {
    await _tts.speak(text);
  }

  void _copyContent() {
    final text =
        '${word.word}\nMeaning: $translatedMeaning\nExample: ${exampleController.text}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Copied to clipboard')));
  }

  void _shareContent() {
    final text =
        '${word.word}\nMeaning: $translatedMeaning\nExample: ${exampleController.text}';
    Share.share(text);
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: AppTheme.primaryDark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
        side: const BorderSide(color: Colors.white, width: 1),
      ),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      elevation: 5,
    );
  }

  @override
  void dispose() {
    _tts.stop();
    exampleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          word.word,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 40, 42, 0),
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 227, 255, 113),
                Color.fromARGB(255, 255, 251, 189),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 69, 93, 55), Color(0xFF021B02)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.volume_up, color: Colors.white),
                    onPressed: () => _speak(word.word),
                  ),
                  IconButton(
                    icon: Icon(
                      word.learned
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      color: word.learned ? Colors.green : Colors.white,
                    ),
                    onPressed: _toggleLearned,
                  ),
                  const Spacer(),
                  DropdownButton<String>(
                    value: selectedLang,
                    dropdownColor: Colors.black87,
                    style: const TextStyle(color: Colors.white),
                    items: const [
                      DropdownMenuItem(value: 'en', child: Text('English')),
                      DropdownMenuItem(value: 'si', child: Text('Sinhala')),
                      DropdownMenuItem(value: 'ta', child: Text('Tamil')),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        setState(() => selectedLang = v);
                        _translateWord();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Meaning',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 6),
              Text(
                translatedMeaning,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              const Text(
                'Example',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: exampleController,
                decoration: const InputDecoration(
                  hintText: 'Add your example here...',
                  hintStyle: TextStyle(color: Colors.white70),
                  border: OutlineInputBorder(),
                ),
                minLines: 2,
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: savingExample ? null : _saveExample,
                style: _buttonStyle(),
                child: savingExample
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : const Text(
                        'Save Example',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _copyContent,
                      icon: const Icon(Icons.copy, color: Colors.white),
                      label: const Text(
                        'Copy',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: _buttonStyle(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _shareContent,
                      icon: const Icon(Icons.share, color: Colors.white),
                      label: const Text(
                        'Share',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: _buttonStyle(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
