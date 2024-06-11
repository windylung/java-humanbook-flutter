import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class BookViewer extends StatefulWidget {
  final int bookId;

  BookViewer({required this.bookId});

  @override
  _BookViewerState createState() => _BookViewerState();
}

class _BookViewerState extends State<BookViewer> {
  bool loading = false;
  String filePath = "";

  @override
  void initState() {
    super.initState();
    _fetchAndOpenBookContent(widget.bookId);
  }

  Future<void> _fetchAndOpenBookContent(int bookId) async {
    try {
      setState(() {
        loading = true;
      });

      final response = await http.get(Uri.parse('http://humanbook.kr/api/book/$bookId/content'));
      if (response.statusCode == 200) {
        // 로컬 디렉토리에 파일 저장
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/book_$bookId.epub';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // EPUB 뷰어 열기
        await _openEpub(filePath);
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

  Future<void> _openEpub(String filePath) async {
    VocsyEpub.setConfig(
      themeColor: Theme.of(context).primaryColor,
      identifier: "book_$filePath",
      scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
      allowSharing: true,
      enableTts: true,
      nightMode: true,
    );

    // 현재 위치 저장을 위한 스트림
    VocsyEpub.locatorStream.listen((locator) {
      print('LOCATOR: $locator');
    });

    VocsyEpub.open(
      filePath,
      lastLocation: EpubLocator.fromJson({
        "bookId": "2239",
        "href": "/OEBPS/ch06.xhtml",
        "created": 1539934158390,
        "locations": {"cfi": "epubcfi(/0!/4/4[simple_book]/2/2/6)"}
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Viewer'),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Center(child: Text('EPUB 파일이 로드되었습니다')),
    );
  }
}
