import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/style/app_colors.dart';
import 'package:task_reminder/style/text_styles.dart';
import 'package:task_reminder/widgets/task_widget.dart';

class DismissibleTaskWidget extends StatelessWidget {
  final Task task;
  final Function()? onLongPress;
  final Function()? onTap;
  final Future<bool?> Function(DismissDirection) onConfirmDismiss;
  final Function(DismissDirection) onDismissed;
  final String backgroundLabel;
  final bool hideCategory;

  const DismissibleTaskWidget(
      {Key? key,
      required this.task,
      required this.onConfirmDismiss,
      required this.onDismissed,
      this.onLongPress,
      this.onTap,
      this.backgroundLabel = "swipe\r\nto\r\ncomplete",
      this.hideCategory = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: onConfirmDismiss,
      onDismissed: onDismissed,
      direction: DismissDirection.startToEnd,
      dismissThresholds: <DismissDirection, double>{}
        ..[DismissDirection.startToEnd] = 0.4,
      background: Container(
          decoration: BoxDecoration(
              color: AppColors.appBackgroundSecondary,
              borderRadius: const BorderRadius.all(Radius.circular(6.0))),
          child: Row(children: [
            const SizedBox(width: 5),
            SizedBox(
                width: 60,
                child: Text(backgroundLabel,
                    style: TextStyles.dismissLabel,
                    textAlign: TextAlign.center)),
            const SizedBox(width: 5),
            Icon(FontAwesomeIcons.arrowRight, color: AppColors.icon),
            const SizedBox(width: 5),
            Icon(FontAwesomeIcons.arrowRight, color: AppColors.icon),
            const SizedBox(width: 5),
            Icon(FontAwesomeIcons.arrowRight, color: AppColors.icon)
          ])),
      child: TaskWidget(
          task: task,
          onLongPress: onLongPress,
          onTap: onTap,
          hideCategory: hideCategory),
      key: Key(task.id.toString()),
    );
  }
}
