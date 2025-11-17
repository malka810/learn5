import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learn5/theme.dart';
import 'package:learn5/services/firestore_service.dart';
import 'package:learn5/services/daily_words_manager.dart';
import 'package:learn5/screens/learning/words_screen.dart';
import 'package:learn5/widgets/progress_card.dart';
import 'package:learn5/data/words_data.dart';
import 'package:learn5/screens/history_screen.dart'; // <-- ADDED

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DailyWordsManager _dailyManager = DailyWordsManager();
  final FirestoreService _fs = FirestoreService();

  double dailyProgress = 0;
  double weeklyProgress = 0;
  double monthlyProgress = 0;
  double yearlyProgress = 0;
  int streakDays = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _refreshAll();
  }

  Future<void> _refreshAll() async {
    setState(() => loading = true);

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await _dailyManager.getOrCreateTodayWords();
      final uid = user.uid;

      final todayStart = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      );
      final todayCount = await _fs.countLearnedInRange(
        uid,
        todayStart,
        DateTime.now(),
      );

      dailyProgress = (WordsData.todayWords.isEmpty)
          ? 0
          : (todayCount / WordsData.todayWords.length);

      final weekStart = DateTime.now().subtract(const Duration(days: 7));
      final weekCount = await _fs.countLearnedInRange(
        uid,
        weekStart,
        DateTime.now(),
      );
      weeklyProgress = weekCount / (5 * 7);

      final monthStart = DateTime.now().subtract(const Duration(days: 30));
      final monthCount = await _fs.countLearnedInRange(
        uid,
        monthStart,
        DateTime.now(),
      );
      monthlyProgress = monthCount / (5 * 30);

      final yearStart = DateTime.now().subtract(const Duration(days: 365));
      final yearCount = await _fs.countLearnedInRange(
        uid,
        yearStart,
        DateTime.now(),
      );
      yearlyProgress = yearCount / (5 * 365);

      int streak = 0;
      for (int i = 0; i < 365; i++) {
        final day = DateTime.now().subtract(Duration(days: i));
        final start = DateTime(day.year, day.month, day.day);
        final end = start.add(const Duration(days: 1));
        final count = await _fs.countLearnedInRange(uid, start, end);

        if (count > 0) {
          streak++;
        } else {
          break;
        }
      }
      streakDays = streak;
    }

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Learn5",
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
        iconTheme: const IconThemeData(color: Color(0xFF202200), size: 25),
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

        // -----------------------
        // ADDED HISTORY BUTTON
        // -----------------------
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HistoryScreen()),
              );
            },
          ),
        ],
      ),

      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "Daily 5 English Words 📚",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        "Learn new words every day with Sinhala or Tamil translations.\n"
                        "Understand meanings with examples and track your progress.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      ),

                      const SizedBox(height: 40),

                      Container(
                        padding: const EdgeInsets.all(20),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.asset(
                            'assets/images/home_image.png',
                            height: 200,
                            fit: BoxFit.contain,
                            colorBlendMode: BlendMode.modulate,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(13),
                            side: const BorderSide(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          elevation: 5,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const WordsScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Start Learning",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Your Learning Progress 📊",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 15),
                            ProgressCard(
                              label: "Daily",
                              value: dailyProgress,
                              color: Colors.green,
                            ),
                            ProgressCard(
                              label: "Weekly",
                              value: weeklyProgress,
                              color: Colors.orange,
                            ),
                            ProgressCard(
                              label: "Monthly",
                              value: monthlyProgress,
                              color: Colors.blue,
                            ),
                            ProgressCard(
                              label: "Yearly",
                              value: yearlyProgress,
                              color: Colors.purple,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.local_fire_department,
                            color: Colors.orange,
                            size: 28,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "$streakDays-Day Streak!",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Keep learning daily to maintain your streak 🔥",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryDark,
        child: const Icon(Icons.refresh),
        onPressed: _refreshAll,
      ),
    );
  }
}
