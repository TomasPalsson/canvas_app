import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Models/Canvas/module_item.dart';
import '../../Providers/chat/chat_provider.dart';
import '../../Providers/module_provider.dart';

class FileSelectorDialog extends StatefulWidget {
  final String chatId;
  final String courseId;

  const FileSelectorDialog({
    super.key,
    required this.chatId,
    required this.courseId,
  });

  @override
  State<FileSelectorDialog> createState() => _FileSelectorDialogState();
}

class _FileSelectorDialogState extends State<FileSelectorDialog> {
  List<ModuleItem> selectedFiles = [];
  List<ModuleItem> availableFiles = [];

  @override
  void initState() {
    super.initState();
    loadFiles();
  }

  Future<void> loadFiles() async {
    final files = await ModuleProvider().getAllModuleItems(widget.courseId);
    setState(() {
      availableFiles = files
          .where((item) => item.type == 'File' || item.type == 'Page')
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Files'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: availableFiles.length,
          itemBuilder: (context, index) {
            final file = availableFiles[index];
            return CheckboxListTile(
              title: Text(file.title,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black)),
              subtitle: Text(file.type,
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey)),
              value: selectedFiles.contains(file),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    selectedFiles.add(file);
                  } else {
                    selectedFiles.remove(file);
                  }
                });
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (selectedFiles.isNotEmpty) {
              context
                  .read<ChatProvider>()
                  .addFiles(selectedFiles, widget.chatId);
            }
            Navigator.pop(context);
          },
          child: const Text('Add Files'),
        ),
      ],
    );
  }
}
