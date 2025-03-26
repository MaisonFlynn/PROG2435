import 'dart:convert';
import 'package:http/http.dart' as http;

class AIClient {
  final String url = 'http://localhost:11434/api/generate';
  final String model = 'mistral';

  Future<List<Map<String, dynamic>>> Generate({
    required int ranku,
    required int xp,
    required int chekku,
  }) async {
    final prompt = Prompt(ranku: ranku, xp: xp, chekku: chekku);

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'model': model,
        'prompt': prompt,
        'stream': false,
      }),
    );

    if (response.statusCode == 200) {
      print('✅ AI');
      final result = jsonDecode(response.body);
      final content = result['response'].trim();

      // print('$content');

      try {
        final List<dynamic> parsed = jsonDecode(content);
        return parsed
            .map<Map<String, dynamic>>((e) => {
                  'TasukuID':
                      DateTime.now().millisecondsSinceEpoch + parsed.indexOf(e),
                  'Tasuku': e['task'],
                  'XP': e['xp'],
                })
            .toList();
      } catch (e) {
        throw Exception('⚠️ $content');
      }
    } else {
      throw Exception('⚠️ ${response.statusCode}');
    }
  }

  // !
  String Prompt({required int ranku, required int xp, required int chekku}) {
    return '''
      𝐆𝐄𝐍𝐄𝐑𝐀𝐓𝐄 𝟓 𝐒𝐄𝐋𝐅-𝐂𝐀𝐑𝐄 𝐓𝐀𝐒𝐊𝐒!

      𝐃𝐈𝐅𝐅𝐈𝐂𝐔𝐋𝐓𝐘 ${ranku == 1 ? 'EASY' : ranku == 2 ? 'MED' : 'HARD'}

      📝 𝐓𝐀𝐒𝐊
      • ALL CAPS.
      • MAX 15 CHARS.

      🌟 𝐗𝐏
      𝘌𝘈𝘚𝘠 (5–10 XP)
      𝘔𝘌𝘋. (10–15 XP)
      𝘏𝘈𝘙𝘋 (15–20 XP)

      📦 𝐅𝐎𝐑𝐌𝐀𝐓 (JSON)
      [
        {"Tasuku": "DRINK WATER", "XP": 5},
        {"Tasuku": "READ BOOK", "XP": 10}
      ]
    ''';
  }
}
