import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/timezone.dart';

class NotificationService {
  static const String _notificationId = "1";
  static const String _channelId = "Daily Tasks";

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

  Future cancelNotification() async {
    if (_plugin == null) await init();

    _plugin?.cancel(int.parse(_notificationId));
  }

  Future scheduleNextNotification(int taskCount) async {
    if (taskCount == 0) return;

    String title = "Your daily task reminder";
    String description =
        "You have $taskCount tasks for today! Click here to see them";

    if (_plugin == null) await init();

    var details = _createNotificationDetails(title);

    // 9 am Berlin time the next day
    var now = DateTime.now();
    var scheduled = TZDateTime.local(now.year, now.month, now.day, 9, 0)
        .add(const Duration(days: 1));

    await _plugin?.zonedSchedule(
        int.parse(_notificationId), title, description, scheduled, details,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: _notificationId);
  }

  NotificationDetails _createNotificationDetails(String title) {
    return NotificationDetails(
        android: AndroidNotificationDetails(_notificationId, title,
            channelDescription: _channelId,
            importance: Importance.defaultImportance,
            priority: Priority.defaultPriority));
  }
}
