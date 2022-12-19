import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:task_reminder/navigation/navigation_service.dart';
import 'package:task_reminder/style/text_styles.dart';
import 'package:task_reminder/views/task_edit_view/task_edit_view_model.dart';
import 'package:task_reminder/views/task_edit_view/utils/task_validation_exception.dart';
import 'package:task_reminder/views/task_edit_view/widgets/multi_line_text_field_widget.dart';
import 'package:task_reminder/views/task_edit_view/widgets/text_field_widget.dart';
import 'package:task_reminder/widgets/action_button_widget.dart';
import 'package:task_reminder/widgets/snack_bar_builder.dart';
import 'package:task_reminder/widgets/wrapper_widget.dart';
import 'package:flutter/material.dart';

class TaskEditView extends StatefulWidget {
  final TaskEditViewModel viewModel;

  const TaskEditView(this.viewModel, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<TaskEditView> {
  final String _heading = "Set task details";
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.viewModel.title;
    _descriptionController.text = widget.viewModel.description;
    _categoryController.text = widget.viewModel.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
            child: _buildTaskDetailWidget()));
  }

  Widget _buildTaskDetailWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildActionBar(),
      const SizedBox(height: 10),
      WrapperWidget(
          child: Column(children: [
        const SizedBox(height: 10),
        TextFieldWidget(
            isRequiredField: true,
            label: "Name your task!",
            onChangedHandler: (val) {
              widget.viewModel.title = val;
              _refreshUi();
            },
            controller: _titleController),
        const SizedBox(height: 10),
        MultiLineTextFieldWidget(
            label: "Describe your task with a few words",
            onChangedHandler: (val) {
              widget.viewModel.description = val;
              _refreshUi();
            },
            controller: _descriptionController),
        const SizedBox(height: 10),
        TextFieldWidget(
            label: "Choose a task category",
            onChangedHandler: (val) {
              widget.viewModel.category = val;
              _refreshUi();
            },
            controller: _categoryController),
        const SizedBox(height: 10),
        CheckboxListTile(
            title: Text("Set as template to quickly create copies",
                style: TextStyles.labelBig),
            secondary: ActionButtonWidget(
                icon: FontAwesomeIcons.solidCircleQuestion,
                onPressed: () async {
                  await widget.viewModel.showHelpDialog(context);
                }),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: widget.viewModel.template,
            onChanged: (val) {
              if (widget.viewModel.canEditTemplateProperty) {
                setState(() {
                  widget.viewModel.template = val as bool;
                });
              } else {
                widget.viewModel.showNotification(context,
                    "Please create a new task and mark it as a template!");
              }
            })
      ]))
    ]);
  }

  Widget _buildActionBar() {
    return Row(children: [
      Text(_heading, style: TextStyles.heading),
      const Spacer(),
      ActionButtonWidget(
          onPressed: () async {
            try {
              await widget.viewModel.save();
              Get.find<NavigationService>().goBack();
            } on TaskValidationException catch (ex) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBarBuilder.buildErrorSnackBar(ex.message));
            }
          },
          icon: FontAwesomeIcons.check),
      const SizedBox(width: 10),
      ActionButtonWidget(
          onPressed: () => Get.find<NavigationService>().goBack(result: false),
          icon: FontAwesomeIcons.ban),
    ]);
  }

  void _refreshUi() {
    setState(() {});
  }
}
