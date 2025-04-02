import 'dart:async';
import 'package:flutter/material.dart';
import '../../../Core/Service/DBService.dart';
import '../../../Core/Utility/LevelHelper.dart';

class HomeController {
  final BuildContext context;
  final String username;

  final ValueNotifier<int> level = ValueNotifier(1);
  final ValueNotifier<int> streak = ValueNotifier(0);
  final ValueNotifier<double> xp = ValueNotifier(0);
  final ValueNotifier<double> hp = ValueNotifier(10);
  final ValueNotifier<bool> throbber = ValueNotifier(true);

  Timer? _timer;

  HomeController({required this.context, required this.username});

  void init() async {
    await _GetUser();
    _StartTimer();
  }

  void dispose() => _timer?.cancel();

  Future<void> _GetUser() async {
    final user = await DBService.GetUser(username);
    final XP = user?.xp ?? 0;
    final rank = user?.rank ?? 1;

    level.value = LevelHelper.GetLevel(XP, rank);
    xp.value = LevelHelper.Percentage(XP, rank);
    hp.value = (user?.hp ?? 10).toDouble();
    streak.value = user?.streak ?? 0;
    throbber.value = false;
  }

  void _StartTimer() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final countdown = midnight.difference(now);

    _timer = Timer(countdown, () async {
      await _HandleTimer();
      _StartTimer();
    });
  }

  Future<void> _HandleTimer() async {
    final user = await DBService.GetUser(username);
    final tasks = await DBService.GetTask(username);
    final completed = tasks.where((t) => t['Chekku'] == 1).length;

    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final active =
        user?.active != null ? DateTime.tryParse(user!.active!) : null;

    int HP = user?.hp ?? 10;
    int rank = user?.rank ?? 1;
    int Streak = 0;
    String? Active;

    if (completed == 0) {
      HP -= rank;
      if (rank > 1) rank--;
    } else {
      HP += 1;
      if (completed == 5 && rank < 3) rank++;
      Streak = (active?.difference(yesterday).inDays == 0)
          ? (user?.streak ?? 0) + 1
          : 1;
      Active = now.toIso8601String();
    }

    await DBService.UpdateHP(username, HP.clamp(1, 10));
    await DBService.UpdateRank(username, rank);
    await DBService.UpdateStreak(username, Streak, Active);
    await DBService.DeleteTask(username);
    await DBService.UpdateTask(username, []);
    await _GetUser();
  }
}
