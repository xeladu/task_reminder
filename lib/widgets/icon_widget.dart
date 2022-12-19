import 'package:flutter/material.dart';
import 'package:task_reminder/style/app_colors.dart';

class IconWidget extends StatelessWidget {
  final IconData icon;
  final double radius;

  const IconWidget({Key? key, required this.icon, this.radius = 24.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.appBackgroundSecondary,
        child: Icon(icon, size: radius, color: AppColors.icon));
  }
}
