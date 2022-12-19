import 'dart:convert';
import 'dart:math';

import 'package:task_reminder/database/models/task.dart';
import 'package:hive/hive.dart';

class DatabaseService {
  static const boxId = "tasks";

  Future<List<Task>> getAllOpenTasks() async {
    var box = await Hive.openBox(boxId);
    var res = box.values
        .map((entry) => Task.fromJson(jsonDecode(entry)))
        .where((task) => task.completed == null && !task.template)
        .toList();
    await box.close();

    return res;
  }

  Future<List<Task>> getAllCompletedTasks() async {
    var box = await Hive.openBox(boxId);
    var res = box.values
        .map((entry) => Task.fromJson(jsonDecode(entry)))
        .where((task) => task.completed != null)
        .toList();

    res.sort((t1, t2) => t1.completed!.isBefore(t2.completed!) ? 1 : -1);
    await box.close();

    return res;
  }

  Future<List<Task>> getAllTemplateTasks() async {
    var box = await Hive.openBox(boxId);
    var res = box.values
        .map((entry) => Task.fromJson(jsonDecode(entry)))
        .where((task) => task.template)
        .toList();
    await box.close();

    return res;
  }

  Future<int> getNewTaskId() async {
    var box = await Hive.openBox(boxId);
    var res =
        box.values.map((entry) => Task.fromJson(jsonDecode(entry))).toList();
    await box.close();

    final highestId = res.isEmpty ? 1 : res.map((e) => e.id).reduce(max) + 1;

    return highestId;
  }

  Future<Task> getTaskById(int id) async {
    return (await getAllOpenTasks())
        .firstWhere((element) => element.id == id, orElse: () => Task.empty());
  }

  Future addTask(Task task) async {
    var box = await Hive.openBox(boxId);
    await box.put(task.id, jsonEncode(task.toJson()));
    await box.close();
  }

  Future removeTask(Task task) async {
    var box = await Hive.openBox(boxId);
    await box.delete(task.id);
    await box.close();
  }

  Future replaceTask(Task oldTask, Task newTask) async {
    await removeTask(oldTask);
    await addTask(newTask);
  }

  Future updateTask(Task task) async {
    await replaceTask(task, task);
  }
}
