import 'dart:async';
import 'package:flutter/material.dart';
import '../DB/DBHelper.dart';
import '../Utility/Task.dart';

class Home extends StatefulWidget {
  final String username;

  const Home({super.key, required this.username});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool Dropdown = false;
  late List<Map<String, dynamic>> task;
  late List<bool> check;
  late Duration duration;
  late Timer timer;
  int XP = 0;

  @override
  void initState() {
    super.initState();
    _innit();
    duration = _duration(); // Midnight
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() {
          duration = _duration();
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // Fetch/Create Task(s)
  Future<void> _innit() async {
    List<Map<String, dynamic>> tupperware =
        await DBHelper.FETCH(widget.username); // Storage

    int xp = await DBHelper.GET_XP(widget.username);
    setState(() {
      XP = xp;
    });

    if (tupperware.isEmpty) {
      // + Task(s)
      List<Map<String, dynamic>> task = Tasuku.GET();
      await DBHelper.SAVE(widget.username, task);
      tupperware = await DBHelper.FETCH(widget.username);
    }

    setState(() {
      task = tupperware;
      check = tupperware.map((task) => task['Chekku'] == 1).toList();
    });
  }

  // Check Task(s)
  Future<void> Check(int index) async {
    await DBHelper.CHECK(task[index]['TasukuID'], widget.username);

    int EXP = await DBHelper.GET_XP(widget.username);

    setState(() {
      check[index] = true;
      XP = EXP;
    });
  }

  // Calc.
  Duration _duration() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    return midnight.difference(now);
  }

  // Delete "User"
  Future<void> DELETE(BuildContext context) async {
    await DBHelper.DELETE(widget.username);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("❌ ${widget.username}")),
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
                    Row(
                      children: [
                        Text("👋🏻 ${widget.username} ",
                            style: TextStyle(fontSize: 18)),
                        Text("$XP",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                            )),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
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
                    // Temporary
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
                        itemCount: task.length,
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
                                    check[index] ? null : () => Check(index),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Task Name
                                    Text(
                                      task[index]['Tasuku'],
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                    // XP Display
                                    Text(
                                      "${task[index]['XP']} XP",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // HH:MM:SS
                    Text(
                      "${duration.inHours.toString().padLeft(2, '0')}:"
                      "${(duration.inMinutes % 60).toString().padLeft(2, '0')}:"
                      "${(duration.inSeconds % 60).toString().padLeft(2, '0')}",
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
