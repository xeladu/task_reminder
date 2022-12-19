import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_reminder/style/app_colors.dart';
import 'package:task_reminder/style/text_styles.dart';

class SnackBarBuilder {
  const SnackBarBuilder._();

  static SnackBar buildErrorSnackBar(String message) {
    return _buildSnackBar(
        message, FontAwesomeIcons.circleExclamation, AppColors.error);
  }

  static SnackBar buildDefaultSnackBar(String message) {
    return _buildSnackBar(message, FontAwesomeIcons.circleInfo, AppColors.icon);
  }

  static SnackBar _buildSnackBar(
      String message, IconData icon, Color iconColor) {
    return SnackBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        behavior: SnackBarBehavior.floating,
        content: Row(children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 5),
          Expanded(
              child: Text(message,
                  textAlign: TextAlign.center, style: TextStyles.label))
        ]),
        backgroundColor: AppColors.snackBarBackground);
  }
}
