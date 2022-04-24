import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

@immutable
class TaskReminder extends Equatable {
  const TaskReminder(
      {required this.id, required this.scheduledOn, required this.state});

  final int id;
  final tz.TZDateTime scheduledOn;
  final TaskReminderActionState state;

  factory TaskReminder.fromJson(Map<String, dynamic> json) => TaskReminder(
      id: json.containsKey("id") ? json["id"] : "",
      scheduledOn: json.containsKey("scheduledOn")
          ? tz.TZDateTime.fromMillisecondsSinceEpoch(
              tz.local, json["scheduledOn"])
          : tz.TZDateTime.fromMicrosecondsSinceEpoch(tz.local, 1),
      state: json.containsKey("state")
          ? TaskReminderActionState.values[json["state"]]
          : TaskReminderActionState.none);

  Map<String, dynamic> toJson() => {
        "id": id,
        "scheduledOn": scheduledOn.millisecondsSinceEpoch,
        "state": state.index
      };

  TaskReminder copyWith(
      {int? newId,
      tz.TZDateTime? newScheduledOn,
      TaskReminderActionState? newState}) {
    return TaskReminder(
        id: newId ?? id,
        scheduledOn: newScheduledOn ?? scheduledOn,
        state: newState ?? state);
  }

  @override
  List<Object?> get props => [id, scheduledOn, state];
}

enum TaskReminderActionState { none, skipped, done }
