import 'package:canvas_app/Components/loading_enum.dart';
import 'package:canvas_app/Models/Canvas/canvas_data.dart';
import 'package:canvas_app/Models/chat/gemini_chat_sender.dart';
import 'package:canvas_app/Models/settings_data.dart';
import 'package:canvas_app/Providers/http_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class SettingsProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  LoadingWidget loadingWidget = LoadingWidget.newtonCradle;
  SettingsData settingsData =
      SettingsData(isDarkMode: true, loadingWidget: LoadingWidget.newtonCradle);

  void toggleTheme(bool isDark) {
    themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    settingsData.isDarkMode = isDark;
    notifyListeners();
    settingsData.save();
  }

  void setLoadingWidget(LoadingWidget widget) {
    loadingWidget = widget;
    settingsData.loadingWidget = widget;
    notifyListeners();
    settingsData.save();
  }

  Future<void> loadSettings() async {
    final box = Hive.box('settings');
    settingsData = box.get('settings') ??
        SettingsData(
            isDarkMode: true, loadingWidget: LoadingWidget.newtonCradle);
    themeMode = settingsData.isDarkMode ? ThemeMode.dark : ThemeMode.light;
    loadingWidget = settingsData.loadingWidget;
    print("Loading settings: ${settingsData.geminiApiKey}");
    notifyListeners();
  }

  ThemeData getTheme() {
    return themeMode == ThemeMode.dark ? darkTheme : lightTheme;
  }

  void setCanvasData(CanvasData canvasData) {
    settingsData.canvasBaseUrl = canvasData.baseUrl;
    settingsData.canvasToken = canvasData.apiKey;
    notifyListeners();
    settingsData.save();
  }

  void setOpenAiApiKey(String apiKey) {
    settingsData.openAiApiKey = apiKey;
    notifyListeners();
    settingsData.save();
  }

  Future<Map<String, bool>> verifyData() async {
    Map<String, bool> results = {};
    results['gemini'] =
        await GeminiChatSender().verifyApiKey(settingsData.geminiApiKey ?? '');
    results['canvas'] = await HttpProvider().verifyCanvasData(
        settingsData.canvasBaseUrl ?? '', settingsData.canvasToken ?? '');
    return results;
  }

  ThemeData get darkTheme {
    Color baseColor = Color(0xFF131515);
    Color secondaryColor = Colors.blueAccent;
    Color jet = Color(0xFF2B2C28);
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: baseColor.withOpacity(0.9),
      cardColor: jet,
      colorScheme: ColorScheme.fromSeed(
        seedColor: secondaryColor,
        surface: baseColor,
      ),
      dialogBackgroundColor: baseColor,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: baseColor,
        selectedItemColor: secondaryColor,
        unselectedItemColor: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: baseColor,
        titleTextStyle: GoogleFonts.rubik(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      textTheme: TextTheme(
        bodyMedium: GoogleFonts.rubik(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodySmall: GoogleFonts.rubik(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.white.withValues(alpha: 50),
        ),
        titleLarge: GoogleFonts.rubik(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        titleMedium: GoogleFonts.rubik(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
        titleSmall: GoogleFonts.rubik(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: baseColor,
      ),
      listTileTheme: ListTileThemeData(
        textColor: Colors.white,
      ),
    );
  }

  ThemeData get lightTheme {
    Color baseColor = Color(0xFFFAFBFC);
    Color secondaryColor = Colors.blueAccent;
    Color jet = Color(0xFF2B2C28);
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: baseColor,
      cardColor: baseColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: secondaryColor,
        surface: baseColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: baseColor,
        selectedItemColor: secondaryColor,
        unselectedItemColor: jet,
      ),
      textTheme: TextTheme(
        bodyMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodySmall: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Colors.black.withValues(alpha: 50),
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
