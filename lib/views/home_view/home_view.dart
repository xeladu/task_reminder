import 'dart:collection';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/dialogs/dialog_service.dart';
import 'package:task_reminder/dialogs/dialog_utils.dart';
import 'package:task_reminder/providers/completed_task_list_provider.dart';
import 'package:task_reminder/providers/reminder_update_provider.dart';
import 'package:task_reminder/providers/reminder_update_state_provider.dart';
import 'package:task_reminder/providers/task_list_provider.dart';
import 'package:task_reminder/providers/template_list_provider.dart';
import 'package:task_reminder/style/text_styles.dart';
import 'package:task_reminder/views/home_view/home_view_model.dart';
import 'package:task_reminder/views/home_view/widgets/grouped_dismissible_list_widget.dart';
import 'package:task_reminder/widgets/action_button_widget.dart';
import 'package:task_reminder/widgets/empty_data_widget.dart';
import 'package:task_reminder/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  final HomeViewModel viewModel;

  const HomeView(this.viewModel, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<HomeView> {
  final String _heading = "All tasks";

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(taskListProvider);

    return provider.when(
        loading: _buildLoadingContent,
        error: _buildErrorContent,
        data: (data) => _buildDataContent(data));
  }

  Widget _buildLoadingContent() {
    return const Scaffold(body: LoadingWidget());
  }

  Widget _buildErrorContent(Object? o, StackTrace? st) {
    return Scaffold(body: ErrorWidget(o.toString()));
  }

  Widget _buildDataContent(List<Task> data) {
    return Scaffold(
        body: Stack(children: [
      Padding(
          padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _buildActionBar(),
            Container(height: 10),
            data.isEmpty ? _buildEmptyDataContent() : _buildTaskList(data)
          ])),
      _buildUpdateIndicator()
    ]));
  }

  Widget _buildTaskList(List<Task> data) {
    var items = _groupData(data);
    return Expanded(
        child: GroupedDismissibleListWidget(
            onLongPress: (item) async {
              await widget.viewModel.showOptionsDialog(context, item);
              ref.refresh(taskListProvider);
            },
            items: items,
            onTap: (item) async {
              await widget.viewModel.goToTaskEditView(item);
              await widget.viewModel.updateNotification(ref);
              ref.refresh(taskListProvider);
            },
            onConfirmDismiss: (item) async =>
                await widget.viewModel.isCompletionConfirmed(item, context),
            onDismissed: (item) => _handleDismissed(item)));
  }

  Widget _buildActionBar() {
    return Row(children: [
      Text(_heading, style: TextStyles.heading),
      const Spacer(),
      ActionButtonWidget(
          onPressed: () async {
            await widget.viewModel.addNewTask(ref);
            await widget.viewModel.updateNotification(ref);
            ref.refresh(taskListProvider);
          },
          icon: FontAwesomeIcons.plus),
      const SizedBox(width: 10),
      ActionButtonWidget(
          onPressed: () => Get.find<DialogService>()
              .showHelpDialog(context, DialogSource.homeView),
          icon: FontAwesomeIcons.solidCircleQuestion),
      const SizedBox(width: 10),
      ActionButtonWidget(
          onPressed: () async {
            ref.refresh(completedTaskListProvider);
            await widget.viewModel.goToHistoryView();
          },
          icon: FontAwesomeIcons.clockRotateLeft),
      const SizedBox(width: 10),
      ActionButtonWidget(
          onPressed: () async {
            ref.refresh(templateListProvider);
            await widget.viewModel.goToTemplateView();
          },
          icon: FontAwesomeIcons.solidCopy)
    ]);
  }

  Widget _buildEmptyDataContent() {
    return const EmptyDataWidget(message: "No data found!");
  }

  Widget _buildUpdateIndicator() {
    final updateDone = ref.watch(reminderUpdateStateProvider);

    if (updateDone) return const SizedBox();

    final provider = ref.watch(reminderUpdateProvider);
    return provider.when(
        data: (data) => const SizedBox(),
        error: (o, s) => const SizedBox(),
        loading: () => Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.all(10),
                child: const Text("Updating reminders..."))));
  }

  Map<String, List<Task>> _groupData(List<Task> data) {
    final res = SplayTreeMap<String, List<Task>>();

    for (var item in data) {
      var category = item.category.isEmpty ? "---" : item.category;

      if (!res.containsKey(category)) res[category] = <Task>[];

      res[category]!.add(item);
    }

    return res;
  }

  void _handleDismissed(Task item) {
    widget.viewModel.markAsCompleted(item);
    widget.viewModel.updateNotification(ref);
    ref.refresh(taskListProvider);

    widget.viewModel.showNotification(context, "Task completed");
  }
}
