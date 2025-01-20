import 'package:canvas_app/Providers/assingment_provider.dart';
import 'package:canvas_app/Providers/calendar_provider.dart';
import 'package:canvas_app/Providers/chat/chat_provider.dart';
import 'package:canvas_app/Providers/course_provider.dart';
import 'package:canvas_app/Providers/flashcard_provider.dart';
import 'package:canvas_app/Providers/module_provider.dart';
import 'package:canvas_app/Providers/settings_provider.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  CourseProvider,
  SettingsProvider,
  AssignmentProvider,
  CalendarProvider,
  ChatProvider,
  ModuleProvider,
  FlashcardProvider,
])
void main() {}
