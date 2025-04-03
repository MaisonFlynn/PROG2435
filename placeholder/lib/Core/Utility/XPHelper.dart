import 'dart:math';

class XPHelper {
  static final _rng = Random();

  static int GetXP(int ranku) {
    switch (ranku) {
      case 1:
        return _rng.nextInt(6) + 5; // 5–10 XP
      case 2:
        return _rng.nextInt(6) + 10; // 10–15 XP
      case 3:
        return _rng.nextInt(6) + 15; // 15–20 XP
      default:
        return 5; // Default
    }
  }
}
