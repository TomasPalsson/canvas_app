import 'package:hive/hive.dart';

import '../base_model.dart';
import 'module_item.dart';

part 'module.g.dart';

@HiveType(typeId: 120)
class Module extends BaseModel {
  @HiveField(120)
  final String name;
  @HiveField(121)
  final String itemsUrl;
  @HiveField(122)
  final List<dynamic> items;

  Module({
    required super.id,
    required this.name,
    required this.itemsUrl,
    required this.items,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    List<ModuleItem> items = [];
    for (var item in json['items']) {
      items.add(ModuleItem.fromJson(item));
    }
    return Module(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      itemsUrl: json['items_url'] ?? '',
      items: items,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items_url': itemsUrl,
      'items': items,
    };
  }
}
