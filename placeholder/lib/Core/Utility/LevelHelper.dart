import 'dart:math';

class LevelHelper {
  static int Formula(int level) {
    if (level <= 1) return 0;

    const double base = 25;
    const double exponent = 1.6;
    const double shift = 40;

    double xp = base * pow(level, exponent) + shift;
    return (xp / 5).round() * 5;
  }

  static int GetLevel(int xp) {
    int level = 1;
    while (xp >= Formula(level + 1)) {
      level++;
    }
    return level;
  }

  static int Remainder(int xp) {
    int curr = GetLevel(xp);
    int next = Formula(curr + 1);
    return next - xp;
  }

  static double Percentage(int xp) {
    int level = GetLevel(xp);
    int curr = Formula(level);
    int next = Formula(level + 1);
    return (xp - curr) / (next - curr);
  }
}
