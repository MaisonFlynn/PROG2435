import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    // Innit DB Factory
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final path = join(await getDatabasesPath(), 'Detabesu.db'); // Detabase
    return await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) { // Create "User" Table
            return db.execute('''
              CREATE TABLE Yuza (
                ID INTEGER PRIMARY KEY AUTOINCREMENT,
                Namae TEXT UNIQUE NOT NULL,
                Pasuwado TEXT NOT NULL
              )
            ''');
          },
        ));
  }

  // Print "Path"
  static Future<void> PRINT() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    String path = join(await getDatabasesPath(), 'Detabesu.db');
    print("📌 $path");
  }

  // Create "User"
  static Future<int> CREATE(String namae, String pasuwado) async {
    final db = await database;
    return db.insert('Yuza', {'Namae': namae, 'Pasuwado': pasuwado},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get "User"
  static Future<Map<String, dynamic>?> GET(String namae) async {
    final db = await database;
    final result =
        await db.query('Yuza', where: 'namae = ?', whereArgs: [namae]);
    return result.isNotEmpty ? result.first : null;
  }
}
