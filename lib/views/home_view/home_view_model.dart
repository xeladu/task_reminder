import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:task_reminder/database/database_service.dart';
import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/dialogs/dialog_service.dart';
import 'package:task_reminder/dialogs/dialog_utils.dart';
import 'package:task_reminder/navigation/navigation_service.dart';
import 'package:task_reminder/navigation/route_generator.dart';
import 'package:task_reminder/notification/notification_service.dart';
import 'package:task_reminder/providers/reminder_update_state_provider.dart';
import 'package:task_reminder/providers/task_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:task_reminder/widgets/dialog_button_widget.dart';
import 'package:task_reminder/widgets/snack_bar_builder.dart';
import 'package:timezone/timezone.dart' as tz;

class HomeViewModel {
  late NavigationService _navigationService;
  late DatabaseService _databaseService;
  late NotificationService _notificationService;
  late DialogService _dialogService;

  HomeViewModel() {
    _navigationService = Get.find<NavigationService>();
    _databaseService = Get.find<DatabaseService>();
    _notificationService = Get.find<NotificationService>();
    _dialogService = Get.find<DialogService>();
  }

  Future goToTaskEditView(Task task) async {
    await _navigationService.navigateTo(RouteGenerator.routeTaskEdit,
        arguments: <String, dynamic>{}..["task"] = task);
  }

  Future goToHistoryView() async {
    await _navigationService.navigateTo(RouteGenerator.routeHistory);
  }

  Future goToTemplateView() async {
    await _navigationService.navigateTo(RouteGenerator.routeTemplate);
  }

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
    await _dialogService.showOptionsDialog(context, "Task options", options);
  }

  Future createTemplateFromTask(Task task) async {
    final newId = await _databaseService.getNewTaskId();

    var template = task.copyWith(newId: newId, isTemplate: true);
    await _databaseService.addTask(template);
  }

  Future addNewTask(WidgetRef ref) async {
    final highestId = await _databaseService.getNewTaskId();

    await _navigationService.navigateTo(RouteGenerator.routeTaskEdit,
        arguments: {"task": null, "newId": highestId + 1});

    ref.read(reminderUpdateStateProvider.notifier).state = false;
  }

  Future markAsCompleted(Task task) async {
    var newTask = task.copyWith(completedDate: tz.TZDateTime.now(tz.local));

    await _databaseService.removeTask(task);
    await _databaseService.addTask(newTask);
  }

  Future<bool> isCompletionConfirmed(Task task, BuildContext context) async {
    return await _dialogService.showConfirmationDialog(context,
            "Do you really want to mark the task '${task.title}' as completed?") ==
        OkCancelResult.ok;
  }

  Future updateNotification(WidgetRef ref) async {
    final tasks = ref.watch(taskListProvider);

    await _notificationService.cancelNotification();
    await _notificationService
        .scheduleNextNotification(tasks.asData!.value.length);
  }

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBarBuilder.buildDefaultSnackBar(message));
  }
}
