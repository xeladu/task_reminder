// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:app_example/database/models/skip_configuration.dart';
import 'package:app_example/database/models/task.dart';
import 'package:app_example/database/models/task_reminder.dart';
import 'package:app_example/database/models/task_reminder_configuration.dart';
import 'package:app_example/notification/reminder_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:timezone/timezone.dart' as tz;

void main() {
  test("Missing reminders before today should be created", () {
    final now = tz.TZDateTime.now(tz.local);
    final createDate =
        tz.TZDateTime.now(tz.local).subtract(const Duration(days: 8));
    final initialDate = tz.TZDateTime.now(tz.local)
        .subtract(const Duration(days: 6, hours: 10));
    var task = Task(
        id: 1,
        title: "test",
        description: "test",
        created: createDate,
        configuration: TaskReminderConfiguration(
            enabled: true,
            recurringInterval: const Duration(days: 1),
            initialDate: initialDate,
            skipOn: const SkipConfiguration.empty()),
        reminders: <TaskReminder>[]);

    var sut = ReminderService();
    sut.fillReminders(task);

    expect(task.reminders.length, 8,
        reason: "There should be 7 past reminders and 1 coming");
    expect(
        task.reminders.where((item) => item.scheduledOn.isBefore(now)).length,
        task.reminders.length - 1,
        reason:
            "${task.reminders.length - 1} reminders should be scheduled for the past days");
    expect(
        task.reminders.where((item) => item.scheduledOn.isAfter(now)).length, 1,
        reason: "1 reminder should be scheduled to come");
    expect(
        task.reminders.every((element) =>
            element.scheduledOn.hour == initialDate.hour &&
            element.scheduledOn.minute == initialDate.minute),
        isTrue,
        reason: "Every reminder should be scheduled at the same time");
  });

  test("Skip days must be respected when creating reminders", () {
    final now = tz.TZDateTime.now(tz.local);
    final createDate =
        tz.TZDateTime.now(tz.local).subtract(const Duration(days: 8));
    final initialDate = tz.TZDateTime.now(tz.local)
        .subtract(const Duration(days: 7, hours: 10));
    var task = Task(
        id: 1,
        title: "test",
        description: "test",
        created: createDate,
        configuration: TaskReminderConfiguration(
            enabled: true,
            recurringInterval: const Duration(days: 1),
            initialDate: initialDate,
            skipOn: const SkipConfiguration(
                monday: false,
                tuesday: false,
                wednesday: false,
                thursday: false,
                friday: false,
                saturday: false,
                sunday: true)),
        reminders: <TaskReminder>[]);

    var sut = ReminderService();
    sut.fillReminders(task);

    expect(task.reminders.length, 8,
        reason: "There should be 7 past reminders and 1 coming");
    expect(
        task.reminders.where((item) => item.scheduledOn.isBefore(now)).length,
        task.reminders.length - 1,
        reason:
            "${task.reminders.length - 1} reminders should be scheduled for the past days");
    expect(
        task.reminders.where((item) => item.scheduledOn.isAfter(now)).length, 1,
        reason: "1 reminder should be scheduled to come");
    expect(
        task.reminders.every((element) =>
            element.scheduledOn.hour == initialDate.hour &&
            element.scheduledOn.minute == initialDate.minute),
        isTrue,
        reason: "Every reminder should be scheduled at the same time");
  });

  test("Existing reminders must be be respected when creating reminders", () {
    final now = tz.TZDateTime.now(tz.local);
    final createDate =
        tz.TZDateTime.now(tz.local).subtract(const Duration(days: 8));
    final initialDate = tz.TZDateTime.now(tz.local)
        .subtract(const Duration(days: 6, hours: 10));
    var task = Task(
        id: 1,
        title: "test",
        description: "test",
        created: createDate,
        configuration: TaskReminderConfiguration(
            enabled: true,
            recurringInterval: const Duration(days: 1),
            initialDate: initialDate,
            skipOn: const SkipConfiguration(
                monday: false,
                tuesday: false,
                wednesday: false,
                thursday: false,
                friday: false,
                saturday: false,
                sunday: true)),
        reminders: <TaskReminder>[
          TaskReminder(
              id: 1,
              scheduledOn: initialDate,
              state: TaskReminderActionState.done),
          TaskReminder(
              id: 2,
              scheduledOn: initialDate.add(const Duration(days: 1)),
              state: TaskReminderActionState.done),
          TaskReminder(
              id: 3,
              scheduledOn: initialDate.add(const Duration(days: 2)),
              state: TaskReminderActionState.done)
        ]);

    var sut = ReminderService();
    sut.fillReminders(task);

    expect(task.reminders.length, 7,
        reason: "There should be 6 past reminders and 1 coming");
    expect(
        task.reminders.where((item) => item.scheduledOn.isBefore(now)).length,
        task.reminders.length - 1,
        reason:
            "${task.reminders.length - 1} reminders should be scheduled for the past days");
    expect(
        task.reminders.where((item) => item.scheduledOn.isAfter(now)).length, 1,
        reason: "1 reminder should be scheduled to come");
    expect(
        task.reminders.every((element) =>
            element.scheduledOn.hour == initialDate.hour &&
            element.scheduledOn.minute == initialDate.minute),
        isTrue,
        reason: "Every reminder should be scheduled at the same time");
  });

  test(
      "If the next reminder is a skip day, the reminder must be scheduled the day after",
      () {
    final now = tz.TZDateTime.now(tz.local);
    final createDate = now.subtract(const Duration(days: 1, seconds: 1));
    final initialDate = createDate;

    final tomorrow = now.add(const Duration(days: 1)).weekday;
    var task = Task(
        id: 1,
        title: "test",
        description: "test",
        created: createDate,
        configuration: TaskReminderConfiguration(
            enabled: true,
            recurringInterval: const Duration(days: 1),
            initialDate: initialDate,
            skipOn: SkipConfiguration(
                monday: tomorrow == 1,
                tuesday: tomorrow == 2,
                wednesday: tomorrow == 3,
                thursday: tomorrow == 4,
                friday: tomorrow == 5,
                saturday: tomorrow == 6,
                sunday: tomorrow == 7)),
        reminders: <TaskReminder>[]);

    var sut = ReminderService();
    sut.fillReminders(task);

    expect(task.reminders.length, 3,
        reason: "There should be 2 past reminder and 1 coming");
    expect(
        task.reminders.where((item) => item.scheduledOn.isBefore(now)).length,
        task.reminders.length - 1,
        reason:
            "${task.reminders.length - 1} reminders should be scheduled for the past days");
    expect(
        task.reminders.where((item) => item.scheduledOn.isAfter(now)).length, 1,
        reason: "1 reminder should be scheduled to come");
    expect(
        task.reminders.every((element) =>
            element.scheduledOn.hour == initialDate.hour &&
            element.scheduledOn.minute == initialDate.minute),
        isTrue,
        reason: "Every reminder should be scheduled at the same time");
    expect(
        task.reminders.last.scheduledOn.weekday ==
            (tomorrow + 1 > 7 ? 1 : tomorrow + 1),
        isTrue,
        reason:
            "The latest reminder should be scheduled the day AFTER tomorrow");
  });
}
