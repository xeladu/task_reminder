import 'package:task_reminder/database/database_service.dart';
import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/navigation/navigation_service.dart';
import 'package:task_reminder/navigation/route_generator.dart';
import 'package:task_reminder/notification/notification_service.dart';
import 'package:task_reminder/providers/reminder_update_state_provider.dart';
import 'package:task_reminder/providers/task_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:adaptive_dialog/adaptive_dialog.dart';

class HomeViewModel {
  Future goToTaskView(int taskId) async {
    await Get.find<NavigationService>()
        .navigateTo(RouteGenerator.routeTask, arguments: taskId);
  }

  Future addNewTask(WidgetRef ref) async {
    final tasks = ref.watch(taskListProvider);

    final taskData = tasks.asData!.value;
    final highestId =
        taskData.isEmpty ? 1 : taskData.map((e) => e.id).reduce(max);

    await Get.find<NavigationService>().navigateTo(RouteGenerator.routeTaskEdit,
        arguments: {"task": null, "newTaskId": highestId + 1});

    ref.read(reminderUpdateStateProvider.notifier).state = false;
  }

  Future deleteTask(Task task) async {
    await Get.find<NotificationService>().cancelNotifications(task);
    await Get.find<DatabaseService>().removeTask(task);
  }

  Future<bool> isDeleteConfirmed(Task task, BuildContext context) async {
    return (await showOkCancelAlertDialog(
            context: context,
            title: "Confirmation",
            message:
                "Do you really want to delete then task '${task.title}'?")) ==
        OkCancelResult.ok;
  }

  Future updateNotification(Task task) async {
    var notificationService = Get.find<NotificationService>();

    await notificationService.cancelNotifications(task);
    await notificationService.scheduleNextNotification(task);
  }
}
