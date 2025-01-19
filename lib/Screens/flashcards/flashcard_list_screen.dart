import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Components/flashcards/flashcard_deck_widget.dart';
import '../../Models/Canvas/course.dart';
import '../../Providers/flashcard_provider.dart';

class FlashcardListScreen extends StatelessWidget {
  final Course course;

  const FlashcardListScreen({
    super.key,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
        backgroundColor: course.color,
      ),
      body: Consumer<FlashcardProvider>(
        builder: (context, provider, child) {
          final decks = provider.getDecksForCourse(course.id);

          if (decks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.school_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No flashcard decks yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create flashcards from your course content',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: decks.length,
            itemBuilder: (context, index) {
              return FlashcardDeckWidget(deck: decks[index]);
            },
          );
        },
      ),
    );
  }
}
