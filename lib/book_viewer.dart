import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class BookViewer extends StatefulWidget {
  final int bookId;

  BookViewer({required this.bookId});

  @override
  _BookViewerState createState() => _BookViewerState();
}

class _BookViewerState extends State<BookViewer> {
  late WebViewController _controller;
  Future<String>? _filePath;

  @override
  void initState() {
    super.initState();
    _filePath = _fetchBookContent(widget.bookId);
  }

  Future<String> _fetchBookContent(int id) async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/book/$id/content'));
    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/book_$id.epub';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
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
        future: _filePath,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..loadFile(snapshot.data!),
            );
          } else {
            return Center(child: Text('Unknown error occurred'));
          }
        },
      ),
    );
  }
}
