import 'dart:math';
import '../Service/DBService.dart';
import 'XPHelper.dart';

// Backup IF 🚫AI
class TaskDefault {
  static final List<Map<String, dynamic>> _tasuku = [
    // 💪🏻 EASY
    {"TasukuID": 1, "Tasuku": "BRUSH TEETH", "Ranku": 1, "Goru": "💪🏻"},
    {"TasukuID": 2, "Tasuku": "WASH FACE", "Ranku": 1, "Goru": "💪🏻"},
    {"TasukuID": 3, "Tasuku": "SIT STRAIGHT", "Ranku": 1, "Goru": "💪🏻"},
    {"TasukuID": 4, "Tasuku": "TIDY SHOES", "Ranku": 1, "Goru": "💪🏻"},
    {"TasukuID": 5, "Tasuku": "DRINK WATER", "Ranku": 1, "Goru": "💪🏻"},

    // 💪🏻 MED.
    {"TasukuID": 6, "Tasuku": "STRETCH", "Ranku": 2, "Goru": "💪🏻"},
    {"TasukuID": 7, "Tasuku": "PLAN DAY", "Ranku": 2, "Goru": "💪🏻"},
    {"TasukuID": 8, "Tasuku": "WALK 10MIN", "Ranku": 2, "Goru": "💪🏻"},
    {"TasukuID": 9, "Tasuku": "EAT FRUIT", "Ranku": 2, "Goru": "💪🏻"},
    {"TasukuID": 10, "Tasuku": "DEEP BREATHS", "Ranku": 2, "Goru": "💪🏻"},

    // 💪🏻 HARD
    {"TasukuID": 11, "Tasuku": "PUSH-UPS", "Ranku": 3, "Goru": "💪🏻"},
    {"TasukuID": 12, "Tasuku": "COLD SHOWER", "Ranku": 3, "Goru": "💪🏻"},
    {"TasukuID": 13, "Tasuku": "RUN 1KM", "Ranku": 3, "Goru": "💪🏻"},
    {"TasukuID": 14, "Tasuku": "NO SUGAR", "Ranku": 3, "Goru": "💪🏻"},
    {"TasukuID": 15, "Tasuku": "CLEAN ROOM", "Ranku": 3, "Goru": "💪🏻"},

    // 🧠 EASY
    {"TasukuID": 16, "Tasuku": "MAKE BED", "Ranku": 1, "Goru": "🧠"},
    {"TasukuID": 17, "Tasuku": "WIPE DESK", "Ranku": 1, "Goru": "🧠"},
    {"TasukuID": 18, "Tasuku": "OPEN CURTAINS", "Ranku": 1, "Goru": "🧠"},
    {"TasukuID": 19, "Tasuku": "SMILE ONCE", "Ranku": 1, "Goru": "🧠"},
    {"TasukuID": 20, "Tasuku": "WATER PLANT", "Ranku": 1, "Goru": "🧠"},

    // 🧠 MED.
    {"TasukuID": 21, "Tasuku": "READ 5 PAGES", "Ranku": 2, "Goru": "🧠"},
    {"TasukuID": 22, "Tasuku": "MEDITATE", "Ranku": 2, "Goru": "🧠"},
    {"TasukuID": 23, "Tasuku": "WRITE NOTE", "Ranku": 2, "Goru": "🧠"},
    {"TasukuID": 24, "Tasuku": "CLEAN PHONE", "Ranku": 2, "Goru": "🧠"},
    {"TasukuID": 25, "Tasuku": "PRAY", "Ranku": 2, "Goru": "🧠"},

    // 🧠 HARD
    {"TasukuID": 26, "Tasuku": "NO PHONE 1HR", "Ranku": 3, "Goru": "🧠"},
    {"TasukuID": 27, "Tasuku": "SET GOALS", "Ranku": 3, "Goru": "🧠"},
    {"TasukuID": 28, "Tasuku": "BRAINSTORM", "Ranku": 3, "Goru": "🧠"},
    {"TasukuID": 29, "Tasuku": "PLAN WEEK", "Ranku": 3, "Goru": "🧠"},
    {"TasukuID": 30, "Tasuku": "STUDY 30MIN", "Ranku": 3, "Goru": "🧠"},

    // 🫀 EASY
    {"TasukuID": 31, "Tasuku": "PET ANIMAL", "Ranku": 1, "Goru": "🫀"},
    {"TasukuID": 32, "Tasuku": "DEEP BREATH", "Ranku": 1, "Goru": "🫀"},
    {"TasukuID": 33, "Tasuku": "LOOK OUTSIDE", "Ranku": 1, "Goru": "🫀"},
    {"TasukuID": 34, "Tasuku": "HUM A SONG", "Ranku": 1, "Goru": "🫀"},
    {"TasukuID": 35, "Tasuku": "SIT QUIET", "Ranku": 1, "Goru": "🫀"},

    // 🫀 MED.
    {"TasukuID": 36, "Tasuku": "TALK TO FRIEND", "Ranku": 2, "Goru": "🫀"},
    {"TasukuID": 37, "Tasuku": "SHOW GRATITUDE", "Ranku": 2, "Goru": "🫀"},
    {"TasukuID": 38, "Tasuku": "LISTEN MUSIC", "Ranku": 2, "Goru": "🫀"},
    {"TasukuID": 39, "Tasuku": "DOODLE", "Ranku": 2, "Goru": "🫀"},
    {"TasukuID": 40, "Tasuku": "JOURNAL", "Ranku": 2, "Goru": "🫀"},

    // 🫀 HARD
    {"TasukuID": 41, "Tasuku": "CALL FAMILY", "Ranku": 3, "Goru": "🫀"},
    {"TasukuID": 42, "Tasuku": "VOLUNTEER", "Ranku": 3, "Goru": "🫀"},
    {"TasukuID": 43, "Tasuku": "GIVE COMPLIMENT", "Ranku": 3, "Goru": "🫀"},
    {"TasukuID": 44, "Tasuku": "WALK WITH LOVED", "Ranku": 3, "Goru": "🫀"},
    {"TasukuID": 45, "Tasuku": "WRITE LETTER", "Ranku": 3, "Goru": "🫀"},
  ];

  static Future<List<Map<String, dynamic>>> GetTask(String namae) async {
    final rng = Random();
    final user = await DBService.GetUser(namae);
    final int ranku = user?.rank ?? 1;
    final String goru = user?.goal ?? '❓';

    final filtered =
        _tasuku.where((t) => t['Ranku'] == ranku && t['Goru'] == goru).toList();

    filtered.shuffle(rng);
    final selected = filtered.take(5).toList();

    return selected.map((t) {
      return {
        ...t,
        "XP": XPHelper.GetXP(ranku),
      };
    }).toList();
  }
}
