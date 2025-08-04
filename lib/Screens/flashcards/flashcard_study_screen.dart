import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/flashcards/flashcard.dart';
import '../../Models/flashcards/flashcard_deck.dart';
import '../../Providers/flashcard_provider.dart';

class FlashcardStudyScreen extends StatefulWidget {
  final FlashcardDeck deck;

  const FlashcardStudyScreen({
    super.key,
    required this.deck,
  });

  @override
  State<FlashcardStudyScreen> createState() => _FlashcardStudyScreenState();
}

class _FlashcardStudyScreenState extends State<FlashcardStudyScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextCard(bool wasCorrect) {
    final provider = context.read<FlashcardProvider>();
    final currentCard = widget.deck.cards[_currentIndex];

    provider.updateCardProgress(widget.deck.id, currentCard.id, wasCorrect);

    if (_currentIndex < widget.deck.cards.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Deck Complete'),
          content: const Text('You have reviewed all cards in this deck!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Return to course page
              },
              child: const Text('Finish'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _currentIndex = 0;
                  _showAnswer = false;
                });
                _pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text('Study Again'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildCard(Flashcard card) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () {
          setState(() {
            _showAnswer = !_showAnswer;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(24),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(card.correctCount.toString(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.green,
                          )),
                  const SizedBox(width: 8),
                  Text(card.incorrectCount.toString(),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.red,
                          )),
                ],
              ),
              Text(
                _showAnswer ? 'Answer' : 'Question',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                _showAnswer ? card.answer : card.question,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              if (_showAnswer) ...[
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => _nextCard(false),
                      icon: const Icon(Icons.close, color: Colors.white),
                      label: Text(
                        'Incorrect',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _nextCard(true),
                      icon: const Icon(Icons.check, color: Colors.white),
                      label: Text(
                        'Correct',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.title),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${_currentIndex + 1}/${widget.deck.cards.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: widget.deck.cards.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
            _showAnswer = false;
          });
        },
        itemBuilder: (context, index) {
          return _buildCard(widget.deck.cards[index]);
        },
      ),
    );
  }
}
