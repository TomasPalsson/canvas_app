import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'Components/loading_enum.dart';
import 'Models/Canvas/assignment.dart';
import 'Models/Canvas/calendar_event.dart';
import 'Models/Canvas/course.dart';
import 'Models/Canvas/course_tab.dart';
import 'Models/Canvas/module.dart';
import 'Models/Canvas/quiz.dart';
import 'Models/Canvas/quiz_submission.dart';
import 'Models/base_model.dart';
import 'Models/chat/chat_message.dart';
import 'Models/flashcards/flashcard.dart';
import 'Models/flashcards/flashcard_deck.dart';
import 'Models/flashcards/flashcard_generator.dart';
import 'Models/settings_data.dart';
import 'Providers/assingment_provider.dart';
import 'Providers/calendar_provider.dart';
import 'Providers/chat/chat_provider.dart';
import 'Providers/course_provider.dart';
import 'Providers/flashcard_provider.dart';
import 'Providers/http_provider.dart';
import 'Providers/module_provider.dart';
import 'Providers/theme_provider.dart';
import 'Screens/Base Screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(BaseModelAdapter());
  Hive.registerAdapter(CourseAdapter());
  Hive.registerAdapter(CalendarEventAdapter());
  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(ModuleAdapter());
  Hive.registerAdapter(LoadingWidgetAdapter());
  Hive.registerAdapter(SettingsDataAdapter());
  Hive.registerAdapter(FlashcardDeckImplAdapter());
  Hive.registerAdapter(FlashcardAdapter());

  // Register HTTP Provider parsers
  HttpProvider().registerFromJson(Course, Course.fromJson);
  HttpProvider().registerFromJson(CourseTab, CourseTab.fromJson);
  HttpProvider().registerFromJson(Assignment, Assignment.fromJson);
  HttpProvider().registerFromJson(CalendarEvent, CalendarEvent.fromJson);
  HttpProvider().registerFromJson(Module, Module.fromJson);
  HttpProvider().registerFromJson<Quiz>(Quiz, Quiz.fromJson);
  HttpProvider().registerFromJson<QuizSubmission>(
      QuizSubmission, QuizSubmission.fromJson);
  // Open the boxes
  await Hive.openBox('courses');
  await Hive.openBox('calendarEvents');
  await Hive.openBox('chat_messages');
  await Hive.openBox('settings');
  await Hive.openBox<FlashcardDeck>('flashcard_decks');

  // Create providers
  final chatProvider = ChatProvider();
  final flashcardGenerator = FlashcardGenerator(chatProvider.geminiSender);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AssignmentProvider()),
        ChangeNotifierProvider(create: (_) => CalendarProvider()),
        ChangeNotifierProvider.value(value: chatProvider),
        ChangeNotifierProvider(create: (_) => ModuleProvider()),
        ChangeNotifierProvider(
          create: (_) => FlashcardProvider(
            flashcardGenerator,
            Hive.box<FlashcardDeck>('flashcard_decks'),
          ),
        ),
      ],
      child: Builder(
        builder: (context) => MaterialApp(
          title: 'Canvas App V2',
          theme: Provider.of<ThemeProvider>(context).getTheme(),
          debugShowCheckedModeBanner: false,
          home: Builder(
            builder: (context) {
              ThemeProvider().loadSettings();
              HttpProvider().setContext(context);
              return const HomeScreen();
            },
          ),
        ),
      ),
    ),
  );
}
