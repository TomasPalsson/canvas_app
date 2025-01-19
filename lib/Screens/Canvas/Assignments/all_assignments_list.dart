import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Components/canvas/assignment_widget.dart';
import '../../../Models/Canvas/course.dart';
import '../../../Providers/assingment_provider.dart';

class AllAssignmentsList extends StatelessWidget {
  final Course course;
  const AllAssignmentsList({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.name),
        backgroundColor: course.color,
      ),
      body: Consumer<AssignmentProvider>(
          builder: (context, assignmentProvider, child) {
        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ListView.builder(
            itemCount: assignmentProvider.assignments.length,
            itemBuilder: (context, index) {
              return AssignmentWidget(
                  assignment: assignmentProvider.assignments[index]);
            },
          ),
        );
      }),
    );
  }
}
