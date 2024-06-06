import 'package:flutter/material.dart';
import 'book.dart';
class BookDetailPage extends StatelessWidget {
  final Book book;

  BookDetailPage({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title ?? 'No title'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Title: ${book.title}'),
            Text('Author: ${book.author}'),
            // 추가적인 책 정보를 여기에 표시할 수 있습니다.
          ],
        ),
      ),
    );
  }
}