import 'package:flutter/material.dart';
import '../Controller/UIController.dart';

class Dropdown extends StatelessWidget {
  final UIController controller;
  const Dropdown({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.dropdown,
      builder: (_, toggled, __) {
        if (!toggled) {
          return const SizedBox.shrink();
        }

        return Positioned(
          top: 60,
          left: 0,
          right: 0,
          bottom: 60,
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "TASUKU ",
                      style: TextStyle(
                          fontSize: 45.5, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: controller.UpdateGoal,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: ValueListenableBuilder<String>(
                          valueListenable: controller.goal,
                          builder: (_, goru, __) => Text(
                            goru,
                            style: const TextStyle(fontSize: 34.125),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: controller.throbber,
                    builder: (_, loading, __) {
                      if (loading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.black),
                        );
                      }

                      final taskList = controller.tasks.value;
                      final checkList = controller.check.value;

                      return ListView.builder(
                        itemCount: taskList.length,
                        itemBuilder: (_, index) => Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: SizedBox(
                              width: 300,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: checkList[index]
                                    ? null
                                    : () => controller.TaskCompleted(index),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      taskList[index]['Tasuku'],
                                      style: const TextStyle(
                                        fontSize: 18.2,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "${taskList[index]['XP']} XP",
                                      style: const TextStyle(
                                        fontSize: 18.2,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ValueListenableBuilder<Duration>(
                  valueListenable: controller.countdown,
                  builder: (_, time, __) => Text(
                    "${time.inHours.toString().padLeft(2, '0')}:"
                    "${(time.inMinutes % 60).toString().padLeft(2, '0')}:"
                    "${(time.inSeconds % 60).toString().padLeft(2, '0')}",
                    style: const TextStyle(
                      fontSize: 45.5,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
