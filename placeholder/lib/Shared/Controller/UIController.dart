import 'dart:async';
import 'package:flutter/material.dart';
import '../../Core/Service/DBService.dart';
import '../../Core/Utility/TaskDefault.dart';
import '../../Core/Service/AIService.dart';

class UIController {
  final BuildContext context;
  final String username;

  final ValueNotifier<bool> dropdown = ValueNotifier(false);
  final ValueNotifier<List<Map<String, dynamic>>> tasks = ValueNotifier([]);
  final ValueNotifier<List<bool>> check = ValueNotifier([]);
  final ValueNotifier<String> goal = ValueNotifier('❓');
  final ValueNotifier<Duration> countdown = ValueNotifier(Duration.zero);
  final ValueNotifier<bool> throbber = ValueNotifier(true);

  UIController({required this.context, required this.username});

  Future<void> init() async {
    await _GetGoal();
    await GetTask();
    _StartTimer();
  }

  void toggle() => dropdown.value = !dropdown.value;

  Future<void> _GetGoal() async {
    goal.value = await DBService.GetGoal(username) ?? '❓';
  }

  Future<void> UpdateGoal() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(
            child: Text('GŌRU',
                style:
                    TextStyle(fontSize: 34.125, fontWeight: FontWeight.bold))),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: ['💪🏻', '🧠', '🫀'].map((g) {
            return TextButton(
              onPressed: () => Navigator.pop(context, g),
              child: Text(g, style: const TextStyle(fontSize: 28)),
            );
          }).toList(),
        ),
      ),
    );

    if (selected != null && selected != goal.value) {
      await DBService.UpdateGoal(username, selected);
      goal.value = selected;
      await GetTask();
    }
  }

  Future<void> GetTask() async {
    throbber.value = true;
    List<Map<String, dynamic>> data = await DBService.GetTask(username);

    if (data.isEmpty) {
      final user = await DBService.GetUser(username);
      final Default = await TaskDefault.GetTask(username);

      try {
        data = await AIService().Generate(
          ranku: user?.rank ?? 1,
          xp: user?.xp ?? 0,
          chekku: 0,
          goru: goal.value,
        );
      } catch (_) {
        data = Default;
      }

      await DBService.UpdateTask(username, data);
    }

    tasks.value = data;
    check.value = data.map((t) => t['Chekku'] == 1).toList();
    throbber.value = false;
  }

  Future<void> TaskCompleted(int index) async {
    final task = tasks.value[index];
    if (check.value[index]) return;

    await DBService.TaskCompleted(task['TasukuID'], username);
    await GetTask();
  }

  void _StartTimer() {
    Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final midnight = DateTime(now.year, now.month, now.day + 1);
      countdown.value = midnight.difference(now);
    });
  }

  void ConfirmDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(
          child: Text(
            'DELETE?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 34.125,
              color: Colors.black,
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'NO',
              style: TextStyle(
                fontSize: 22.75,
                color: Colors.red,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'YES',
              style: TextStyle(
                fontSize: 22.75,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DBService.DeleteUser(username);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ $username")),
      );
      Navigator.pop(context);
    }
  }

  void Bonus(int streak) {
    final multiplier = (1.0 + streak * 0.1).clamp(1.0, 2.0);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("BŌNASU",
                style:
                    TextStyle(fontSize: 34.125, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Text("×${multiplier.toStringAsFixed(1)} XP",
                style: const TextStyle(color: Colors.green, fontSize: 22.75)),
          ],
        ),
      ),
    );
  }
}
