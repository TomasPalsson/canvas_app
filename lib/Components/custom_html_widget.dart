import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Providers/http_provider.dart';
import '../Screens/Canvas/pdf_viewer_screen.dart';

class CustomHtmlWidget extends StatelessWidget {
  final String htmlContent;

  const CustomHtmlWidget({
    super.key,
    required this.htmlContent,
  });

  Future<void> _handleLinkTap(
    BuildContext context,
    String? url,
    Map<String, String> attributes,
  ) async {
    print("url: $url");
    if (url == null) return;

    print("attributes: $attributes");
    try {
      final apiEndpoint = attributes['data-api-endpoint'];
      if (apiEndpoint == null) {
        // If no API endpoint, just launch the URL directly
        await launchUrl(Uri.parse(url));
        return;
      }

      if (attributes['title']?.toLowerCase().endsWith('.pdf') ?? false) {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PdfViewerScreen(pdfUrl: apiEndpoint),
            ),
          );
        }
      } else {
        final response = await HttpProvider().getJson(apiEndpoint);

        if (response != null) {
          final String urlToLaunch = response['url'] ?? response['html_url'];
          if (urlToLaunch.isNotEmpty) {
            await launchUrl(Uri.parse(urlToLaunch));
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open link: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      htmlContent,
      onTapUrl: (url) async {
        await _handleLinkTap(context, url, {});
        return true;
      },
      customWidgetBuilder: (element) {
        if (element.localName == 'a') {
          final attributes = Map<String, String>.fromEntries(
            element.attributes.entries.map(
              (e) => MapEntry<String, String>(
                  e.key.toString(), e.value.toString()),
            ),
          );

          return TextButton(
            onPressed: () => _handleLinkTap(
              context,
              element.attributes['href'] ?? '',
              attributes,
            ),
            child: HtmlWidget(
              element.outerHtml,
              textStyle: const TextStyle(
                color: Colors.redAccent,
                decoration: TextDecoration.underline,
              ),
            ),
          );
        }
        return null;
      },
    );
  }
}
