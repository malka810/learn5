import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCmd205prCmP6VPFTQ7yGR8Mxo5FJ57pVE",
        authDomain: "learn5-12b00.firebaseapp.com",
        projectId: "learn5-12b00",
        storageBucket: "learn5-12b00.firebasestorage.app",
        messagingSenderId: "870380130321",
        appId: "1:870380130321:web:54b8b888c8f46f59d661b0",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

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
