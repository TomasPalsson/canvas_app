import 'dart:convert';
import 'dart:developer' as developer;

import 'package:canvas_app/Providers/http_provider.dart';
import 'package:http/http.dart' as http;

import 'base_chat_sender.dart';
import 'chat_message.dart';

class GeminiChatSender extends BaseChatSender {
  @override
  Future<String> sendMessage(String message) async {
    final settingsProvider = HttpProvider().settingsProvider;
    ChatMessage userMessage =
        ChatMessage(role: "user", content: message, files: Map.from(files));
    messages.add(userMessage);

    print("Key: ${settingsProvider.settingsData.geminiApiKey}");
    final response = await http.post(
        Uri.parse(
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${settingsProvider.settingsData.geminiApiKey}"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'model': 'gemini-1.5-flash',
          "contents": messages.map((m) => m.toJson()).toList(),
        }));

    if (response.statusCode == 200) {
      for (var message in messages) {
        var messageJson = message.toJson();
        if (messageJson.containsKey('parts')) {
          for (var part in messageJson['parts']) {
            if (part.containsKey('inline_data')) {
              part['inline_data'] = '...';
            }
          }
        }
        developer.log(messageJson.toString());
      }
      final data = jsonDecode(response.body);
      var content = data["candidates"][0]["content"]["parts"][0]["text"];
      messages.add(ChatMessage(role: "assistant", content: content));
      return content;
    } else {
      throw Exception(
          "Failed to send message: ${response.statusCode} ${response.body}");
    }
  }

  Future<bool> verifyApiKey(String apiKey) async {
    final response = await http.post(
        Uri.parse(
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          'model': 'gemini-1.5-flash',
          "contents": [
            {
              "parts": [
                {"text": "Hello, how are you?"}
              ]
            }
          ]
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
