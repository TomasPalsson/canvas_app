import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Components/canvas/course_widget.dart';
import '../../../Providers/course_provider.dart';

class AllCoursesScreen extends StatelessWidget {
  AllCoursesScreen({super.key});
  bool filter = true;

  void filterCourses(CourseProvider provider) {
    filter = !filter;
    if (filter) {
      provider.filterCourses((course) => course.term == 164);
    } else {
      provider.filterCourses(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("All Courses"),
          actions: [
            IconButton(
                onPressed: () {
                  filterCourses(
                      Provider.of<CourseProvider>(context, listen: false));
                },
                icon: Icon(Icons.filter_list))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount:
                      Provider.of<CourseProvider>(context).courses.length,
                  itemBuilder: (context, index) {
                    return Consumer<CourseProvider>(
                      builder: (context, provider, child) {
                        if (index % 2 == 0) {
                          return Row(
                            children: [
                              CourseWidget(course: provider.courses[index]),
                              if (index + 1 < provider.courses.length)
                                CourseWidget(
                                    course: provider.courses[index + 1]),
                            ],
                          );
                        }
                        return SizedBox.shrink();
                      },
                    );
                  }),
            ),
          ],
        ));
  }
}
