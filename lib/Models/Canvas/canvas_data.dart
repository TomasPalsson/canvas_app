import 'package:canvas_app/Providers/settings_provider.dart';

class CanvasData {
  get baseUrl => SettingsProvider().settingsData.canvasBaseUrl ?? '';
  get apiKey => SettingsProvider().settingsData.canvasToken ?? '';
}
