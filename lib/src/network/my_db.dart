import 'dart:io';

import 'package:mmc_test/src/models/task_wrapper.dart';
import 'package:mmc_test/src/network/firebase/firebase_crud.dart';
import 'package:mmc_test/src/network/sqflite/sqflite_crud.dart';

class MyDb {
  static Future<void> initDb() async {
    await SqfliteCrud.initDb();
  }

  // to forcefully disable internet
  static bool internetAllowed = true;

  static Future<bool> _isConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<TaskWrapper?> addTask(TaskWrapper task) async {
    final isConnected = await _isConnected();
    final task_ = task.copyWith(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      dueDate: DateTime.now().microsecondsSinceEpoch.toString(),
      status: isConnected ? 1 : 0,
    );
    if (isConnected && internetAllowed) {
      await FirebaseCrud.addTask(task_);
    }
    await SqfliteCrud.addTask(task_);
    return task_;
  }

  static Future<void> updateTask(TaskWrapper task) async {
    final isConnected = await _isConnected();
    final task_ = task.copyWith(
      dueDate: DateTime.now().microsecondsSinceEpoch.toString(),
      status: isConnected ? 1 : 0,
    );
    if (isConnected && internetAllowed) {
      await FirebaseCrud.updateTask(task_);
    }
    await SqfliteCrud.updateTask(task_);
  }

  static Future<List<TaskWrapper>?> fetchAllFirebaseTasks() async {
    if (await _isConnected() && internetAllowed) {
      return await FirebaseCrud.fetchAllTasks();
    } else {
      return null;
    }
  }

  static Future<List<TaskWrapper>?> fetchAllSqfliteTasks() async {
    return await SqfliteCrud.fetchAllTasks();
  }

  static Future<List<TaskWrapper>> fetchAllTasks() async {
    List<TaskWrapper> tasks = [];
    if (await _isConnected() && internetAllowed) {
      tasks = await FirebaseCrud.fetchAllTasks();
    } else {
      tasks = await SqfliteCrud.fetchAllTasks();
    }
    return tasks;
  }

  static Future<void> removeTask(String id) async {
    final isConnected = await _isConnected();
    if (isConnected && internetAllowed) {
      await FirebaseCrud.removeTask(id);
      await SqfliteCrud.removeTask(id);
    } else {
      final task = (await SqfliteCrud.fetchAllTasks())
          .firstWhere((element) => element.id == id);
      await SqfliteCrud.updateTask(task.copyWith(
        dueDate: null,
        status: 0,
      ));
    }
  }
}
