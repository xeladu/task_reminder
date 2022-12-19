import 'package:flutter/material.dart';

class DropDownWidget extends StatelessWidget {
  final List<DropdownMenuItem<int>> items;
  final Function(int?) onChanged;
  final int value;

  const DropDownWidget(
      {Key? key,
      required this.items,
      required this.onChanged,
      required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
        child: DropdownButton<int>(
      value: value,
      isExpanded: true,
      items: items,
      onChanged: onChanged,
    ));
  }
}
