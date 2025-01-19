import 'dart:convert';
import 'dart:io';

import 'package:canvas_app/Models/chat/file_upload_response.dart';
import 'package:canvas_app/Providers/http_provider.dart';
import 'package:http/http.dart' as http;

abstract class IFileUploader {
  Future<FileUploadResponse> uploadFile(File file);
  Future<void> deleteFile(String fileId);
}

class OpenAIFileUploader implements IFileUploader {
  final settingsProvider = HttpProvider().settingsProvider;
  static const String _baseUrl = 'https://api.openai.com/v1/files';

  @override
  Future<FileUploadResponse> uploadFile(File file) async {
    if (settingsProvider.settingsData.openAiApiKey == null) {
      throw Exception("OpenAI API key not set");
    }

    final request = http.MultipartRequest('POST', Uri.parse(_baseUrl))
      ..headers['Authorization'] =
          'Bearer ${settingsProvider.settingsData.openAiApiKey}'
      ..fields['purpose'] = 'assistants'
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      return FileUploadResponse.fromJson(json.decode(responseBody));
    } else {
      throw Exception(
          'Failed to upload file: ${response.statusCode} $responseBody');
    }
  }

  @override
  Future<void> deleteFile(String fileId) async {
    if (settingsProvider.settingsData.openAiApiKey == null) {
      throw Exception("OpenAI API key not set");
    }

    final response = await http.delete(
      Uri.parse('$_baseUrl/$fileId'),
      headers: {
        'Authorization': 'Bearer ${settingsProvider.settingsData.openAiApiKey}',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to delete file: ${response.statusCode} ${response.body}');
    }
  }
}
