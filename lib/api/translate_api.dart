import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/translation_cache.dart';

class TranslateAPI {
  static Future<String> translate(String text, String to) async {
    if (text.trim().isEmpty) return '';

    final key = TranslationCache.makeKey(text, to);

    final cached = await TranslationCache.getCachedTranslation(key);
    if (cached != null) {
      print("🔵 Using cached translation: $cached");
      return cached;
    }
    try {
      final url =
          'https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=$to&dt=t&q=${Uri.encodeComponent(text)}';
      final resp = await http.get(Uri.parse(url));

      if (resp.statusCode == 200) {
        final body = jsonDecode(resp.body);

        final List parts = body[0] as List;
        final buffer = StringBuffer();

        for (var seg in parts) {
          if (seg is List && seg.isNotEmpty) {
            buffer.write(seg[0]?.toString() ?? '');
          }
        }

        final result = buffer.toString();

        await TranslationCache.setCachedTranslation(key, result);
        return result;
      }

      return 'Translation failed';
    } catch (e) {
      print('TranslateAPI error: $e');
      return 'Translation error';
    }
  }
}
