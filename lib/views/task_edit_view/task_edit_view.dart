import 'package:app_example/style/app_colors.dart';
import 'package:app_example/style/text_styles.dart';
import 'package:app_example/views/task_edit_view/task_edit_view_model.dart';
import 'package:app_example/widgets/wrapper_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;

class TaskEditView extends StatefulWidget {
  final TaskEditViewModel viewModel;

  const TaskEditView(this.viewModel, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TaskEditView> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  bool _isEdit = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.viewModel.title;
    _descriptionController.text = widget.viewModel.description;
    _dateController.text =
        DateFormat("yyyy-MM-dd HH:mm").format(widget.viewModel.firstExecution);

    _isEdit = widget.viewModel.task != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
            child: ListView(padding: EdgeInsets.zero, children: [
              _buildTaskDetailWidget(),
              Container(height: 20),
              _buildTaskReminderWidget(),
              Container(height: 20),
              _buildTaskSkipOptionsWidget(),
              Container(height: 20),
              WrapperWidget(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Row(children: [
                          const Icon(Icons.arrow_back),
                          Container(width: 10),
                          const Text("Go back")
                        ])),
                    ElevatedButton(
                        onPressed: () async {
                          await widget.viewModel.save();
                          Navigator.pop(context);
                        },
                        child: Row(children: [
                          const Icon(Icons.check),
                          Container(width: 10),
                          const Text("Save")
                        ]))
                  ])),
            ])));
  }

  Widget _buildTaskDetailWidget() {
    return WrapperWidget(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Set task details", style: TextStyles.heading),
      Container(height: 10),
      TextField(
        controller: _titleController,
        decoration: const InputDecoration(label: Text("Title")),
        onChanged: (value) {
          widget.viewModel.title = value;
        },
      ),
      Container(height: 10),
      TextField(
        controller: _descriptionController,
        decoration: const InputDecoration(label: Text("Description")),
        onChanged: (value) {
          widget.viewModel.description = value;
        },
      )
    ]));
  }

  Widget _buildTaskReminderWidget() {
    return WrapperWidget(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("First reminder on", style: TextStyles.heading),
      Row(children: [
        Expanded(
            child: Text(DateFormat("yyyy-MM-dd HH:mm")
                .format(widget.viewModel.firstExecution))),
        Container(
            decoration: BoxDecoration(
                color: _isEdit
                    ? AppColors.taskBackground
                    : AppColors.appBackground,
                borderRadius: BorderRadius.circular(30)),
            child: IconButton(
                onPressed: _isEdit ? null : () async => await _selectDateTime(),
                icon:
                    Icon(Icons.calendar_today, color: AppColors.taskBackground),
                color: AppColors.taskBackground))
      ]),
      Text("Reminders will be scheduled daily",
          style: TextStyles.taskDescription)
    ]));
  }

  Widget _buildTaskSkipOptionsWidget() {
    return WrapperWidget(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Select days to be skipped", style: TextStyles.heading),
      Container(height: 10),
      SwitchListTile(
          visualDensity: VisualDensity.compact,
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text("Mondays"),
          contentPadding: EdgeInsets.zero,
          value: widget.viewModel.skipMondays,
          onChanged: (value) {
            widget.viewModel.skipMondays = value;
            _refreshUi();
          }),
      SwitchListTile(
          visualDensity: VisualDensity.compact,
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text("Tuesdays"),
          contentPadding: EdgeInsets.zero,
          value: widget.viewModel.skipTuesdays,
          onChanged: (value) {
            widget.viewModel.skipTuesdays = value;
            _refreshUi();
          }),
      SwitchListTile(
          visualDensity: VisualDensity.compact,
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text("Wednesdays"),
          contentPadding: EdgeInsets.zero,
          value: widget.viewModel.skipWednesdays,
          onChanged: (value) {
            widget.viewModel.skipWednesdays = value;
            _refreshUi();
          }),
      SwitchListTile(
          visualDensity: VisualDensity.compact,
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text("Thursdays"),
          contentPadding: EdgeInsets.zero,
          value: widget.viewModel.skipThursdays,
          onChanged: (value) {
            widget.viewModel.skipThursdays = value;
            _refreshUi();
          }),
      SwitchListTile(
          visualDensity: VisualDensity.compact,
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text("Fridays"),
          contentPadding: EdgeInsets.zero,
          value: widget.viewModel.skipFridays,
          onChanged: (value) {
            widget.viewModel.skipFridays = value;
            _refreshUi();
          }),
      SwitchListTile(
          visualDensity: VisualDensity.compact,
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text("Saturdays"),
          contentPadding: EdgeInsets.zero,
          value: widget.viewModel.skipSaturdays,
          onChanged: (value) {
            widget.viewModel.skipSaturdays = value;
            _refreshUi();
          }),
      SwitchListTile(
          visualDensity: VisualDensity.compact,
          dense: true,
          controlAffinity: ListTileControlAffinity.leading,
          title: const Text("Sundays"),
          contentPadding: EdgeInsets.zero,
          value: widget.viewModel.skipSundays,
          onChanged: (value) {
            widget.viewModel.skipSundays = value;
            _refreshUi();
          }),
    ]));
  }

  Future _selectDateTime() async {
    var date = await showDatePicker(
        context: context,
        helpText: "When should the task start?",
        initialDate: widget.viewModel.firstExecution,
        firstDate: DateTime.now().subtract(const Duration(days: 1)),
        lastDate: DateTime.now().add(const Duration(days: 365)));

    if (date != null) {
      var time = await showTimePicker(
          helpText: "At what time should a reminder be delivered?",
          context: context,
          initialTime: TimeOfDay.now());

      if (time != null) {
        widget.viewModel.firstExecution = tz.TZDateTime(
            tz.local, date.year, date.month, date.day, time.hour, time.minute);
        _refreshUi();
      }
    }
  }

  void _refreshUi() {
    setState(() {});
  }
}
