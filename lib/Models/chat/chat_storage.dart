import 'package:hive/hive.dart';

import 'chat_message.dart';

class ChatStorage {
  static const String _boxName = 'chat_messages';
  Box? _box;

  Future<Box> openBox() async {
    _box ??= await Hive.openBox(_boxName);
    return _box!;
  }

  Future<void> saveMessages(String chatId, List<ChatMessage> messages) async {
    final box = await openBox();
    await box.put(chatId, messages);
  }

  Future<List<ChatMessage>> getMessages(String chatId) async {
    final box = await openBox();
    final dynamic messages = box.get(chatId);
    if (messages == null) return [];
    return (messages as List).cast<ChatMessage>();
  }

  Future<void> clearMessages(String chatId) async {
    final box = await openBox();
    await box.delete(chatId);
  }

  Future<void> clearAllMessages() async {
    final box = await openBox();
    await box.clear();
  }
}
