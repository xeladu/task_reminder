import 'package:flutter/cupertino.dart';
import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/style/app_colors.dart';
import 'package:task_reminder/style/text_styles.dart';

class StatisticsWidget extends StatelessWidget {
  final Task task;

  const StatisticsWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var donePercentage = task.getDoneReminderPercentage();
    var skippedPercentage = task.getSkippedReminderPercentage();
    var remainingPercentage = task.getRemainingReminderPercentage();

    var radiusPosRight = skippedPercentage == 0.0 && remainingPercentage == 0.0
        ? const Radius.circular(10)
        : Radius.zero;
    var radiusNegLeft =
        donePercentage == 0.0 ? const Radius.circular(10) : Radius.zero;
    var radiusNegRight =
        remainingPercentage == 0.0 ? const Radius.circular(10) : Radius.zero;
    var radiusWarnLeft = donePercentage == 0.0 && skippedPercentage == 0.0
        ? const Radius.circular(10)
        : Radius.zero;

    return SizedBox(
        height: 20,
        child: Row(children: [
          if (donePercentage != 0.0)
            Flexible(
                flex: _convertToInt(donePercentage),
                child: Stack(children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                              left: const Radius.circular(10),
                              right: radiusPosRight),
                          color: AppColors.positive)),
                  Center(child: _getProgressLabel(donePercentage))
                ])),
          if (skippedPercentage != 0.0)
            Flexible(
                flex: _convertToInt(skippedPercentage),
                child: Stack(children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                              right: radiusNegRight, left: radiusNegLeft),
                          color: AppColors.negative)),
                  Center(child: _getProgressLabel(skippedPercentage))
                ])),
          if (remainingPercentage != 0.0)
            Flexible(
                flex: _convertToInt(remainingPercentage),
                child: Stack(children: [
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.horizontal(
                              left: radiusWarnLeft,
                              right: const Radius.circular(10)),
                          color: AppColors.warning)),
                  Center(child: _getProgressLabel(remainingPercentage))
                ]))
        ]));
  }

  Widget _getProgressLabel(double percentage) {
    return Text("${(percentage * 100).toStringAsFixed(0)}%",
        style: TextStyles.statisticsLabel,
        overflow: TextOverflow.clip,
        maxLines: 1);
  }

  int _convertToInt(double percentage) {
    return (percentage * 100).round();
  }
}
