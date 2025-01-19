import 'package:flutter/material.dart';

import '../../Models/Canvas/course.dart';
import '../../Models/Canvas/module.dart';
import 'module_item_widget.dart';

class ModuleWidget extends StatelessWidget {
  final Module module;
  final Course? course;
  const ModuleWidget({super.key, required this.module, this.course});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            module.name,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
          ),
          const SizedBox(height: 10),
          ...module.items
              .map((item) => ModuleItemWidget(item: item, course: course)),
        ],
      ),
    );
  }
}
