import 'package:app_example/database/database_service.dart';
import 'package:app_example/database/models/skip_configuration.dart';
import 'package:app_example/database/models/task.dart';
import 'package:app_example/database/models/task_reminder.dart';
import 'package:app_example/database/models/task_reminder_configuration.dart';
import 'package:app_example/notification/reminder_service.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;

class TaskEditViewModel {
  final Task? task;
  late int id;
  late String title;
  late String description;
  late tz.TZDateTime firstExecution;
  late bool skipMondays;
  late bool skipTuesdays;
  late bool skipWednesdays;
  late bool skipThursdays;
  late bool skipFridays;
  late bool skipSaturdays;
  late bool skipSundays;
  late bool enabled;

  TaskEditViewModel(this.task, {int? newId}) {
    id = newId ?? task?.id as int;
    title = task?.title ?? "";
    description = task?.description ?? "";
    firstExecution = task?.configuration.initialDate ??
        tz.TZDateTime.now(tz.local).add(const Duration(minutes: 2));
    skipMondays = task?.configuration.skipOn.monday ?? false;
    skipTuesdays = task?.configuration.skipOn.tuesday ?? false;
    skipWednesdays = task?.configuration.skipOn.wednesday ?? false;
    skipThursdays = task?.configuration.skipOn.thursday ?? false;
    skipFridays = task?.configuration.skipOn.friday ?? false;
    skipSaturdays = task?.configuration.skipOn.saturday ?? false;
    skipSundays = task?.configuration.skipOn.sunday ?? false;
    enabled = task?.configuration.enabled ?? false;
  }

  Future save() async {
    var newTask = Task(
        id: id,
        title: title,
        description: description,
        created: task?.created ?? tz.TZDateTime.now(tz.local),
        configuration: TaskReminderConfiguration(
            enabled: enabled,
            initialDate: firstExecution,
            recurringInterval: const Duration(days: 1),
            skipOn: SkipConfiguration(
                monday: skipMondays,
                tuesday: skipTuesdays,
                wednesday: skipWednesdays,
                thursday: skipThursdays,
                friday: skipFridays,
                saturday: skipSaturdays,
                sunday: skipSundays)),
        reminders: task?.reminders ?? <TaskReminder>[]);

    Get.find<ReminderService>().fillReminders(newTask);

    var dbService = Get.find<DatabaseService>();

    if (task == null) {
      await dbService.addTask(newTask);
    } else {
      await dbService.replaceTask(task!, newTask);
    }
  }
}
