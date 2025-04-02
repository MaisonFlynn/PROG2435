import 'package:flutter/material.dart';
import '../Controller/HomeController.dart';

class Body extends StatelessWidget {
  final HomeController controller;
  const Body({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Spacer(),
          Center(
            child: SizedBox(
              child: ValueListenableBuilder<double>(
                valueListenable: controller.hp,
                builder: (_, hp, __) => _HP(hp.toInt()),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              child: ValueListenableBuilder<double>(
                valueListenable: controller.xp,
                builder: (_, xp, __) => _XP(xp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _HP(int hp) {
    return Row(
      children: List.generate(10, (index) {
        bool filled = index < hp;
        return Expanded(
          child: Container(
            height: 50,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: filled ? Colors.red : Colors.black12,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        );
      }),
    );
  }

  Widget _XP(double xpValue) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(6),
      ),
      clipBehavior: Clip.hardEdge,
      child: LinearProgressIndicator(
        value: xpValue.clamp(0.0, 1.0),
        color: Colors.green,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
