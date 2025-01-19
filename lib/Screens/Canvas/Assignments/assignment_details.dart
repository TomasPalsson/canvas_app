import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';

import '../../../Models/Canvas/assignment.dart';
import '../../../Providers/course_provider.dart';

class AssignmentDetails extends StatelessWidget {
  final Assignment assignment;
  const AssignmentDetails({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(assignment.name),
        backgroundColor: Provider.of<CourseProvider>(context)
            .getCourseById(assignment.courseId)
            .color,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: HtmlWidget(assignment.description),
          ),
        ],
      ),
    );
  }
}
