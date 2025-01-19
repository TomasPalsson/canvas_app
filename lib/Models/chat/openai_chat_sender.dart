import 'dart:convert';
import 'dart:developer' as developer;

import 'package:canvas_app/Providers/http_provider.dart';
import 'package:http/http.dart' as http;

import 'base_chat_sender.dart';
import 'chat_message.dart';

class OpenAIChatSender extends BaseChatSender {
  final settingsProvider = HttpProvider().settingsProvider;
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  static const String _defaultModel = 'gpt-4-turbo-preview';
  static const String _visionModel = 'gpt-4-vision-preview';

  Map<String, dynamic> _convertMessageToOpenAIFormat(ChatMessage message) {
    // Check if the message has image files
    bool hasImages = message.files.entries.any((file) =>
        file.key.toLowerCase().endsWith('.jpg') ||
        file.key.toLowerCase().endsWith('.jpeg') ||
        file.key.toLowerCase().endsWith('.png'));

    if (!hasImages) {
      // Regular text message format
      return {
        "role": message.role == "assistant" ? "assistant" : "user",
        "content": message.content,
      };
    }

    // Vision API message format
    List<Map<String, dynamic>> contents = [];

    // Add image files
    for (var file in message.files.entries) {
      if (file.key.toLowerCase().endsWith('.jpg') ||
          file.key.toLowerCase().endsWith('.jpeg') ||
          file.key.toLowerCase().endsWith('.png')) {
        contents.add({
          "type": "image_url",
          "image_url": {"url": file.value, "detail": "auto"}
        });
      }
    }

    // Add the text content
    contents.add({"type": "text", "text": message.content});

    return {
      "role": message.role == "assistant" ? "assistant" : "user",
      "content": contents
    };
  }

  @override
  Future<String> sendMessage(String message) async {
    if (settingsProvider.settingsData.openAiApiKey == null) {
      throw Exception("OpenAI API key not set");
    }
    print("Sending with openai");
    ChatMessage userMessage =
        ChatMessage(role: "user", content: message, files: Map.from(files));
    messages.add(userMessage);

    // Check if we need to use the vision model
    bool useVisionModel = userMessage.files.entries.any((file) =>
        file.key.toLowerCase().endsWith('.jpg') ||
        file.key.toLowerCase().endsWith('.jpeg') ||
        file.key.toLowerCase().endsWith('.png'));

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${settingsProvider.settingsData.openAiApiKey}",
      },
      body: jsonEncode({
        "model": useVisionModel ? _visionModel : _defaultModel,
        "messages":
            messages.map((m) => _convertMessageToOpenAIFormat(m)).toList(),
        "temperature": 0.7,
        "max_tokens": useVisionModel ? 4096 : null,
        "response_format": {"type": "text"},
      }),
    );

    if (response.statusCode == 200) {
      developer.log("OpenAI Response: ${response.body}");
      final data = jsonDecode(response.body);
      var content = data["choices"][0]["message"]["content"];
      messages.add(ChatMessage(role: "assistant", content: content));
      return content;
    } else {
      throw Exception(
          "Failed to send message: ${response.statusCode} ${response.body}");
    }
  }
}
