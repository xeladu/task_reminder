import 'package:flutter/material.dart';

class MarkButtonWidget extends StatelessWidget {
  final Color backgroundColor;
  final String label;
  final Function() onPressed;
  final Widget avatar;

  const MarkButtonWidget(
      {Key? key,
      required this.backgroundColor,
      required this.label,
      required this.onPressed,
      required this.avatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ActionChip(
        backgroundColor: backgroundColor,
        shadowColor: Colors.black,
        elevation: 3,
        avatar: avatar,
        label: SizedBox(
            width: 80,
            child: Center(
                child:
                    Text(label, style: const TextStyle(color: Colors.white)))),
        onPressed: onPressed);
  }
}
