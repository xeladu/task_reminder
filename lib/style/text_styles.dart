import 'package:app_example/style/app_colors.dart';
import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle heading =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
  static TextStyle subHeading =
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  static TextStyle reminderSkipped =
      TextStyle(fontWeight: FontWeight.bold, color: AppColors.negative);
  static TextStyle reminderDone =
      TextStyle(fontWeight: FontWeight.bold, color: AppColors.positive);
  static TextStyle taskDescription =
      TextStyle(fontSize: 14, color: AppColors.description);
  static TextStyle taskDescriptionSmall =
      TextStyle(fontSize: 12, color: AppColors.description);
}
