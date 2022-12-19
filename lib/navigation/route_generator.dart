import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/views/error_view/error_view.dart';
import 'package:task_reminder/views/history_view/history_view.dart';
import 'package:task_reminder/views/history_view/history_view_model.dart';
import 'package:task_reminder/views/home_view/home_view.dart';
import 'package:task_reminder/views/home_view/home_view_model.dart';
import 'package:task_reminder/views/task_edit_view/task_edit_view.dart';
import 'package:task_reminder/views/task_edit_view/task_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:task_reminder/views/template_view/template_view.dart';
import 'package:task_reminder/views/template_view/template_view_model.dart';

class RouteGenerator {
  static const String routeError = "/error";
  static const String routeHome = "/";
  static const String routeTaskEdit = "/task/edit";
  static const String routeHistory = "/history";
  static const String routeTemplate = "/templates";

  Route generateRoute(RouteSettings settings) {
    var args = settings.arguments as Map<String, dynamic>?;
    Task? task = args?["task"];
    int? newId = args?["newId"];

    switch (settings.name) {
      case routeHome:
        return _buildRoute(HomeView(HomeViewModel()));
      case routeTaskEdit:
        return _buildRoute(TaskEditView(TaskEditViewModel(task, newId: newId)));
      case routeError:
        return _buildRoute(const ErrorView());
      case routeHistory:
        return _buildRoute(HistoryView(HistoryViewModel()));
      case routeTemplate:
        return _buildRoute(TemplateView(TemplateViewModel()));
      default:
        return _buildRoute(const ErrorView());
    }
  }

  Route _buildRoute(Widget widget) {
    return PageRouteBuilder(pageBuilder: (ctx, _, __) => widget);
  }
}
