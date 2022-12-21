import 'package:task_reminder/notification/notification_service.dart';
import 'package:task_reminder/providers/task_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

/// Schedules the next notification
final reminderUpdateProvider = FutureProvider((ref) async {
  var notificationService = Get.find<NotificationService>();

  final provider = ref.watch(taskListProvider);

  provider.whenData((taskList) async {
    await notificationService.cancelNotification();
    await notificationService.scheduleNextNotification(taskList.length);
  });
});
