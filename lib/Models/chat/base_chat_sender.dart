import 'chat_message.dart';

abstract class BaseChatSender {
  List<ChatMessage> messages = [];
  Map<String, String> files = {};

  Future<String> sendMessage(String message);

  void addFiles(Map<String, String> newFiles) {
    files.addAll(newFiles);
  }

  void clearFile(String fileName) {
    if (files.containsKey(fileName)) {
      files.remove(fileName);
    }
  }

  void clearFiles() {
    files.clear();
  }
}
