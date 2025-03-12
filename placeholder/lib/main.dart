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
  final TextEditingController Controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                    controller: Controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      hintText: 'PETTO\'S NAMAE',
                    ),
                    textCapitalization: TextCapitalization.characters,
                    validator: (Value) {
                      if (Value == null || Value.trim().isEmpty) {
                        return 'ERROR'; // !
                      }
                      if (!RegExp(r'^[A-Z0-9]+$').hasMatch(Value)) {
                        return 'ERROR'; // !
                      }
                      return null;
                    },
                    onChanged: (Value) {
                      String Purell = Value.toUpperCase()
                          .replaceAll(RegExp(r'[^A-Z0-9]'), ''); // Sanitize
                      if (Purell != Value) {
                        Controller.value = Controller.value.copyWith(
                          text: Purell,
                          selection:
                              TextSelection.collapsed(offset: Purell.length),
                        );
                      }
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
