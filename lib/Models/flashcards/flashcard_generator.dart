import 'dart:convert';

import 'package:canvas_app/Models/chat/gemini_chat_sender.dart';
import 'package:flutter/foundation.dart';

import 'flashcard.dart';

class FlashcardGenerator {
  final GeminiChatSender _geminiSender;

  FlashcardGenerator(this._geminiSender);

  Future<List<Flashcard>> generateFromText(
      {String? text, Map<String, String>? file}) async {
    try {
      String prompt =
          '''Please generate flashcards from the following text. Try to focus on the most important information and the more difficult concepts.
          Format your response as a JSON array of objects with "question" and "answer" fields. For example:
[
  {
    "question": "What is the capital of France?",
    "answer": "Paris"
  }
]
''';
      if (text != null) {
        prompt += '\n\nHere\'s the text to generate flashcards from:\n$text';
      }
      if (file != null) {
        print("Here's the file: ${file.entries}");
        prompt += '\n\nUse the file provided to generate flashcards';
        _geminiSender.addFiles(file);
      }

      final response = await _geminiSender.sendMessage(prompt);

      // Extract JSON from response
      final jsonStr =
          response.trim().replaceAll('```json\n', '').replaceAll('\n```', '');
      final List<dynamic> cards = jsonDecode(jsonStr);

      return cards
          .map((card) => Flashcard(
                id: UniqueKey().toString(),
                question: card['question'],
                answer: card['answer'],
                createdAt: DateTime.now(),
              ))
          .toList();
    } catch (e) {
      debugPrint('Error generating flashcards: $e');
      rethrow;
    }
  }
}
