import 'package:sqflite/sqflite.dart';
import 'package:wits_test/data/models/tasks_model.dart';
import 'database_helper.dart';

class TasksTable {
  static const tableName = 'tasks';

  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnDesc = 'desc';
  static const columnDeadline = 'deadline';
  static const columnPriority = 'priority';
  static const columnIsCompleted = 'isCompleted';

  static const createTableQuery = '''
    CREATE TABLE $tableName (
      $columnId INTEGER PRIMARY KEY,
      $columnTitle TEXT NOT NULL,
      $columnDesc TEXT NOT NULL,
      $columnDeadline TEXT NOT NULL,
      $columnPriority TEXT NOT NULL,
      $columnIsCompleted INTEGER NOT NULL
    )
  ''';

  // Insert or update (overwrite) a district record
  Future<bool> insertOrUpdate(TasksModel task) async {
    Database? db = await MyDatabaseHelper.instance.database;
    await db!.insert(
      tableName,
      task.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return true;
  }

  Future<bool> insertOrUpdateBulkTasksFromServer(List<TasksModel> tasks) async {
    Database? db = await MyDatabaseHelper.instance.database;

    // Start a batch for bulk operations
    Batch batch = db!.batch();

    // Iterate over the tasks list and add each insert/update to the batch
    for (var task in tasks) {
      batch.insert(
        tableName,
        task.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    // Commit the batch operation
    await batch.commit(noResult: true);

    return true;
  }

  Future<List<TasksModel>> getTasks() async {
    Database? db = await MyDatabaseHelper.instance.database;

    final List<Map<String, dynamic>> maps = await db!.query(tableName);

    return List.generate(maps.length, (i) {
      return TasksModel(
        id: maps[i]['id'].toString(),
        title: maps[i]['title'],
        desc: maps[i]['desc'],
        deadline: maps[i]['deadline'],
        priority: maps[i]['priority'],
        isCompleted: maps[i]['isCompleted'],
      );
    });
  }

  Future<bool> deleteTask(String? id) async {
    Database? db = await MyDatabaseHelper.instance.database;
    await db!.delete(
      tableName,
      where: '$columnId = ?',
      whereArgs: [int.parse(id.toString())],
    );
    return true;
  }

  Future<bool> deleteAllTasks() async {
    Database? db = await MyDatabaseHelper.instance.database;
    await db!.delete(tableName); // Deletes all rows in the tasks table
    return true;
  }
}
