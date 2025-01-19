import 'package:flutter/material.dart';

import '../base_model.dart';
import 'course.dart';

class CourseTab extends BaseModel {
  final String htmlUrl;
  final String label;
  final bool isHidden;
  Course? course;
  Function()? onTap;
  IconData? icon;

  CourseTab({
    required super.id,
    required this.htmlUrl,
    required this.label,
    required this.isHidden,
    required this.course,
    this.onTap,
    this.icon,
  });

  @override
  factory CourseTab.fromJson(Map<String, dynamic> json) {
    return CourseTab(
      id: json['id'],
      htmlUrl: json['html_url'],
      label: json['label'],
      isHidden: json['hidden'] ?? false,
      course: null,
      onTap: null,
      icon: null,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'html_url': htmlUrl,
      'label': label,
      'hidden': isHidden,
      'course_id': course?.id,
      'icon': icon,
    };
  }
}
