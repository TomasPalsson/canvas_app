import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Components/settings_comp.dart';
import '../../Components/settings_input.dart';
import '../../Providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Canvas Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SettingsInput(
                label: 'Canvas Base URL',
                value: themeProvider.settingsData.canvasBaseUrl ?? '',
                onChanged: (value) {
                  themeProvider.settingsData.canvasBaseUrl = value;
                  themeProvider.settingsData.save();
                },
              ),
              const SizedBox(height: 8),
              SettingsInput(
                label: 'Canvas Token',
                value: themeProvider.settingsData.canvasToken ?? '',
                onChanged: (value) {
                  themeProvider.settingsData.canvasToken = value;
                  themeProvider.settingsData.save();
                },
                isPassword: true,
              ),
              const SizedBox(height: 24),
              const Text(
                'Chat Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SettingsInput(
                label: 'Gemini API Key',
                value: themeProvider.settingsData.geminiApiKey ?? '',
                onChanged: (value) {
                  themeProvider.settingsData.geminiApiKey = value;
                  themeProvider.settingsData.save();
                },
                isPassword: true,
              ),
              const SizedBox(height: 8),
              SettingsInput(
                label: 'OpenAI API Key',
                value: themeProvider.settingsData.openAiApiKey ?? '',
                onChanged: (value) {
                  themeProvider.settingsData.openAiApiKey = value;
                  themeProvider.settingsData.save();
                },
                isPassword: true,
              ),
              const SizedBox(height: 24),
              const Text(
                'App Settings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SettingsComp(
                title: 'Dark Mode',
                value: themeProvider.settingsData.isDarkMode,
                onChanged: (value) {
                  themeProvider.settingsData.isDarkMode = value;
                  themeProvider.settingsData.save();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
