import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:wits_test/data/models/tasks_model.dart';
import 'package:wits_test/data/repositery/tasks_repository.dart';

class TasksController extends GetxController {
  final TasksRepository repository;

  TasksController({required this.repository});

  RxBool hasInternetConnection = true.obs;

  RxList<TasksModel> tasks = <TasksModel>[].obs;
  RxBool isLoading = false.obs;
  RxBool isAddingTask = false.obs;
  RxBool isUpdatingTask = false.obs;

  RxBool isTaskSelectionStarted = false.obs;
  RxList<TasksModel> selectedTask = <TasksModel>[].obs;

  @override
  void onInit() {
    _checkInternetConnection();
    super.onInit();
  }

  void _checkInternetConnection() async {
    hasInternetConnection.value = await InternetConnection().hasInternetAccess;
    Get.find<TasksController>().fetchTasks();
  }

  Future<void> fetchTasks() async {
    isLoading.value = true;

    try {
      List<TasksModel> data = await repository.getTasks();
      tasks.clear();
      tasks.addAll(data);
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addTask(TasksModel task) async {
    isAddingTask.value = true;

    try {
      return await repository.addTask(task);
    } finally {
      await fetchTasks();
      isAddingTask.value = false;
    }
  }

  Future<bool> updateTask(TasksModel task) async {
    isUpdatingTask.value = true;

    try {
      return await repository.updateTask(task);
    } finally {
      await fetchTasks();
      isUpdatingTask.value = false;
    }
  }

  Future<bool> deleteTask(TasksModel task) async {
    isUpdatingTask.value = true;

    try {
      await repository.deleteTask(task);
    } finally {
      await fetchTasks();
      isUpdatingTask.value = false;
    }
    return true;
  }

  Future<bool> markTaskStatus(TasksModel task) async {
    isUpdatingTask.value = true;

    try {
      task.isCompleted = task.isCompleted == 0 ? 1 : 0;
      await repository.updateTask(task);
    } finally {
      await fetchTasks();
      isUpdatingTask.value = false;
    }
    return true;
  }

  Future<void> markSelectedTasksStatus() async {
    isUpdatingTask.value = true;

    try {
      await Future.wait(selectedTask.map((task) {
        task.isCompleted = task.isCompleted == 0 ? 1 : 0;
        return repository.updateTask(task);
      }));
    } finally {
      await fetchTasks();
      clearTaskSelectionMode();
      isUpdatingTask.value = false;
    }
  }

  Future<void> deleteSelectedTasksStatus() async {
    isUpdatingTask.value = true;

    try {
      await Future.wait(selectedTask.map((task) {
        return repository.deleteTask(task);
      }));
    } finally {
      await fetchTasks();
      clearTaskSelectionMode();
      isUpdatingTask.value = false;
    }
  }

  void toggelTaskSelectionMode() {
    selectedTask.clear();
    isTaskSelectionStarted.value = !isTaskSelectionStarted.value;
  }

  void clearTaskSelectionMode() {
    selectedTask.clear();
    isTaskSelectionStarted.value = false;
  }

  void selectTask(TasksModel task) {
    if (selectedTask.contains(task)) {
      selectedTask.remove(task);
    } else {
      selectedTask.add(task);
    }
  }
}
