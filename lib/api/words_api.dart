import 'dart:convert';
import 'package:http/http.dart' as http;

class WordsApi {
  static Future<List<Map<String, dynamic>>> fetchDailyWords({
    int count = 5,
  }) async {
    try {
      final randomResp = await http.get(
        Uri.parse('https://random-word-api.vercel.app/api?words=$count'),
      );

      if (randomResp.statusCode != 200) return [];

      final List<dynamic> words = jsonDecode(randomResp.body);
      final List<Map<String, dynamic>> results = [];

      for (final w in words) {
        final resp = await http.get(
          Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$w'),
        );

        if (resp.statusCode == 200) {
          final data = jsonDecode(resp.body);

          if (data is List && data.isNotEmpty) {
            results.add(data[0]);
          }
        }
      }

      return results;
    } catch (e) {
      print('WordsApi error: $e');
      return [];
    }
  }
}
