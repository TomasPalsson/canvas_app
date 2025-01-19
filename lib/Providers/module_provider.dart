import 'package:flutter/material.dart';

import '../Models/Canvas/module.dart';
import '../Models/Canvas/module_item.dart';
import '../Providers/http_provider.dart';

class ModuleProvider extends ChangeNotifier {
  List<Module> modules = [];

  Future<void> fetchModules(String courseId) async {
    List<Module> modules = await HttpProvider().get(
      '/courses/$courseId/modules',
      queryParameters: {
        'include[]': 'items',
      },
    );

    this.modules = modules;
    notifyListeners();
  }

  Future<String> getPageHtml(ModuleItem item) async {
    Map<String, dynamic> json = await HttpProvider().getJson(item.url);
    return json['body'];
  }

  Future<String> getModuleItemFileUrl(ModuleItem item) async {
    Map<String, dynamic> json = await HttpProvider().getJson(item.url);
    return json['url'];
  }

  Future<List<ModuleItem>> getAllModuleItems(String courseId) async {
    if (modules.isEmpty) {
      await fetchModules(courseId);
    }

    List<ModuleItem> allItems = [];
    for (var module in modules) {
      if (module.items is List<ModuleItem>) {
        allItems.addAll(module.items as List<ModuleItem>);
      } else
        allItems.addAll(
            module.items.map((item) => ModuleItem.fromJson(item)).toList());
    }
    return allItems;
  }
}
