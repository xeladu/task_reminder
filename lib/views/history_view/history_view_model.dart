import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:task_reminder/base/base_view_model.dart';
import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/providers/completed_task_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_reminder/widgets/dialog_button_widget.dart';

class HistoryViewModel extends BaseViewModel {
  Future<bool> confirmDeletion(BuildContext context) async {
    return (await dialogService.showConfirmationDialog(
            context, "Do you really want to delete the task history?")) ==
        OkCancelResult.ok;
  }

  Future showOptionsDialog(BuildContext context, Task task) async {
    final options = <DialogButtonWidget>[];
    options.add(DialogButtonWidget(
        onPressed: () async {
          await deleteTask(task);
          showNotification(context, "Task deleted");
        },
        label: "Delete task"));
    await dialogService.showOptionsDialog(context, "Task options", options);
  }

  Future addTaskCopyToDatabase(Task task) async {
    final highestId = await databaseService.getNewTaskId();

    final copy = task.copyWith(newId: highestId, completedDate: null);

    await databaseService.addTask(copy);
  }

  Future clearTaskHistory(WidgetRef ref) async {
    final tasks = ref.read(completedTaskListProvider);

    final taskData = tasks.asData!.value;
    for (var task in taskData) {
      await databaseService.removeTask(task);
    }
  }

  Future<bool> isDeletionConfirmed(Task task, BuildContext context) async {
    return await dialogService.showConfirmationDialog(context,
            "Do you really want to delete the task '${task.title}' from your history?") ==
        OkCancelResult.ok;
  }

  Future deleteTask(Task task) async {
    await databaseService.removeTask(task);
  }
}
