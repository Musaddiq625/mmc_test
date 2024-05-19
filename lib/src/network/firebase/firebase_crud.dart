import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:mmc_test/src/components/ui_log.dart';
import 'package:mmc_test/src/models/task_wrapper.dart';

class FirebaseCrud {
  static final _fInstance = FirebaseDatabase.instance
    ..setPersistenceEnabled(true)
    ..setLoggingEnabled(kDebugMode);

  static DatabaseReference get _ref => _fInstance.ref().child('todo');

  static Future<void> addTask(TaskWrapper task) async {
    try {
      var newTaskRef = _ref.child(task.id!);
      await newTaskRef.set(task.toJson());
    } catch (e) {
      UILog.logs('firebase addTask error ${e.toString()}');
    }
  }

  static Future<void> removeTask(String id) async {
    try {
      _ref.child(id).remove();
    } catch (e) {
      UILog.logs('firebase removeTask error ${e.toString()}');
    }
  }

  static Future<void> updateTask(TaskWrapper task) async {
    try {
      _ref.child(task.id!).update(task.toJson());
    } catch (e) {
      UILog.logs('firebase updateTask error ${e.toString()}');
    }
  }

  static Future<List<TaskWrapper>> fetchAllTasks() async {
    try {
      final data = (await _ref.get()).value as Map?;
      if (data == null) return [];
      List<TaskWrapper> tasks = [];
      tasks = data.values
          .map(
            (taskData) => TaskWrapper.fromJson(taskData),
          )
          .toList();
      return tasks;
    } catch (e) {
      UILog.logs('firebase fetchAllTasks error ${e.toString()}');
      return [];
    }
  }
}
