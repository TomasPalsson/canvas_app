import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Providers/flashcard_provider.dart';

class FlashcardCreationDialog extends StatefulWidget {
  final String courseId;
  final String? content;
  final String title;
  final Map<String, String>? file;

  const FlashcardCreationDialog({
    super.key,
    required this.courseId,
    this.content,
    required this.title,
    this.file,
  });

  @override
  State<FlashcardCreationDialog> createState() =>
      _FlashcardCreationDialogState();
}

class _FlashcardCreationDialogState extends State<FlashcardCreationDialog> {
  bool _isLoading = false;
  String? _error;

  Future<void> _createDeck() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      if (widget.content != null) {
        final provider = context.read<FlashcardProvider>();
        await provider.createDeck(
          widget.courseId,
          widget.title,
          content: widget.content!,
        );
      } else {
        final provider = context.read<FlashcardProvider>();
        await provider.createDeck(
          widget.courseId,
          widget.title,
          file: widget.file,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Flashcards created successfully'),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to create flashcards: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Flashcards'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Create flashcards from:',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(
            widget.title,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (_error != null) ...[
            const SizedBox(height: 16),
            Text(
              _error!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.red,
                  ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createDeck,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : const Text('Create'),
        ),
      ],
    );
  }
}
