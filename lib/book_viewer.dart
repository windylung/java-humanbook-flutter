import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class BookViewer extends StatefulWidget {
  final int bookId;

  BookViewer({required this.bookId});

  @override
  _BookViewerState createState() => _BookViewerState();
}

class _BookViewerState extends State<BookViewer> {
  late WebViewController _controller;
  Future<String>? _htmlContent;

  @override
  void initState() {
    super.initState();
    _htmlContent = _fetchBookContent(widget.bookId);
  }

  Future<String> _fetchBookContent(int bookId) async {
    final response = await http.get(Uri.parse('http://humanbook.kr/api/book/$bookId/content'));
    if (response.statusCode == 200) {
      // EPUB 파일을 HTML 콘텐츠로 변환하는 작업이 필요
      // 여기서는 간단히 HTML로 래핑하여 표시
      final htmlContent = '''
        <!DOCTYPE html>
        <html>
        <head>
          <title>Book Viewer</title>
        </head>
        <body>
          <embed src="data:application/epub+zip;base64,${base64Encode(response.bodyBytes)}" type="application/epub+zip" width="100%" height="100%">
        </body>
        </html>
      ''';
      return htmlContent;
    } else {
      throw Exception('Failed to load book content');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Viewer'),
      ),
      body: FutureBuilder<String>(
        future: _htmlContent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..loadHtmlString(snapshot.data!),
            );
          } else {
            return Center(child: Text('Unknown error occurred'));
          }
        },
      ),
    );
  }
}
