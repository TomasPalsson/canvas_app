import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../Models/Canvas/assignment.dart';
import '../Models/Canvas/calendar_event.dart';
import '../Providers/course_provider.dart';
import '../Providers/http_provider.dart';

class CalendarProvider extends ChangeNotifier {
  List<CalendarEvent> events = [];
  List<Assignment> assignments = [];
  DateTime startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime endDate = DateTime.now().add(const Duration(days: 30));
  bool isLoading = false;

  // Fetch calendar events for the current user.
  // BuildContext [context] is the context of the widget.
  // Fills the events list with the events from the database.
  Future<void> fetchEvents(BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final box = Hive.box('calendarEvents');
    events.clear();
    events = box.values.toList().cast<CalendarEvent>();
    if (events.isNotEmpty) {
      isLoading = false;
      events.sort((a, b) => a.startAt.compareTo(b.startAt));
      notifyListeners();
    }
    CourseProvider courseProvider =
        Provider.of<CourseProvider>(context, listen: false);

    Map<String, dynamic> queryParams = {
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'context_codes[]': courseProvider.courses
          .map((course) => 'course_${course.id}')
          .toList(),
    };

    try {
      // Fetch calendar events
      final List<CalendarEvent> fetchedEvents = await HttpProvider()
          .get('calendar_events', queryParameters: queryParams);
      print("Fetched ${fetchedEvents.length} events");

      events.clear();
      await box.clear();

      events.addAll(fetchedEvents);
      for (var event in fetchedEvents) {
        box.put(event.id, event);
      }

      // Fetch assignments for each course
      assignments.clear();
      for (var course in courseProvider.courses) {
        final List<Assignment> courseAssignments =
            await HttpProvider().get('courses/${course.id}/assignments');
        assignments.addAll(courseAssignments.where((assignment) =>
            assignment.dueAt != null &&
            assignment.dueAt!.isAfter(startDate) &&
            assignment.dueAt!.isBefore(endDate)));
      }
      assignments.sort((a, b) => a.dueAt!.compareTo(b.dueAt!));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Get the events and assignments for a given day.
  // DateTime [day] is the day to get the events and assignments for.
  // Returns a list of dynamic objects.
  List<dynamic> getItemsForDay(DateTime day) {
    final dayEvents = events
        .where((event) =>
            event.startAt.year == day.year &&
            event.startAt.month == day.month &&
            event.startAt.day == day.day)
        .toList();

    final dayAssignments = assignments
        .where((assignment) =>
            assignment.dueAt != null &&
            assignment.dueAt!.year == day.year &&
            assignment.dueAt!.month == day.month &&
            assignment.dueAt!.day == day.day)
        .toList();

    return [...dayEvents, ...dayAssignments];
  }
}
