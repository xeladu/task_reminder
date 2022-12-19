import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/style/app_colors.dart';
import 'package:task_reminder/style/text_styles.dart';
import 'package:task_reminder/widgets/wrapper_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  final Function()? onLongPress;
  final Function()? onTap;
  final bool hideCategory;

  const TaskWidget(
      {Key? key,
      required this.task,
      this.onLongPress,
      this.onTap,
      this.hideCategory = false})
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
                const SizedBox(height: 5),
                Text(task.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.taskDescription),
                const SizedBox(height: 5),
                if (!hideCategory) _buildAnnotationRow()
              ])),
    );
  }

  Widget _buildAnnotationRow() {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      if (task.category != "")
        Chip(
            label: Text(task.category, style: TextStyles.subHeading),
            backgroundColor: AppColors.appBackgroundSecondary),
      if (task.category != "") const SizedBox(width: 10),
      if (task.completed != null)
        Chip(
            label: Text(
                DateFormat("dd.MM.yyyy").format(
                    DateTime.fromMicrosecondsSinceEpoch(
                        task.completed!.microsecondsSinceEpoch)),
                style: TextStyles.subHeading),
            backgroundColor: AppColors.appBackgroundSecondary)
    ]);
  }
}
