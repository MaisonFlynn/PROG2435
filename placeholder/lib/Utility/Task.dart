import 'dart:math';
import '../DB/DBHelper.dart';
import 'XP.dart';

// Backup IF 🚫AI
class Tasuku {
  static final List<Map<String, dynamic>> _tasuku = [
    // Ranku 1 (𝘌𝘢𝘴𝘺)
    {"TasukuID": 1, "Tasuku": "BRUSH TEETH", "Ranku": 1},
    {"TasukuID": 2, "Tasuku": "DRINK WATER", "Ranku": 1},
    {"TasukuID": 3, "Tasuku": "MAKE BED", "Ranku": 1},
    {"TasukuID": 4, "Tasuku": "WASH FACE","Ranku": 1},
    {"TasukuID": 5, "Tasuku": "OPEN CURTAINS", "Ranku": 1},
    {"TasukuID": 6, "Tasuku": "TIDY SHOES", "Ranku": 1},
    {"TasukuID": 7, "Tasuku": "SIT STRAIGHT", "Ranku": 1},
    {"TasukuID": 8, "Tasuku": "SMILE ONCE", "Ranku": 1},
    {"TasukuID": 9, "Tasuku": "WIPE DESK", "Ranku": 1},
    {"TasukuID": 10, "Tasuku": "WATER PLANT", "Ranku": 1},

    // Ranku 2 (𝘔𝘦𝘥.)
    {"TasukuID": 11, "Tasuku": "10-MIN WALK", "Ranku": 2},
    {"TasukuID": 12, "Tasuku": "MEDITATE", "Ranku": 2},
    {"TasukuID": 13, "Tasuku": "PRAY", "Ranku": 2},
    {"TasukuID": 14, "Tasuku": "READ 5 PAGES", "Ranku": 2},
    {"TasukuID": 15, "Tasuku": "STRETCH", "Ranku": 2},
    {"TasukuID": 16, "Tasuku": "PLAN DAY", "Ranku": 2},
    {"TasukuID": 17, "Tasuku": "CLEAN PHONE", "Ranku": 2},
    {"TasukuID": 18, "Tasuku": "WRITE NOTE", "Ranku": 2},
    {"TasukuID": 19, "Tasuku": "EAT FRUIT", "Ranku": 2},
    {"TasukuID": 20, "Tasuku": "DEEP BREATHS", "Ranku": 2},

    // Ranku 3 (𝘏𝘢𝘳𝘥)
    {"TasukuID": 21, "Tasuku": "10 PUSH-UPS", "Ranku": 3},
    {"TasukuID": 22, "Tasuku": "BRAINSTORM", "Ranku": 3},
    {"TasukuID": 23, "Tasuku": "NO PHONE 1HR", "Ranku": 3},
    {"TasukuID": 24, "Tasuku": "COLD SHOWER", "Ranku": 3},
    {"TasukuID": 25, "Tasuku": "CLEAN ROOM", "Ranku": 3},
    {"TasukuID": 26, "Tasuku": "SET GOALS", "Ranku": 3},
    {"TasukuID": 27, "Tasuku": "CALL FAMILY", "Ranku": 3},
    {"TasukuID": 28, "Tasuku": "NO SUGAR", "Ranku": 3},
    {"TasukuID": 29, "Tasuku": "RUN 1KM", "Ranku": 3},
    {"TasukuID": 30, "Tasuku": "GO OUTSIDE", "Ranku": 3},
  ];

  static Future<List<Map<String, dynamic>>> GET(String namae) async {
    final rng = Random(DateTime.now().day);
    final yuza = await DBHelper.GET_USER(namae);
    final int ranku = yuza?['Ranku'] ?? 1;

    List<Map<String, dynamic>> filter =
        _tasuku.where((t) => t["Ranku"] == ranku).toList();

    filter.shuffle(rng);

    final select = filter.take(5).toList();

    return select.map((t) {
      return {
        ...t,
        "XP": XPHelper.GetXP(ranku),
      };
    }).toList();
  }
}