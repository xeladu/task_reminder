import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_reminder/style/app_colors.dart';
import 'package:task_reminder/style/text_styles.dart';
import 'package:task_reminder/views/task_edit_view/task_edit_view_model.dart';
import 'package:task_reminder/views/task_edit_view/utils/task_validation_exception.dart';
import 'package:task_reminder/widgets/wrapper_widget.dart';
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
              _buildTaskReminderNotificationSelectorWidget(),
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
                          try {
                            await widget.viewModel.save();
                            Navigator.pop(context);
                          } on TaskValidationException catch (ex) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(ex.message)));
                          }
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
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const FaIcon(FontAwesomeIcons.clipboardList, size: 16),
        Container(width: 5),
        Text("Set task details", style: TextStyles.heading)
      ]),
      Container(height: 10),
      TextField(
        controller: _titleController,
        decoration: InputDecoration(
            label: const Text("Title"),
            helperText: "Required field!",
            helperStyle: TextStyle(color: AppColors.negative)),
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
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const FaIcon(FontAwesomeIcons.bell, size: 16),
        Container(width: 5),
        Text("First reminder on", style: TextStyles.heading)
      ]),
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

  Widget _buildTaskReminderNotificationSelectorWidget() {
    return WrapperWidget(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const FaIcon(FontAwesomeIcons.calendarWeek, size: 16),
        Container(width: 5),
        Text("How many reminders to schedule?", style: TextStyles.heading)
      ]),
      DropdownButtonHideUnderline(
          child: DropdownButton<int>(
              isExpanded: true,
              value: widget.viewModel.maxScheduledNotificationCount,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  widget.viewModel.maxScheduledNotificationCount = value;
                });
              },
              items: const [
            DropdownMenuItem(
                key: Key("1"), value: 1, child: Text("Just the next reminder")),
            DropdownMenuItem(
                key: Key("2"), value: 2, child: Text("The next 2 reminders")),
            DropdownMenuItem(
                key: Key("3"), value: 3, child: Text("The next 3 reminders")),
            DropdownMenuItem(
                key: Key("4"), value: 4, child: Text("The next 4 reminders")),
            DropdownMenuItem(
                key: Key("5"), value: 5, child: Text("The next 5 reminders")),
            DropdownMenuItem(
                key: Key("6"), value: 6, child: Text("The next 6 reminders")),
            DropdownMenuItem(
                key: Key("7"), value: 7, child: Text("The next 7 reminders")),
          ])),
      Text(
          "Amount of reminder notifications that will be scheduled in advance. Default is 1. Notifications are rescheduled on every app launch.",
          style: TextStyles.taskDescription)
    ]));
  }

  Widget _buildTaskSkipOptionsWidget() {
    return WrapperWidget(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
        const FaIcon(FontAwesomeIcons.gears, size: 16),
        Container(width: 5),
        Text("Select days to be skipped", style: TextStyles.heading)
      ]),
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
