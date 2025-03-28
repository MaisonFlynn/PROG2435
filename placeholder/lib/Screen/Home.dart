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
  int Streak = 0;
  bool _AI = false;

  void _Streak() {
    double multiplier = (1.0 + (Streak * 0.1)).clamp(1.0, 2.0);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "BŌNASU",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 34.125,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                "×${multiplier.toStringAsFixed(1)} XP",
                style: const TextStyle(
                  fontSize: 22.75,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

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
      final tasuku = await DBHelper.Fetch(namae);
      final int count = tasuku.where((t) => t['Chekku'] == 1).length;

      final user = await DBHelper.GetUser(namae);
      int ranku = user?['Ranku'] ?? 1;
      int hp = user?['HP'] ?? 10;
      int streak = user?['Streak'] ?? 0;
      String? Active = user?['Active'];
      DateTime? active = Active != null ? DateTime.tryParse(Active) : null;

      int rank = ranku;
      int health = hp;
      int Streak = 0;
      String? last = Active;

      // Calc. HP & Ranku
      if (count == 0) {
        // ➖
        health -= ranku;
        if (ranku > 1) rank -= 1;
        Streak = 0;
        last = null;
      } else {
        // 🟰
        health += 1;
        if (count == 5 && ranku < 3) rank += 1; // ➕

        // 🔄 Streak
        final yesterday = DateTime(now.year, now.month, now.day - 1);
        if (active != null &&
            active.year == yesterday.year &&
            active.month == yesterday.month &&
            active.day == yesterday.day) {
          Streak = streak + 1;
        } else {
          Streak = 1;
        }
        last = now.toIso8601String();
      }

      health = health.clamp(1, 10);

      await DBHelper.UpdateHP(namae, health);
      await DBHelper.UpdateRank(namae, rank);
      await DBHelper.UpdateStreak(namae, Streak, last);
      await DBHelper.Reset(namae);
      await DBHelper.Save(namae, []);

      if (!mounted) return;
      setState(() {
        HP = health;
        Ranku = rank;
        HD = health.toDouble();
        task = [];
        check = [];
        _AI = false;
      });

      await _innit();

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
    final user = await DBHelper.GetUser(namae);
    final int xp = user?['XP'] ?? 0;
    final int ranku = user?['Ranku'] ?? 1;
    final int hp = user?['HP'] ?? 10;
    final int streak = user?['Streak'] ?? 0;

    List<Map<String, dynamic>> tupperware = await DBHelper.Fetch(namae);
    final int chekku = tupperware.where((t) => t['Chekku'] == 1).length;

    if (!mounted) return;
    setState(() {
      XP = xp;
      Ranku = ranku;
      HP = hp;
      HD = hp.toDouble();
      Streak = streak;
    });

    if (tupperware.isEmpty && !_AI) {
      _AI = true;

      try {
        List<Map<String, dynamic>> list = [];

        try {
          final AI = AIClient();

          list = await AI.Generate(ranku: ranku, xp: xp, chekku: chekku)
              .timeout(const Duration(seconds: 30), onTimeout: () async {
            debugPrint("⚠️ AI Taimuauto");
            return await Tasuku.GetTask(namae);
          });

          if (list.length < 5 ||
              list.any((e) => e['Tasuku'] == null || e['XP'] == null)) {
            throw Exception("⚠️ AI Tasuku");
          }
        } catch (e) {
          list = await Tasuku.GetTask(namae);
        }

        if (list.isEmpty) {
          throw Exception("⚠️ Tasuku");
        } else {
          await DBHelper.Save(namae, list);
          tupperware = await DBHelper.Fetch(namae);
        }
      } finally {
        _AI = false;
      }
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
    final namae = widget.username;

    int XPrev = XP; // Prev. XP
    int PreLV = Level.Get(XPrev, Ranku); // Prev. LV

    await DBHelper.Check(task[index]['TasukuID'], namae);
    int EXP = await DBHelper.GetXP(namae); // Next XP
    int LVL = Level.Get(EXP, Ranku); // Next LV

    // UI
    setState(() {
      check[index] = true;
      XP = EXP;
      if (!Dropdown) {
        XD = EXP.toDouble();
      }
    });

    // 🔄 Tasuku (LV+)
    if (LVL > PreLV) {
      setState(() => Loading = true);
      await DBHelper.Save(namae, []);
      setState(() => task = []);
      _AI = false;
      await _innit();
    }
  }

  // Calc.
  Duration _duration() {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day + 1);
    return midnight.difference(now);
  }

  // Delete "User"
  Future<void> DELETE(BuildContext context) async {
    await DBHelper.Delete(widget.username);
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
                        Text("${Level.Get(XP, Ranku)} ",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                            )),
                        GestureDetector(
                          onTap: _Streak,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Text(
                              "$Streak",
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.orange,
                              ),
                            ),
                          ),
                        ),
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
