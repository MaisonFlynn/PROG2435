import 'package:flutter/material.dart';
import 'Screen/home.dart';
import 'dart:core';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'DB/DBHelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Innit DB

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  await DBHelper.PRINT(); // Temporary

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
  final TextEditingController namae = TextEditingController();
  final TextEditingController pasuwado = TextEditingController();
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
                    controller: namae,
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
                        namae.value = namae.value.copyWith(
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
                    controller: pasuwado,
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
                      if (!RegExp( // 💪🏻 Pasuwādo
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
                        String Namae = namae.text;
                        String Pasuwado = pasuwado.text;

                        // GET "User"
                        Map<String, dynamic>? Yuza = await DBHelper.GET(Namae);

                        // IF !"User", CREATE + LOGIN
                        if (Yuza == null) {
                          await DBHelper.CREATE(Namae, Pasuwado);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Home(namae: Namae)), // PASS "Username"
                          );
                        } else {
                          // IF "User", Check 🔒 Pasuwādo
                          bool waPasuwado =
                              await DBHelper.VALIDATE(Namae, Pasuwado);

                          if (waPasuwado) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Home(namae: Namae)), // PASS "Username"
                            );
                          } else {
                            // IF Pasuwādo ≠ Yūzā's Pasuwādo
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Pasuwādo ≠")), // Temporary
                            );
                          }
                        }
                      }
                    },
                    child: const Text('✔'), // Placeholder
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
