import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Components/settings_comp.dart';
import '../../Components/settings_input.dart';
import '../../Providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, SettingsProvider, child) {
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
                value: SettingsProvider.settingsData.canvasBaseUrl ?? '',
                onChanged: (value) {
                  SettingsProvider.settingsData.canvasBaseUrl = value;
                  SettingsProvider.settingsData.save();
                },
              ),
              const SizedBox(height: 8),
              SettingsInput(
                label: 'Canvas Token',
                value: SettingsProvider.settingsData.canvasToken ?? '',
                onChanged: (value) {
                  SettingsProvider.settingsData.canvasToken = value;
                  SettingsProvider.settingsData.save();
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
                value: SettingsProvider.settingsData.geminiApiKey ?? '',
                onChanged: (value) {
                  SettingsProvider.settingsData.geminiApiKey = value;
                  SettingsProvider.settingsData.save();
                },
                isPassword: true,
              ),
              const SizedBox(height: 8),
              SettingsInput(
                label: 'OpenAI API Key',
                value: SettingsProvider.settingsData.openAiApiKey ?? '',
                onChanged: (value) {
                  SettingsProvider.settingsData.openAiApiKey = value;
                  SettingsProvider.settingsData.save();
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
                value: SettingsProvider.settingsData.isDarkMode,
                onChanged: (value) {
                  SettingsProvider.settingsData.isDarkMode = value;
                  SettingsProvider.settingsData.save();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
