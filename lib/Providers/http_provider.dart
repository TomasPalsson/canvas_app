import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../Models/base_model.dart';
import '../Providers/theme_provider.dart';
import '../Screens/Base Screens/settings_screen.dart';

class HttpProvider {
  final Map<Type, Function(Map<String, dynamic>)> _fromJson = {};
  static HttpProvider? _instance;
  BuildContext? context;

  HttpProvider._internal();

  factory HttpProvider() {
    _instance ??= HttpProvider._internal();
    return _instance!;
  }

  // Sets the [context] to allow the HttpProvider to access it.
  // Should be done at the start/main of the app.
  void setContext(BuildContext context) {
    this.context = context;
  }

  ThemeProvider get themeProvider => context != null
      ? Provider.of<ThemeProvider>(context!, listen: false)
      : ThemeProvider();

  // Get a JSON object from the Canvas API.
  // string [urlExtension] is the path to the API endpoint.
  Future<dynamic> getJson(String urlExtension) async {
    if (themeProvider.settingsData.canvasBaseUrl?.isEmpty != false &&
        context != null) {
      Fluttertoast.showToast(
          msg: 'Canvas base URL is required. Please configure it in settings.');
      await Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => const SettingsScreen()),
      );

      if (themeProvider.settingsData.canvasBaseUrl?.isEmpty != false) {
        throw Exception(
            'Canvas base URL is required. Please configure it in settings.');
      }
    }

    String baseUrl = themeProvider.settingsData.canvasBaseUrl ?? '';

    // Add a trailing slash if it's not already there.
    if (!baseUrl.endsWith('/')) baseUrl += '/';

    // Remove the leading slash if it's there.
    if (urlExtension.startsWith('/')) urlExtension = urlExtension.substring(1);

    Uri url = Uri.parse("$baseUrl/api/v1/$urlExtension");
    // In cases where the url returns the full url, we need to parse it as a Uri.
    if (urlExtension.startsWith('http')) {
      url = Uri.parse(urlExtension);
    }

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${themeProvider.settingsData.canvasToken ?? ''}'
    });

    if (response.statusCode == 200) {
      try {
        return jsonDecode(response.body);
      } catch (e) {
        rethrow;
      }
    } else {
      throw Exception(
          'Failed to fetch data code: ${response.statusCode} ${url.toString()}');
    }
  }

  // Register object type [T] with the [fromJson] function.
  // This is used to convert the JSON object to a Dart object.
  void registerFromJson<T extends BaseModel>(
      Type type, Function(Map<String, dynamic>) fromJson) {
    _fromJson[type] = fromJson;
  }

  // Get a list of objects from the Canvas API.
  // string [urlExtension] is the path to the API endpoint.
  // [queryParameters] is a map of query parameters to add to the API call.
  Future<List<T>> get<T extends BaseModel>(String urlExtension,
      {List<String> include = const [],
      Map<String, dynamic> queryParameters = const {}}) async {
    List<T> data = [];
    Uri? url;

    // Check if the Canvas base URL is set.
    if (themeProvider.settingsData.canvasBaseUrl?.isEmpty != false &&
        context != null) {
      Fluttertoast.showToast(
          msg: 'Canvas base URL is required. Please configure it in settings.');
      await Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => const SettingsScreen()),
      );
      if (themeProvider.settingsData.canvasBaseUrl?.isEmpty != false) {
        throw Exception(
            'Canvas base URL is required. Please configure it in settings.');
      }
    }

    String baseUrl = themeProvider.settingsData.canvasBaseUrl ?? '';
    if (!urlExtension.startsWith('/')) urlExtension = '/$urlExtension';

    try {
      url = Uri.parse("$baseUrl/api/v1/$urlExtension");
    } catch (e) {
      throw Exception('Invalid URL: ${baseUrl + urlExtension}. Error: $e');
    }

    if (include.isNotEmpty) {
      queryParameters = {...queryParameters, 'include[]': include.join(',')};
    }

    if (queryParameters.isNotEmpty) {
      url = url.replace(queryParameters: queryParameters);
    }

    // Loop through the pages of the API call.
    while (url != null) {
      if (themeProvider.settingsData.canvasToken?.isEmpty != false) {
        throw Exception(
            'Canvas API key is not set. Please configure it in settings.');
      }

      final response = await http.get(url, headers: {
        'Authorization':
            'Bearer ${themeProvider.settingsData.canvasToken ?? ''}'
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData is! List) {
          jsonData = [jsonData];
        }
        for (var item in jsonData) {
          try {
            data.add(_fromJson[T]!(item));
          } catch (e) {
            throw Exception(
                'Failed to parse data code: ${response.statusCode} type: $T was not registered in ${_fromJson.keys} url: $urlExtension error: $e');
          }
        }
        url = _getNextPageUrl(response.headers['link']);
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(
            msg: 'Canvas API key is invalid. Please configure it in settings.');
        await Navigator.push(
          context!,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        );
      } else {
        throw Exception(
            'Failed to fetch data code: ${response.statusCode} ${baseUrl + urlExtension} key = ${themeProvider.settingsData.canvasToken}');
      }
    }
    return data;
  }

  Uri? _getNextPageUrl(String? linkHeader) {
    if (linkHeader == null) return null;

    // Split the link header into individual links.
    final links = linkHeader.split(',').map((link) => link.trim());

    // Loop through the links and find the next page given by the rel="next" attribute.
    for (var link in links) {
      final match = RegExp(r'<([^>]+)>;\s*rel="([^"]+)"').firstMatch(link);
      if (match != null && match.group(2) == 'next') {
        return Uri.parse(match.group(1)!);
      }
    }
    return null;
  }

  // Post a JSON object to the Canvas API.
  // string [urlExtension] is the path to the API endpoint.
  // [body] is the JSON object to post.
  Future<dynamic> post(String urlExtension,
      {Map<String, dynamic>? body}) async {
    if (themeProvider.settingsData.canvasBaseUrl?.isEmpty != false &&
        context != null) {
      Fluttertoast.showToast(
          msg: 'Canvas base URL is required. Please configure it in settings.');
      await Navigator.push(
        context!,
        MaterialPageRoute(builder: (context) => const SettingsScreen()),
      );
      if (themeProvider.settingsData.canvasBaseUrl?.isEmpty != false) {
        throw Exception(
            'Canvas base URL is required. Please configure it in settings.');
      }
    }

    String baseUrl = themeProvider.settingsData.canvasBaseUrl ?? '';
    if (!baseUrl.endsWith('/')) baseUrl += '/';
    if (urlExtension.startsWith('/')) urlExtension = urlExtension.substring(1);

    final url = Uri.parse("$baseUrl/api/v1/$urlExtension");
    print("Making POST request to: $url");

    final response = await http.post(
      url,
      headers: {
        'Authorization':
            'Bearer ${themeProvider.settingsData.canvasToken ?? ''}',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body ?? {}),
    );

    if (response.statusCode == 204) {
      return null; // Success with no content
    } else if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
          'Failed to post data: ${response.statusCode} - ${response.body}');
    }
  }

  // Upload a file to the Canvas API.
  // string [uploadUrl] is the URL to upload the file to.
  // [file] is the file to upload.
  // [additionalParams] is a map of additional parameters to add to the API call.
  Future<void> uploadFile(String uploadUrl, File file,
      Map<String, dynamic> additionalParams) async {
    var request = http.MultipartRequest('POST', Uri.parse(uploadUrl))
      ..headers['Authorization'] =
          'Bearer ${themeProvider.settingsData.canvasToken ?? ''}'
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    additionalParams.forEach((key, value) {
      request.fields[key] = value.toString();
    });

    final response = await request.send();
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to upload file: ${response.statusCode}');
    }
  }
}
