import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:mmc_test/src/components/ui_log.dart';
import 'package:mmc_test/src/models/task_wrapper.dart';
import 'package:mmc_test/src/network/my_db.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  List<TaskWrapper> tasks = [];

  Future<void> addTask(TaskWrapper task) async {
    try {
      emit(TaskAddLoadingState());

      final task_ = await MyDb.addTask(task);
      if (task_ != null) tasks.add(task);
      emit(TaskAddSuccessState());
    } catch (e) {
      emit(TaskAddErrorState(e.toString()));
    }
  }

  Future<void> updateTask(
    TaskWrapper task, {
    bool isSyncing = false,
  }) async {
    try {
      emit(TaskUpdateLoadingState());
      await MyDb.updateTask(task);
      if (isSyncing) {
        emit(TaskSyncUpdateSuccessState());
      } else {
        emit(TaskUpdateSuccessState());
      }
    } catch (e) {
      emit(TaskUpdateErrorState(e.toString()));
    }
  }

  Future<void> fetchAllTasks() async {
    try {
      emit(TaskFetchAllLoadingState());
      // tasks = await MyDb.fetchAllTasks();
      tasks = (await MyDb.fetchAllSqfliteTasks()) ?? [];
      emit(TaskFetchAllSuccessState());
    } catch (e) {
      UILog.logs('fetchAllTasks cubit error ${e.toString()}');
      emit(TaskFetchAllErrorState(e.toString()));
    }
  }

  Future<void> removeTask(String id) async {
    try {
      emit(TaskRemoveLoadingState());
      await MyDb.removeTask(id);
      emit(TaskRemoveSuccessState());
    } catch (e) {
      emit(TaskRemoveErrorState(e.toString()));
    }
  }

  Future<void> syncTasks() async {
    try {
    final dbTasks = await MyDb.fetchAllFirebaseTasks();

    if (dbTasks == null) {
      emit(TaskSyncErrorState(
          'Please check your internet connection and try again'));
      return;
    }
    emit(TaskSyncLoadingState());
    final localDbTasks = (await MyDb.fetchAllSqfliteTasks()) ?? [];
    Set<String> dbTaskIds = dbTasks.map((task) => task.id!).toSet();
    Set<String> localTaskIds = localDbTasks.map((task) => task.id!).toSet();

    if (dbTaskIds.length == localTaskIds.length && dbTaskIds.containsAll(localTaskIds)) {
      emit(TaskSyncErrorState('Already updated'));
      return;
    }


    /// When firebase is empty, upload all local tasks to firebase
    if (dbTasks.isEmpty) {
      for (final localTask in localDbTasks) {
        await addTask(localTask);
      }
      return;
    }

    /// when the some of the tasks need to be updated based on their due date (last updated time) from the firebase data
    for (final localDbTask in localDbTasks) {
      final TaskWrapper? dbTask = dbTasks.firstWhereOrNull((element) => element.id == localDbTask.id);
      /// If not found in firebase, upload it then continue
      if (dbTask == null) {
        await updateTask(
          localDbTask.copyWith(
            status: 1,
          ),
          isSyncing: true,
        );
        continue;
      }

      final dbDueDate = DateTime.fromMicrosecondsSinceEpoch(int.parse(localDbTask.dueDate!));
      final localDueDate = DateTime.fromMicrosecondsSinceEpoch(int.parse(dbTask.dueDate!));

      /// Updating the local data on firebase
      if (dbDueDate.isBefore(localDueDate)) {
        await updateTask(
          dbTask.copyWith(
            dueDate: localDbTask.dueDate,
            status: 1,
          ),
          isSyncing: true,
        );
      }
    }
    emit(TaskSyncSuccessState());
    await fetchAllTasks();
    } catch (e) {
      emit(TaskSyncErrorState(e.toString()));
    }
  }
}
