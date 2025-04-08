import 'package:flutter/material.dart';
import '../../Feature/Home/Controller/HomeController.dart';

class NewFooter extends StatelessWidget {
  final HomeController controller;
  const NewFooter({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black, width: 1)),
      ),
      child: TabBar(tabs: [
        Tab(
          text: "Home",
          icon: Icon(Icons.home),
        ),
        Tab(
          text: "Map",
          icon: Icon(Icons.map),
        )
      ]),
    );
  }
}
