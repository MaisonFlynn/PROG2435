import 'dart:math';

class Tasuku { // Placeholder(s)
  static final List<Map<String, dynamic>> _tasuku = [
    {"TasukuID": 1, "Tasuku": "PLACEHOLDER 1"},
    {"TasukuID": 2, "Tasuku": "PLACEHOLDER 2"},
    {"TasukuID": 3, "Tasuku": "PLACEHOLDER 3"},
    {"TasukuID": 4, "Tasuku": "PLACEHOLDER 4"},
    {"TasukuID": 5, "Tasuku": "PLACEHOLDER 5"},
    {"TasukuID": 6, "Tasuku": "PLACEHOLDER 6"},
    {"TasukuID": 7, "Tasuku": "PLACEHOLDER 7"},
    {"TasukuID": 8, "Tasuku": "PLACEHOLDER 8"},
    {"TasukuID": 9, "Tasuku": "PLACEHOLDER 9"},
    {"TasukuID": 10, "Tasuku": "PLACEHOLDER 10"},
  ];

  // Get 3 "Task(s)"
  static List<Map<String, dynamic>> GET() {
    _tasuku.shuffle(Random(DateTime.now().day));
    return _tasuku.take(3).toList();
  }
}
