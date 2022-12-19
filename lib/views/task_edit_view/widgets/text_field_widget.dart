import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_reminder/style/text_styles.dart';

class TextFieldWidget extends StatelessWidget {
  final Function(String) onChangedHandler;
  final TextEditingController controller;
  final InputDecoration? decoration;
  final bool isRequiredField;
  final String label;

  const TextFieldWidget(
      {Key? key,
      required this.onChangedHandler,
      required this.controller,
      this.decoration,
      this.isRequiredField = false,
      required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
        maxLines: 1,
        minLines: 1,
        maxLength: 64,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        controller: controller,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelStyle: TextStyles.label,
            label: Text(label),
            hintText: isRequiredField ? "Required field!" : null,
            hintStyle: TextStyles.label),
        onChanged: onChangedHandler);
  }
}
