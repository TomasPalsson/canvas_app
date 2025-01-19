import 'package:canvas_app/Providers/assingment_provider.dart';
import 'package:canvas_app/Providers/calendar_provider.dart';
import 'package:canvas_app/Providers/chat/chat_provider.dart';
import 'package:canvas_app/Providers/course_provider.dart';
import 'package:canvas_app/Providers/flashcard_provider.dart';
import 'package:canvas_app/Providers/module_provider.dart';
import 'package:canvas_app/Providers/theme_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([
  CourseProvider,
  ThemeProvider,
  AssignmentProvider,
  CalendarProvider,
  ChatProvider,
  ModuleProvider,
  FlashcardProvider,
])
void main() {}
