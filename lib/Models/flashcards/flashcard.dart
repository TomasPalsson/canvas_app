import 'package:hive/hive.dart';

part 'flashcard.g.dart';

@HiveType(typeId: 7)
class Flashcard extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String question;

  @HiveField(2)
  final String answer;

  @HiveField(3)
  final DateTime createdAt;

  @HiveField(4)
  int correctCount;

  @HiveField(5)
  int incorrectCount;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    required this.createdAt,
    this.correctCount = 0,
    this.incorrectCount = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'question': question,
        'answer': answer,
        'createdAt': createdAt.toIso8601String(),
        'correctCount': correctCount,
        'incorrectCount': incorrectCount,
      };

  factory Flashcard.fromJson(Map<String, dynamic> json) => Flashcard(
        id: json['id'] as String,
        question: json['question'] as String,
        answer: json['answer'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        correctCount: json['correctCount'] as int? ?? 0,
        incorrectCount: json['incorrectCount'] as int? ?? 0,
      );

  Flashcard copyWith({
    String? id,
    String? question,
    String? answer,
    DateTime? createdAt,
    int? correctCount,
    int? incorrectCount,
  }) =>
      Flashcard(
        id: id ?? this.id,
        question: question ?? this.question,
        answer: answer ?? this.answer,
        createdAt: createdAt ?? this.createdAt,
        correctCount: correctCount ?? this.correctCount,
        incorrectCount: incorrectCount ?? this.incorrectCount,
      );
}
