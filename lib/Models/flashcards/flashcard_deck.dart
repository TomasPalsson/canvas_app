import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import 'flashcard.dart';

part 'flashcard_deck.freezed.dart';
part 'flashcard_deck.g.dart';

@freezed
class FlashcardDeck with _$FlashcardDeck {
  @HiveType(typeId: 8)
  const factory FlashcardDeck({
    @HiveField(0) required String id,
    @HiveField(1) required String courseId,
    @HiveField(2) required String title,
    @HiveField(3) required List<Flashcard> cards,
    @HiveField(4) required DateTime createdAt,
    @HiveField(5) @Default(0) int totalReviews,
  }) = _FlashcardDeck;

  factory FlashcardDeck.fromJson(Map<String, dynamic> json) =>
      _$FlashcardDeckFromJson(json);
}
