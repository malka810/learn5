import 'package:flutter/material.dart';
import '../models/word.dart';
import 'package:learn5/screens/learning/word_detail_screen.dart';

class WordCard extends StatefulWidget {
  final Word word;
  final VoidCallback? onTap;
  final VoidCallback? onMarkLearned;

  const WordCard({
    super.key,
    required this.word,
    this.onTap,
    this.onMarkLearned,
  });

  @override
  State<WordCard> createState() => _WordCardState();
}

class _WordCardState extends State<WordCard> {
  String _selectedLang = 'si';
  final Map<String, String> langNames = {
    'en': 'English',
    'si': 'Sinhala',
    'ta': 'Tamil',
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Card(
        color: Colors.white,
        shadowColor: Color.fromARGB(255, 35, 34, 0),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,

        child: ListTile(
          title: Text(
            widget.word.word,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          trailing: DropdownButton<String>(
            focusColor: Color(0xFFF5F5DC),
            value: _selectedLang,
            items: langNames.entries
                .map(
                  (e) => DropdownMenuItem(value: e.key, child: Text(e.value)),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) setState(() => _selectedLang = v);
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    WordDetailScreen(word: widget.word, lang: _selectedLang),
              ),
            );
          },
        ),
      ),
    );
  }
}
