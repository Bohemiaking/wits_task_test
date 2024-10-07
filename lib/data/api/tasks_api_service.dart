import 'package:wits_test/utils/constants/api_uris.dart';
import 'package:wits_test/data/api/api_core.dart';
import 'package:wits_test/data/models/tasks_model.dart';
import 'package:wits_test/utils/widgets/custom_snackbar.dart';

class TasksApiService {
  final ApiService _apiService = ApiService();

  Future<List<TasksModel>> fetchTasks() async {
    List<TasksModel> tasks = [];
    try {
      final response = await _apiService.dio.get(AppUri.mokeApiURI);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        tasks = data.map((task) => TasksModel.fromJson(task)).toList();
      } else {
        AppSnackBar.showSnackBar('Failed to fetch tasks');
      }
    } catch (e) {
      AppSnackBar.showSnackBar('Failed to fetch tasks');
      rethrow;
    }
    return tasks;
  }

  Future<bool> addTask(TasksModel tasksModel) async {
    bool result = false;
    try {
      final response = await _apiService.dio.post(
        AppUri.mokeApiURI,
        data: tasksModel.toJson(),
      );
      if (response.statusCode == 201) {
        result = true;
        await fetchTasks();
      } else {
        result = false;
        AppSnackBar.showSnackBar('Failed to add task');
      }
    } catch (e) {
      result = false;
      AppSnackBar.showSnackBar('Failed to add task');
      rethrow;
    }
    return result;
  }

  Future<bool> updateTask(TasksModel tasksModel) async {
    bool result = false;
    try {
      final response = await _apiService.dio.put(
        '${AppUri.mokeApiURI}/${tasksModel.id}',
        data: tasksModel.toJson(),
      );
      if (response.statusCode == 200) {
        result = true;
        await fetchTasks();
      } else {
        result = false;
        AppSnackBar.showSnackBar('Failed to update task');
      }
    } catch (e) {
      result = false;
      AppSnackBar.showSnackBar('Failed to update task');
    }
    return result;
  }

  Future<bool> deleteTask(TasksModel tasksModel) async {
    bool result = false;
    try {
      final response = await _apiService.dio.delete(
        '${AppUri.mokeApiURI}/${tasksModel.id}',
        data: tasksModel.toJson(),
      );
      if (response.statusCode == 200) {
        result = true;
        await fetchTasks();
      } else {
        result = false;
        AppSnackBar.showSnackBar('Failed to delete task');
      }
    } catch (e) {
      result = false;
      AppSnackBar.showSnackBar('Failed to delete task');
    }
    return result;
  }
}
