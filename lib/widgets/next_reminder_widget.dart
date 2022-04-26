import 'package:flutter/material.dart';
import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/style/app_colors.dart';
import 'package:task_reminder/style/text_styles.dart';
import 'package:timeago/timeago.dart' as timeago;

class NextReminderWidget extends StatelessWidget {
  final Task task;

  const NextReminderWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var nextReminder = task.reminders
        .firstWhere((rem) => rem.scheduledOn.isAfter(DateTime.now()));

    return Row(children: [
      Icon(Icons.alarm, size: 14, color: AppColors.description),
      Container(width: 3),
      Text(timeago.format(nextReminder.scheduledOn, allowFromNow: true),
          style: TextStyles.taskDescriptionSmall)
    ]);
  }
}
