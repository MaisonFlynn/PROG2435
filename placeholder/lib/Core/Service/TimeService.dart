import 'dart:async';
import 'package:flutter/material.dart';
import 'DBService.dart';

class TimeService {
  static Timer? _Timer;
  static Timer? _Countdown;

  static void StartCountdown(ValueNotifier<Duration> countdown) {
    _Countdown?.cancel();
    _Countdown = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day + 1);
      countdown.value = midnight.difference(now);
    });
  }

  static void StartUpdate(String username,
      {required Future<void> Function() Update}) {
    _Timer?.cancel();

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final difference = midnight.difference(now);

    _Timer = Timer(difference, () async {
      await _HandleUpdate(username);
      await Update();
      StartUpdate(username, Update: Update);
    });
  }

  static Future<void> _HandleUpdate(String username) async {
    final user = await DBService.GetUser(username);
    final tasks = await DBService.GetTask(username);
    final completed = tasks.where((t) => t['Chekku'] == 1).length;

    final now = DateTime.now();
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final active =
        user?.active != null ? DateTime.tryParse(user!.active!) : null;

    int hp = user?.hp ?? 10;
    int rank = user?.rank ?? 1;
    int streak = 0;
    String? Active;

    if (completed == 0) {
      hp -= rank;
      if (rank > 1) rank--;
    } else {
      hp += 1;
      if (completed == 5 && rank < 3) rank++;
      streak = (active?.difference(yesterday).inDays == 0)
          ? (user?.streak ?? 0) + 1
          : 1;
      Active = now.toIso8601String();
    }

    await DBService.UpdateHP(username, hp.clamp(1, 10));
    await DBService.UpdateRank(username, rank);
    await DBService.UpdateStreak(username, streak, Active);
    await DBService.DeleteTask(username);
    await DBService.UpdateTask(username, []);
  }

  static void CancelUpdate() {
    _Timer?.cancel();
    _Countdown?.cancel();
  }
}
