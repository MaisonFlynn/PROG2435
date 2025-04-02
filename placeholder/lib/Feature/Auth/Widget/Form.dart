import 'package:flutter/material.dart';
import '../Controller/AuthController.dart';

class F0rm extends StatefulWidget {
  final Function(String username) onSuccess;

  const F0rm({super.key, required this.onSuccess});

  @override
  State<F0rm> createState() => _FormState();
}

class _FormState extends State<F0rm> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(
            width: 300,
            height: 55,
            child: TextFormField(
              controller: username,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                hintText: "PETTO'S NAMAE",
                errorStyle: TextStyle(fontSize: 0, height: 0),
              ),
              textCapitalization: TextCapitalization.characters,
              validator: AuthController.ValidateUsername,
              onChanged: (value) => AuthController.SanitizeUsername(username),
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
                hintText: 'PASUWĀDO',
                errorStyle: const TextStyle(fontSize: 0, height: 0),
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureText = !_obscureText),
                ),
              ),
              validator: AuthController.ValidatePassword,
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
                  final success = await AuthController.HandleAuth(
                    context,
                    username.text,
                    password.text,
                  );
                  if (success) widget.onSuccess(username.text);
                }
              },
              child: const Icon(Icons.check, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
