import 'package:flutter/material.dart';

import '../../Models/Canvas/assignment.dart';
import '../../Screens/Canvas/assignment_submission_screen.dart';
import '../../Screens/Canvas/quiz_screen.dart';
import '../../utils.dart';

class AssignmentWidget extends StatelessWidget {
  final Assignment assignment;
  const AssignmentWidget({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => assignment.isQuizAssignment
                ? QuizScreen(assignment: assignment)
                : AssignmentSubmissionScreen(assignment: assignment),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  assignment.isQuizAssignment ? Icons.quiz : Icons.assignment,
                  size: 32,
                  color: assignment.isQuizAssignment
                      ? Colors.orange
                      : Colors.grey[600],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        assignment.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (assignment.dueAt != null)
                        Text(
                          "Due: ${assignment.dueAt?.toBetterString() ?? ""}",
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
