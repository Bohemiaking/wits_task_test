import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wits_test/data/database/tasks_db.dart';

class MyDatabaseHelper {
  static const _databaseName = "app_db.db";
  static const _databaseVersion = 1;

  static final MyDatabaseHelper instance =
      MyDatabaseHelper._privateConstructor();
  static Database? _database;

  MyDatabaseHelper._privateConstructor();

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Add this for handling upgrades
    );
  }

  // Creating tables
  Future _onCreate(Database db, int version) async {
    await db.execute(TasksTable.createTableQuery);
  }

  // Upgrading the database schema
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    await db.execute(TasksTable.createTableQuery);
  }

  // Function to delete the database
  Future<void> deleteMyDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    await deleteDatabase(path);
    debugPrint('$_databaseName deleted');
  }
}
