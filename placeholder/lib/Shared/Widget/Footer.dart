import 'package:flutter/material.dart';
import '../../Feature/Home/Controller/HomeController.dart';

class Footer extends StatelessWidget {
  final HomeController controller;
  const Footer({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                border:
                    Border(right: BorderSide(color: Colors.black, width: 1)),
              ),
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  padding: EdgeInsets.zero,
                ),
                child: const Center(
                  child: Icon(Icons.home, color: Colors.black),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              child: TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  padding: EdgeInsets.zero,
                ),
                child: const Center(
                  child: Icon(Icons.map, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
