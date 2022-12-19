import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:task_reminder/navigation/navigation_service.dart';
import 'package:task_reminder/style/text_styles.dart';
import 'package:task_reminder/widgets/icon_widget.dart';

class DialogButtonWidget extends StatefulWidget {
  final Function onPressed;
  final String label;

  const DialogButtonWidget(
      {Key? key, required this.onPressed, required this.label})
      : super(key: key);

  @override
  State<DialogButtonWidget> createState() => _DialogButtonWidgetState();
}

class _DialogButtonWidgetState extends State<DialogButtonWidget> {
  bool _handlerRunning = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: _handlePressed,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              const IconWidget(icon: FontAwesomeIcons.check, radius: 14),
              const SizedBox(width: 10),
              Text(widget.label, style: TextStyles.buttonLabel)
            ])));
  }

  Future _handlePressed() async {
    if (_handlerRunning) return;

    setState(() {
      _handlerRunning = true;
    });

    await widget.onPressed();

    if (mounted) {
      setState(() {
        _handlerRunning = false;
      });
    }

    // close the dialog popup
    Get.find<NavigationService>().goBack();
  }
}
