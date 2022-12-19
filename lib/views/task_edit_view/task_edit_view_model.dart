import 'package:flutter/material.dart';
import 'package:task_reminder/base/base_view_model.dart';
import 'package:task_reminder/constants/errors.dart';
import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/dialogs/dialog_utils.dart';
import 'package:task_reminder/views/task_edit_view/utils/task_validation_exception.dart';
import 'package:timezone/timezone.dart' as tz;

class TaskEditViewModel extends BaseViewModel {
  final Task? task;
  late int id;
  late int position;
  late String title;
  late String description;
  late String category;
  late bool template;
  late bool canEditTemplateProperty;

  TaskEditViewModel(this.task, {int? newId}) {
    id = newId ?? task?.id as int;
    title = task?.title ?? "";
    description = task?.description ?? "";
    category = task?.category ?? "";
    template = task?.template ?? false;
    canEditTemplateProperty = task == null;
  }

  Future save() async {
    var newTask = Task(
        id: id,
        title: title,
        description: description,
        created: task?.created ?? tz.TZDateTime.now(tz.local),
        category: category,
        template: template);

    if (!newTask.isValid()) {
      throw TaskValidationException(taskCreationEditError);
    }

    if (task == null) {
      await databaseService.addTask(newTask);
    } else {
      await databaseService.replaceTask(task!, newTask);
    }
  }

  Future showHelpDialog(BuildContext context) async {
    await dialogService.showHelpDialog(context, DialogSource.template);
  }
}
