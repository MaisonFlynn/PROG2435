import 'package:flutter/material.dart';
import 'package:placeholder/Feature/Home/Widget/MapBody.dart';
import 'package:placeholder/Shared/Widget/NewFooter.dart';
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

  @override
  void initState() {
    super.initState();
    Home = HomeController(context: context, username: widget.username);
    UI = UIController(context: context, username: widget.username, home: Home);
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Stack(
          children: [
            Column(
              children: [
                Header(Home, UI),
                Expanded(
                    // Tab bar view is necessary to switch between the different screens
                    child: TabBarView(children: [
                  Body(controller: Home),
                  MapBody(controller: Home)
                ])),
                // New footer made with the TabBar
                NewFooter(controller: Home),
              ],
            ),
            Dropdown(controller: UI),
          ],
        ),
      ),
    );
  }
}
