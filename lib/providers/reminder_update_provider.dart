import 'package:app_example/database/database_service.dart';
import 'package:app_example/notification/notification_service.dart';
import 'package:app_example/notification/reminder_service.dart';
import 'package:app_example/providers/reminder_update_state_provider.dart';
import 'package:app_example/providers/task_list_provider.dart';
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
      reminderService.fillReminders(task);
      await notificationService.cancelNotifications(task);
      await notificationService.scheduleNextNotification(task);
      await databaseService.updateTask(task);
    }

    ref.read(reminderUpdateStateProvider.notifier).state = true;
  });
});
