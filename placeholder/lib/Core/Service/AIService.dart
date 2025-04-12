import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Utility/XPHelper.dart';

class AIService {
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
  {"task": "STRETCH"},
  {"task": "PUSH-UPS"},
  {"task": "COLD SHOWER"},
  {"task": "WALK 10MIN"},
  {"task": "RUN 1KM"}
]
''';
        break;
      case '🧠':
        Goal = 'MIND';
        Example = '''
[
  {"task": "MEDITATE"},
  {"task": "BRAINSTORM"},
  {"task": "MAKE BED"},
  {"task": "PRAY"},
  {"task": "PLAN WEEK"}
]
''';
        break;
      case '🫀':
        Goal = 'SOUL';
        Example = '''
[
  {"task": "VOLUNTEER"},
  {"task": "CALL FAMILY"},
  {"task": "JOURNAL"},
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
      2: 'MEDIUM',
      3: 'HARD',
    }[ranku]!;

    return '''
Generate 5 SHORT (LESS THAN 15 CHARACTERS), ALL UPPERCASE & UNIQUE Self-Care Tasks FOR User's GOAL: $Goal AND DIFFICULTY: $Difficulty.

RETURN ONLY JSON!

EXAMPLE:
$Example
''';
  }
}
