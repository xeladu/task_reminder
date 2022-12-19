import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:task_reminder/database/database_service.dart';
import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/dialogs/dialog_service.dart';
import 'package:task_reminder/navigation/navigation_service.dart';
import 'package:task_reminder/navigation/route_generator.dart';
import 'package:task_reminder/providers/completed_task_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:task_reminder/widgets/dialog_button_widget.dart';
import 'package:task_reminder/widgets/snack_bar_builder.dart';

class TemplateViewModel {
  late DatabaseService _databaseService;
  late DialogService _dialogService;
  late NavigationService _navigationService;

  TemplateViewModel() {
    _databaseService = Get.find<DatabaseService>();
    _dialogService = Get.find<DialogService>();
    _navigationService = Get.find<NavigationService>();
  }

  Future<bool> confirmDeletion(BuildContext context) async {
    return (await _dialogService.showConfirmationDialog(
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
    await _dialogService.showOptionsDialog(
        context, "Template options", options);
  }

  Future addTaskCopyToDatabase(Task task) async {
    final highestId = await _databaseService.getNewTaskId();

    final copy =
        task.copyWith(newId: highestId, completedDate: null, isTemplate: false);

    await _databaseService.addTask(copy);
  }

  Future clearTaskHistory(WidgetRef ref) async {
    final tasks = ref.read(completedTaskListProvider);

    final taskData = tasks.asData!.value;
    for (var task in taskData) {
      await _databaseService.removeTask(task);
    }
  }

  Future<bool> isDeletionConfirmed(Task task, BuildContext context) async {
    return await _dialogService.showConfirmationDialog(context,
            "Do you really want to delete the template '${task.title}'?") ==
        OkCancelResult.ok;
  }

  Future deleteTask(Task task) async {
    await _databaseService.removeTask(task);
  }

  Future goToTaskEditView(Task task) async {
    await _navigationService.navigateTo(RouteGenerator.routeTaskEdit,
        arguments: <String, dynamic>{}..["task"] = task);
  }

  Future deleteTemplate(Task task) async {
    await _databaseService.removeTask(task);
  }

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBarBuilder.buildDefaultSnackBar(message));
  }
}
