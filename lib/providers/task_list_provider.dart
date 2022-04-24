import 'package:app_example/database/database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

// returns all tasks from the database
final taskListProvider = FutureProvider((ref) async {
  return await Get.find<DatabaseService>().getAllTasks();
});
