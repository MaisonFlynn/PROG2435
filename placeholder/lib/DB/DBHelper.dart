import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

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
          onCreate: (db, version) {
            // Create "User" Table
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

  // 🔒 Pasuwādo (SHA-256)
  static String HASH(String pasuwado) {
    return sha256.convert(utf8.encode(pasuwado)).toString();
  }

  // Verify Pasuwādo
  static Future<bool> VERIFY(String namae, String pasuwado) async {
    final yuza = await GET(namae);
    if (yuza == null) return false; // !"User"

    String hasshu = HASH(pasuwado);
    return yuza['Pasuwado'] == hasshu; // =?
  }

  // Create "User"
  static Future<int> CREATE(String namae, String pasuwado) async {
    final db = await database;
    String hasshu = HASH(pasuwado); // 🔒
    return db.insert('Yuza', {'Namae': namae, 'Pasuwado': hasshu},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get "User"
  static Future<Map<String, dynamic>?> GET(String namae) async {
    final db = await database;
    final result =
        await db.query('Yuza', where: 'namae = ?', whereArgs: [namae]);
    return result.isNotEmpty ? result.first : null;
  }

  // Delete "User"
  static Future<int> DELETE(String namae) async {
    final db = await database;
    return await db.delete(
      'Yuza',
      where: 'Namae = ?',
      whereArgs: [namae],
    );
  }
}
