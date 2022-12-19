import 'package:task_reminder/style/app_colors.dart';
import 'package:flutter/material.dart';

class WrapperWidget extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;

  const WrapperWidget({Key? key, required this.child, this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: kElevationToShadow[2],
            color: backgroundColor ?? AppColors.taskBackground),
        child: child);
  }
}
