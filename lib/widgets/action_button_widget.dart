import 'package:flutter/material.dart';
import 'package:task_reminder/style/app_colors.dart';

class ActionButtonWidget extends StatelessWidget {
  final Function()? onPressed;
  final IconData icon;
  final bool noSplash;

  const ActionButtonWidget(
      {Key? key,
      required this.onPressed,
      required this.icon,
      this.noSplash = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.appBackgroundSecondary,
        child: IconButton(
          splashColor: AppColors.splashBackground,
          splashRadius: noSplash ? 0.1 : 10.0,
          color: AppColors.icon,
          icon: Icon(icon, size: 24),
          onPressed: onPressed,
        ));
  }
}
