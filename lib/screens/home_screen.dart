import 'package:flutter/material.dart';
import 'package:learn5/theme.dart';
import 'package:learn5/screens/words_screen.dart';
import 'package:learn5/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double dailyProgress = 0.4;
  double weeklyProgress = 0.6;
  double monthlyProgress = 0.3;
  double yearlyProgress = 0.1;
  int streakDays = 3; // example value — can be updated dynamically later

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Learn5",
          style: TextStyle(
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
        iconTheme: const IconThemeData(color: Color(0xFF202200), size: 25),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                const Text(
                  "Daily 5 English Words 📚",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(221, 255, 255, 255),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Learn new words every day with Sinhala or Tamil translations.\n"
                  "Understand meanings with examples and track your progress.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(221, 255, 255, 255),
                    fontSize: 15,
                    height: 1.5,
                  ),
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
                        color: Color.fromARGB(255, 255, 255, 255),
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
                      MaterialPageRoute(builder: (_) => const WordsScreen()),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Today's Progress",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: dailyProgress,
                        color: Colors.green,
                        backgroundColor: Colors.grey[300],
                        minHeight: 6,
                      ),
                      const SizedBox(height: 6),
                      Text("${(dailyProgress * 5).round()} of 5 words learned"),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      _buildProgressBar("Daily", dailyProgress, Colors.green),
                      _buildProgressBar(
                        "Weekly",
                        weeklyProgress,
                        Colors.orange,
                      ),
                      _buildProgressBar(
                        "Monthly",
                        monthlyProgress,
                        Colors.blue,
                      ),
                      _buildProgressBar(
                        "Yearly",
                        yearlyProgress,
                        Colors.purple,
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
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label Progress",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: value,
            color: color,
            backgroundColor: Colors.grey[300],
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}
