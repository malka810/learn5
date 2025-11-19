import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../services/firestore_service.dart';
import '../models/history_item.dart';
import '../theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String filter = 'day';
  bool loading = false;
  List<HistoryItem> entries = [];
  final FirestoreService _fs = FirestoreService();

  @override
  void initState() {
    super.initState();
    _load();
  }

  DateTime _rangeStart() {
    final now = DateTime.now();
    switch (filter) {
      case 'day':
        return DateTime(now.year, now.month, now.day);
      case 'week':
        return now.subtract(const Duration(days: 7));
      case 'month':
        return now.subtract(const Duration(days: 30));
      case 'year':
        return now.subtract(const Duration(days: 365));
      default:
        return DateTime(now.year, now.month, now.day);
    }
  }

  Future<void> _load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    setState(() => loading = true);

    final start = _rangeStart();
    final end = DateTime.now();
    final res = await _fs.queryHistory(uid, start, end);

    setState(() {
      entries = res.map((e) {
        final ts = e['ts'];
        DateTime date;
        if (ts is Timestamp) {
          date = ts.toDate();
        } else if (ts is DateTime) {
          date = ts;
        } else {
          date = DateTime.now();
        }

        return HistoryItem(
          word: e['word'] ?? '',
          action: e['action'] ?? '',
          date: date,
        );
      }).toList();
      loading = false;
    });
  }

  String _formatTs(DateTime date) {
    return DateFormat.yMd().add_jm().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "History",
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(255, 40, 42, 0),
            letterSpacing: 1.5,
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

        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              setState(() => filter = v);
              _load();
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'day', child: Text('Day')),
              PopupMenuItem(value: 'week', child: Text('Week')),
              PopupMenuItem(value: 'month', child: Text('Month')),
              PopupMenuItem(value: 'year', child: Text('Year')),
            ],
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : entries.isEmpty
            ? const Center(
                child: Text(
                  'No history here yet',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: entries.length,
                itemBuilder: (c, i) {
                  final e = entries[i];
                  return Card(
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(
                        e.word,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        '${e.action} • ${_formatTs(e.date)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
