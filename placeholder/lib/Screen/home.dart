import 'package:flutter/material.dart';
import '../DB/DBHelper.dart';

class Home extends StatefulWidget {
  final String namae;

  const Home({super.key, required this.namae});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool Tasuku = false; // Dropdown

  Future<void> DELETE(BuildContext context) async {
    await DBHelper.DELETE(widget.namae);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ ${widget.namae}")),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Header
              Container(
                height: 60,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.black, width: 1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("👋🏻 ${widget.namae}"),
                    IconButton(
                      icon: Icon(
                        Tasuku ? Icons.expand_less : Icons.expand_more,
                      ),
                      onPressed: () {
                        setState(() {
                          Tasuku = !Tasuku;
                        });
                      },
                    ),
                  ],
                ),
              ),

              // Body
              Expanded(
                child: Center(
                  child: Text("Placeholder"), // Temporary
                ),
              ),

              // Footer
              Container(
                height: 60,
                decoration: BoxDecoration(
                  border:
                      Border(top: BorderSide(color: Colors.black, width: 1)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: double.infinity,
                        decoration: BoxDecoration(
                          border: Border(
                              right: BorderSide(color: Colors.black, width: 1)),
                        ),
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            padding: EdgeInsets.zero,
                          ),
                          child: const SizedBox(
                            height: double.infinity,
                            child: Center(
                                child: Text("🏠",
                                    style: TextStyle(
                                      fontSize: 24,
                                    ),
                                    textAlign:
                                        TextAlign.center)), // "Home" Screen
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
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            padding: EdgeInsets.zero,
                          ),
                          child: const SizedBox(
                            height: double.infinity,
                            child: Center(
                                child: Text("🗺️",
                                    style: TextStyle(
                                      fontSize: 24,
                                    ),
                                    textAlign:
                                        TextAlign.center)), // "Map" Screen
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Task(s)
          if (Tasuku)
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              bottom: 60,
              child: Container(
                color: Colors.white,
                child: Center(
                  child: SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => DELETE(context),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      child: const Text("❌"),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
