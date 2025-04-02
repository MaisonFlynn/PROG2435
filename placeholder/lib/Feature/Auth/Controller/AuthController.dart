import 'package:flutter/material.dart';
import '../../../Core/Service/DBService.dart';

class AuthController {
  static String? ValidateUsername(String? value) {
    if (value == null || value.trim().isEmpty) return '';
    if (value.length < 3 || value.length > 16) return '';
    if (!RegExp(r'^[A-Z0-9]+$').hasMatch(value)) return '';
    return null;
  }

  static void SanitizeUsername(TextEditingController controller) {
    String value =
        controller.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (value != controller.text) {
      controller.value = controller.value.copyWith(
        text: value,
        selection: TextSelection.collapsed(offset: value.length),
      );
    }
  }

  static String? ValidatePassword(String? value) {
    if (value == null || value.isEmpty) return '';
    if (value.length < 8) return '';
    if (!RegExp(
            r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@\$!%*?&])[A-Za-z\d@\$!%*?&]{8,}\$')
        .hasMatch(value)) return '';
    return null;
  }

  static Future<bool> HandleAuth(
      BuildContext context, String username, String password) async {
    final user = await DBService.GetUser(username);

    if (user == null) {
      int? ranku = await _SelectRank(context);
      if (ranku == null) return false;

      String? goru = await _SelectGoal(context);
      if (goru == null) return false;

      await DBService.CreateUser(username, password, ranku);
      await DBService.UpdateGoal(username, goru);
      return true;
    } else {
      bool valid = await DBService.ValidatePassword(username, password);
      if (!valid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Pasuwādo")),
        );
      }
      return valid;
    }
  }

  static Future<int?> _SelectRank(BuildContext context) async {
    return showDialog<int>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(
          child: Text('RANKU',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34.125)),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [1, 2, 3]
              .map((r) => TextButton(
                    onPressed: () => Navigator.pop(context, r),
                    child: Text('$r',
                        style: TextStyle(
                          fontSize: 22.75,
                          fontWeight: FontWeight.bold,
                          color: r == 1
                              ? Colors.green
                              : r == 2
                                  ? Colors.orange
                                  : Colors.red,
                        )),
                  ))
              .toList(),
        ),
      ),
    );
  }

  static Future<String?> _SelectGoal(BuildContext context) async {
    const goals = ['💪🏻', '🧠', '🫀'];
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Center(
          child: Text('GŌRU',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 34.125)),
        ),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: goals
              .map((g) => TextButton(
                    onPressed: () => Navigator.pop(context, g),
                    child: Text(g, style: const TextStyle(fontSize: 22.75)),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
