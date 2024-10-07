import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wits_test/controllers/tasks_controller.dart';
import 'package:wits_test/data/api/tasks_api_service.dart';
import 'package:wits_test/data/repositery/tasks_repository.dart';
import 'package:wits_test/utils/routes/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(scheme: FlexScheme.gold),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.gold),
      themeMode: ThemeMode.dark,
      routeInformationParser: AppRoutes().router.routeInformationParser,
      routeInformationProvider: AppRoutes().router.routeInformationProvider,
      routerDelegate: AppRoutes().router.routerDelegate,
      initialBinding: InitialBinding(),
    );
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TasksController(
        repository: TasksRepository(taskApiService: TasksApiService())));
  }
}
