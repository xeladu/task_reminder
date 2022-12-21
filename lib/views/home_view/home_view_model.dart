import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:task_reminder/base/base_view_model.dart';
import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/navigation/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_reminder/widgets/dialog_button_widget.dart';
import 'package:timezone/timezone.dart' as tz;

class HomeViewModel extends BaseViewModel {
  Future showOptionsDialog(BuildContext context, Task task) async {
    final options = <DialogButtonWidget>[];
    options.add(DialogButtonWidget(
        onPressed: () async => await goToTaskEditView(task),
        label: "Edit task details"));
    options.add(DialogButtonWidget(
        onPressed: () async {
          await markAsCompleted(task);
          showNotification(context, "Task completed");
        },
        label: "Mark as completed"));
    options.add(DialogButtonWidget(
        onPressed: () async {
          await createTemplateFromTask(task);
          showNotification(context, "Template created");
        },
        label: "Create template"));
    await dialogService.showOptionsDialog(context, "Task options", options);
  }

  Future createTemplateFromTask(Task task) async {
    final newId = await databaseService.getNewTaskId();

    var template = task.copyWith(newId: newId, isTemplate: true);
    await databaseService.addTask(template);
  }

  Future addNewTask(WidgetRef ref) async {
    final highestId = await databaseService.getNewTaskId();

    await navigationService.navigateTo(RouteGenerator.routeTaskEdit,
        arguments: {"task": null, "newId": highestId + 1});
  }

  Future markAsCompleted(Task task) async {
    var newTask = task.copyWith(completedDate: tz.TZDateTime.now(tz.local));

    await databaseService.removeTask(task);
    await databaseService.addTask(newTask);
  }

  Future<bool> isCompletionConfirmed(Task task, BuildContext context) async {
    return await dialogService.showConfirmationDialog(context,
            "Do you really want to mark the task '${task.title}' as completed?") ==
        OkCancelResult.ok;
  }
}
