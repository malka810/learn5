import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(const Learn5App());
}

class Learn5App extends StatelessWidget {
  const Learn5App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn5',
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}
