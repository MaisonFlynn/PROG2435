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
                builder: (_, xp, __) => XP(xp),
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
}

class XP extends StatefulWidget {
  final double xp;
  const XP(this.xp, {super.key});

  @override
  State<XP> createState() => _XPState();
}

class _XPState extends State<XP> {
  double exp = 0;

  @override
  void didUpdateWidget(covariant XP oldWidget) {
    super.didUpdateWidget(oldWidget);
    exp = oldWidget.xp;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(6),
      ),
      clipBehavior: Clip.hardEdge,
      child: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 500),
        tween: Tween<double>(begin: exp, end: widget.xp),
        builder: (_, value, __) => LinearProgressIndicator(
          value: value.clamp(0.0, 1.0),
          color: Colors.green,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
