import 'package:canvas_app/Models/base_model.dart';

class ModuleItem extends BaseModel {
  final String title;
  final String type;
  final String url;

  ModuleItem(
      {required super.id,
      required this.title,
      required this.type,
      required this.url});

  factory ModuleItem.fromJson(Map<String, dynamic> json) {
    return ModuleItem(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      url: json['url'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'url': url,
    };
  }
}
