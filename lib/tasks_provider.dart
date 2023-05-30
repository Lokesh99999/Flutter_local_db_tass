import 'package:assignment/TasksModel.dart';
import 'package:assignment/utils/TasksDbHelper.dart';
import 'package:flutter/material.dart';

class TasksProvider extends ChangeNotifier {
  List<TaskModel> tasks = [];
  TasksDb db = TasksDb.instance;
  addTask(TaskModel task) async {
    bool isInserted = await db.insert(table: 'tasks', data: task.toMap());
    if (isInserted) tasks.add(task);
    notifyListeners();
  }

  getAllTass() async {
    List tasksRes = await db.getAll("tasks");
    tasks = tasksRes.map((e) => TaskModel.fromJson(e)).toList();
    notifyListeners();
  }

  updateTask(TaskModel task, String update) async {
    bool updated = await db.update('tasks', task, update);
    if (updated) {
      getAllTass();
    }
  }

  removeTask(TaskModel task) async {
    if (task.id != null) {
      bool deleted = await db.delete(task.id ?? 0, 'tasks');
      getAllTass();
    }
  }
}
