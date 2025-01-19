import 'package:canvas_app/Providers/settings_provider.dart';

class ChatData {
  String get model => "gemini-1.5-flash";
  String get apiKey => SettingsProvider().settingsData.geminiApiKey ?? '';
}
