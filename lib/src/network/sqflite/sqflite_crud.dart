import 'package:mmc_test/src/components/ui_log.dart';
import 'package:mmc_test/src/models/task_wrapper.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteCrud {
  static Database? _db;
  static const String _table = 'tasks';

  static Future<void> initDb() async {
    _db ??= await openDatabase('mmc_database.db');
    await _initTable();
  }

  static Future<void> _initTable() async {
    try {
      await _db!.rawQuery('SELECT * FROM $_table;');
    } catch (e) {
      await _db!.execute('''
    CREATE TABLE $_table (
      id_ INTEGER PRIMARY KEY,
      id Text,
      title TEXT,
      desc TEXT,
      due_date TEXT,
      status INTEGER
    )
  ''');
    }
  }

  static Future<bool> addTask(TaskWrapper task) async {
    try {
      return (await _db!.insert(_table, task.toJson())) == 1;
    } catch (e) {
      UILog.logs('sqflite addTask error ${e.toString()}');
      return false;
    }
  }

  static Future<List<TaskWrapper>> fetchAllTasks() async {
    try {
      final x =  (await _db!.rawQuery('SELECT * FROM $_table;'))
          .map((e) => TaskWrapper.fromJson(e))
          .toList();
      return x;
    } catch (e) {
      UILog.logs('sqflite fetchAllTasks error ${e.toString()}');
      return [];
    }
  }

  static Future<int> updateTask(TaskWrapper task) async {
    return await _db!
        .update(_table, task.toJson(), where: 'id =?', whereArgs: [task.id!]);
  }

  static Future<int> removeTask(String id) async =>
      await _db!.delete(_table, where: 'id =?', whereArgs: [id]);
}
