import 'dart:math';

class Tasuku {
  static final List<Map<String, dynamic>> _tasuku = [
    {"TasukuID": 1, "Tasuku": "BRAINSTORM?", "XP": 10},
    {"TasukuID": 2, "Tasuku": "10-MIN. WALK", "XP": 20},
    {"TasukuID": 3, "Tasuku": "DRINK WATER", "XP": 5},
    {"TasukuID": 4, "Tasuku": "5 PUSH-UPS", "XP": 15},
    {"TasukuID": 5, "Tasuku": "WASH FACE", "XP": 5},
    {"TasukuID": 6, "Tasuku": "BRUSH TEETH", "XP": 5},
    {"TasukuID": 7, "Tasuku": "MAKE BED", "XP": 10},
    {"TasukuID": 8, "Tasuku": "PRAY", "XP": 10},
    {"TasukuID": 9, "Tasuku": "MEDITATE", "XP": 15},
    {"TasukuID": 10, "Tasuku": "READ", "XP": 15},
  ];

  // Get "Task(s)"
  static List<Map<String, dynamic>> GET() {
    _tasuku.shuffle(Random(DateTime.now().day));
    return _tasuku.take(5).toList(); // !
  }
}
