import 'dart:io';

Future<void> Ollama() async {
  try {
    final result = await Process.run('pgrep', ['-f', 'ollama run mistral']);
    if (result.exitCode != 0) {
      final directory = Platform.environment['USERPROFILE'];
      final path = '$directory\\AppData\\Local\\Programs\\Ollama\\ollama.exe';
      await Process.start(path, ['run', 'mistral']);
      print("✔️ Ollama '𝘔𝘪𝘴𝘵𝘳𝘢𝘭'");
    }
  } catch (e) {
    print("❌ $e");
  }
}
