import 'package:canvas_app/Components/loading_enum.dart';
import 'package:canvas_app/Models/settings_data.dart';
import 'package:canvas_app/Providers/assingment_provider.dart';
import 'package:canvas_app/Providers/calendar_provider.dart';
import 'package:canvas_app/Providers/chat/chat_provider.dart';
import 'package:canvas_app/Providers/course_provider.dart';
import 'package:canvas_app/Providers/flashcard_provider.dart';
import 'package:canvas_app/Providers/module_provider.dart';
import 'package:canvas_app/Providers/theme_provider.dart';
import 'package:canvas_app/Screens/Base%20Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import 'test_helpers/mock_providers.mocks.dart';

void main() {
  late MockCourseProvider mockCourseProvider;
  late MockThemeProvider mockThemeProvider;
  late MockAssignmentProvider mockAssignmentProvider;
  late MockCalendarProvider mockCalendarProvider;
  late MockChatProvider mockChatProvider;
  late MockModuleProvider mockModuleProvider;
  late MockFlashcardProvider mockFlashcardProvider;

  void setupDefaultMockBehaviors() {
    when(mockThemeProvider.getTheme()).thenReturn(ThemeData.light());
    when(mockCourseProvider.courses).thenReturn([]);
    when(mockCalendarProvider.getItemsForDay(any)).thenReturn([]);
    when(mockCalendarProvider.isLoading).thenReturn(false);
    when(mockModuleProvider.modules).thenReturn([]);
    when(mockThemeProvider.settingsData).thenReturn(SettingsData(
      isDarkMode: false,
      loadingWidget: LoadingWidget.halfTriangleDot,
    ));
  }

  setUp(() {
    mockCourseProvider = MockCourseProvider();
    mockThemeProvider = MockThemeProvider();
    mockAssignmentProvider = MockAssignmentProvider();
    mockCalendarProvider = MockCalendarProvider();
    mockChatProvider = MockChatProvider();
    mockModuleProvider = MockModuleProvider();
    mockFlashcardProvider = MockFlashcardProvider();

    // Setup default behaviors
    setupDefaultMockBehaviors();
  });

  Widget createHomeScreen() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CourseProvider>.value(value: mockCourseProvider),
        ChangeNotifierProvider<ThemeProvider>.value(value: mockThemeProvider),
        ChangeNotifierProvider<AssignmentProvider>.value(
            value: mockAssignmentProvider),
        ChangeNotifierProvider<CalendarProvider>.value(
            value: mockCalendarProvider),
        ChangeNotifierProvider<ChatProvider>.value(value: mockChatProvider),
        ChangeNotifierProvider<ModuleProvider>.value(value: mockModuleProvider),
        ChangeNotifierProvider<FlashcardProvider>.value(
            value: mockFlashcardProvider),
      ],
      child: MaterialApp(
        home: const HomeScreen(),
      ),
    );
  }

  group('HomeScreen', () {
    testWidgets('should have a bottom navigation bar',
        (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());

      expect(find.text('Home'), findsOne);
      expect(find.text('Calendar'), findsOne);
      expect(find.text('Settings'), findsOne);
      expect(find.byType(BottomNavigationBar), findsOne);
    });

    testWidgets(
        'clicking on bottom navigation bar should navigate to correct screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(createHomeScreen());

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(find.text('App Settings'), findsOne);
    });
  });
}
