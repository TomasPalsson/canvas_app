import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 20)
class ChatMessage {
  @HiveField(20)
  final String role;

  @HiveField(21)
  final String content;

  @HiveField(22)
  Map<String, String> files;

  ChatMessage(
      {required this.role, required this.content, this.files = const {}});

  Map<String, dynamic> toJson() {
    if (files.isEmpty) {
      return {
        "role": role,
        "parts": [
          {"text": content}
        ],
      };
    } else {
      List<Map<String, dynamic>> parts = [];
      for (var file in files.entries) {
        parts.add({
          "inline_data": {
            "mime_type": determineMimeType(file.key),
            "data": file.value
          }
        });
      }
      parts.add({"text": content});
      return {
        "role": role,
        "parts": parts,
      };
    }
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'],
      content: json['parts'][0]['text'],
    );
  }

  String determineMimeType(String file) {
    if (file.endsWith('.pdf')) {
      return 'application/pdf';
    } else if (file.endsWith('.html')) {
      return 'text/html';
    } else {
      return 'text/plain';
    }
  }
}
