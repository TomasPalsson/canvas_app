import 'package:canvas_app/Providers/http_provider.dart';
import 'package:flutter/material.dart';

import '../Models/Canvas/assignment.dart';

class AssignmentProvider extends ChangeNotifier {
  List<Assignment> assignments = [];

  // Get assignments for a course.
  // string [courseId] is the ID of the course to get assignments for.
  void getAssignments(String courseId) async {
    List<Assignment> response =
        await HttpProvider().get('courses/$courseId/assignments');
    assignments = response;
    notifyListeners();
  }
}
