import 'package:app_example/dependency_setup.dart';
import 'package:app_example/navigation/navigation_service.dart';
import 'package:app_example/navigation/route_generator.dart';
import 'package:app_example/notification/notification_service.dart';
import 'package:app_example/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        navigatorKey: Get.find<NavigationService>()
            .navigatorKey, // <-- our navigation key
        theme: ThemeData(
            primarySwatch: Colors.blue,
            dialogBackgroundColor: AppColors.dialogBackground,
            scaffoldBackgroundColor: AppColors.appBackground),
        onGenerateRoute: (settings) =>
            RouteGenerator().generateRoute(settings));
  }
}
