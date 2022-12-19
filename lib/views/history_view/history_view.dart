import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:task_reminder/database/models/task.dart';
import 'package:task_reminder/dialogs/dialog_service.dart';
import 'package:task_reminder/dialogs/dialog_utils.dart';
import 'package:task_reminder/navigation/navigation_service.dart';
import 'package:task_reminder/providers/completed_task_list_provider.dart';
import 'package:task_reminder/style/text_styles.dart';
import 'package:task_reminder/views/history_view/history_view_model.dart';
import 'package:task_reminder/widgets/dismissible_task_widget.dart';
import 'package:task_reminder/widgets/action_button_widget.dart';
import 'package:task_reminder/widgets/empty_data_widget.dart';
import 'package:task_reminder/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_reminder/widgets/task_widget.dart';

class HistoryView extends ConsumerStatefulWidget {
  final HistoryViewModel viewModel;

  const HistoryView(this.viewModel, {Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _State();
}

class _State extends ConsumerState<HistoryView> {
  final String _heading = "Task archive";

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(completedTaskListProvider);

    return provider.when(
        loading: _buildLoadingContent,
        error: _buildErrorContent,
        data: (data) => _buildDataContent(data, ref));
  }

  Widget _buildLoadingContent() {
    return const Scaffold(body: LoadingWidget());
  }

  Widget _buildErrorContent(Object? o, StackTrace? st) {
    return Scaffold(body: ErrorWidget(o.toString()));
  }

  Widget _buildDataContent(List<Task> data, WidgetRef ref) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildActionBar(),
              Container(height: 10),
              data.isEmpty ? _buildEmptyDataContent() : _buildTaskList(data)
            ])));
  }

  Widget _buildTaskList(List<Task> data) {
    return Expanded(
        child: ListView.separated(
            padding: EdgeInsets.zero,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: ((context, index) => DismissibleTaskWidget(
                  task: data[index],
                  onConfirmDismiss: (dir) async => await widget.viewModel
                      .isDeletionConfirmed(data[index], context),
                  onDismissed: (dir) async {
                    await widget.viewModel.deleteTask(data[index]);
                    ref.refresh(completedTaskListProvider);
                  },
                  onLongPress: () async {
                    await widget.viewModel
                        .showOptionsDialog(context, data[index]);
                    ref.refresh(completedTaskListProvider);
                  },
                  backgroundLabel: "swipe\r\nto\r\ndelete",
                )),
            itemCount: data.length));
  }

  Widget _buildActionBar() {
    return Row(children: [
      Text(_heading, style: TextStyles.heading),
      const Spacer(),
      ActionButtonWidget(
          onPressed: () => Get.find<NavigationService>().goBack(result: null),
          icon: FontAwesomeIcons.arrowLeft),
      const SizedBox(width: 10),
      ActionButtonWidget(
          onPressed: () => Get.find<DialogService>()
              .showHelpDialog(context, DialogSource.historyView),
          icon: FontAwesomeIcons.solidCircleQuestion),
      const SizedBox(width: 10),
      ActionButtonWidget(
          onPressed: () async {
            if (await widget.viewModel.confirmDeletion(context)) {
              await widget.viewModel.clearTaskHistory(ref);
              ref.refresh(completedTaskListProvider);
            }
          },
          icon: FontAwesomeIcons.trash)
    ]);
  }

  Widget _buildEmptyDataContent() {
    return const EmptyDataWidget(
        message: "You haven't completed any tasks yet!");
  }
}
