import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart' as material;
import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/database/models/task_reminder.dart';
import 'package:task_reminder/style/app_colors.dart';
import 'package:task_reminder/style/text_styles.dart';
import 'package:task_reminder/widgets/wrapper_widget.dart';
import 'package:flutter/material.dart';

class TaskDetailWidget extends StatelessWidget {
  final Task task;

  const TaskDetailWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WrapperWidget(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Weekday summary", style: TextStyles.heading),
      SizedBox(
          height: 100,
          child: task.reminders.isEmpty
              ? const Center(child: Text("no data"))
              : BarChart(
                  _getData(),
                  barGroupingType: BarGroupingType.groupedStacked,
                  primaryMeasureAxis:
                      const NumericAxisSpec(renderSpec: NoneRenderSpec()),
                ))
    ]));
  }

  List<Series<DaySegment, String>> _getData() {
    return <Series<DaySegment, String>>[
      Series(
          id: "remaining",
          data: _calculateNotDonePercentagePerDay(),
          domainFn: (data, __) => data.day,
          labelAccessorFn: (item, _) => "",
          colorFn: (data, __) => data.isSkipDay
              ? _convertColor(AppColors.description)
              : _convertColor(AppColors.negative),
          measureFn: (data, __) => data.value),
      Series(
          id: "done",
          data: _calculateDonePercentagePerDay(),
          labelAccessorFn: (item, _) => "${(item.value * 100).round()}%",
          domainFn: (data, __) => data.day,
          colorFn: (_, __) => _convertColor(AppColors.positive),
          measureFn: (data, __) => data.value),
    ];
  }

  Color _convertColor(material.Color color) {
    return Color(g: color.green, b: color.blue, r: color.red);
  }

  List<DaySegment> _calculateDonePercentagePerDay() {
    var res = <DaySegment>[];

    if (task.reminders.isEmpty) return res;

    var dayNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

    for (var i = 1; i <= 7; i++) {
      var totalReminderPerDayCount = task.reminders
          .where((element) => element.scheduledOn.weekday == i)
          .length;
      var doneReminderPerDayCount = task.reminders
          .where((element) =>
              element.scheduledOn.weekday == i &&
              element.state == TaskReminderActionState.done)
          .length;

      _isSkipDay(i)
          ? res.add(DaySegment(dayNames[i - 1], 0, true))
          : res.add(DaySegment(
              dayNames[i - 1],
              totalReminderPerDayCount == 0
                  ? 0
                  : doneReminderPerDayCount / totalReminderPerDayCount,
              false));
    }

    return res;
  }

  List<DaySegment> _calculateNotDonePercentagePerDay() {
    var res = <DaySegment>[];

    if (task.reminders.isEmpty) return res;

    var done = _calculateDonePercentagePerDay();

    for (var item in done) {
      res.add(DaySegment(item.day, 1 - item.value, item.isSkipDay));
    }

    return res;
  }

  bool _isSkipDay(int weekday) {
    switch (weekday) {
      case 1:
        return task.configuration.skipOn.monday;
      case 2:
        return task.configuration.skipOn.tuesday;
      case 3:
        return task.configuration.skipOn.wednesday;
      case 4:
        return task.configuration.skipOn.thursday;
      case 5:
        return task.configuration.skipOn.friday;
      case 6:
        return task.configuration.skipOn.saturday;
      case 7:
        return task.configuration.skipOn.sunday;
      default:
        return true;
    }
  }
}

class DaySegment {
  final String day;
  final double value;
  final bool isSkipDay;

  DaySegment(this.day, this.value, this.isSkipDay);
}
