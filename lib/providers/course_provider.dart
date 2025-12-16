import 'package:flutter/material.dart';
import '../models/course.dart';
import '../core/database_helper.dart';

class CourseProvider with ChangeNotifier {
  List<Course> _courses = [];

  List<Course> get courses => _courses;

  Future<void> loadCourses() async {
    _courses = await DatabaseHelper.instance.readAllCourses();
    notifyListeners();
  }

  Future<void> addCourse(Course course) async {
    await DatabaseHelper.instance.createCourse(course);
    await loadCourses();
  }

  Future<void> updateCourse(Course course) async {
    await DatabaseHelper.instance.updateCourse(course);
    await loadCourses();
  }

  Future<void> deleteCourse(int id) async {
    await DatabaseHelper.instance.deleteCourse(id);
    await loadCourses();
  }
}
