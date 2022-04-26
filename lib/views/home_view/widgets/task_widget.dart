import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/style/text_styles.dart';
import 'package:task_reminder/widgets/next_reminder_widget.dart';
import 'package:task_reminder/widgets/progress_hint_widget.dart';
import 'package:task_reminder/widgets/statistics_widget.dart';
import 'package:task_reminder/widgets/wrapper_widget.dart';
import 'package:flutter/material.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  final Function()? onLongPress;
  final Function()? onTap;
  const TaskWidget({Key? key, required this.task, this.onLongPress, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WrapperWidget(
      child: ListTile(
          contentPadding: EdgeInsets.zero,
          onLongPress: onLongPress,
          onTap: onTap,
          title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(task.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.heading),
                Expanded(
                    child: Text(task.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.taskDescription)),
                StatisticsWidget(task: task),
                Container(height: 15),
                ProgressHintWidget(task: task),
                NextReminderWidget(task: task)
              ])),
    );
  }
}
