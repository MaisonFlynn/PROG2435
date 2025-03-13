import 'package:flutter/material.dart';
import 'home.dart';
import 'dart:core';

void main() {
  runApp(const Placeholder());
}

class Placeholder extends StatelessWidget {
  const Placeholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SPLASH',
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
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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
                  child: TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: "PETTO'S NAMAE", // Placeholder
                    ),
                    textCapitalization: TextCapitalization.characters,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return ''; // !
                      }
                      if (value.length < 3 || value.length > 16) {
                        return ''; // !
                      }
                      if (!RegExp(r'^[A-Z0-9]+$').hasMatch(value)) {
                        return ''; // !
                      }
                      return null;
                    },
                    onChanged: (value) {
                      String sanitized = value.toUpperCase()
                          .replaceAll(RegExp(r'[^A-Z0-9]'), '');
                      if (sanitized != value) {
                        usernameController.value = usernameController.value.copyWith(
                          text: sanitized,
                          selection: TextSelection.collapsed(offset: sanitized.length),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: 'PASUWĀDO', // Placeholder
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ''; // !
                      }
                      if (value.length < 8) {
                        return ''; // !
                      }
                      if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@\$!%*?&])[A-Za-z\d@\$!%*?&]{8,}\$')
                          .hasMatch(value)) {
                        return ''; // !
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
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Home()),
                        );
                      }
                    },
                    child: const Text('✔'),
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