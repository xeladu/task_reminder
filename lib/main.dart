import 'package:flutter/services.dart';
import 'package:task_reminder/dependency_setup.dart';
import 'package:task_reminder/navigation/navigation_service.dart';
import 'package:task_reminder/navigation/route_generator.dart';
import 'package:task_reminder/notification/notification_service.dart';
import 'package:task_reminder/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  await DependencySetup.registerDependencies();
  await Hive.initFlutter();
  await Get.find<NotificationService>().init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Task Reminder',
        debugShowCheckedModeBanner: false,
        navigatorKey: Get.find<NavigationService>().navigatorKey,
        theme: ThemeData(
            primarySwatch: AppColors.primarySwatch,
            dialogBackgroundColor: AppColors.dialogBackground,
            scaffoldBackgroundColor: AppColors.appBackground),
        onGenerateRoute: (settings) =>
            RouteGenerator().generateRoute(settings));
  }
}
