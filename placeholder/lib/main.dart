import 'package:flutter/material.dart';
import 'Screen/Home.dart';
import 'dart:core';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'DB/DBHelper.dart';
import 'Utility/Llama.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Innit DB

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb; // Web
  } else {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi; // Desktop
  }

  await DBHelper.Print(); // Temporary

  if (!kIsWeb) {
    await Ollama(); // Start
  }

  runApp(const Placeholder());
}

class Placeholder extends StatelessWidget {
  const Placeholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'MAIN', // "Splash" Screen
      home: Redirect(),
    );
  }
}

class Redirect extends StatefulWidget {
  const Redirect({super.key});

  @override
  _RedirectState createState() => _RedirectState();
}

class _RedirectState extends State<Redirect> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'KENKŌ PETTO',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 45.5,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  height: 55,
                  child: TextFormField(
                    controller: username,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "PETTO'S NAMAE", // Username
                      errorStyle: TextStyle(fontSize: 0, height: 0),
                    ),
                    textCapitalization: TextCapitalization.characters,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return '';
                      }
                      if (value.length < 3 || value.length > 16) {
                        return '';
                      }
                      if (!RegExp(r'^[A-Z0-9]+$').hasMatch(value)) {
                        return '';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      String purell = value
                          .toUpperCase() // Sanitize
                          .replaceAll(RegExp(r'[^A-Z0-9]'), '');
                      if (purell != value) {
                        username.value = username.value.copyWith(
                          text: purell,
                          selection:
                              TextSelection.collapsed(offset: purell.length),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  height: 55,
                  child: TextFormField(
                    controller: password,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: 'PASUWĀDO', // Password
                      errorStyle: const TextStyle(fontSize: 0, height: 0),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText
                            ? Icons.visibility_off
                            : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '';
                      }
                      if (value.length < 8) {
                        return '';
                      }
                      if (!RegExp(// 💪🏻 Pasuwādo
                              r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@\$!%*?&])[A-Za-z\d@\$!%*?&]{8,}$')
                          .hasMatch(value)) {
                        return '';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String Username = username.text;
                        String Password = password.text;

                        // GET "User"
                        Map<String, dynamic>? Yuza =
                            await DBHelper.GetUser(Username);

                        // IF !"User", CREATE + LOGIN
                        if (Yuza == null) {
                          int? Ranku = await showDialog<int>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontSize: 34.125,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    children: [
                                      const TextSpan(text: 'RANKU '),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: MouseRegion(
                                          cursor: SystemMouseCursors.click,
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (_) => AlertDialog(
                                                  title: Center(
                                                    child: RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          const TextSpan(
                                                            text: 'RANKU ',
                                                            style: TextStyle(
                                                              fontSize: 34.125,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                          WidgetSpan(
                                                            alignment:
                                                                PlaceholderAlignment
                                                                    .middle,
                                                            child: Text(
                                                              'ℹ️',
                                                              style: TextStyle(
                                                                fontSize: 25,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  content: const SizedBox(
                                                    width: 255,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Center(
                                                          child: Text(
                                                            "PLACEHOLDER",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    22.75),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'ℹ️',
                                              style: TextStyle(
                                                fontSize: 25,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              content: SizedBox(
                                width: 255,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 1),
                                      child: const Text(
                                        '1',
                                        style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22.75),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 2),
                                      child: const Text(
                                        '2',
                                        style: TextStyle(
                                            color: Colors.orange,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22.75),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 3),
                                      child: const Text(
                                        '3',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22.75),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                          if (Ranku != null) {
                            // Goal?
                            String? Goru = await showDialog<String>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Center(
                                  child: Text(
                                    "GŌRU",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 34.125,
                                    ),
                                  ),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    'BODY',
                                    'MIND',
                                    'SOUL',
                                  ].map((goru) {
                                    return MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () =>
                                            Navigator.pop(context, goru),
                                        child: Text(
                                          goru,
                                          style: const TextStyle(
                                            fontSize: 22.75,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            );
                            if (Goru != null) {
                              await DBHelper.Create(Username, Password, Ranku);
                              await DBHelper.UpdateGoal(
                                  Username, Goru); // 💾 Goal

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Home(username: Username),
                                ),
                              );
                            }
                          }
                        } else {
                          // IF "User", Check 🔒 Pasuwādo
                          bool isPassword =
                              await DBHelper.Validate(Username, Password);

                          if (isPassword) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Home(
                                      username: Username)), // PASS "Username"
                            );
                          } else {
                            // IF Pasuwādo ≠ Yūzā's Pasuwādo
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("❌ Pasuwādo")), // Temporary
                            );
                          }
                        }
                      }
                    },
                    child:
                        Icon(Icons.check, color: Colors.black), // Placeholder
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
