import 'dart:convert';

import 'package:canvas_app/Models/Canvas/module_item.dart';
import 'package:canvas_app/Providers/http_provider.dart';
import 'package:canvas_app/Providers/theme_provider.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as html;
import 'package:http/http.dart' as http;

extension DateTimeExtension on DateTime {
  // Convert a DateTime object to a short string.
  String toShortString() {
    return "$year-$month-$day";
  }

  // Convert a DateTime object to a better string.
  String toBetterString() {
    return "$day/$month/$year ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  }
}

class FileUtils {
  // Fetch a file from Canvas and return it as a base64 encoded string.
  // string [url] is the URL to fetch the file from.
  static Future<Map<String, String>> fetchFileAsBase64(String url) async {
    ThemeProvider themeProvider = HttpProvider().themeProvider;
    final firstResponse = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${themeProvider.settingsData.canvasToken}',
      },
    );
    var decodedResponse = jsonDecode(firstResponse.body);

    // call get twice, first gets the url, second gets the file
    if (decodedResponse.containsKey('url')) {
      if (decodedResponse['filename']?.contains('.pdf') ?? false) {
        final response = await http.get(
          Uri.parse(decodedResponse['url']),
          headers: {
            'Authorization': 'Bearer ${themeProvider.settingsData.canvasToken}',
          },
        );
        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;
          var type = decodedResponse['content-type'].split('/')[1];
          return {"${decodedResponse['filename']}.$type": base64Encode(bytes)};
        } else {
          throw Exception('Failed to load file: ${response.statusCode}');
        }
      }
    }
    return {};
  }

  // Fetch a page from Canvas and return it as a base64 encoded string.
  // string [url] is the URL to fetch the page from.
  // string [name] is the name of the page.
  static Future<Map<String, String>> fetchPageAsBase64(
      String url, String name) async {
    Map<String, String> data = {};
    ThemeProvider themeProvider = HttpProvider().themeProvider;

    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${themeProvider.settingsData.canvasToken}',
    });
    if (response.statusCode == 200) {
      var pageBytes = response.bodyBytes;
      var pageHtml = html.parse(jsonDecode(response.body)['body']);

      List<dom.Element> elements = pageHtml.querySelectorAll('a');

      for (var elem in elements) {
        if (elem.attributes['data-api-endpoint'] != null) {
          var endpoint = elem.attributes['data-api-endpoint']!;
          var base64 = await FileUtils.fetchFileAsBase64(endpoint);
          if (base64.isNotEmpty) {
            data.addAll(base64);
          }
        }
      }
      // Add html so chat knows how to handle it
      data['$name.html'] = base64Encode(pageBytes);

      return data;
    } else {
      throw Exception('Failed to load page: ${response.statusCode}');
    }
  }

  // Fetch files from Canvas and return them as a map of base64 encoded strings.
  // List<ModuleItem> [selectedFiles] is the list of files to fetch.
  static Future<Map<String, String>> handleFiles(
      List<ModuleItem> selectedFiles) async {
    if (selectedFiles.isEmpty) {
      return {};
    }
    Map<String, String> encodedFiles = {};
    for (var file in selectedFiles) {
      if (file.type == 'File') {
        encodedFiles.addAll(await FileUtils.fetchFileAsBase64(file.url));
      } else if (file.type == 'Page') {
        encodedFiles
            .addAll(await FileUtils.fetchPageAsBase64(file.url, file.title));
      }
    }
    return encodedFiles;
  }

  // Fetch a file from Canvas and return it as a base64 encoded string.
  // string [url] is the URL to fetch the file from.
  static Future<Map<String, String>> fetchFileAsBase64Single(String url) async {
    ThemeProvider themeProvider = HttpProvider().themeProvider;
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer ${themeProvider.settingsData.canvasToken}',
    });
    if (response.statusCode == 200) {
      return {"$url.pdf": base64Encode(response.bodyBytes)};
    } else {
      throw Exception('Failed to load file: ${response.statusCode}');
    }
  }
}

// Helper function to check if a string is numeric.
bool isNumeric(String s) {
  return double.tryParse(s) != null;
}
