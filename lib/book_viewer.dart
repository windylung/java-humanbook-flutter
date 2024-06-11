import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_java_humanbook/auth_provider.dart';

class BookViewer extends StatefulWidget {
  final int bookId;

  BookViewer({required this.bookId});

  @override
  _BookViewerState createState() => _BookViewerState();
}

class _BookViewerState extends State<BookViewer> {
  bool loading = false;
  String filePath = "";
  Map<String, dynamic>? lastLocation;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter is properly initialized
    _fetchAndOpenBookContent(widget.bookId);
  }

  Future<void> _fetchAndOpenBookContent(int bookId) async {
    try {
      setState(() {
        loading = true;
      });

      final dio = Provider.of<AuthProvider>(context, listen: false).dio;
      final response = await dio.get('http://humanbook.kr/api/book/$bookId/content');
      if (response.statusCode == 200) {
        // 로컬 디렉토리에 파일 저장
        final directory = await getTemporaryDirectory(); // Use temporary directory
        final filePath = '${directory.path}/book_$bookId.epub';
        final file = File(filePath);
        await file.writeAsBytes(response.data);

        // 마지막 위치 로드
        await _loadLastLocation(bookId);

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

  Future<void> _loadLastLocation(int bookId) async {
    final directory = await getTemporaryDirectory(); // Use temporary directory
    final filePath = '${directory.path}/last_location_$bookId.json';
    final file = File(filePath);

    if (await file.exists()) {
      final content = await file.readAsString();
      lastLocation = jsonDecode(content);
    }
  }

  Future<void> _saveLastLocation(int bookId, Map<String, dynamic> locator) async {
    final directory = await getTemporaryDirectory(); // Use temporary directory
    final filePath = '${directory.path}/last_location_$bookId.json';
    final file = File(filePath);

    final content = jsonEncode(locator);
    await file.writeAsString(content);
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
    VocsyEpub.locatorStream.listen((locator) async {
      print('LOCATOR: $locator');
      await _saveLastLocation(widget.bookId, locator);
    });

    VocsyEpub.open(
      filePath,
      lastLocation: lastLocation != null ? EpubLocator.fromJson(lastLocation!) : null,
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
