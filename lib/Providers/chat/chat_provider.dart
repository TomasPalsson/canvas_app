import 'package:flutter/material.dart';

import '../../Models/Canvas/module_item.dart';
import '../../Models/chat/base_chat_sender.dart';
import '../../Models/chat/chat_storage.dart';
import '../../Models/chat/gemini_chat_sender.dart';
import '../../Models/chat/openai_chat_sender.dart';
import '../../utils.dart';

enum ChatModel {
  gemini,
  openai,
}

class ChatProvider extends ChangeNotifier {
  Map<String, BaseChatSender> chatSenders = {};
  final ChatStorage _storage = ChatStorage();
  ChatModel _currentModel = ChatModel.gemini;
  late final GeminiChatSender _geminiSender = GeminiChatSender();

  ChatModel get currentModel => _currentModel;
  GeminiChatSender get geminiSender => _geminiSender;

  void setModel(ChatModel model) {
    if (_currentModel == model) return;
    print("Switching to $model");

    _currentModel = model;

    // Update all existing chat senders to the new model while preserving messages
    for (var entry in chatSenders.entries) {
      var oldMessages = entry.value.messages;
      var oldFiles = entry.value.files;

      var newSender = _createChatSender();
      newSender.messages = oldMessages;
      newSender.files = oldFiles;

      chatSenders[entry.key] = newSender;
    }

    notifyListeners();
  }

  BaseChatSender _createChatSender() {
    switch (_currentModel) {
      case ChatModel.gemini:
        return _geminiSender;
      case ChatModel.openai:
        return OpenAIChatSender();
    }
  }

  Future<void> loadMessages(String id) async {
    if (chatSenders[id] == null) {
      chatSenders[id] = _createChatSender();
    }
    final messages = await _storage.getMessages(id);
    chatSenders[id]!.messages = messages;
    notifyListeners();
  }

  Future<String> sendMessage(String message, String id) async {
    if (chatSenders[id] == null) {
      chatSenders[id] = _createChatSender();
    }
    final response = await chatSenders[id]!.sendMessage(message);
    await _storage.saveMessages(id, chatSenders[id]!.messages);
    return response;
  }

  Future<void> addMessage(String message, String id) async {
    if (chatSenders[id] == null) {
      chatSenders[id] = _createChatSender();
    }
    notifyListeners();
    await chatSenders[id]!.sendMessage(message);
    await _storage.saveMessages(id, chatSenders[id]!.messages);
    notifyListeners();
  }

  Future<void> addFiles(List<ModuleItem> selectedFiles, String id) async {
    if (chatSenders[id] == null) {
      chatSenders[id] = _createChatSender();
    }
    final files = await FileUtils.handleFiles(selectedFiles);
    chatSenders[id]!.addFiles(files);
    notifyListeners();
  }

  void clearFiles(String id) {
    if (chatSenders[id] != null) {
      chatSenders[id]!.clearFiles();
      notifyListeners();
    }
  }

  void clearFile(String fileName, String id) {
    if (chatSenders[id] != null) {
      chatSenders[id]!.clearFile(fileName);
      notifyListeners();
    }
  }

  Future<void> clearChat(String id) async {
    await _storage.clearMessages(id);
    chatSenders[id]?.messages.clear();
    chatSenders[id]?.clearFiles();
    notifyListeners();
  }

  Future<void> clearAllChats() async {
    await _storage.clearAllMessages();
    chatSenders.clear();
    notifyListeners();
  }
}
