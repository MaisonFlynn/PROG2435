import 'dart:async';
import 'package:flutter/material.dart';
import '../DB/DBHelper.dart';
import '../DB/Tasuku.dart';

class Home extends StatefulWidget {
  final String namae;

  const Home({super.key, required this.namae});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool Dropdown = false;
  late List<Map<String, dynamic>> tasuku; // "Task(s)" List
  late List<bool> chekku; // "Task(s)" Checked
  late Duration taimu;
  late Timer taima;

  @override
  void initState() {
    super.initState();
    _innit();
    taimu = _taimu(); // Midnight
    taima = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() {
          taimu = _taimu();
        });
      }
    });
  }

  @override
  void dispose() {
    taima.cancel();
    super.dispose();
  }

  // Fetch/Create Task(s)
  Future<void> _innit() async {
    List<Map<String, dynamic>> tupperware =
        await DBHelper.FETCHI(widget.namae); // Storage

    if (tupperware.isEmpty) {
      // + Task(s)
      List<Map<String, dynamic>> newTasks = Tasuku.GET();
      await DBHelper.SAVE(widget.namae, newTasks);
      tupperware = await DBHelper.FETCHI(widget.namae);
    }

    setState(() {
      tasuku = tupperware;
      chekku = tupperware.map((task) => task['Chekku'] == 1).toList();
    });
  }

  // Check Task(s)
  Future<void> Chekku(int index) async {
    await DBHelper.CHEKKU(tasuku[index]['TasukuID'], widget.namae);
    setState(() {
      chekku[index] = true;
    });
  }

  // Calculate time until midnight
  Duration _taimu() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    return midnight.difference(now);
  }

  // Delete "User"
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
                    Row(
                      children: [
                        IconButton(
                          // Temporary
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => DELETE(context),
                        ),
                        IconButton(
                          icon: Icon(
                            Dropdown ? Icons.expand_less : Icons.expand_more,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              Dropdown = !Dropdown;
                            });
                          },
                        ),
                      ],
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
                              child: Icon(Icons.home, color: Colors.black),
                            ),
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
                              child: Icon(Icons.map, color: Colors.black),
                            ),
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
          if (Dropdown)
            Positioned(
              top: 60,
              left: 0,
              right: 0,
              bottom: 60,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "TASUKU",
                      style: TextStyle(
                          fontSize: 45.5, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    // Task(s)
                    Expanded(
                      child: ListView.builder(
                        itemCount: tasuku.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(
                              top: index == 0 ? 0 : 10,
                              bottom: 10,
                            ),
                            child: SizedBox(
                              width: 300,
                              height: 50,
                              child: ElevatedButton(
                                onPressed:
                                    chekku[index] ? null : () => Chekku(index),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                                child: Text(
                                  tasuku[index]['Tasuku'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Timer
                    Text(
                      "${taimu.inHours.toString().padLeft(2, '0')}:"
                      "${(taimu.inMinutes % 60).toString().padLeft(2, '0')}:"
                      "${(taimu.inSeconds % 60).toString().padLeft(2, '0')}",
                      style: TextStyle(
                          fontSize: 45.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
