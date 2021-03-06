import 'package:task_reminder/database/models/task_reminder_configuration.dart';
import 'package:task_reminder/database/models/task_reminder.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

@immutable
class Task extends Equatable {
  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.created,
    required this.configuration,
    required this.reminders,
  });

  final int id;
  final String title;
  final String description;
  final tz.TZDateTime created;
  final TaskReminderConfiguration configuration;
  final List<TaskReminder> reminders;

  Task.empty()
      : this(
            id: 0,
            title: "",
            description: "",
            created: tz.TZDateTime.now(tz.local),
            configuration: const TaskReminderConfiguration.empty(),
            reminders: <TaskReminder>[]);

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json.containsKey("id") ? json["id"] : "",
        title: json.containsKey("title") ? json["title"] : "",
        description: json.containsKey("description") ? json["description"] : "",
        created: json.containsKey("created")
            ? tz.TZDateTime.fromMillisecondsSinceEpoch(
                tz.local, json["created"])
            : tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, 1),
        configuration: json.containsKey("configuration")
            ? TaskReminderConfiguration.fromJson(json["configuration"])
            : const TaskReminderConfiguration.empty(),
        reminders: json.containsKey("reminders")
            ? List<TaskReminder>.from(
                json["reminders"].map((x) => TaskReminder.fromJson(x)))
            : <TaskReminder>[],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "created": created.millisecondsSinceEpoch,
        "configuration": configuration.toJson(),
        "reminders": List<dynamic>.from(reminders.map((x) => x.toJson())),
      };

  @override
  List<Object?> get props =>
      [id, title, description, created, configuration, reminders];

  bool isValid() {
    return title.isNotEmpty;
  }

  double getDoneReminderPercentage() {
    return reminders.isNotEmpty
        ? reminders
                .where((rem) => rem.state == TaskReminderActionState.done)
                .length /
            reminders.length
        : 0.0;
  }

  double getSkippedReminderPercentage() {
    return reminders.isNotEmpty
        ? reminders
                .where((rem) => rem.state == TaskReminderActionState.skipped)
                .length /
            reminders.length
        : 0.0;
  }

  double getRemainingReminderPercentage() {
    return reminders.isNotEmpty
        ? reminders
                .where((rem) => rem.state == TaskReminderActionState.none)
                .length /
            reminders.length
        : 0.0;
  }
}
