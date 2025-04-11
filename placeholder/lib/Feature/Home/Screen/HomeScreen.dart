import 'package:flutter/material.dart';
import 'package:placeholder/Feature/Home/Widget/API.dart';
import 'package:placeholder/Shared/Widget/Footer.dart';
import '../../../Shared/Widget/Header.dart';
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
  int _Index = 0;

  @override
  void initState() {
    super.initState();
    Home = HomeController(context: context, username: widget.username);
    UI = UIController(context: context, username: widget.username, home: Home);
    Home.init();
    UI.init();
  }

  void _Select(int index) {
    setState(() {
      _Index = index;
    });
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
              Expanded(
                child: _Index == 0
                    ? ValueListenableBuilder<UniqueKey>(
                        valueListenable: Home.Key,
                        builder: (_, key, __) =>
                            Body(key: key, controller: Home),
                      )
                    : MapBody(controller: Home),
              ),
              Footer(
                controller: Home,
                currentIndex: _Index,
                onTabSelected: _Select,
              ),
            ],
          ),
          Dropdown(controller: UI),
        ],
      ),
    );
  }
}
