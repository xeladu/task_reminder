import 'package:app_example/database/database_service.dart';
import 'package:app_example/navigation/navigation_service.dart';
import 'package:app_example/notification/notification_service.dart';
import 'package:app_example/notification/reminder_service.dart';
import 'package:get/get.dart';

class DependencySetup {
  static Future registerDependencies() async {
    await Get.putAsync<DatabaseService>(() => Future.value(DatabaseService()));
    await Get.putAsync<NavigationService>(
        () => Future.value(NavigationService()));
    await Get.putAsync<NotificationService>(
        () => Future.value(NotificationService()));
    await Get.putAsync<ReminderService>(() => Future.value(ReminderService()));
  }
}
