import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:task_reminder/dialogs/dialog_utils.dart';
import 'package:task_reminder/navigation/navigation_service.dart';
import 'package:task_reminder/style/text_styles.dart';
import 'package:task_reminder/widgets/action_button_widget.dart';
import 'package:task_reminder/widgets/dialog_button_widget.dart';

class DialogService {
  late NavigationService _navigationService;

  DialogService() {
    _navigationService = Get.find<NavigationService>();
  }

  Future<OkCancelResult> showConfirmationDialog(
      BuildContext context, String message) async {
    return await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SimpleDialog(
              contentPadding: const EdgeInsets.all(16.0),
              title: Center(
                  child: Text("Confirmation", style: TextStyles.heading)),
              children: [
                ActionButtonWidget(
                    onPressed: () {},
                    icon: FontAwesomeIcons.circleExclamation,
                    noSplash: true),
                const SizedBox(height: 10),
                Text(message, style: TextStyles.labelBig),
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  TextButton(
                      onPressed: () =>
                          Navigator.of(context).pop(OkCancelResult.cancel),
                      child: const Text("No, cancel!")),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).pop(OkCancelResult.ok),
                      child: const Text("Yes, do it!"))
                ])
              ],
            ));
  }

  Future showHelpDialog(BuildContext context, DialogSource source) async {
    return await showDialog(
        barrierDismissible: true,
        context: context,
        builder: ((context) => SimpleDialog(
              contentPadding: const EdgeInsets.all(16.0),
              title: Center(
                  child: Text(DialogUtils.getHelpTitleBySource(source),
                      style: TextStyles.heading)),
              children: [
                ActionButtonWidget(
                    onPressed: () {},
                    icon: FontAwesomeIcons.solidCircleQuestion,
                    noSplash: true),
                const SizedBox(height: 10),
                RichText(
                    text: TextSpan(
                        style: TextStyles.labelBig,
                        text: DialogUtils.getHelpTextBySource(source))),
                const SizedBox(height: 10),
                Center(
                  child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                          child: const Text("Got it!"),
                          onPressed: () => _navigationService.goBack())),
                )
              ],
            )));
  }

  Future showOptionsDialog(BuildContext context, String title,
      List<DialogButtonWidget> options) async {
    return await showDialog(
        barrierDismissible: true,
        context: context,
        builder: ((context) => SimpleDialog(
              contentPadding: const EdgeInsets.all(16.0),
              title: Center(child: Text(title, style: TextStyles.heading)),
              children: [
                ActionButtonWidget(
                    onPressed: () {},
                    icon: FontAwesomeIcons.listCheck,
                    noSplash: true),
                const SizedBox(height: 10),
                ...options
              ],
            )));
  }
}
