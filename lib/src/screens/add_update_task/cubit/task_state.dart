part of 'task_cubit.dart';

@immutable
sealed class TaskState {}

final class TaskInitial extends TaskState {}

/// Add
final class TaskAddLoadingState extends TaskState {}

final class TaskAddSuccessState extends TaskState {}

final class TaskAddErrorState extends TaskState {
  final String error;

  TaskAddErrorState(this.error);
}

/// Fetch All
final class TaskFetchAllLoadingState extends TaskState {}

final class TaskFetchAllSuccessState extends TaskState {}

final class TaskFetchAllErrorState extends TaskState {
  final String error;

  TaskFetchAllErrorState(this.error);
}

/// Update
final class TaskUpdateLoadingState extends TaskState {}

final class TaskUpdateSuccessState extends TaskState {}
final class TaskSyncUpdateSuccessState extends TaskState {}

final class TaskUpdateErrorState extends TaskState {
  final String error;

  TaskUpdateErrorState(this.error);
}

/// Remove
final class TaskRemoveLoadingState extends TaskState {}

final class TaskRemoveSuccessState extends TaskState {}

final class TaskRemoveErrorState extends TaskState {
  final String error;

  TaskRemoveErrorState(this.error);
}

/// Sync
final class TaskSyncLoadingState extends TaskState {}

final class TaskSyncSuccessState extends TaskState {}

final class TaskSyncErrorState extends TaskState {
  final String error;

  TaskSyncErrorState(this.error);
}
