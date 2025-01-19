import 'dart:convert';

import 'package:canvas_app/Models/Canvas/course.dart';
import 'package:canvas_app/Models/Canvas/course_tab.dart';
import 'package:canvas_app/Providers/http_provider.dart';
import 'package:http/http.dart' as http;

class TabProvider {
  static Future<List<CourseTab>> getTabs(Course course) async {
    List<CourseTab> tabs =
        await HttpProvider().get<CourseTab>('courses/${course.id}/tabs');
    for (var tab in tabs) {
      tab.course = course;
    }
    tabs.removeWhere((tab) =>
        tab.id == 'home' || tab.id == 'assignments' || tab.id == 'modules');
    return tabs;
  }

  static Future<String> getLink(CourseTab tab) async {
    var id = '';
    try {
      id = int.parse(tab.id.substring(tab.id.length - 3)).toString();
    } catch (e) {
      id = tab.id;
    }
    var link = Uri.parse(
        "${HttpProvider().themeProvider.settingsData.canvasBaseUrl}/api/v1/courses/${tab.course?.id}/external_tools/sessionless_launch?id=$id");
    var response = await http.get(link, headers: {
      'Authorization':
          'Bearer ${HttpProvider().themeProvider.settingsData.canvasToken}',
    });

    var url = jsonDecode(response.body)['url'];
    try {
      if (response.statusCode == 200) {
        return url ?? '';
      }
      print("Error getting sessionless launch URL: ${response.body}");
      return '';
    } catch (e) {
      print("Error parsing response: $e");
      return '';
    }
  }
}
