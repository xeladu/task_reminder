import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_reminder/style/text_styles.dart';

class MultiLineTextFieldWidget extends StatelessWidget {
  final Function(String) onChangedHandler;
  final TextEditingController controller;
  final InputDecoration? decoration;
  final String label;
  final bool isRequiredField;

  const MultiLineTextFieldWidget(
      {Key? key,
      required this.onChangedHandler,
      required this.controller,
      this.decoration,
      required this.label,
      this.isRequiredField = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
        maxLines: 3,
        minLines: 3,
        maxLength: 128,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        controller: controller,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            label: Text(label, style: TextStyles.label),
            hintText: isRequiredField ? "Required field!" : null,
            hintStyle: TextStyles.label),
        onChanged: onChangedHandler);
  }
}
