import 'dart:io';

Future<void> Ollama() async {
  try {
    // Runnin'?
    final result = await Process.run('tasklist', []);
    if (result.stdout.toString().contains('ollama.exe')) {
      print("⚙️ Ollama");
      return;
    }

    final directory = Platform.environment['USERPROFILE'];
    final path = '$directory\\AppData\\Local\\Programs\\Ollama\\ollama.exe';

    final file = File(path);
    if (await file.exists()) {
      await Process.start(
        path,
        ['run', 'mistral'],
        mode: ProcessStartMode.detached,
      );
      print("✔️ Ollama");
    } else {
      print("❌ Ollama @ $path");
    }
  } catch (e) {
    print("❌ $e");
  }
}
