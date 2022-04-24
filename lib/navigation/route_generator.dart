import 'package:app_example/views/error_view/error_view.dart';
import 'package:app_example/views/home_view/home_view.dart';
import 'package:app_example/views/home_view/home_view_model.dart';
import 'package:app_example/views/task_edit_view/task_edit_view.dart';
import 'package:app_example/views/task_edit_view/task_edit_view_model.dart';
import 'package:app_example/views/task_view/task_view.dart';
import 'package:app_example/views/task_view/task_view_model.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static const String routeError = "/error";
  static const String routeHome = "/";
  static const String routeTask = "/task";
  static const String routeTaskEdit = "/task/edit";

  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case routeHome:
        return _buildRoute(HomeView(HomeViewModel()));
      case routeTask:
        return _buildRoute(TaskView(TaskViewModel(settings.arguments as int)));
      case routeTaskEdit:
        return _buildRoute(TaskEditView(TaskEditViewModel(
            (settings.arguments as Map<String, dynamic>)["task"],
            newId: (settings.arguments as Map<String, dynamic>)["newTaskId"])));
      case routeError:
        return _buildRoute(const ErrorView());
      default:
        return _buildRoute(const ErrorView());
    }
  }

  Route _buildRoute(Widget widget) {
    return PageRouteBuilder(pageBuilder: (ctx, _, __) => widget);
  }
}
