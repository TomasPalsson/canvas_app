import 'package:flutter/material.dart';

import '../../Models/Canvas/course.dart';
import '../../Screens/Canvas/Course/course_detail.dart';
import '../../Screens/chat/chat_course.dart';

class CourseWidget extends StatelessWidget {
  final Course course;
  const CourseWidget({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetail(course: course),
          ),
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        height: 200,
        child: Card(
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(color: Colors.black.withOpacity(0.5)),
          ),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  color: course.color,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                  border: Border.all(color: Colors.black.withOpacity(0.5)),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatCourse(course: course),
                        ),
                      );
                    },
                    icon: Icon(Icons.auto_awesome),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        course.courseCode,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
