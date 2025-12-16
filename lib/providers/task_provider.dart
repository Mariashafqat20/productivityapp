import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../core/database_helper.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  
  // In-memory storage for Web
  List<Task> _webTasks = [];

  List<Task> get tasks => _tasks;

  Future<void> loadTasks() async {
    if (kIsWeb) {
      _tasks = [..._webTasks];
    } else {
      _tasks = await DatabaseHelper.instance.readAllTasks();
    }
    notifyListeners();
  }
  
  Future<void> loadTasksByDate(String date) async {
       await loadTasks(); 
  }

  Future<void> addTask(Task task) async {
    if (kIsWeb) {
      // Simulate ID generation
      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch,
        title: task.title,
        description: task.description,
        date: task.date,
        startTime: task.startTime,
        endTime: task.endTime,
        priority: task.priority,
        isCompleted: task.isCompleted,
        course: task.course,
      );
      _webTasks.add(newTask);
    } else {
      await DatabaseHelper.instance.createTask(task);
    }
    await loadTasks();
  }

  Future<void> updateTask(Task task) async {
    if (kIsWeb) {
      final index = _webTasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _webTasks[index] = task;
      }
    } else {
      await DatabaseHelper.instance.updateTask(task);
    }
    await loadTasks();
  }

  Future<void> deleteTask(int id) async {
    if (kIsWeb) {
      _webTasks.removeWhere((t) => t.id == id);
    } else {
      await DatabaseHelper.instance.deleteTask(id);
    }
    await loadTasks();
  }

  Future<void> toggleTaskStatus(Task task) async {
    final newTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      date: task.date,
      startTime: task.startTime,
      endTime: task.endTime,
      priority: task.priority,
      isCompleted: task.isCompleted == 0 ? 1 : 0,
      course: task.course,
    );
    await updateTask(newTask);
  }
  
  double getCompletionPercentage() {
      if (_tasks.isEmpty) return 0.0;
      int completed = _tasks.where((t) => t.isCompleted == 1).length;
      return completed / _tasks.length;
  }
}
