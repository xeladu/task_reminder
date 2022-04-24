import 'package:app_example/database/models/task.dart';
import 'package:app_example/database/models/task_reminder.dart';
import 'package:timezone/timezone.dart' as tz;

class ReminderService {
  /// Creates reminder objects for every recurring interval until the current
  /// date is reached. The latest reminder object will be used to schedule a
  /// notification.
  void fillReminders(Task task) {
    var dt = DateTime.now();
    var interval = task.configuration.recurringInterval!;

    // remove all reminders that haven't been marked and that are scheduled in the future
    task.reminders.removeWhere((element) =>
        element.scheduledOn.isAfter(DateTime.now()) &&
        element.state == TaskReminderActionState.none);

    // check the latest scheduled time
    var latestScheduledReminder = task.reminders.isNotEmpty
        ? task.reminders.last.scheduledOn
        : task.configuration.initialDate!.subtract(interval);

    // create missing reminders and make sure to add at least one upcoming reminder
    while (latestScheduledReminder.isBefore(dt) ||
        task.reminders.every((element) => element.scheduledOn.isBefore(dt))) {
      var nextScheduledReminder = latestScheduledReminder.add(interval);

      // if the new date is configured to be skipped, then no reminder is created
      if (_isSkipDay(nextScheduledReminder, task)) {
        latestScheduledReminder = nextScheduledReminder;
        continue;
      }

      // create a new reminder according to the recurringInterval
      _createReminder(task, nextScheduledReminder);

      latestScheduledReminder = nextScheduledReminder;
    }
  }

  void _createReminder(Task task, tz.TZDateTime scheduledOn) {
    task.reminders.add(TaskReminder(
        id: task.reminders.isNotEmpty ? task.reminders.last.id + 1 : 1,
        scheduledOn: scheduledOn,
        state: TaskReminderActionState.none));
  }

  bool _isSkipDay(DateTime scheduledDate, Task task) {
    switch (scheduledDate.weekday) {
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
        return false;
    }
  }
}
