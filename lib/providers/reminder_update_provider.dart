import 'package:task_reminder/database/database_service.dart';
import 'package:task_reminder/notification/notification_service.dart';
import 'package:task_reminder/notification/reminder_service.dart';
import 'package:task_reminder/providers/reminder_update_state_provider.dart';
import 'package:task_reminder/providers/task_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

/// Initializes the notification service, reschedules the next notification
/// for every task, and marks the app state as updated
final reminderUpdateProvider = FutureProvider((ref) async {
  var notificationService = Get.find<NotificationService>();
  var reminderService = Get.find<ReminderService>();
  var databaseService = Get.find<DatabaseService>();

  final provider = ref.watch(taskListProvider);

  provider.whenData((taskList) async {
    for (var task in taskList) {
      await notificationService.cancelNotifications(task);
      reminderService.fillReminders(task);
      await notificationService.scheduleNextNotifications(task);
      await databaseService.updateTask(task);
    }

    ref.read(reminderUpdateStateProvider.notifier).state = true;
  });
});
