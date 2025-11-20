import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryDark = Color(0xFF202200);
  static const Color textDark = Color(0xFF282A00);
  static const Color lightCream = Color(0xFFFDFCBE);

  static const LinearGradient mainGradient = LinearGradient(
    colors: [Color(0xFF2C3000), Color(0xFFF8FFDD), Color(0xFFE3FF71)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static final ButtonStyle mainButton = ElevatedButton.styleFrom(
    backgroundColor: primaryDark,
    padding: const EdgeInsets.symmetric(horizontal: 45, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: const BorderSide(color: lightCream, width: 1.5),
    ),
    elevation: 10,
  );

  static const TextStyle titleStyle = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: textDark,
    letterSpacing: 1.5,
    shadows: [Shadow(blurRadius: 10, color: lightCream, offset: Offset(4, 4))],
  );

  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: textDark,
  );

  static const TextStyle labelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black87,
  );

  static const TextStyle bodyText = TextStyle(fontSize: 18, color: textDark);
}
