import 'package:app_example/style/app_colors.dart';
import 'package:flutter/material.dart';

class WrapperWidget extends StatelessWidget {
  final Widget child;
  const WrapperWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: kElevationToShadow[2],
            color: AppColors.taskBackground),
        child: child);
  }
}
