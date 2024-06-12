import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:epub_view/epub_view.dart';

import 'auth_provider.dart'; // AuthProvider를 사용하는 경우, 이 파일을 import 해야 합니다.

class BookViewer extends StatefulWidget {
  final int bookId;

  BookViewer({required this.bookId});

  @override
  _BookViewerState createState() => _BookViewerState();
}

class _BookViewerState extends State<BookViewer> {
  bool loading = false;
  Uint8List? epubBytes;
  EpubController? _epubController;

  @override
  void initState() {
    super.initState();
    _fetchBookContent(widget.bookId);
  }

  Future<void> _fetchBookContent(int bookId) async {
    try {
      setState(() {
        loading = true;
      });

      final dio = Provider.of<AuthProvider>(context, listen: false).dio;
      final response = await dio.get(
        'http://humanbook.kr/api/book/$bookId/content',
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        epubBytes = Uint8List.fromList(response.data);
        _epubController = EpubController(
          document: EpubDocument.openData(epubBytes!),
        );
      } else {
        throw Exception('Failed to load book content');
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load book content: $e')),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    _epubController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Viewer'),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : epubBytes == null
          ? Center(child: Text('Failed to load book content'))
          : EpubView(
        controller: _epubController!,
      ),
    );
  }
}
