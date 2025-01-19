import 'package:canvas_app/Components/loading_enum.dart';
import 'package:canvas_app/Models/Canvas/module_item.dart';
import 'package:canvas_app/Providers/module_provider.dart';
import 'package:canvas_app/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ModuleFileViewer extends StatelessWidget {
  final ModuleItem moduleItem;

  const ModuleFileViewer({super.key, required this.moduleItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(moduleItem.title),
      ),
      body: FutureBuilder<String>(
        future: context.read<ModuleProvider>().getModuleItemFileUrl(moduleItem),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: context.read<ThemeProvider>().loadingWidget.widget);
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return SfPdfViewer.network(snapshot.data!);
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
