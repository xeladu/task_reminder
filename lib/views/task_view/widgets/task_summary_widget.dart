import 'package:app_example/database/models/task.dart';
import 'package:app_example/database/models/task_reminder.dart';
import 'package:app_example/style/app_colors.dart';
import 'package:app_example/style/text_styles.dart';
import 'package:app_example/widgets/wrapper_widget.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:percent_indicator/circular_percent_indicator.dart';

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
        _buildTaskStatisticsIndicator(task),
        Container(height: 10),
        _getProgressHint(task),
        Row(children: [
          Icon(Icons.alarm, size: 14, color: AppColors.description),
          Container(width: 3),
          Text(
              timeago.format(task.reminders.last.scheduledOn,
                  allowFromNow: true),
              style: TextStyles.taskDescriptionSmall)
        ])
      ]),
    );
  }

  Widget _buildTaskStatisticsIndicator(Task task) {
    var percentage = task.reminders.isEmpty
        ? 0.0
        : task.reminders
                .where(
                    (element) => element.state == TaskReminderActionState.done)
                .length /
            task.reminders.length;

    return Center(
        child: CircularPercentIndicator(
            radius: 25,
            lineWidth: 6,
            animation: true,
            animationDuration: 1000,
            percent: percentage,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: Colors.green.shade300,
            backgroundColor: Colors.grey,
            center: _getProgressLabel(task)));
  }

  Widget _getProgressHint(Task task) {
    var openRemindersCount = task.reminders
        .where((element) => element.state == TaskReminderActionState.none)
        .length;

    return openRemindersCount == 0
        ? Container()
        : Row(children: [
            Icon(Icons.warning_rounded, size: 14, color: AppColors.negative),
            Container(width: 3),
            Text("$openRemindersCount open reminders",
                style: TextStyles.taskDescriptionSmall)
          ]);
  }

  Widget _getProgressLabel(Task task) {
    var percentage = task.reminders.isEmpty
        ? 0.0
        : task.reminders
                .where(
                    (element) => element.state == TaskReminderActionState.done)
                .length /
            task.reminders.length;
    return percentage == 1.0
        ? Icon(Icons.check_rounded, color: AppColors.positive)
        : Text("${(percentage * 100).toStringAsFixed(0)}%");
  }
}
