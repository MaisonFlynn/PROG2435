import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Utility/XP.dart';

class AIClient {
  final String url = 'http://localhost:11434/api/generate';
  final String model = 'mistral';

  Future<List<Map<String, dynamic>>> Generate({
    required int ranku,
    required int xp,
    required int chekku,
    required String goru,
  }) async {
    final prompt = Prompt(ranku: ranku, xp: xp, chekku: chekku, goru: goru);

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
                  'Tasuku': e['Task'],
                  'XP': XPHelper.GetXP(ranku),
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
  String Prompt({required int ranku, required int xp, required int chekku, required String goru}) {
    return '''
      𝐆𝐄𝐍𝐄𝐑𝐀𝐓𝐄 𝟓 𝐒𝐄𝐋𝐅-𝐂𝐀𝐑𝐄 𝐓𝐀𝐒𝐊𝐒 𝐅𝐎𝐑 𝐔𝐒𝐄𝐑'𝐒 𝐆𝐎𝐀𝐋: $goru!

      💪🏻 𝐁𝐎𝐃𝐘 (e.g. EXERCISE, SLEEP, HYDRATION)
      🧠 𝐌𝐈𝐍𝐃 (e.g. MEDITATE, READ, JOURNAL)
      🫀 𝐒𝐎𝐔𝐋 (e.g. SOCIAL, DETOX, CLEAN)

      𝐃𝐈𝐅𝐅𝐈𝐂𝐔𝐋𝐓𝐘 ${ranku == 1 ? 'EASY' : ranku == 2 ? 'MED' : 'HARD'}

      📝 𝐓𝐀𝐒𝐊
      • ALL CAPS.
      • MAX 15 CHARS.

      📦 𝐅𝐎𝐑𝐌𝐀𝐓 (JSON)
      [
        {"Task": "DRINK WATER"},
        {"Task": "READ BOOK"}
      ]
    ''';
  }
}
