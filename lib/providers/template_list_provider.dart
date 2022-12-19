import 'package:task_reminder/database/database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

// returns all template tasks from the database
final templateListProvider = FutureProvider((ref) async {
  return await Get.find<DatabaseService>().getAllTemplateTasks();
});
