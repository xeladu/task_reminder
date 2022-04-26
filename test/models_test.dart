import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:task_reminder/database/models/skip_configuration.dart';
import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/database/models/task_reminder.dart';
import 'package:task_reminder/database/models/task_reminder_configuration.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  const String json1 = """
    { 
        "id": 1,
        "title": "test title 1",
        "description": "test description 1",
        "created": 1645383600000,
        "configuration": {
            "initialDate": 1645383600000,
            "recurringInterval": 1,
            "maxScheduledNotificationCount": 1,
            "enabled": true,
            "skipOn": {
                "monday": false,
                "tuesday": false,
                "wednesday": false,
                "thursday": false,
                "friday": false,
                "saturday": true,
                "sunday": true
            }
        },
        "reminders": [
            {
                "id": 1,
                "scheduledOn": 1645383600000,
                "state": 1
            },
            {
                "id": 2,
                "scheduledOn": 1645383600000,
                "state": 2
            },
            {
                "id": 3,
                "scheduledOn": 1645383600000,
                "state": 0
            },
            {
                "id": 4,
                "scheduledOn": 1645383600000,
                "state": 0
            }
        ]
    }
    """;

  const String json2 = """
    {
        "id": 2,
        "title": "test title 2",
        "description": "test description 2",
        "created": 1645383600000,
        "configuration": {
            "initialDate": null,
            "recurringInterval": null,
            "maxScheduledNotificationCount": null,
            "enabled": false,
            "skipOn": {}
        },
        "reminders": []
    }
    """;

  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation("Europe/Berlin"));

    return Future.value();
  });

  test("Verify object deserialization 1", () {
    var task = Task.fromJson(jsonDecode(json1));

    expect(1, task.id);
    expect("test title 1", task.title);
    expect("test description 1", task.description);
    expect(tz.TZDateTime.local(2022, 02, 20, 20, 0, 0), task.created);
    expect(tz.TZDateTime.local(2022, 02, 20, 20, 0, 0),
        task.configuration.initialDate);
    expect(86400, task.configuration.recurringInterval!.inSeconds);
    expect(1, task.configuration.maxScheduledNotificationCount);
    expect(true, task.configuration.enabled);
    expect(false, task.configuration.skipOn.monday);
    expect(false, task.configuration.skipOn.tuesday);
    expect(false, task.configuration.skipOn.wednesday);
    expect(false, task.configuration.skipOn.thursday);
    expect(false, task.configuration.skipOn.friday);
    expect(true, task.configuration.skipOn.saturday);
    expect(true, task.configuration.skipOn.sunday);
    expect(
        2,
        task.reminders
            .where((x) => x.state == TaskReminderActionState.none)
            .length);
    expect(
        1,
        task.reminders
            .where((x) => x.state == TaskReminderActionState.done)
            .length);
    expect(
        1,
        task.reminders
            .where((x) => x.state == TaskReminderActionState.skipped)
            .length);
  });

  test("Verify object deserialization 2", () {
    var task = Task.fromJson(jsonDecode(json2));

    expect(2, task.id);
    expect("test title 2", task.title);
    expect("test description 2", task.description);
    expect(tz.TZDateTime.local(2022, 02, 20, 20, 0, 0), task.created);
    expect(null, task.configuration.initialDate);
    expect(null, task.configuration.recurringInterval);
    expect(1, task.configuration.maxScheduledNotificationCount);
    expect(false, task.configuration.enabled);
    expect(false, task.configuration.skipOn.monday);
    expect(false, task.configuration.skipOn.tuesday);
    expect(false, task.configuration.skipOn.wednesday);
    expect(false, task.configuration.skipOn.thursday);
    expect(false, task.configuration.skipOn.friday);
    expect(false, task.configuration.skipOn.saturday);
    expect(false, task.configuration.skipOn.sunday);
    expect(0, task.reminders.length);
  });

  test("Verify serialization and deserialization", () {
    var date = tz.TZDateTime.local(2022, 4, 20, 16, 34, 58, 0, 0);

    var expected = Task(
        created: date,
        id: 1,
        title: "title",
        description: "description",
        configuration: TaskReminderConfiguration(
            enabled: true,
            initialDate: date,
            maxScheduledNotificationCount: 1,
            recurringInterval: const Duration(days: 1),
            skipOn: const SkipConfiguration.empty()),
        reminders: <TaskReminder>[
          TaskReminder(
              id: 11, scheduledOn: date, state: TaskReminderActionState.none),
          TaskReminder(
              id: 22, scheduledOn: date, state: TaskReminderActionState.done),
          TaskReminder(
              id: 33, scheduledOn: date, state: TaskReminderActionState.skipped)
        ]);

    var actual = Task.fromJson(jsonDecode(jsonEncode(expected.toJson())));

    expect(actual, expected);
  });
}
