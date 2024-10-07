import 'package:get/get.dart';
import 'package:wits_test/controllers/tasks_controller.dart';
import 'package:wits_test/data/api/tasks_api_service.dart';
import 'package:wits_test/data/database/tasks_db.dart';
import 'package:wits_test/data/models/tasks_model.dart';

class TasksRepository {
  final TasksApiService taskApiService;

  TasksRepository({required this.taskApiService});
  final TasksTable _tasksTable = TasksTable();

  Future<List<TasksModel>> getTasks() async {
    final TasksController tasksController = Get.find();
    List<TasksModel> tasks = [];

    if (tasksController.hasInternetConnection.isFalse) {
      tasks = await _tasksTable.getTasks();
    } else {
      tasks = await taskApiService.fetchTasks();
      await _tasksTable.deleteAllTasks();
      await _tasksTable.insertOrUpdateBulkTasksFromServer(tasks);
    }

    return tasks;
  }

  Future<bool> addTask(TasksModel task) async {
    final TasksController tasksController = Get.find();

    if (tasksController.hasInternetConnection.isFalse) {
      return await _tasksTable.insertOrUpdate(task);
    }
    return await taskApiService.addTask(task);
  }

  Future<bool> updateTask(TasksModel task) async {
    final TasksController tasksController = Get.find();

    if (tasksController.hasInternetConnection.isFalse) {
      return await _tasksTable.insertOrUpdate(task);
    }
    return await taskApiService.updateTask(task);
  }

  Future<bool> deleteTask(TasksModel task) async {
    final TasksController tasksController = Get.find();

    if (tasksController.hasInternetConnection.isFalse) {
      return await _tasksTable.deleteTask(task.id);
    }

    return await taskApiService.deleteTask(task);
  }
}
