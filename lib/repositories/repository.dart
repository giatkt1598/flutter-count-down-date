import 'package:count_down_date/models/countdown.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'dart:async';

class CountdownRepository {
  Database database;

  Future open() async {
    String dbPath = join(await getDatabasesPath(), 'countdown.db');
    database = await openDatabase(
      dbPath,
      onCreate: (db, version) async {
        await db.execute(
            'CREATE TABLE Countdown(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, startDate DATETIME, endDate DATETIME)');
      },
      version: 1,
    );
  }

  Future insert(CountDown entity) async {
    await open();
    await database.insert('Countdown', entity.toMap());
  }

  Future<List<CountDown>> getAll() async {
    await open();
    List<Map<String, dynamic>> list = await database.query('Countdown');
    return List.generate(
      list.length,
      (index) => CountDown.fromMap(
        list[index],
      ),
    );
  }

  Future delete(CountDown entity) async {
    await open();
    await database.delete('Countdown', where: 'id = ?', whereArgs: [entity.id]);
  }
}
