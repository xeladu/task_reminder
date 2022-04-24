import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/providers/task_list_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// returns a Task object with the given id
final singleTaskProvider = FutureProvider.family<Task?, int>((ref, id) async {
  final tasks = await ref.watch(taskListProvider.future);

  return tasks.firstWhere((element) => element.id == id);
});
