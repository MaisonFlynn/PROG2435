import 'package:flutter/material.dart';
import '../../Feature/Home/Controller/HomeController.dart';
import '../Controller/UIController.dart';
import 'Dropdown.dart';

class Header extends StatelessWidget {
  final HomeController Home;
  final UIController UI;

  const Header(this.Home, this.UI, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black, width: 1)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text("👋🏻 ${Home.username} ",
                      style: const TextStyle(fontSize: 18)),
                  ValueListenableBuilder<int>(
                    valueListenable: Home.level,
                    builder: (_, level, __) => Text(
                      "$level ",
                      style: const TextStyle(fontSize: 18, color: Colors.green),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => UI.Bonus(Home.streak.value),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: ValueListenableBuilder<int>(
                        valueListenable: Home.streak,
                        builder: (_, streak, __) => Text(
                          "$streak",
                          style: const TextStyle(
                              fontSize: 18, color: Colors.orange),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: UI.ConfirmDelete,
                  ),
                  IconButton(
                    icon: ValueListenableBuilder<bool>(
                      valueListenable: UI.dropdown,
                      builder: (_, expanded, __) => Icon(
                        expanded ? Icons.expand_less : Icons.expand_more,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: UI.toggle,
                  ),
                ],
              ),
            ],
          ),
        ),
        Dropdown(controller: UI),
      ],
    );
  }
}
