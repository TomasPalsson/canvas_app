import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../base_model.dart';

part 'course.g.dart';

@HiveType(typeId: 1)
class Course extends BaseModel {
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String courseCode;
  @HiveField(3)
  final int term;

  Course({
    required super.id,
    required this.name,
    required this.courseCode,
    required this.term,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
        id: json['id'].toString(),
        name: json['name'],
        courseCode: json['course_code'],
        term: json['enrollment_term_id']);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'course_code': courseCode,
      'enrollment_term_id': term
    };
  }

  Color get color {
    return _getColorFromId(int.parse(id.replaceAll('course_', '')));
  }

  Color _getColorFromId(int id) {
    // Map the ID to a hue value (0-360)

    const double minSaturation = 0.7;
    const double maxSaturation = 0.8;
    const double minLightness = 0.5;
    const double maxLightness = 0.7;

    // Generate Hue by mapping ID to [0, 360)
    double hue =
        (id * 137.508) % 360; // Using the golden angle for better distribution

    // Generate Saturation by mapping ID to [minSaturation, maxSaturation]
    double saturation =
        minSaturation + ((id * 0.02469) % 1) * (maxSaturation - minSaturation);

    // Generate Lightness by mapping ID to [minLightness, maxLightness]
    double lightness =
        minLightness + ((id * 0.03727) % 1) * (maxLightness - minLightness);

    return HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Course &&
        other.id == id &&
        other.name == name &&
        other.courseCode == courseCode &&
        other.term == term;
  }

  @override
  int get hashCode => Object.hash(id, name, courseCode, term);
}
