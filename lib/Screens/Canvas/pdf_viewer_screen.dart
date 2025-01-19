import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../Providers/http_provider.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;

  const PdfViewerScreen({
    super.key,
    required this.pdfUrl,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? pdfUrl;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final response = await HttpProvider().getJson(widget.pdfUrl);
      final url = response['url'] ?? response['html_url'];

      if (url == null || url.isEmpty) {
        throw Exception('PDF URL not found in response');
      }

      if (mounted) {
        setState(() {
          pdfUrl = url;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    'Error loading PDF: $errorMessage',
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : SfPdfViewer.network(
                  pdfUrl!,
                  onDocumentLoadFailed: (details) {
                    setState(() {
                      errorMessage = details.error;
                    });
                  },
                ),
    );
  }
}
