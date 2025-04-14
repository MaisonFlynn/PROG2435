import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'Feature/Auth/Screen/AuthScreen.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb; // Web
  } else {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi; // Desktop
  }

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => Placeholder(),
    ),
  );
}

class Placeholder extends StatelessWidget {
  const Placeholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kenkō Petto',
      home: AuthScreen(),
    );
  }
}
