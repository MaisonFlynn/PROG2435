import 'package:flutter/material.dart';
import '../../../Shared/Widget/Header.dart';
import '../../../Shared/Widget/Footer.dart';
import '../Widget/Body.dart';
import '../Controller/HomeController.dart';
import '../../../Shared/Controller/UIController.dart';
import '../../../Shared/Widget/Dropdown.dart';

class Home extends StatefulWidget {
  final String username;
  const Home({super.key, required this.username});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final HomeController Home;
  late final UIController UI;

  @override
  void initState() {
    super.initState();
    Home = HomeController(context: context, username: widget.username);
    UI = UIController(context: context, username: widget.username);
    Home.init();
    UI.init();
  }

  @override
  void dispose() {
    Home.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Header(Home, UI),
              Expanded(child: Body(controller: Home)),
              Footer(controller: Home),
            ],
          ),
          Dropdown(controller: UI),
        ],
      ),
    );
  }
}
