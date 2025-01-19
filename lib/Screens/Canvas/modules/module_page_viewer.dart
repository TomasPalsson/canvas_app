import 'package:canvas_app/Providers/module_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../../Models/Canvas/module_item.dart';

class ModulePageViewer extends StatefulWidget {
  final ModuleItem item;
  const ModulePageViewer({super.key, required this.item});

  @override
  State<ModulePageViewer> createState() => _ModulePageViewerState();
}

class _ModulePageViewerState extends State<ModulePageViewer> {
  String pageData = '';

  Future<void> getJson() async {
    print('Getting page data');
    print(widget.item.id);
    String response = await ModuleProvider().getPageHtml(widget.item);
    setState(() {
      pageData = response;
    });
  }

  @override
  void initState() {
    super.initState();
    getJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.item.title),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          HtmlWidget(pageData),
        ],
      ),
    );
  }
}
