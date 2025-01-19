import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/calendar_provider.dart';
import '../../Providers/course_provider.dart';
import '../../Providers/settings_provider.dart';
import '../Calendar/calendar_main.dart';
import '../Canvas/Course/all_courses_list.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settingsProvider =
          Provider.of<SettingsProvider>(context, listen: false);
      settingsProvider.loadSettings();
      final courseProvider =
          Provider.of<CourseProvider>(context, listen: false);
      courseProvider.getCourses();
      final calendarProvider =
          Provider.of<CalendarProvider>(context, listen: false);
      calendarProvider.fetchEvents(context);
    });
  }

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    SettingsScreen(),
    CalendarMain(),
    AllCoursesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Homer"),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: "All Courses"),
        ],
      ),
      body: _pages[_selectedIndex],
    );
  }
}
