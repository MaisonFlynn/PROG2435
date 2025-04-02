import 'package:flutter/material.dart';
import '../../Home/Screen/HomeScreen.dart';
import '../Widget/Form.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  void _onSuccess(BuildContext context, String username) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Home(username: username)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
            const SizedBox(height: 20),
            F0rm(onSuccess: (username) => _onSuccess(context, username)),
          ],
        ),
      ),
    );
  }
}
