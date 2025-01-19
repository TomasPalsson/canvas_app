import 'package:flutter/material.dart';

import 'chat_func.dart';

abstract class BaseChat extends ChangeNotifier {
  List<Map<String, dynamic>> messages = [];
  String systemPrompt = "";
  List<ChatFunction> functions = [];
  bool isFunctionCalling = false;
  Map<String, String> files = {};
  bool isLoading = false;

  void addMessage(String message);

  void setSystemPrompt(String prompt);

  void addFunctions(List<ChatFunction> functions);

  void addFiles(Map<String, String> files);
}
