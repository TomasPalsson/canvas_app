import 'package:flutter/material.dart';

import '../Models/Canvas/course.dart';

class CustomTab {
  final String label;
  final IconData icon;
  final Color color;
  final Function() onTap;
  final Course? course;
  const CustomTab({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    required this.course,
  });
}
