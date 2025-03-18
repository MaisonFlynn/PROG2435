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
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    final path = join(await getDatabasesPath(), 'Detabesu.db'); // Detabase
    return await databaseFactory.openDatabase(path,
        options: OpenDatabaseOptions(
          version: 2, // ++
          onCreate: (db, version) async {
            // Create "User" Table
            await db.execute('''
              CREATE TABLE Yuza (
                ID INTEGER PRIMARY KEY AUTOINCREMENT,
                Namae TEXT UNIQUE NOT NULL,
                Pasuwado TEXT NOT NULL,
                XP INTEGER DEFAULT 0
              )
            ''');

            // Create "Task(s)" Table
            await db.execute('''
              CREATE TABLE Tasuku (
                ID INTEGER PRIMARY KEY AUTOINCREMENT,
                Namae TEXT NOT NULL,
                TasukuID INTEGER NOT NULL,
                Tasuku TEXT NOT NULL,
                Chekku INTEGER DEFAULT 0,
                XP INTEGER DEFAULT 0
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

  // ========================
  // Yūzā Function(s)
  // ========================

  // 🔒 Pasuwādo (SHA-256)
  static String HASH(String pasuwado) {
    return sha256.convert(utf8.encode(pasuwado)).toString();
  }

  // Validate Pasuwādo
  static Future<bool> VALIDATE(String namae, String pasuwado) async {
    final yuza = await GET(namae);
    if (yuza == null) return false; // !"User"

    String hasshu = HASH(pasuwado);
    return yuza['Pasuwado'] == hasshu; // =?
  }

  // Create "User"
  static Future<int> CREATE(String namae, String pasuwado) async {
    final db = await database;
    String hasshu = HASH(pasuwado); // 🔒
    return db.insert('Yuza', {'Namae': namae, 'Pasuwado': hasshu, 'XP': 0},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get "User"
  static Future<Map<String, dynamic>?> GET(String namae) async {
    final db = await database;
    final result =
        await db.query('Yuza', where: 'Namae = ?', whereArgs: [namae]);
    return result.isNotEmpty ? result.first : null;
  }

  // Get XP
  static Future<int> GET_XP(String namae) async {
    final db = await database;
    final result = await db.query('Yuza',
        columns: ['XP'], where: 'Namae = ?', whereArgs: [namae]);
    return result.isNotEmpty ? result.first['XP'] as int : 0;
  }

  // Update XP
  static Future<void> UPDATE_XP(String namae, int xp) async {
    final db = await database;
    await db.rawUpdate('''
    UPDATE Yuza 
    SET XP = XP + ? 
    WHERE Namae = ?
  ''', [xp, namae]);
  }

  // Delete "User" & Task(s)
  static Future<int> DELETE(String namae) async {
    final db = await database;

    await db.delete(
      'Tasuku',
      where: 'Namae = ?',
      whereArgs: [namae],
    );

    return await db.delete(
      'Yuza',
      where: 'Namae = ?',
      whereArgs: [namae],
    );
  }

  // ========================
  // Tasuku Function(s)
  // ========================

  // Save "Task(s)"
  static Future<void> SAVE(
      String namae, List<Map<String, dynamic>> tasukus) async {
    final db = await database;

    await db.delete('Tasuku', where: 'Namae = ?', whereArgs: [namae]);

    for (var tasuku in tasukus) {
      await db.insert('Tasuku', {
        "Namae": namae,
        "TasukuID": tasuku["TasukuID"],
        "Tasuku": tasuku["Tasuku"],
        "Chekku": 0,
        "XP": tasuku["XP"] ?? 0,
      });
    }
  }

  // Fetch "Task(s)"
  static Future<List<Map<String, dynamic>>> FETCHI(String namae) async {
    final db = await database;
    return await db.query('Tasuku', where: 'Namae = ?', whereArgs: [namae]);
  }

  // Check "Task(s)" (DONE)
  static Future<void> CHEKKU(int tasukuID, String namae) async {
    final db = await database;

    List<Map<String, dynamic>> task = await db.query(
      'Tasuku',
      where: 'TasukuID = ? AND Namae = ?',
      whereArgs: [tasukuID, namae],
    );

    if (task.isNotEmpty && task.first['Chekku'] == 0) {
      int earnedXP = task.first['XP'];

      await db.update(
        'Tasuku',
        {"Chekku": 1},
        where: 'TasukuID = ? AND Namae = ?',
        whereArgs: [tasukuID, namae],
      );

      // + XP
      await UPDATE_XP(namae, earnedXP);
    }
  }

  // Reset "Task(s)" (Midnight)
  static Future<void> RISETTO(String namae) async {
    final db = await database;

    await db.update(
      'Tasuku',
      {"Chekku": 0},
      where: 'Namae = ?',
      whereArgs: [namae],
    );
  }
}
