import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'book.dart';
import 'book_viewer.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;

  BookDetailPage({required this.book});

  Future<String> _fetchBookContent(BuildContext context) async {
    final response = await http.get(Uri.parse('http://humanbook.kr/api/book/${book.id}/content'));
    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/book_${book.id}.epub';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      return filePath;
    } else {
      throw Exception('Failed to load book content');
    }
  }

  void _readBook(BuildContext context) async {
    try {
      final filePath = await _fetchBookContent(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BookViewer(bookId: book.id,),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load book content')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title ?? 'No title'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/cover.png', // 책 표지 이미지 경로
                  width: 150,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                book.title ?? 'No title',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Author: ${book.author}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
              SizedBox(height: 16.0),
              Divider(color: Colors.grey),
              SizedBox(height: 16.0),
              Text(
                '책 설명',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '설명설명설명설명설명',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Divider(color: Colors.grey),
              SizedBox(height: 16.0),
              Text(
                '기타 정보',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '기타 정보 공간',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: ElevatedButton(
                  onPressed: () => _readBook(context),
                  child: Text('사람책 읽기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
