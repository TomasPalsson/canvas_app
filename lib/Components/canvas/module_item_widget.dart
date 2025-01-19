import 'package:canvas_app/utils.dart';
import 'package:flutter/material.dart';

import '../../Components/flashcards/flashcard_creation_dialog.dart';
import '../../Models/Canvas/course.dart';
import '../../Models/Canvas/module_item.dart';
import '../../Providers/http_provider.dart';
import '../../Providers/module_provider.dart';
import '../../Screens/Canvas/modules/module_file_viewer.dart';
import '../../Screens/Canvas/modules/module_page_viewer.dart';

class ModuleItemWidget extends StatelessWidget {
  final ModuleItem item;
  final Course? course;
  const ModuleItemWidget({super.key, required this.item, this.course});
  final Map<String, IconData> icons = const {
    'File': Icons.file_present,
    'Page': Icons.book,
    'Discussion': Icons.question_answer,
    'Assignment': Icons.assignment,
  };

  void _openItem(BuildContext context) {
    switch (item.type) {
      case 'Page':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModulePageViewer(item: item),
          ),
        );
        break;
      case 'File':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ModuleFileViewer(moduleItem: item),
          ),
        );
        break;
      default:
        print('Not a page');
    }
  }

  Future<void> _showCreateFlashcardsDialog(BuildContext context) async {
    if (course == null) return;

    try {
      final httpProvider = HttpProvider();
      String? content;
      Map<String, String>? file;
      if (item.type == 'Page') {
        final data = await ModuleProvider().getPageHtml(item);
        content = data;
      } else if (item.type == 'File') {
        file = await FileUtils.handleFiles([item]);
      }

      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) => FlashcardCreationDialog(
          courseId: course!.id,
          title: item.title,
          content: content,
          file: file,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching content: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return item.type != 'SubHeader'
        ? InkWell(
            onTap: () {
              _openItem(context);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    icons[item.type] ?? Icons.book,
                    color: course?.color ?? Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (item.type == 'Page' || item.type == 'File')
                    IconButton(
                      icon: const Icon(Icons.flash_on),
                      onPressed: () => _showCreateFlashcardsDialog(context),
                      tooltip: 'Create Flashcards',
                    ),
                ],
              ),
            ),
          )
        : Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              item.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
  }
}
