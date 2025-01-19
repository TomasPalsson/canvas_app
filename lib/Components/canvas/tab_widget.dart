import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Components/custom_tab.dart';
import '../../Models/Canvas/course_tab.dart';
import '../../Providers/tab_provider.dart';
import '../../utils.dart';

class TabWidget extends StatelessWidget {
  final CourseTab? courseTab;
  final CustomTab? customTab;
  const TabWidget({super.key, this.courseTab, this.customTab});

  @override
  Widget build(BuildContext context) {
    return courseTab != null
        ? _buildCourseTab(context, courseTab!)
        : _buildCustomTab(context, customTab!);
  }

  Widget _buildCourseTab(BuildContext context, CourseTab courseTab) {
    if (courseTab.isHidden ||
        !isNumeric(courseTab.id.substring(courseTab.id.length - 3)))
      return SizedBox.shrink();
    return GestureDetector(
      onTap: courseTab.onTap ??
          () async {
            try {
              var link = await TabProvider.getLink(courseTab);
              launchUrl(Uri.parse(link));
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error: $e"),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
      child: Container(
        padding: EdgeInsets.all(10),
        height: 70,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Row(
          children: [
            Icon(
              courseTab.icon ?? Icons.link,
              color: courseTab.course?.color,
            ),
            SizedBox(width: 10),
            Text(
              courseTab.label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomTab(BuildContext context, CustomTab customTab) {
    return GestureDetector(
      onTap: customTab.onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        height: 70,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        child: Row(
          children: [
            Icon(
              customTab.icon,
              color: customTab.course?.color,
            ),
            SizedBox(width: 10),
            Text(
              customTab.label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
