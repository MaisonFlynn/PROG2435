import 'package:flutter/material.dart';
import '../DB/DBHelper.dart';

class Home extends StatelessWidget {
  final String namae; // PASSED "Namae"

  const Home({super.key, required this.namae});

  Future<void> DELETE(BuildContext context) async {
    await DBHelper.DELETE(namae); // Delete "User"
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ $namae")),
    );

    Navigator.pop(context); // Redirect "Splash"
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "👋🏻 $namae",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 45.5,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox( // Temporary
                width: 300,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                  ),
                  onPressed: () => DELETE(context), // Delete "User"
                  child: const Text("❌"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
