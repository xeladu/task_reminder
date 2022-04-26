import 'package:flutter/material.dart';
import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/database/models/task_reminder.dart';
import 'package:task_reminder/style/app_colors.dart';
import 'package:task_reminder/style/text_styles.dart';

class ProgressHintWidget extends StatelessWidget {
  final Task task;

  const ProgressHintWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var openRemindersCount = task.reminders
        .where((element) => element.state == TaskReminderActionState.none)
        .length;

    return openRemindersCount == 0
        ? Text("", style: TextStyles.taskDescriptionSmall)
        : Row(children: [
            Icon(Icons.warning_rounded, size: 14, color: AppColors.warning),
            Container(width: 3),
            Text("$openRemindersCount open reminders",
                style: TextStyles.taskDescriptionSmall)
          ]);
  }
}
