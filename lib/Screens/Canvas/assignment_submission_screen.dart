import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../Components/custom_html_widget.dart';
import '../../Models/Canvas/assignment.dart';
import '../../Providers/http_provider.dart';

class AssignmentSubmissionScreen extends StatefulWidget {
  final Assignment assignment;

  const AssignmentSubmissionScreen({super.key, required this.assignment});

  @override
  State<AssignmentSubmissionScreen> createState() =>
      _AssignmentSubmissionScreenState();
}

class _AssignmentSubmissionScreenState
    extends State<AssignmentSubmissionScreen> {
  final TextEditingController _commentController = TextEditingController();
  File? _selectedFile;
  bool _isSubmitting = false;
  String? _errorMessage;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
        _errorMessage = null;
      });
    }
  }

  Future<void> _submitAssignment() async {
    if (_selectedFile == null && _commentController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please add a file or comment before submitting';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      // First, create the submission
      final response = await HttpProvider().post(
        'courses/${widget.assignment.courseId}/assignments/${widget.assignment.id}/submissions',
        body: {'comment': _commentController.text},
      );

      if (_selectedFile != null) {
        // If there's a file, upload it
        final String uploadUrl = response['upload_url'];
        await HttpProvider().uploadFile(
          uploadUrl,
          _selectedFile!,
          {'assignment_id': widget.assignment.id},
        );
      }

      // Show success and pop back
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Assignment submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to submit assignment: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Submit Assignment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.assignment.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            if (widget.assignment.description.isNotEmpty) ...[
              Text(
                'Description:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              CustomHtmlWidget(htmlContent: widget.assignment.description),
              const SizedBox(height: 16),
            ],
            ElevatedButton.icon(
              onPressed: _isSubmitting ? null : _pickFile,
              icon: Icon(Icons.attach_file),
              label: Text(_selectedFile != null
                  ? 'Change File: ${_selectedFile!.path.split('/').last}'
                  : 'Attach File'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                labelText: 'Comment (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              enabled: !_isSubmitting,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitAssignment,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Submit Assignment'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
