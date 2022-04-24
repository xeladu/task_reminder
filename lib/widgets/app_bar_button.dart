import 'package:app_example/style/app_colors.dart';
import 'package:flutter/material.dart';

class AppBarButton extends StatelessWidget {
  final IconData icon;
  final Function() onPressed;

  const AppBarButton({Key? key, required this.icon, required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.appBackground),
            child: Icon(icon, color: AppColors.taskBackground)),
        onPressed: onPressed);
  }
}
