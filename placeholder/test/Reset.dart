import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:placeholder/DB/DBHelper.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('Tasuku', () {
    late Database db;

    setUp(() async {
      // Innit IN-Memory DB
      db = await databaseFactory.openDatabase(
        inMemoryDatabasePath,
        options: OpenDatabaseOptions(
          version: 2,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE Yuza (
                ID INTEGER PRIMARY KEY AUTOINCREMENT,
                Namae TEXT UNIQUE NOT NULL,
                Pasuwado TEXT NOT NULL,
                XP INTEGER DEFAULT 0,
								Ranku INTEGER DEFAULT 0
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

      // Inject Test DB ➡️ DBHelper
      DBHelper.Test = db;
    });

    tearDown(() async {
      await db.close();
    });

    test('🔄', () async {
      String yuza = "Test";

      await db
          .insert('Yuza', {"Namae": yuza, "Pasuwado": "Passw0rd!", "XP": 0});

      await db.insert('Tasuku', {
        "Namae": yuza,
        "TasukuID": 1,
        "Tasuku": "TEST",
        "Chekku": 1, // ✔️
        "XP": 10
      });

      await db.insert('Tasuku', {
        "Namae": yuza,
        "TasukuID": 2,
        "Tasuku": "TEST",
        "Chekku": 1, // ✔️
        "XP": 15
      });

      List<Map<String, dynamic>> UNA = await db.query(
        'Tasuku',
        where: 'Namae = ?',
        whereArgs: [yuza],
      );

      print("1️⃣ $UNA");

      expect(UNA.every((task) => task['Chekku'] == 1), isTrue, reason: "❓");

      // Simulate Midnight
      await DBHelper.Reset(yuza);

      List<Map<String, dynamic>> DOS = await db.query(
        'Tasuku',
        where: 'Namae = ?',
        whereArgs: [yuza],
      );

      print("2️⃣ $DOS");

      expect(DOS.every((task) => task['Chekku'] == 0), isTrue, reason: "❓");
    });
  });
}
