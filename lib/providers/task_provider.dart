import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../core/database_helper.dart';
import '../services/notification_service.dart';

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

  // Updated addTask with Notification logic
  Future<void> addTask(Task task, {int minutesEarly = 10}) async {
    int id;
    if (kIsWeb) {
      id = DateTime.now().millisecondsSinceEpoch;
      final newTask = task.copyWith(id: id);
      _webTasks.add(newTask);
    } else {
      id = await DatabaseHelper.instance.createTask(task);
    }

    // Schedule Notification (Mobile only)
    if (!kIsWeb) {
      _scheduleTaskNotification(id, task, minutesEarly);
    }

    await loadTasks();
  }

  // Fixed: Added missing updateTask method
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

  // Fixed: Added missing deleteTask method
  Future<void> deleteTask(int id) async {
    if (kIsWeb) {
      _webTasks.removeWhere((t) => t.id == id);
    } else {
      await DatabaseHelper.instance.deleteTask(id);
      // Cancel notification when task is deleted
      NotificationService().cancelNotification(id);
    }
    await loadTasks();
  }

  // Fixed: Added missing toggleTaskStatus method
  Future<void> toggleTaskStatus(Task task) async {
    final newTask = task.copyWith(
      isCompleted: task.isCompleted == 0 ? 1 : 0,
    );
    await updateTask(newTask);
  }

  double getCompletionPercentage() {
    if (_tasks.isEmpty) return 0.0;
    int completed = _tasks.where((t) => t.isCompleted == 1).length;
    return completed / _tasks.length;
  }

  // Helper to schedule notification
  void _scheduleTaskNotification(int id, Task task, int minutesEarly) {
    try {
      // Parse Date and Time strings to DateTime object
      // task.date format "2023-12-25"
      // task.startTime format "10:30 AM" or "10:30"

      final dateParts = task.date.split('-'); // [2023, 12, 25]
      final timeParts = task.startTime.split(' '); // ["10:30", "AM"] or just ["10:30"]
      final hourMin = timeParts[0].split(':'); // ["10", "30"]

      int hour = int.parse(hourMin[0]);
      int minute = int.parse(hourMin[1]);

      // Handle AM/PM if present
      if (timeParts.length > 1) {
        if (timeParts[1] == "PM" && hour != 12) hour += 12;
        if (timeParts[1] == "AM" && hour == 12) hour = 0;
      }

      final DateTime taskTime = DateTime(
          int.parse(dateParts[0]),
          int.parse(dateParts[1]),
          int.parse(dateParts[2]),
          hour,
          minute
      );

      final scheduledTime = taskTime.subtract(Duration(minutes: minutesEarly));

      if (scheduledTime.isAfter(DateTime.now())) {
        NotificationService().scheduleNotification(
          id: id,
          title: "Upcoming Task: ${task.title}",
          body: "Your task starts in $minutesEarly mins! (${task.startTime})",
          scheduledTime: scheduledTime,
        );
      }
    } catch (e) {
      print("Error parsing time for notification: $e");
    }
  }
}