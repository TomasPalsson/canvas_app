import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../Models/Canvas/course.dart';
import '../Providers/http_provider.dart';

class CourseProvider extends ChangeNotifier {
  final List<Course> _courses = [];
  bool Function(Course)? _activeFilter = (course) => course.term == 164;

  List<Course> get courses => _activeFilter == null
      ? _courses
      : _courses.where(_activeFilter!).toList();

  // Get courses from the database and the Canvas API.
  Future<void> getCourses() async {
    Hive.box('courses').values.forEach((element) {
      _courses.add(element);
    });
    List<Course> newCourses = await HttpProvider().get<Course>('courses');

    for (var course in newCourses) {
      if (!_courses.contains(course)) {
        _courses.add(course);
        Hive.box('courses').put(course.id, course);
      }
    }
    notifyListeners();
  }

  void addCourse(Course course) {
    if (!Hive.box('courses').containsKey(course.id)) {
      _courses.add(course);
      Hive.box('courses').put(course.id, course);
      notifyListeners();
    }
  }

  void removeCourse(String id) {
    try {
      _courses.removeWhere((course) => course.id == id);
      Hive.box('courses').delete(id);
      notifyListeners();
    } catch (e) {
      print("Error removing course: $e");
    }
  }

  // Filter the courses list.
  // bool Function(Course)? [filter] is the filter to apply.
  void filterCourses(bool Function(Course)? filter) {
    _activeFilter = filter;
    notifyListeners();
  }

  // Get a course by its ID.
  // string [id] is the ID of the course to get.
  // Returns a Course object.
  Course getCourseById(String id) {
    try {
      return _courses.firstWhere((course) => course.id == id);
    } catch (e) {
      throw Exception("Course $id not found");
    }
  }
}
