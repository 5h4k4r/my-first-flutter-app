import 'package:flutter_complete_guide/models/todo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models/task.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        await db.execute(
            "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)");
        await db.execute(
            "CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)");
      },
      version: 1,
    );
  }

  Future<int> insertTask(Task task) async {
    Database _db = await database();
    return await _db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateTaskDesc(int id, String desc) async {
    Database _db = await database();
    await _db
        .rawUpdate("UPDATE tasks SET description = '$desc' WHERE id = '$id'");
  }

  Future<int> insertTodo(Todo todo) async {
    Database _db = await database();
    return await _db.insert(
      'todo',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> listTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');

    return List.generate(taskMap.length, (index) {
      return Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          description: taskMap[index]['description']);
    });
  }

  Future<List<Todo>> getTodo(int id) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap =
        await _db.rawQuery("select * from todo where taskId = $id");

    return List.generate(todoMap.length, (index) {
      return Todo(
          id: todoMap[index]['id'],
          title: todoMap[index]['title'],
          isDone: todoMap[index]['isDone'],
          taskId: todoMap[index]['taskId']);
    });
  }

  Future<int> updateTodo(int id, int isDone) async {
    Database _db = await database();
    return await _db
        .rawUpdate("update todo set isDone = $isDone where id = $id");
  }

  Future<int> deleteTask(int id) async {
    Database _db = await database();
    await _db.rawDelete("delete from todo where taskId = $id");
    return await _db.rawDelete("delete from tasks where id = $id");
  }
}
