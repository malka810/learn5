import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TranslationCache {
  static const _langKey = 'last_translation_lang';
  static const _cacheKey = 'translation_cache_v1';

  static Future<String?> getLastLang() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(_langKey);
  }

  static Future<void> setLastLang(String lang) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_langKey, lang);
  }

  static Future<Map<String, String>> _readCache() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_cacheKey);
    if (raw == null) return {};
    try {
      final Map<String, dynamic> json = jsonDecode(raw);
      return json.map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      return {};
    }
  }

  static Future<void> _writeCache(Map<String, String> m) async {
    final sp = await SharedPreferences.getInstance();
    await sp.setString(_cacheKey, jsonEncode(m));
  }

  static Future<String?> getCachedTranslation(String key) async {
    final map = await _readCache();
    return map[key];
  }

  static Future<void> setCachedTranslation(
    String key,
    String translated,
  ) async {
    final map = await _readCache();
    map[key] = translated;
    await _writeCache(map);
  }

  static String makeKey(String wordOrText, String lang) => '$wordOrText|$lang';
}
