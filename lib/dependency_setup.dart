import 'package:task_reminder/database/database_service.dart';
import 'package:task_reminder/dialogs/dialog_service.dart';
import 'package:task_reminder/navigation/navigation_service.dart';
import 'package:task_reminder/notification/notification_service.dart';
import 'package:get/get.dart';

class DependencySetup {
  static Future registerDependencies() async {
    await Get.putAsync<DatabaseService>(() => Future.value(DatabaseService()));
    await Get.putAsync<NavigationService>(
        () => Future.value(NavigationService()));
    await Get.putAsync<NotificationService>(
        () => Future.value(NotificationService()));
    await Get.putAsync<DialogService>(() => Future.value(DialogService()));
  }
}
