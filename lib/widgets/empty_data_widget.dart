import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:task_reminder/style/app_colors.dart';
import 'package:task_reminder/style/text_styles.dart';

class EmptyDataWidget extends StatelessWidget {
  final String message;

  const EmptyDataWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 88.0, 8.0, 8.0),
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          FaIcon(FontAwesomeIcons.triangleExclamation,
              size: 64, color: AppColors.warning),
          const SizedBox(height: 10),
          Text(message, style: TextStyles.heading, textAlign: TextAlign.center)
        ])));
  }
}
