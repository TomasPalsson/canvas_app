import 'package:hive/hive.dart';

import '../base_model.dart';

part 'calendar_event.g.dart';

@HiveType(typeId: 100)
class CalendarEvent extends BaseModel {
  @HiveField(100)
  final String title;
  @HiveField(101)
  final DateTime startAt;
  @HiveField(102)
  final DateTime endAt;
  @HiveField(103)
  final bool hidden;
  @HiveField(104)
  final String description;
  @HiveField(105)
  final String locationName;
  @HiveField(106)
  final String locationAddress;
  @HiveField(107)
  final String contextCode;
  @HiveField(108)
  final String contextName;

  CalendarEvent({
    required super.id,
    required this.title,
    required this.startAt,
    required this.endAt,
    required this.description,
    required this.locationName,
    required this.locationAddress,
    required this.contextCode,
    required this.contextName,
    required this.hidden,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      startAt:
          DateTime.parse(json['start_at'] ?? DateTime.now().toIso8601String()),
      endAt: DateTime.parse(json['end_at'] ?? DateTime.now().toIso8601String()),
      description: json['description'] ?? '',
      locationName: json['location_name'] ?? '',
      locationAddress: json['location_address'] ?? '',
      contextCode: json['all_context_codes'] ?? '',
      contextName: json['context_name'] ?? '',
      hidden: json['hidden'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'start_at': startAt.toIso8601String(),
      'end_at': endAt.toIso8601String(),
      'description': description,
      'location_name': locationName,
      'location_address': locationAddress,
      'all_context_codes': contextCode,
      'context_name': contextName,
      'hidden': hidden,
    };
  }
}
