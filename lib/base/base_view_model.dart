import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_reminder/database/database_service.dart';
import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/dialogs/dialog_service.dart';
import 'package:task_reminder/navigation/navigation_service.dart';
import 'package:task_reminder/navigation/route_generator.dart';
import 'package:task_reminder/notification/notification_service.dart';
import 'package:task_reminder/widgets/snack_bar_builder.dart';

abstract class BaseViewModel {
  late NavigationService _navigationService;
  late DatabaseService _databaseService;
  late NotificationService _notificationService;
  late DialogService _dialogService;

  NavigationService get navigationService => _navigationService;
  DatabaseService get databaseService => _databaseService;
  NotificationService get notificationService => _notificationService;
  DialogService get dialogService => _dialogService;

  BaseViewModel() {
    _navigationService = Get.find<NavigationService>();
    _databaseService = Get.find<DatabaseService>();
    _notificationService = Get.find<NotificationService>();
    _dialogService = Get.find<DialogService>();
  }

  Future goToTaskEditView(Task task) async {
    await navigationService.navigateTo(RouteGenerator.routeTaskEdit,
        arguments: <String, dynamic>{}..["task"] = task);
  }

  Future goToHistoryView() async {
    await navigationService.navigateTo(RouteGenerator.routeHistory);
  }

  Future goToTemplateView() async {
    await navigationService.navigateTo(RouteGenerator.routeTemplate);
  }

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBarBuilder.buildDefaultSnackBar(message));
  }
}
