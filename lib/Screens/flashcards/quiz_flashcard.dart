import 'dart:convert';

import 'package:canvas_app/Models/Canvas/course.dart';
import 'package:canvas_app/Models/flashcards/flashcard.dart';
import 'package:canvas_app/Providers/flashcard_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Components/flashcards/quiz_widget.dart';
import '../../Components/loading_enum.dart';
import '../../Models/flashcards/quiz_checker.dart';
import '../../Providers/settings_provider.dart';

class QuizFlashcard extends StatefulWidget {
  final Course course;
  const QuizFlashcard({super.key, required this.course});

  @override
  State<QuizFlashcard> createState() => _QuizFlashcardState();
}

class _QuizFlashcardState extends State<QuizFlashcard> {
  final Map<String, Map<Flashcard, String>> deckAnswers = {};
  final Map<String, Map<Flashcard, bool>> deckResults = {};
  final Map<String, Map<Flashcard, String>> deckFeedback = {};
  bool isChecking = false;

  String getScoreText() {
    int totalCorrect = 0;
    int totalAnswered = 0;

    deckResults.forEach((deckId, results) {
      results.forEach((card, isCorrect) {
        if (isCorrect) totalCorrect++;
        totalAnswered++;
      });
    });

    return totalAnswered > 0 ? '$totalCorrect / $totalAnswered correct' : '';
  }

  @override
  void initState() {
    super.initState();
    final flashcardProvider =
        Provider.of<FlashcardProvider>(context, listen: false);
    final decks = flashcardProvider.getDecksForCourse(widget.course.id);
    // Initialize answers for all decks
    for (final deck in decks) {
      initializeDeckAnswers(deck.id, deck.cards);
    }
  }

  void initializeDeckAnswers(String deckId, List<Flashcard> cards) {
    if (!deckAnswers.containsKey(deckId)) {
      deckAnswers[deckId] = {
        for (var card in cards) card: '',
      };
    }
  }

  void updateAnswer(String deckId, Flashcard card, String answer) {
    setState(() {
      deckAnswers[deckId] ??= {};
      deckAnswers[deckId]![card] = answer;
    });
  }

  Future<void> checkAnswers(String deckId, List<Flashcard> cards) async {
    setState(() {
      isChecking = true;
    });
    String response = await QuizChecker.checkAnswer(deckAnswers[deckId]!);
    Map<String, dynamic> jsonResponse = jsonDecode(response);
    List<dynamic> results = jsonResponse['results'] as List;

    if (mounted && results.length == cards.length) {
      setState(() {
        deckResults[deckId] = {};
        deckFeedback[deckId] = {};
        for (int i = 0; i < cards.length; i++) {
          final result = results[i] as Map<String, dynamic>;
          deckResults[deckId]![cards[i]] = result['correct'] as bool;
          deckFeedback[deckId]![cards[i]] = result['feedback'] as String;
        }
        setState(() {
          isChecking = false;
        });
      });
    } else {
      print("Results length: ${results.length}, Cards length: ${cards.length}");
      print("Results: $results");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error checking answers. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Flashcard'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                getScoreText(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<FlashcardProvider>(
        builder: (context, flashcardProvider, child) {
          final decks = flashcardProvider.getDecksForCourse(widget.course.id);
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: decks.length,
            itemBuilder: (context, index) {
              final deck = decks[index];
              // Initialize answers for this deck if not already initialized
              initializeDeckAnswers(deck.id, deck.cards);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      deck.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: deck.cards.length,
                    itemBuilder: (context, cardIndex) {
                      final card = deck.cards[cardIndex];
                      return QuizWidget(
                        card: card,
                        isCorrect: deckResults[deck.id]?[card],
                        feedback: deckFeedback[deck.id]?[card],
                        initialAnswer: deckAnswers[deck.id]?[card] ?? '',
                        onAnswerChanged: (answer) =>
                            updateAnswer(deck.id, card, answer),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 32),
                      child: ElevatedButton(
                        onPressed: () => checkAnswers(deck.id, deck.cards),
                        child: isChecking
                            ? Provider.of<SettingsProvider>(context,
                                    listen: false)
                                .loadingWidget
                                .widget
                            : const Text('Check Answers'),
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
