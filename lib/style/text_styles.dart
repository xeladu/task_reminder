import 'package:task_reminder/style/app_colors.dart';
import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle heading = TextStyle(
      fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.headingText);
  static TextStyle subHeading = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: AppColors.subHeadingText);
  static TextStyle buttonLabel = TextStyle(
      fontSize: 18, fontWeight: FontWeight.w500, color: AppColors.label);
  static TextStyle taskDescription =
      TextStyle(fontSize: 16, color: AppColors.description);
  static TextStyle dismissLabel =
      TextStyle(fontSize: 14, color: AppColors.descriptionSecondary);
  static TextStyle label = TextStyle(fontSize: 14, color: AppColors.label);
  static TextStyle labelBig = TextStyle(fontSize: 16, color: AppColors.label);
}
