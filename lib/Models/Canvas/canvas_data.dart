import 'package:canvas_app/Providers/theme_provider.dart';

class CanvasData {
  get baseUrl => ThemeProvider().settingsData.canvasBaseUrl ?? '';
  get apiKey => ThemeProvider().settingsData.canvasToken ?? '';
}
