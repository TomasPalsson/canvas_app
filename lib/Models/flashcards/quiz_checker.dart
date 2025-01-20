import 'dart:convert';

import 'package:canvas_app/Models/chat/gemini_chat_sender.dart';
import 'package:canvas_app/Models/flashcards/flashcard.dart';

class QuizChecker {
  static Future<String> checkAnswer(Map<Flashcard, String> answers) async {
    GeminiChatSender chatSender = GeminiChatSender();

    String prompt = '''
You are a quiz checker. You will be given flashcard questions and user answers. Your task is to check if each answer is correct.

Instructions:
1. Compare each user's answer with the correct answer, considering semantic meaning rather than exact matches
2. Be lenient with minor spelling mistakes or slightly different phrasings
3. Mark empty or missing answers as incorrect
4. Return ONLY a JSON object in this exact format, nothing else:
{
  "results": [
    {"correct": true, "feedback": "Correct! Good job."},
    {"correct": false, "feedback": "Not quite. The answer should focus on..."},
    {"correct": false, "feedback": "No answer provided."}
  ]
}

Questions and Answers to check:
${answers.entries.map((entry) => '''
Question: ${entry.key.question}
User Answer: ${entry.value.trim().isEmpty ? '(No answer provided)' : entry.value}
Correct Answer: ${entry.key.answer}
---''').join('\n')}
''';

    print("Checking ${answers.length} answers");
    String response = await chatSender.sendMessage(prompt);
    response = response.replaceAll('```json', '').replaceAll('```', '').trim();

    try {
      // Validate JSON structure
      Map<String, dynamic> parsed = jsonDecode(response);
      if (!parsed.containsKey('results')) {
        print("Error: Missing 'results' key in response");
        throw FormatException('Invalid response format: missing results key');
      }

      if (parsed['results'] is! List) {
        print("Error: 'results' is not a list");
        throw FormatException('Invalid response format: results is not a list');
      }

      List<dynamic> results = parsed['results'] as List;
      if (results.length != answers.length) {
        print(
            "Error: Results length (${results.length}) doesn't match answers length (${answers.length})");
        throw FormatException('Invalid response length');
      }

      return response;
    } catch (e) {
      print("Error parsing response: $e");
      print("Raw response: $response");
      // If parsing fails, return a properly formatted error response
      return jsonEncode({
        'results': answers.entries
            .map((entry) => {
                  'correct': false,
                  'feedback': 'Error checking answer. Please try again.'
                })
            .toList()
      });
    }
  }
}
