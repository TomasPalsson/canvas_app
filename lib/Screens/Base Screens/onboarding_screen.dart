import 'package:canvas_app/Components/settings_input.dart';
import 'package:canvas_app/Providers/calendar_provider.dart';
import 'package:canvas_app/Providers/settings_provider.dart';
import 'package:canvas_app/Screens/Base Screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController pageController;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Introduction'),
      ),
      body: PageView(
        controller: pageController,
        children: [
          Center(child: SetCanvasCredentials(pageController: pageController)),
          Center(child: SetGeminiCredentials(pageController: pageController)),
          Center(child: FinalPage(pageController: pageController)),
        ],
      ),
    );
  }
}

class SetCanvasCredentials extends StatelessWidget {
  const SetCanvasCredentials({super.key, required this.pageController});
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Set Canvas Credentials',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 8),
          Text(
            'Canvas API key is used to authenticate your requests to the Canvas API. '
            'You can find it in the Canvas settings under "Account" -> "Settings" -> '
            '"Approved Integrations".',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: Colors.grey,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          SettingsInput(
            label: 'Canvas Token',
            onChanged: (value) {
              Provider.of<SettingsProvider>(context, listen: false)
                  .settingsData
                  .canvasToken = value;
            },
            value: Provider.of<SettingsProvider>(context)
                    .settingsData
                    .canvasToken ??
                '',
          ),
          SizedBox(height: 16),
          SettingsInput(
            label: 'Canvas API URL',
            onChanged: (value) {
              Provider.of<SettingsProvider>(context, listen: false)
                  .settingsData
                  .canvasBaseUrl = value;
            },
            value: Provider.of<SettingsProvider>(context)
                    .settingsData
                    .canvasBaseUrl ??
                '',
          ),
          SizedBox(height: 16),
          SafeArea(
            bottom: true,
            child: ElevatedButton(
              onPressed: () {
                pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              },
              child: Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}

class SetGeminiCredentials extends StatelessWidget {
  final PageController pageController;
  const SetGeminiCredentials({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Set Gemini Credentials',
              style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 8),
          Text(
            'You need the Gemini API key to be able to chat with your courses and. '
            'to generate flashcards of your materials.'
            'it can be found at:',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: Colors.grey,
                ),
            textAlign: TextAlign.center,
          ),
          TextButton(
              onPressed: () {
                launchUrl(Uri.parse('https://aistudio.google.com/app/apikey'));
              },
              child: Text('https://aistudio.google.com/app/apikey',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: Colors.lightBlueAccent,
                      ))),
          SizedBox(height: 16),
          SettingsInput(
            label: 'Gemini API Key',
            onChanged: (value) {
              Provider.of<SettingsProvider>(context, listen: false)
                  .settingsData
                  .geminiApiKey = value;
            },
            value: Provider.of<SettingsProvider>(context)
                    .settingsData
                    .geminiApiKey ??
                '',
          ),
          SizedBox(height: 16),
          SafeArea(
            bottom: true,
            child: ElevatedButton(
              onPressed: () {
                pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut);
              },
              child: Text('Next'),
            ),
          ),
        ],
      ),
    );
  }
}

class FinalPage extends StatelessWidget {
  final PageController pageController;
  const FinalPage({super.key, required this.pageController});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('Finish', style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 8),
          Text(
            'Click finish to start using the app.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: Colors.grey,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Provider.of<SettingsProvider>(context, listen: false)
                  .verifyData()
                  .then((value) {
                if (value['gemini'] ?? false) {
                  if (value['canvas'] ?? false) {
                    SettingsProvider settingsProvider =
                        Provider.of<SettingsProvider>(context, listen: false);
                    settingsProvider.settingsData.isFirstTime = false;
                    settingsProvider.settingsData.save();
                    Provider.of<CalendarProvider>(context, listen: false)
                        .fetchEvents(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  } else {
                    pageController.jumpToPage(0);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Canvas API key is invalid')));
                  }
                } else {
                  pageController.jumpToPage(1);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gemini API key is invalid')));
                }
              });
            },
            child: Text('Finish'),
          ),
        ],
      ),
    );
  }
}
