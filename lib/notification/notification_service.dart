import 'dart:async';

import 'package:app_example/database/models/task.dart';
import 'package:app_example/database/models/task_reminder.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  FlutterLocalNotificationsPlugin? _plugin;
  static final StreamController<String> notificationsList =
      StreamController<String>();

  Future init() async {
    if (_plugin != null) return;

    // use default app icon
    var initSettingsAndroid =
        const AndroidInitializationSettings("@mipmap/ic_launcher");

    var initSettings = InitializationSettings(android: initSettingsAndroid);

    _plugin = FlutterLocalNotificationsPlugin();

    // handle notification tap and save the payload
    _plugin?.initialize(initSettings, onSelectNotification: ((payload) async {
      if (payload == null) return;

      notificationsList.add(payload);
    }));

    tz.initializeTimeZones();
    final String timeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  /// Cancels all scheduled notifications for a task
  Future cancelNotifications(Task task) async {
    if (_plugin == null) await init();

    _plugin?.cancel(task.id);
  }

  /// Schedules a notification for the next reminder. Previous reminders should
  /// be cancelled before so that no conflicts occur.
  Future scheduleNextNotification(Task task) async {
    if (_plugin == null) await init();

    var details = _createNotificationDetails(task);

    var reminders = task.reminders.where((r) =>
        r.scheduledOn.isAfter(DateTime.now()) &&
        r.state == TaskReminderActionState.none);

    if (reminders.isEmpty) return null;

    var reminder = reminders.first;
    await _plugin?.zonedSchedule(task.id, task.title, task.description,
        tz.TZDateTime.from(reminder.scheduledOn, tz.local), details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: task.id.toString());
  }

  NotificationDetails _createNotificationDetails(Task task) {
    return NotificationDetails(
        android: AndroidNotificationDetails(task.id.toString(), task.title,
            channelDescription: task.description,
            importance: Importance.high,
            priority: Priority.high));
  }
}
