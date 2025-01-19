import '../base_model.dart';

class Assignment extends BaseModel {
  final String name;
  final String description;
  final DateTime? dueAt;
  final String courseId;
  final bool isQuizAssignment;
  final String? quizId;
  final String submissionType;

  Assignment({
    required super.id,
    required this.name,
    required this.description,
    this.dueAt,
    required this.courseId,
    required this.isQuizAssignment,
    this.quizId,
    required this.submissionType,
  });

  bool get canSubmitOnline =>
      submissionType == 'online_upload' ||
      submissionType == 'online_text_entry' ||
      submissionType == 'online_url';

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json['id'].toString(),
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      dueAt: json['due_at'] != null ? DateTime.parse(json['due_at']) : null,
      courseId: json['course_id']?.toString() ?? "",
      isQuizAssignment: json['is_quiz_assignment'] ?? false,
      quizId: json['quiz_id']?.toString(),
      submissionType: json['submission_types']?.first ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'due_at': dueAt?.toIso8601String(),
      'course_id': courseId,
      'is_quiz_assignment': isQuizAssignment,
      'quiz_id': quizId,
      'submission_types': [submissionType],
    };
  }
}
