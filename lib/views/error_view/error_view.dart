import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_reminder/navigation/navigation_service.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Error View")),
        body: Center(
            child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
                onPressed: () => Get.find<NavigationService>().goBack(),
                child: const Text("Go back")),
          ]),
        )));
  }
}
