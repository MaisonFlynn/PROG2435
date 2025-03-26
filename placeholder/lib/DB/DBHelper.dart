import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class DBHelper {
  static Database? _database;

  static set Test(Database db) {
    _database = db;
  }

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
                XP INTEGER DEFAULT 0,
                Ranku INTEGER DEFAULT 0,
                HP INTEGER DEFAULT 10,
                Streak INTEGER DEFAULT 0,
                Active TEXT
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

  // 🔒 Pasuwādo (SHA-256)
  static String HASH(String pasuwado) {
    return sha256.convert(utf8.encode(pasuwado)).toString();
  }

  // Validate Pasuwādo
  static Future<bool> VALIDATE(String namae, String pasuwado) async {
    final yuza = await GET_USER(namae);
    if (yuza == null) return false; // !"User"

    String hasshu = HASH(pasuwado);
    return yuza['Pasuwado'] == hasshu; // =?
  }

  // Create "User"
  static Future<int> CREATE(String namae, String pasuwado, int ranku) async {
    final db = await database;
    String hasshu = HASH(pasuwado); // 🔒
    return db.insert(
        'Yuza', {'Namae': namae, 'Pasuwado': hasshu, 'XP': 0, 'Ranku': ranku},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Get "User"
  static Future<Map<String, dynamic>?> GET_USER(String namae) async {
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

  // Update "Ranku"
  static Future<void> UPDATE_RANKU(String namae, int ranku) async {
    final db = await database;
    await db.update('Yuza', {'Ranku': ranku},
        where: 'Namae = ?', whereArgs: [namae]);
  }

  // Save "Task(s)"
  static Future<void> SAVE(
      String namae, List<Map<String, dynamic>> tasukus) async {
    final db = await database;

    await db.delete('Tasuku', where: 'Namae = ?', whereArgs: [namae]);

    for (var tasuku in tasukus) {
      if (tasuku["Tasuku"] != null && tasuku["Tasuku"].toString().isNotEmpty) {
        await db.insert('Tasuku', {
          "Namae": namae,
          "TasukuID": tasuku["TasukuID"],
          "Tasuku": tasuku["Tasuku"],
          "Chekku": 0,
          "XP": tasuku["XP"] ?? 0,
        });
      }
    }
  }

  // Fetch "Task(s)"
  static Future<List<Map<String, dynamic>>> FETCH(String namae) async {
    final db = await database;
    return await db.query('Tasuku', where: 'Namae = ?', whereArgs: [namae]);
  }

  // Check "Task(s)" (DONE)
  static Future<void> CHECK(int tasukuID, String namae) async {
    final db = await database;

    List<Map<String, dynamic>> task = await db.query(
      'Tasuku',
      where: 'TasukuID = ? AND Namae = ?',
      whereArgs: [tasukuID, namae],
    );

    if (task.isNotEmpty && task.first['Chekku'] == 0) {
      int xp = task.first['XP'];

      final user = await db.query('Yuza',
          columns: ['Streak'], where: 'Namae = ?', whereArgs: [namae]);
      int streak = user.isNotEmpty ? (user.first['Streak'] as int? ?? 0) : 0;

      double multiplier = 1.0 + (streak * 0.1);
      multiplier = multiplier.clamp(1.0, 2.0); // 2X
      int EXP = (xp * multiplier).round();

      await db.update(
        'Tasuku',
        {"Chekku": 1},
        where: 'TasukuID = ? AND Namae = ?',
        whereArgs: [tasukuID, namae],
      );

      // + XP
      await UPDATE_XP(namae, EXP);
    }
  }

  // Reset "Task(s)" (Midnight)
  static Future<void> RESET(String namae) async {
    final db = await database;

    await db.update(
      'Tasuku',
      {"Chekku": 0},
      where: 'Namae = ?',
      whereArgs: [namae],
    );
  }

  // Update "HP"
  static Future<void> UPDATE_HP(String namae, int hp) async {
    final db = await database;
    await db.update('Yuza', {'HP': hp}, where: 'Namae = ?', whereArgs: [namae]);
  }

  // Update "Streak"
  static Future<void> UPDATE_STREAK(
      String namae, int streak, String? active) async {
    final db = await database;
    await db.update(
        'Yuza',
        {
          'Streak': streak,
          'Active': active,
        },
        where: 'Namae = ?',
        whereArgs: [namae]);
  }
}
