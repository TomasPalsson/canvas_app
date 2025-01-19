import '../base_model.dart';

class Quiz extends BaseModel {
  final String title;
  final String description;
  final int timeLimit;
  final int questionCount;
  final double pointsPossible;
  final int allowedAttempts;

  Quiz({
    required super.id,
    required this.title,
    required this.description,
    required this.timeLimit,
    required this.questionCount,
    required this.pointsPossible,
    required this.allowedAttempts,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      timeLimit: json['time_limit'] ?? 0,
      questionCount: json['question_count'] ?? 0,
      pointsPossible: (json['points_possible'] ?? 0).toDouble(),
      allowedAttempts: json['allowed_attempts'] ?? 1,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time_limit': timeLimit,
      'question_count': questionCount,
      'points_possible': pointsPossible,
      'allowed_attempts': allowedAttempts,
    };
  }
}
