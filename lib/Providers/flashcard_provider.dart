import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../Models/flashcards/flashcard.dart';
import '../Models/flashcards/flashcard_deck.dart';
import '../Models/flashcards/flashcard_generator.dart';

class FlashcardProvider with ChangeNotifier {
  final FlashcardGenerator _generator;
  final Box<FlashcardDeck> _decksBox;
  Map<String, List<FlashcardDeck>> _courseDecks = {};

  FlashcardProvider(this._generator, this._decksBox) {
    _loadDecks();
  }

  List<FlashcardDeck> getDecksForCourse(String courseId) {
    return _courseDecks[courseId] ?? [];
  }

  Future<void> _loadDecks() async {
    try {
      final decks = _decksBox.values.toList();
      _courseDecks = {};

      for (var deck in decks) {
        final courseDecks = _courseDecks[deck.courseId] ?? [];
        courseDecks.add(deck);
        _courseDecks[deck.courseId] = courseDecks;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error loading flashcard decks: $e');
    }
  }

  // Create a flashcard deck. It uses the [courseId] to find the course and then creates the deck.
  // string [title] is the title of the deck and the [content] or [file] is
  // used to generate the flashcards.
  Future<FlashcardDeck> createDeck(String courseId, String title,
      {String? content, Map<String, String>? file}) async {
    try {
      List<Flashcard> cards = await _generator.generateFromText(
        text: content,
        file: file,
      );

      final deck = FlashcardDeck(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        courseId: courseId,
        title: title,
        cards: cards,
        createdAt: DateTime.now(),
      );

      await _decksBox.put(deck.id, deck);

      final courseDecks = _courseDecks[courseId] ?? [];
      courseDecks.add(deck);
      _courseDecks[courseId] = courseDecks;

      notifyListeners();
      return deck;
    } catch (e) {
      debugPrint('Error creating flashcard deck: $e');
      rethrow;
    }
  }

  // Delete a flashcard deck.
  // string [deckId] is the ID of the deck to delete.
  Future<void> deleteDeck(String deckId) async {
    try {
      final deck = _decksBox.get(deckId);
      if (deck != null) {
        await _decksBox.delete(deckId);

        final courseDecks = _courseDecks[deck.courseId] ?? [];
        courseDecks.removeWhere((d) => d.id == deckId);
        _courseDecks[deck.courseId] = courseDecks;

        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error deleting flashcard deck: $e');
      rethrow;
    }
  }

  // Update the progress of a flashcard.
  // string [deckId] is the ID of the deck the card belongs to.
  // string [cardId] is the ID of the card to update.
  // bool [wasCorrect] is true if the card was answered correctly, false otherwise.s
  Future<void> updateCardProgress(
      String deckId, String cardId, bool wasCorrect) async {
    try {
      final deck = _decksBox.get(deckId);
      if (deck == null) return;

      final updatedCards = deck.cards.map((card) {
        if (card.id == cardId) {
          return card.copyWith(
            correctCount:
                wasCorrect ? card.correctCount + 1 : card.correctCount,
            incorrectCount:
                wasCorrect ? card.incorrectCount : card.incorrectCount + 1,
          );
        }
        return card;
      }).toList();

      final updatedDeck = deck.copyWith(
        cards: updatedCards,
        totalReviews: deck.totalReviews + 1,
      );

      await _decksBox.put(deckId, updatedDeck);

      final courseDecks = _courseDecks[deck.courseId] ?? [];
      final index = courseDecks.indexWhere((d) => d.id == deckId);
      if (index != -1) {
        courseDecks[index] = updatedDeck;
        _courseDecks[deck.courseId] = courseDecks;
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error updating card progress: $e');
      rethrow;
    }
  }
}
