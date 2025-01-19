import 'package:hive/hive.dart';

part 'base_model.g.dart';

@HiveType(typeId: 0)
class BaseModel {
  @HiveField(0)
  final String id;
  BaseModel({required this.id});

  factory BaseModel.fromJson(Map<String, dynamic> json) {
    return BaseModel(id: json['id']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}
