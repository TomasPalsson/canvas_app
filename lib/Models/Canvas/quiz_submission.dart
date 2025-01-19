import '../base_model.dart';

class QuizSubmission extends BaseModel {
  final String quizId;
  final List<QuizQuestion> questions;
  final int attempt;
  final String validationToken;

  QuizSubmission({
    required super.id,
    required this.quizId,
    required this.questions,
    required this.attempt,
    required this.validationToken,
  });

  factory QuizSubmission.fromJson(Map<String, dynamic> json) {
    print("Parsing QuizSubmission from JSON: $json");
    List<QuizQuestion> questions = [];

    // Try to get questions from different possible locations in the JSON
    if (json['questions'] != null) {
      questions = (json['questions'] as List)
          .map((q) => QuizQuestion.fromJson(q))
          .toList();
    } else if (json['quiz_questions'] != null) {
      questions = (json['quiz_questions'] as List)
          .map((q) => QuizQuestion.fromJson(q))
          .toList();
    }

    return QuizSubmission(
      id: json['id']?.toString() ?? '',
      quizId: json['quiz_id']?.toString() ?? '',
      questions: questions,
      attempt: json['attempt'] ?? 1,
      validationToken: json['validation_token'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quiz_id': quizId,
      'questions': questions.map((q) => q.toJson()).toList(),
      'attempt': attempt,
      'validation_token': validationToken,
    };
  }
}

class QuizQuestion {
  final String id;
  final String questionText;
  final List<QuizAnswer> answers;

  QuizQuestion({
    required this.id,
    required this.questionText,
    required this.answers,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    print("Parsing QuizQuestion from JSON: $json");
    return QuizQuestion(
      id: json['id']?.toString() ?? '',
      questionText: json['question_text'] ?? json['question_name'] ?? '',
      answers: ((json['answers'] ?? json['answer_choices'] ?? []) as List)
          .map((a) => QuizAnswer.fromJson(a))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_text': questionText,
      'answers': answers.map((a) => a.toJson()).toList(),
    };
  }
}

class QuizAnswer {
  final String id;
  final String text;

  QuizAnswer({
    required this.id,
    required this.text,
  });

  factory QuizAnswer.fromJson(Map<String, dynamic> json) {
    print("Parsing QuizAnswer from JSON: $json");
    return QuizAnswer(
      id: json['id']?.toString() ?? '',
      text: json['text'] ?? json['answer_text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
    };
  }
}
