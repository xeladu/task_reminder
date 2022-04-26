import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/style/text_styles.dart';
import 'package:task_reminder/widgets/next_reminder_widget.dart';
import 'package:task_reminder/widgets/progress_hint_widget.dart';
import 'package:task_reminder/widgets/statistics_widget.dart';
import 'package:task_reminder/widgets/wrapper_widget.dart';
import 'package:flutter/material.dart';

class TaskSummaryWidget extends StatelessWidget {
  final Task task;

  const TaskSummaryWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WrapperWidget(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(task.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.heading),
      Text(task.description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.taskDescription),
      Container(height: 10),
      StatisticsWidget(task: task),
      Container(height: 10),
      ProgressHintWidget(task: task),
      NextReminderWidget(task: task)
    ]));
  }
}
