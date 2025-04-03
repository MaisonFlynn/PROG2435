import 'package:flutter/foundation.dart'; // kIsWeb
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:path/path.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../Core/Model/UserModel.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DBService {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  static Future<Database> _initDB() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
      return await databaseFactory.openDatabase('Detabesu.db');
    } else {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;

      final Directory directory = await getApplicationDocumentsDirectory();
      final String path = join(directory.path, 'Detabesu.db');

      print("📌 $path");

      return await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
          CREATE TABLE Yuza (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            Namae TEXT UNIQUE NOT NULL,
            Pasuwado TEXT NOT NULL,
            XP INTEGER DEFAULT 0,
            Ranku INTEGER DEFAULT 0,
            HP INTEGER DEFAULT 10,
            Streak INTEGER DEFAULT 0,
            Active TEXT,
            Goru TEXT
          )
        ''');

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
        ),
      );
    }
  }

  static String EncryptPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  static Future<bool> ValidatePassword(String username, String password) async {
    final db = await database;
    final result =
        await db.query('Yuza', where: 'Namae = ?', whereArgs: [username]);
    if (result.isEmpty) return false;
    return result.first['Pasuwado'] == EncryptPassword(password);
  }

  static Future<int> CreateUser(
      String username, String password, int ranku) async {
    final db = await database;
    return db.insert(
      'Yuza',
      {
        'Namae': username,
        'Pasuwado': EncryptPassword(password),
        'XP': 0,
        'Ranku': ranku
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<UserModel?> GetUser(String username) async {
    final db = await database;
    final result =
        await db.query('Yuza', where: 'Namae = ?', whereArgs: [username]);
    return result.isNotEmpty ? UserModel.Deserialize(result.first) : null;
  }

  static Future<int> GetXP(String username) async {
    final db = await database;
    final result = await db.query(
      'Yuza',
      columns: ['XP'],
      where: 'Namae = ?',
      whereArgs: [username],
    );
    return result.isNotEmpty ? result.first['XP'] as int : 0;
  }

  static Future<void> UpdateXP(String username, int xp) async {
    final db = await database;
    await db.rawUpdate('''
      UPDATE Yuza 
      SET XP = XP + ? 
      WHERE Namae = ?
    ''', [xp, username]);
  }

  static Future<int> DeleteUser(String username) async {
    final db = await database;
    await db.delete('Tasuku', where: 'Namae = ?', whereArgs: [username]);
    return await db.delete('Yuza', where: 'Namae = ?', whereArgs: [username]);
  }

  static Future<void> UpdateRank(String username, int rank) async {
    final db = await database;
    await db.update('Yuza', {'Ranku': rank},
        where: 'Namae = ?', whereArgs: [username]);
  }

  static Future<void> UpdateTask(
      String username, List<Map<String, dynamic>> tasks) async {
    final db = await database;
    await db.delete('Tasuku', where: 'Namae = ?', whereArgs: [username]);
    for (var task in tasks) {
      if ((task["Tasuku"] ?? '').toString().isNotEmpty) {
        await db.insert('Tasuku', {
          'Namae': username,
          'TasukuID': task['TasukuID'],
          'Tasuku': task['Tasuku'],
          'Chekku': 0,
          'XP': task['XP'] ?? 0,
        });
      }
    }
  }

  static Future<List<Map<String, dynamic>>> GetTask(String username) async {
    final db = await database;
    return await db.query('Tasuku', where: 'Namae = ?', whereArgs: [username]);
  }

  static Future<void> TaskCompleted(int taskID, String username) async {
    final db = await database;

    final task = await db.query(
      'Tasuku',
      where: 'TasukuID = ? AND Namae = ?',
      whereArgs: [taskID, username],
    );

    if (task.isNotEmpty && task.first['Chekku'] == 0) {
      final int xp = task.first['XP'] as int;

      final Streak = await db.query(
        'Yuza',
        columns: ['Streak'],
        where: 'Namae = ?',
        whereArgs: [username],
      );

      final streak = Streak.isNotEmpty ? Streak.first['Streak'] ?? 0 : 0;
      final multiplier = (1.0 + (streak as int) * 0.1).clamp(1.0, 2.0);
      final int XP = (xp * multiplier).round();

      await db.update(
        'Tasuku',
        {'Chekku': 1},
        where: 'TasukuID = ? AND Namae = ?',
        whereArgs: [taskID, username],
      );

      await UpdateXP(username, XP);
    }
  }

  static Future<void> DeleteTask(String username) async {
    final db = await database;
    await db.update('Tasuku', {'Chekku': 0},
        where: 'Namae = ?', whereArgs: [username]);
  }

  static Future<void> UpdateHP(String username, int hp) async {
    final db = await database;
    await db.update('Yuza', {'HP': hp},
        where: 'Namae = ?', whereArgs: [username]);
  }

  static Future<void> UpdateStreak(
      String username, int streak, String? active) async {
    final db = await database;
    await db.update(
      'Yuza',
      {'Streak': streak, 'Active': active},
      where: 'Namae = ?',
      whereArgs: [username],
    );
  }

  static Future<void> UpdateGoal(String username, String goal) async {
    final db = await database;
    await db.update('Yuza', {'Goru': goal},
        where: 'Namae = ?', whereArgs: [username]);
  }

  static Future<String?> GetGoal(String username) async {
    final db = await database;
    final result = await db.query('Yuza',
        columns: ['Goru'], where: 'Namae = ?', whereArgs: [username]);
    return result.isNotEmpty ? result.first['Goru'] as String? : null;
  }
}
