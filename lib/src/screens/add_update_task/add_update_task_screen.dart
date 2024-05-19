import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mmc_test/src/components/ui_button.dart';
import 'package:mmc_test/src/components/ui_scaffold.dart';
import 'package:mmc_test/src/components/ui_textfield.dart';
import 'package:mmc_test/src/components/ui_toast.dart';
import 'package:mmc_test/src/constants/sizedbox_constants.dart';
import 'package:mmc_test/src/constants/string_constants.dart';
import 'package:mmc_test/src/models/task_wrapper.dart';
import 'package:mmc_test/src/screens/add_update_task/cubit/task_cubit.dart';
import 'package:mmc_test/src/screens/task_list/task_list_screen.dart';

class DashboardScreen extends StatefulWidget {
  final TaskWrapper? previousTask;

  const DashboardScreen({super.key, this.previousTask});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final taskCubit = BlocProvider.of<TaskCubit>(context);
  final titleController = TextEditingController();
  final descController = TextEditingController();

  // due date: last updated date
  // status: is synchronized or not

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.previousTask != null) {
      titleController.text = widget.previousTask?.title ?? '';
      descController.text = widget.previousTask?.desc ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.previousTask != null,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: UIScaffold(
          removeBackButton: true,
          widget: BlocConsumer<TaskCubit, TaskState>(
            listener: (context, state) {
              if (state is TaskAddSuccessState) {
                titleController.clear();
                descController.clear();
                UIToast.showToast(context, 'Task Added');
              } else if (state is TaskAddErrorState) {
                UIToast.showToast(context, state.error);
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (kDebugMode) {
                              titleController.text =
                                  'title ${Random().nextInt(50)}';
                              descController.text =
                                  'desc ${Random().nextInt(50)}';
                            }
                          },
                          child: Text(
                            widget.previousTask != null
                                ? StringConstants.updateTask
                                : StringConstants.addTask,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        if (widget.previousTask != null)
                          Column(
                            children: [
                              UITextField(
                                hintText: widget.previousTask?.id ?? '',
                                labelText: StringConstants.id,
                                readOnly: true,
                              ),
                              SizedBoxConstants.eightH(),
                              UITextField(
                                controller: titleController,
                                labelText: StringConstants.title,
                                enableEmptyValidation: true,
                              ),
                              SizedBoxConstants.eightH(),
                              UITextField(
                                controller: descController,
                                labelText: StringConstants.description,
                                enableEmptyValidation: true,
                              ),
                              SizedBoxConstants.eightH(),
                              UITextField(
                                hintText: widget.previousTask?.dueDate ?? '',
                                labelText: StringConstants.dueDate,
                                readOnly: true,
                              ),
                              SizedBoxConstants.eightH(),
                              UITextField(
                                hintText: (widget.previousTask?.status == 1)
                                    .toString(),
                                labelText: StringConstants.status,
                                readOnly: true,
                              ),
                            ],
                          )
                        else
                          Column(
                            children: [
                              SizedBoxConstants.eightH(),
                              UITextField(
                                controller: titleController,
                                labelText: StringConstants.title,
                                enableEmptyValidation: true,
                              ),
                              SizedBoxConstants.eightH(),
                              UITextField(
                                controller: descController,
                                labelText: StringConstants.description,
                                enableEmptyValidation: true,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(12),
            child: UIButton(
              widget.previousTask != null
                  ? StringConstants.update
                  : StringConstants.add,
              onBtnPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                if (!formKey.currentState!.validate()) {
                  return;
                }
                if (widget.previousTask != null) {
                  await taskCubit.updateTask(widget.previousTask!.copyWith(
                    title: titleController.text,
                    desc: descController.text,
                  ));
                } else {
                  final task = TaskWrapper(
                    title: titleController.text,
                    desc: descController.text,
                  );
                  await taskCubit.addTask(task);
                }
                if (widget.previousTask != null) {
                  if (mounted) Navigator.pop(context);
                }
              },
            ),
          ),
          floatingActionButton: widget.previousTask != null
              ? null
              : FloatingActionButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TaskListScreen()),
                    );
                  },
                  child: const Icon(Icons.list),
                ),
        ),
      ),
    );
  }
}
