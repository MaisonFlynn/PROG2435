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

      print(content);

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
    final Example = {
      'BODY': ['STRETCH', 'RUN', 'HYDRATE'],
      'MIND': ['READ', 'JOURNAL', 'LEARN'],
      'SOUL': ['MEDITATE', 'SMILE', 'PRAY'],
    };

    final Difficulty = {
          1: 'EASY',
          2: 'MED.',
          3: 'HARD',
        }[ranku] ??
        'EASY';

    final Examples = Example[goru.toUpperCase()] ?? Example['ALL']!;
    final ExampleString = Examples.map((e) => '• $e').join('\n');

    return '''
𝐆𝐄𝐍𝐄𝐑𝐀𝐓𝐄 𝟓 $Difficulty 𝐒𝐄𝐋𝐅-𝐂𝐀𝐑𝐄 𝐓𝐀𝐒𝐊𝐒 𝐅𝐎𝐑 𝐔𝐒𝐄𝐑'𝐒 𝐆𝐎𝐀𝐋: $goru

𝐈𝐍𝐒𝐏𝐈𝐑𝐀𝐓𝐈𝐎𝐍:
$ExampleString

𝐈𝐍𝐒𝐓𝐑𝐔𝐂𝐓𝐈𝐎𝐍𝐒:
• UPPERCASE
• MAX 15 CHARACTERS, 2 WORDS
• JSON
• NO EXPLANATION, NO EXTRA TEXT

𝐑𝐄𝐓𝐔𝐑𝐍 𝑶𝑵𝑳𝒀 𝐅𝐎𝐑𝐌𝐀𝐓 𝐉𝐒𝐎𝐍:
[
  {"Task": "TASK 1"},
  {"Task": "TASK 2"},
  {"Task": "TASK 3"},
  {"Task": "TASK 4"},
  {"Task": "TASK 5"}
]
''';
  }
}
