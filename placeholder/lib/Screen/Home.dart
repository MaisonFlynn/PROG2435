import 'dart:async';
import 'package:flutter/material.dart';
import '../DB/DBHelper.dart';
import '../AI/AIClient.dart';
import '../Utility/Task.dart';
import '../Utility/Level.dart';

class Home extends StatefulWidget {
  final String username;

  const Home({super.key, required this.username});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool Dropdown = false;
  bool Loading = false;
  double XD = 0; // XP Anime
  double HD = 10; // HP Anime
  Timer? Animation;
  List<Map<String, dynamic>> task = [];
  List<bool> check = [];
  late Duration duration;
  late Timer timer;
  int XP = 0;
  int Ranku = 1;
  int HP = 10;

  @override
  void initState() {
    super.initState();
    _innit();

    _Midnight();

    duration = _duration(); // Midnight
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (mounted) {
        setState(() {
          duration = _duration();
        });
      }
    });
  }

  void _Midnight() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    final countdown = midnight.difference(now).inSeconds;

    // Countdown 🔄 # (Test)
    Timer(Duration(seconds: countdown), () async {
      final namae = widget.username;

      // Count ✔️ Tasuku
      final tasuku = await DBHelper.FETCH(namae);
      final int count = tasuku.where((t) => t['Chekku'] == 1).length;

      final user = await DBHelper.GET_USER(namae);
      int ranku = user?['Ranku'] ?? 1;
      int hp = user?['HP'] ?? 10;

      int rank = ranku;
      int health = hp;

      // Calc. HP & Ranku
      if (count == 0) {
        // ➖
        health -= ranku;
        if (ranku > 1) rank -= 1;
      } else if (count == 5) {
        // ➕
        health += 1;
        if (ranku < 3) rank += 1;
      } else {
        // 🟰
        health += 1;
      }

      health = health.clamp(1, 10);

      await DBHelper.UPDATE_HP(namae, health);
      await DBHelper.UPDATE_RANKU(namae, rank);
      await DBHelper.RESET(namae);
      await DBHelper.SAVE(namae, []);

      if (!mounted) return;
      setState(() {
        HP = health;
        Ranku = rank;
        HD = health.toDouble();
        task = [];
        check = [];
      });

      _innit();
      _Midnight();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    Animation?.cancel();
    super.dispose();
  }

  Future<void> _innit() async {
    setState(() => Loading = true);

    final String namae = widget.username;
    final user = await DBHelper.GET_USER(namae);
    final int xp = user?['XP'] ?? 0;
    final int ranku = user?['Ranku'] ?? 1;
    final int hp = user?['HP'] ?? 10;

    List<Map<String, dynamic>> tupperware = await DBHelper.FETCH(namae);
    final int chekku = tupperware.where((t) => t['Chekku'] == 1).length;

    if (!mounted) return;
    setState(() {
      XP = xp;
      Ranku = ranku;
      HP = hp;
      HD = hp.toDouble();
    });

    if (tupperware.isEmpty) {
      List<Map<String, dynamic>> list;

      try {
        final AI = AIClient();
        list = await AI.Generate(
          ranku: ranku,
          xp: xp,
          chekku: chekku,
        );
      } catch (e) {
        // Backup
        list = await Tasuku.GET(namae);
      }

      await DBHelper.SAVE(namae, list);
      tupperware = await DBHelper.FETCH(namae);
    }

    if (!mounted) return;
    setState(() {
      task = tupperware;
      check = tupperware.map((task) => task['Chekku'] == 1).toList();
      Loading = false;
    });
  }

  // Check Task(s)
  Future<void> Check(int index) async {
    await DBHelper.CHECK(task[index]['TasukuID'], widget.username);

    int EXP = await DBHelper.GET_XP(widget.username);

    setState(() {
      check[index] = true;
      XP = EXP;
      if (!Dropdown) {
        XD = EXP.toDouble();
      }
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

  Widget Placeholder(int xp, int ranku, int hp) {
    int level = Level.Get(xp, ranku);
    int curr = Level.Formula(level, ranku);
    int next = Level.Formula(level + 1, ranku);
    double XP = (xp - curr) / (next - curr);

    Widget HD(int hp) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(10, (index) {
          bool filled = index < hp;
          return Expanded(
            child: Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              decoration: BoxDecoration(
                color: filled ? Colors.red : Colors.black12,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        }),
      );
    }

    Widget XD(double value) {
      return Container(
        height: 50,
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.hardEdge,
        child: LinearProgressIndicator(
          value: value.clamp(0.0, 1.0),
          color: Colors.green,
          backgroundColor: Colors.transparent,
        ),
      );
    }

    return Column(
      children: [
        HD(hp),
        XD(XP),
      ],
    );
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
                        Text("${Level.Get(XP, Ranku)}",
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
                              if (!Dropdown) {
                                Animation?.cancel();
                                Animation = Timer.periodic(
                                    const Duration(milliseconds: 20), (timer) {
                                  setState(() {
                                    bool RIXP = (XD - XP).abs() < 1;
                                    bool RIHP = (HD - HP).abs() < 0.1;

                                    if (RIXP && RIHP) {
                                      XD = XP.toDouble();
                                      HD = HP.toDouble();
                                      timer.cancel();
                                    } else {
                                      if (!RIXP) XD += (XP - XD) * 0.1;
                                      if (!RIHP) HD += (HP - HD) * 0.1;
                                    }
                                  });
                                });
                              }
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                        //
                        ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Placeholder(XD.toInt(), Ranku, HD.toInt()),
                    ),
                  ],
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
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "TASUKU",
                      style: TextStyle(
                          fontSize: 45.5, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),

                    // Task(s)
                    Expanded(
                      child: Loading
                          ? const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.black),
                            )
                          : ListView.builder(
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
                                      onPressed: check[index]
                                          ? null
                                          : () => Check(index),
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8)),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            task[index]['Tasuku'],
                                            style: const TextStyle(
                                              fontSize: 18.2,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            "${task[index]['XP']} XP",
                                            style: const TextStyle(
                                              fontSize: 18.2,
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
