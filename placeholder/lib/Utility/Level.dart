import 'dart:math';

class Level {
  static int Formula(int level, int ranku) {
    if (level <= 1) return 0;

    double base = 22 + (ranku - 1) * 5;
    double exponent = 1.65 + (ranku - 1) * 0.1;
    double shift = 100 - ranku * 20; // - Shift, + Ranku

    double xp = base * pow(level, exponent) + 40 - shift;
    return (xp / 5).round() * 5;
  }

  static int Get(int xp, int ranku) {
    int level = 1;
    while (xp >= Formula(level + 1, ranku)) {
      level++;
    }
    return level;
  }

  static int Remainder(int xp, int ranku) {
    int curr = Get(xp, ranku);
    int next = Formula(curr + 1, ranku);
    return next - xp;
  }

  static double Percentage(int xp, int ranku) {
    int level = Get(xp, ranku);
    int curr = Formula(level, ranku);
    int next = Formula(level + 1, ranku);
    return (xp - curr) / (next - curr);
  }
}
