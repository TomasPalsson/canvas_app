import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../Components/canvas/module_widget.dart';
import '../../../Models/Canvas/course.dart';
import '../../../Providers/module_provider.dart';

class AllModuleList extends StatelessWidget {
  final Course course;
  const AllModuleList({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modules'),
        backgroundColor: course.color,
      ),
      body: Consumer<ModuleProvider>(
        builder: (context, moduleProvider, child) {
          return Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: ListView.builder(
              itemBuilder: (context, index) {
                return ModuleWidget(
                  module: moduleProvider.modules[index],
                  course: course,
                );
              },
              itemCount: moduleProvider.modules.length,
            ),
          );
        },
      ),
    );
  }
}
