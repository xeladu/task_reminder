import 'package:flutter/material.dart';
import 'package:task_reminder/constants/errors.dart';
import 'package:task_reminder/database/database_service.dart';
import 'package:task_reminder/database/models/task.dart';
import 'package:get/get.dart';
import 'package:task_reminder/dialogs/dialog_service.dart';
import 'package:task_reminder/dialogs/dialog_utils.dart';
import 'package:task_reminder/views/task_edit_view/utils/task_validation_exception.dart';
import 'package:task_reminder/widgets/snack_bar_builder.dart';
import 'package:timezone/timezone.dart' as tz;

class TaskEditViewModel {
  final Task? task;
  late int id;
  late int position;
  late String title;
  late String description;
  late String category;
  late bool template;
  late bool canEditTemplateProperty;

  late DialogService _dialogService;
  late DatabaseService _databaseService;

  TaskEditViewModel(this.task, {int? newId}) {
    id = newId ?? task?.id as int;
    title = task?.title ?? "";
    description = task?.description ?? "";
    category = task?.category ?? "";
    template = task?.template ?? false;
    canEditTemplateProperty = task == null;

    _dialogService = Get.find<DialogService>();
    _databaseService = Get.find<DatabaseService>();
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
      await _databaseService.addTask(newTask);
    } else {
      await _databaseService.replaceTask(task!, newTask);
    }
  }

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBarBuilder.buildDefaultSnackBar(message));
  }

  Future showHelpDialog(BuildContext context) async {
    await _dialogService.showHelpDialog(context, DialogSource.template);
  }
}
