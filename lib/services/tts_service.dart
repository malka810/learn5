import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  static final FlutterTts _tts = FlutterTts();
  static Future<void> init() async {
    await _tts.setSpeechRate(0.45);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
  }

  static Future<void> speak(String text, {String? lang}) async {
    if (lang != null) {
      try {
        await _tts.setLanguage(lang);
      } catch (_) {}
    }
    await _tts.speak(text);
  }

  static Future<void> stop() => _tts.stop();
}
