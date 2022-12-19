import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:task_reminder/base/base_view_model.dart';
import 'package:task_reminder/database/models/task.dart';
import 'package:flutter/material.dart';
import 'package:task_reminder/widgets/dialog_button_widget.dart';

class TemplateViewModel extends BaseViewModel {
  Future<bool> confirmDeletion(BuildContext context) async {
    return (await dialogService.showConfirmationDialog(
            context, "Do you really want to delete the task history?")) ==
        OkCancelResult.ok;
  }

  Future showOptionsDialog(BuildContext context, Task task) async {
    final options = <DialogButtonWidget>[];
    options.add(DialogButtonWidget(
        onPressed: () async => await goToTaskEditView(task),
        label: "Edit template details"));
    options.add(DialogButtonWidget(
        onPressed: () async {
          await addTaskCopyToDatabase(task);
          showNotification(context, "Task created");
        },
        label: "Create task from template"));
    options.add(DialogButtonWidget(
        onPressed: () async {
          await deleteTemplate(task);
          showNotification(context, "Template deleted");
        },
        label: "Delete template"));
    await dialogService.showOptionsDialog(context, "Template options", options);
  }

  Future addTaskCopyToDatabase(Task task) async {
    final highestId = await databaseService.getNewTaskId();

    final copy =
        task.copyWith(newId: highestId, completedDate: null, isTemplate: false);

    await databaseService.addTask(copy);
  }

  Future<bool> isDeletionConfirmed(Task task, BuildContext context) async {
    return await dialogService.showConfirmationDialog(context,
            "Do you really want to delete the template '${task.title}'?") ==
        OkCancelResult.ok;
  }

  Future deleteTemplate(Task task) async {
    await databaseService.removeTask(task);
  }
}
