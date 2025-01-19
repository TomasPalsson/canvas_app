import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';

import '../../Models/Canvas/calendar_event.dart';
import '../../Models/Canvas/course.dart';
import '../../Providers/course_provider.dart';

class CalendarEventWidget extends StatelessWidget {
  final CalendarEvent calendarEvent;
  const CalendarEventWidget({super.key, required this.calendarEvent});

  @override
  Widget build(BuildContext context) {
    Course course = Provider.of<CourseProvider>(context, listen: false)
        .getCourseById(calendarEvent.contextCode.replaceAll('course_', ''));

    Color color = course.color;

    String extra = calendarEvent.title.contains('Dæmatím') ? 'Dæmatími' : '';

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color, width: 2),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Title
            Text(
              "${course.name} $extra",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: 8),
            // Event Time
            Row(
              children: [
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  "${calendarEvent.startAt.hour}:${calendarEvent.startAt.minute.toString().padLeft(2, '0')} - ${calendarEvent.endAt.hour}:${calendarEvent.endAt.minute.toString().padLeft(2, '0')}",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
            SizedBox(height: 4),
            // Event Location
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: color),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    calendarEvent.locationName.isNotEmpty
                        ? calendarEvent.locationName
                        : "Online",
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            // Event Description
            HtmlWidget(
              calendarEvent.description,
              textStyle: TextStyle(color: Colors.grey[800]),
              // Additional styling if needed
            ),
          ],
        ),
      ),
    );
  }
}
