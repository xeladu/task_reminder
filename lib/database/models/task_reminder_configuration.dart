import 'package:app_example/database/models/skip_configuration.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

@immutable
class TaskReminderConfiguration extends Equatable {
  const TaskReminderConfiguration({
    required this.initialDate,
    required this.recurringInterval,
    required this.enabled,
    required this.skipOn,
  });

  const TaskReminderConfiguration.empty()
      : this(
            initialDate: null,
            enabled: false,
            recurringInterval: null,
            skipOn: const SkipConfiguration.empty());

  final tz.TZDateTime? initialDate;
  final Duration? recurringInterval;
  final bool enabled;
  final SkipConfiguration skipOn;

  factory TaskReminderConfiguration.fromJson(Map<String, dynamic> json) =>
      TaskReminderConfiguration(
        initialDate:
            json.containsKey("initialDate") && json["initialDate"] != null
                ? tz.TZDateTime.fromMillisecondsSinceEpoch(
                    tz.local, json["initialDate"])
                : null,
        recurringInterval: json.containsKey("recurringInterval") &&
                json["recurringInterval"] != null
            ? Duration(days: json["recurringInterval"])
            : null,
        enabled: json.containsKey("enabled") ? json["enabled"] : false,
        skipOn: json.containsKey("skipOn")
            ? SkipConfiguration.fromJson(json["skipOn"])
            : const SkipConfiguration.empty(),
      );

  Map<String, dynamic> toJson() => {
        "initialDate": initialDate?.millisecondsSinceEpoch,
        "recurringInterval": recurringInterval?.inDays,
        "enabled": enabled,
        "skipOn": skipOn.toJson(),
      };

  @override
  List<Object?> get props => [initialDate, recurringInterval, enabled, skipOn];
}
