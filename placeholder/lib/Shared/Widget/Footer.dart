import 'package:flutter/material.dart';
import '../../Feature/Home/Controller/HomeController.dart';

class Footer extends StatelessWidget {
  final HomeController controller;
  final Function(int) onTabSelected;
  final int currentIndex;

  const Footer({
    super.key,
    required this.controller,
    required this.onTabSelected,
    required this.currentIndex,
  });

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
              decoration: BoxDecoration(
                color: Colors.white,
                border: const Border(
                  right: BorderSide(color: Colors.black, width: 1),
                ),
              ),
              child: TextButton(
                onPressed: () => onTabSelected(0),
                style: TextButton.styleFrom(
                  backgroundColor:
                      currentIndex == 0 ? Colors.black12 : Colors.transparent,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
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
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: TextButton(
                onPressed: () => onTabSelected(1),
                style: TextButton.styleFrom(
                  backgroundColor:
                      currentIndex == 1 ? Colors.black12 : Colors.transparent,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero),
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
