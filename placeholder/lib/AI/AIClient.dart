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

    // print('$prompt');

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

      // print(content);

      final RegEx = RegExp(r'\[.*\]', dotAll: true).firstMatch(content);
      if (RegEx == null) throw Exception("⚠️ JSON");

      final JSON = RegEx.group(0)!;
      final List<dynamic> Parse = jsonDecode(JSON);

      return Parse.whereType<Map<String, dynamic>>()
          .map<Map<String, dynamic>>((e) => {
                'TasukuID':
                    DateTime.now().millisecondsSinceEpoch + Parse.indexOf(e),
                'Tasuku':
                    (e['Task'] ?? e['task'])?.toString().toUpperCase() ?? '',
                'XP': XPHelper.GetXP(ranku),
              })
          .where((t) => t['Tasuku'].isNotEmpty)
          .toList();
    } else {
      throw Exception('⚠️ ${response.statusCode}');
    }
  }

  // !
  String Prompt({
    required int ranku,
    required int xp,
    required int chekku,
    required String goru,
  }) {
    String Goal;
    String Example;

    switch (goru) {
      case '💪🏻':
        Goal = 'BODY';
        Example = '''
[
  {"task": "20 SQUATS"},
  {"task": "10 PUSHUPS"},
  {"task": "15 MIN WALK"},
  {"task": "1 MIN PLANK"},
  {"task": "LEG STRETCH"}
]
''';
        break;
      case '🧠':
        Goal = 'MIND';
        Example = '''
[
  {"task": "READ 10 PAGES"},
  {"task": "3 PUZZLES"},
  {"task": "LEARN 1 TOPIC"},
  {"task": "NO PHONE 1H"},
  {"task": "PLAN WEEK"}
]
''';
        break;
      case '🫀':
        Goal = 'SOUL';
        Example = '''
[
  {"task": "GRATITUDE LIST"},
  {"task": "5 MIN MEDITATE"},
  {"task": "LISTEN MUSIC"},
  {"task": "GIVE COMPLIMENT"},
  {"task": "DEEP BREATHS"}
]
''';
        break;
      default:
        Goal = '';
        Example = '''
[
  {"task": "DRINK WATER"},
  {"task": "WALK OUTSIDE"},
  {"task": "STRETCH ARMS"},
  {"task": "EAT FRUIT"},
  {"task": "SLEEP EARLY"}
]
''';
    }

    String Difficulty = {
      1: 'EASY',
      2: 'MED.',
      3: 'HARD',
    }[ranku]!;

    return '''
𝐆𝐄𝐍𝐄𝐑𝐀𝐓𝐄 𝐄𝐗𝐀𝐂𝐓𝐋𝐘 𝟓 𝐔𝐍𝐈𝐐𝐔𝐄 & $Difficulty 𝐒𝐄𝐋𝐅-𝐂𝐀𝐑𝐄 𝐓𝐀𝐒𝐊𝐒 𝐅𝐎𝐑 𝐔𝐒𝐄𝐑'𝐒 𝐆𝐎𝐀𝐋: $Goal

𝐑𝐔𝐋𝐄𝐒:
• ≤ 15 CHARACTERS
• UPPERCASE
• 𝐍𝐎 EXTRA TEXT
• RETURN 𝐎𝐍𝐋𝐘 JSON:

$Example
''';
  }
}
