import 'package:canvas_app/Providers/theme_provider.dart';

class ChatData {
  String get model => "gemini-1.5-flash";
  String get apiKey => ThemeProvider().settingsData.geminiApiKey ?? '';
}
