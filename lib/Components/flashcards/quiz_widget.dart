import 'package:flutter/material.dart';

import '../../Models/flashcards/flashcard.dart';

class QuizWidget extends StatefulWidget {
  final Flashcard card;
  final bool? isCorrect;
  final String? feedback;
  final String initialAnswer;
  final Function(String) onAnswerChanged;
  const QuizWidget({
    super.key,
    required this.card,
    required this.onAnswerChanged,
    this.isCorrect,
    this.feedback,
    this.initialAnswer = '',
  });

  @override
  _QuizWidgetState createState() => _QuizWidgetState();
}

class _QuizWidgetState extends State<QuizWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialAnswer);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.isCorrect != null
          ? (widget.feedback?.length ?? 0) > 100
              ? 280
              : 240
          : 200,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 80,
                alignment: Alignment.center,
                child: Text(
                  widget.card.question,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: widget.isCorrect == null
                        ? Colors.grey
                        : (widget.isCorrect! ? Colors.green : Colors.red),
                  ),
                ),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Answer',
                    border: InputBorder.none,
                    suffixIcon: widget.isCorrect == null
                        ? null
                        : Icon(
                            widget.isCorrect!
                                ? Icons.check_circle
                                : Icons.cancel,
                            color:
                                widget.isCorrect! ? Colors.green : Colors.red,
                          ),
                  ),
                  style: Theme.of(context).textTheme.bodyMedium,
                  onChanged: widget.onAnswerChanged,
                ),
              ),
              if (widget.isCorrect != null && widget.feedback != null) ...[
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        widget.feedback!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color:
                                  widget.isCorrect! ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
