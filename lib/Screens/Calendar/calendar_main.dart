import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Components/calendar_comp.dart';
import '../../Providers/calendar_provider.dart';

class CalendarMain extends StatelessWidget {
  const CalendarMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CalendarProvider>(
          builder: (context, calendarProvider, child) {
        return CalendarComp();
      }),
    );
  }
}
