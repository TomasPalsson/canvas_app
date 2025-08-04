import 'package:canvas_app/Components/loading_enum.dart';
import 'package:canvas_app/Components/main_drawer.dart';
import 'package:canvas_app/Providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Components/canvas/assignment_widget.dart';
import '../Components/canvas/calendar_event_widget.dart';
import '../Models/Canvas/assignment.dart';
import '../Models/Canvas/calendar_event.dart';
import '../Providers/calendar_provider.dart';

class CalendarComp extends StatefulWidget {
  const CalendarComp({super.key});

  @override
  _CalendarCompState createState() => _CalendarCompState();
}

class _CalendarCompState extends State<CalendarComp> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  bool hideSource = true;

  int daysForward = 100;

  List<dynamic> getItemsForDay(DateTime day) {
    return Provider.of<CalendarProvider>(context, listen: false)
        .getItemsForDay(day);
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  @override
  Widget build(BuildContext context) {
    final calendarProvider = Provider.of<CalendarProvider>(context);
    final selectedDayItems = getItemsForDay(_selectedDay);

    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        actions: [
          IconButton(
            icon: Icon(!hideSource ? Icons.visibility : Icons.hide_source),
            onPressed: () {
              setState(() {
                hideSource = !hideSource;
              });
            },
            tooltip: !hideSource ? 'Show hidden events' : 'Hide hidden events',
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => calendarProvider.fetchEvents(context),
            tooltip: 'Refresh events',
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.now().subtract(const Duration(days: 30)),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            eventLoader: getItemsForDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: _onDaySelected,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: _buildEventsMarker(date, events),
                  );
                }
                return SizedBox();
              },
              selectedBuilder: (context, date, events) {
                return Container(
                  width: 40,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.blueAccent,
                      width: 2,
                    ),
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: calendarProvider.isLoading
                ? Center(
                    child: Provider.of<SettingsProvider>(context, listen: false)
                        .loadingWidget
                        .widget,
                  )
                : selectedDayItems.isEmpty
                    ? Center(child: Text('No items for this day.'))
                    : ListView.builder(
                        itemCount: selectedDayItems.length,
                        itemBuilder: (context, index) {
                          final item = selectedDayItems[index];
                          if (item is CalendarEvent) {
                            if (item.hidden && hideSource) {
                              return SizedBox.shrink();
                            }
                            return CalendarEventWidget(calendarEvent: item);
                          } else if (item is Assignment) {
                            return AssignmentWidget(assignment: item);
                          }
                          return SizedBox.shrink();
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List<dynamic> items) {
    final visibleItems = items.where((item) {
      if (item is CalendarEvent) {
        return !item.hidden || !hideSource;
      }
      return true;
    }).toList();

    if (visibleItems.isEmpty) return SizedBox.shrink();

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blueAccent,
          ),
          width: 12.0,
          height: 12.0,
          child: Center(
            child: Text(
              '${visibleItems.length}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 8.0,
              ),
            ),
          ),
        ),
        if (items.any((item) => item is Assignment))
          Positioned(
            right: -4,
            top: -4,
            child: Container(
              width: 8.0,
              height: 8.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.redAccent,
              ),
            ),
          ),
      ],
    );
  }
}
