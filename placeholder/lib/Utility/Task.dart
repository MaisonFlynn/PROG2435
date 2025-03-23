import 'dart:math';
import '../DB/DBHelper.dart';

class Tasuku {
  static final List<Map<String, dynamic>> _tasuku = [
    // Ranku 1 (𝘌𝘢𝘴𝘺)
    {"TasukuID": 1, "Tasuku": "BRUSH TEETH", "XP": 5, "Ranku": 1},
    {"TasukuID": 2, "Tasuku": "DRINK WATER", "XP": 5, "Ranku": 1},
    {"TasukuID": 3, "Tasuku": "MAKE BED", "XP": 10, "Ranku": 1},
    {"TasukuID": 4, "Tasuku": "WASH FACE", "XP": 5, "Ranku": 1},
    {"TasukuID": 5, "Tasuku": "OPEN CURTAINS", "XP": 5, "Ranku": 1},
    {"TasukuID": 6, "Tasuku": "TIDY SHOES", "XP": 5, "Ranku": 1},
    {"TasukuID": 7, "Tasuku": "SIT STRAIGHT", "XP": 5, "Ranku": 1},
    {"TasukuID": 8, "Tasuku": "SMILE ONCE", "XP": 5, "Ranku": 1},
    {"TasukuID": 9, "Tasuku": "WIPE DESK", "XP": 5, "Ranku": 1},
    {"TasukuID": 10, "Tasuku": "WATER PLANT", "XP": 5, "Ranku": 1},

    // Ranku 2 (𝘔𝘦𝘥.)
    {"TasukuID": 11, "Tasuku": "10-MIN WALK", "XP": 20, "Ranku": 2},
    {"TasukuID": 12, "Tasuku": "MEDITATE", "XP": 15, "Ranku": 2},
    {"TasukuID": 13, "Tasuku": "PRAY", "XP": 10, "Ranku": 2},
    {"TasukuID": 14, "Tasuku": "READ 5 PAGES", "XP": 15, "Ranku": 2},
    {"TasukuID": 15, "Tasuku": "STRETCH", "XP": 10, "Ranku": 2},
    {"TasukuID": 16, "Tasuku": "PLAN DAY", "XP": 15, "Ranku": 2},
    {"TasukuID": 17, "Tasuku": "CLEAN PHONE", "XP": 10, "Ranku": 2},
    {"TasukuID": 18, "Tasuku": "WRITE NOTE", "XP": 15, "Ranku": 2},
    {"TasukuID": 19, "Tasuku": "EAT FRUIT", "XP": 15, "Ranku": 2},
    {"TasukuID": 20, "Tasuku": "DEEP BREATHS", "XP": 15, "Ranku": 2},

    // Ranku 3 (𝘏𝘢𝘳𝘥)
    {"TasukuID": 21, "Tasuku": "10 PUSH-UPS", "XP": 15, "Ranku": 3},
    {"TasukuID": 22, "Tasuku": "BRAINSTORM", "XP": 10, "Ranku": 3},
    {"TasukuID": 23, "Tasuku": "NO PHONE 1HR", "XP": 25, "Ranku": 3},
    {"TasukuID": 24, "Tasuku": "COLD SHOWER", "XP": 25, "Ranku": 3},
    {"TasukuID": 25, "Tasuku": "CLEAN ROOM", "XP": 20, "Ranku": 3},
    {"TasukuID": 26, "Tasuku": "SET GOALS", "XP": 20, "Ranku": 3},
    {"TasukuID": 27, "Tasuku": "CALL FAMILY", "XP": 15, "Ranku": 3},
    {"TasukuID": 28, "Tasuku": "NO SUGAR", "XP": 30, "Ranku": 3},
    {"TasukuID": 29, "Tasuku": "RUN 1KM", "XP": 30, "Ranku": 3},
    {"TasukuID": 30, "Tasuku": "GO OUTSIDE", "XP": 20, "Ranku": 3},
  ];

  static Future<List<Map<String, dynamic>>> GET(String namae) async {
    final RNG = Random(DateTime.now().day);

    final yuza = await DBHelper.GET_USER(namae);
    final int ranku = yuza?['Ranku'] ?? 1;

    List<Map<String, dynamic>> filter =
        _tasuku.where((t) => t["Ranku"] == ranku).toList();

    filter.shuffle(RNG);

    return filter.take(5).toList();
  }
}
