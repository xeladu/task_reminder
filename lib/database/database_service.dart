import 'dart:convert';

import 'package:app_example/database/models/task.dart';
import 'package:hive/hive.dart';

class DatabaseService {
  static const boxId = "tasks";

  Future<List<Task>> getAllTasks() async {
    var box = await Hive.openBox(boxId);
    var res =
        box.values.map((entry) => Task.fromJson(jsonDecode(entry))).toList();
    await box.close();

    return res;
  }

  Future<Task> getTaskById(int id) async {
    return (await getAllTasks())
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
