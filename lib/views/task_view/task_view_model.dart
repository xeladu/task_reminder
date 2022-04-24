import 'package:app_example/database/database_service.dart';
import 'package:app_example/database/models/task.dart';
import 'package:app_example/database/models/task_reminder.dart';
import 'package:app_example/navigation/navigation_service.dart';
import 'package:app_example/navigation/route_generator.dart';
import 'package:app_example/providers/single_task_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

class TaskViewModel {
  final int taskId;
  TaskViewModel(this.taskId);

  void setReminderAsDone(int reminderId, WidgetRef ref) {
    _setReminder(reminderId, false, ref);
  }

  void setReminderAsSkipped(int reminderId, WidgetRef ref) {
    _setReminder(reminderId, true, ref);
  }

  Future goToTaskEditView(Task task) async {
    await Get.find<NavigationService>().navigateTo(RouteGenerator.routeTaskEdit,
        arguments: {"task": task, "newTaskId": null});
  }

  void _setReminder(int reminderId, bool skipped, WidgetRef ref) {
    final provider = ref.read(singleTaskProvider(taskId));

    provider.whenData((task) async {
      final reminder =
          task!.reminders.firstWhere((element) => element.id == reminderId);

      final newReminder = reminder.copyWith(
          newState: skipped
              ? TaskReminderActionState.skipped
              : TaskReminderActionState.done);

      final index = task.reminders.indexOf(reminder);
      task.reminders.removeAt(index);
      task.reminders.insert(index, newReminder);

      var dbService = Get.find<DatabaseService>();
      await dbService.updateTask(task);

      ref.refresh(singleTaskProvider(taskId));
    });
  }
}
