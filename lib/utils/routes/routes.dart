import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:wits_test/data/models/tasks_model.dart';
import 'package:wits_test/screens/add_edit_task_screen.dart';
import 'package:wits_test/screens/tasks_screen.dart';

class AppRoutes {
  static String get initialRoute => '/';
  static String get addTask => '/addTask';
  static String get editTask => '/editTask';

  static final GoRouter _router = GoRouter(
    navigatorKey: Get.key,
    initialLocation: initialRoute,
    routes: [
      GoRoute(
          path: initialRoute,
          builder: (context, state) => const TasksScreen(),
          routes: [
            GoRoute(
              path: addTask,
              builder: (context, state) => const AddEdditTaskScreen(),
            ),
            GoRoute(
              path: editTask,
              builder: (context, state) {
                final TasksModel task = state.extra as TasksModel;
                return AddEdditTaskScreen(
                  task: task,
                );
              },
            ),
          ]),
    ],
  );
  GoRouter get router => _router;
}
