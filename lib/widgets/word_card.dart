import 'package:flutter/material.dart';
import '../models/word.dart';

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
        shadowColor: const Color.fromARGB(255, 35, 34, 0),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: ListTile(
          title: Text(
            widget.word.word,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: _selectedLang,
                items: langNames.entries
                    .map(
                      (e) =>
                          DropdownMenuItem(value: e.key, child: Text(e.value)),
                    )
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedLang = v);
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  widget.word.learned
                      ? Icons.check_circle
                      : Icons.check_circle_outline,
                  color: widget.word.learned ? Colors.green : Colors.grey,
                  size: 28,
                ),
                onPressed: widget.onMarkLearned,
              ),
            ],
          ),
          onTap: widget.onTap,
        ),
      ),
    );
  }
}
