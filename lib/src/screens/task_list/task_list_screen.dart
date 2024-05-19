import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmc_test/src/components/ui_scaffold.dart';
import 'package:mmc_test/src/components/ui_toast.dart';
import 'package:mmc_test/src/constants/string_constants.dart';
import 'package:mmc_test/src/screens/add_update_task/add_update_task_screen.dart';
import 'package:mmc_test/src/screens/add_update_task/cubit/task_cubit.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late final taskCubit = BlocProvider.of<TaskCubit>(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await taskCubit.fetchAllTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool loadingData = false;
    return UIScaffold(
      widget:
          BlocConsumer<TaskCubit, TaskState>(listener: (context, state) async {
        if (state is TaskFetchAllLoadingState) {
          loadingData = true;
        } else if (state is TaskFetchAllErrorState) {
          loadingData = false;
          UIToast.showToast(context, state.error);
        } else if (state is TaskFetchAllSuccessState) {
          loadingData = false;
        } else if (state is TaskSyncLoadingState) {
          UIToast.showToast(context, 'Syncing...');
        } else if (state is TaskSyncSuccessState) {
          UIToast.showToast(context, 'Synced Successfully');
        } else if (state is TaskSyncErrorState) {
          UIToast.showToast(context, state.error);
        } else if (state is TaskUpdateSuccessState) {
          UIToast.showToast(context, 'Task Updated');
          await taskCubit.fetchAllTasks();
        } else if (state is TaskUpdateErrorState) {
          UIToast.showToast(context, state.error);
        }
      }, builder: (context, state) {
        if (state is TaskFetchAllSuccessState && taskCubit.tasks.isEmpty) {
          return const Center(child: Text('No data found :('));
        }
        if (loadingData) {
          return const Center(
              child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ));
        }

        return Column(
          children: [
            const Text(
              StringConstants.allTasks,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(StringConstants.tapToEdit),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: taskCubit.tasks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DashboardScreen(
                                previousTask: taskCubit.tasks[index],
                              ),
                            ));
                      },
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (taskCubit.tasks[index].status != 1)
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: Icon(Icons.sync),
                            ),
                          GestureDetector(
                            onTap: () async {
                              await taskCubit
                                  .removeTask(taskCubit.tasks[index].id!);
                              await taskCubit.fetchAllTasks();
                            },
                            child: Container(
                              // to increase tap area
                              padding: const EdgeInsets.all(15),
                              child: const Icon(Icons.delete),
                            ),
                          ),
                        ],
                      ),
                      tileColor: Colors.blueAccent.withOpacity(.2),
                      title: Text(taskCubit.tasks[index].title ?? ''),
                      // subtitle: Text(taskCubit.tasks[index].desc ?? ''),
                      subtitle: Text(taskCubit.tasks[index].id ?? ''),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          return taskCubit.tasks.isEmpty
              ? const SizedBox.shrink()
              : FloatingActionButton(
                  child: const Icon(Icons.sync),
                  onPressed: () async {
                    await taskCubit.syncTasks();
                  },
                );
        },
      ),
    );
  }
}
