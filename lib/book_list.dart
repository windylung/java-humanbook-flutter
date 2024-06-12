import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'book.dart';

class BookList extends StatefulWidget {
  final String uri;

  BookList({required this.uri});

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  List<Book> _books = [];

  @override
  void initState() {
    super.initState();
    _fetchBooks();
  }

  @override
  void didUpdateWidget(BookList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.uri != widget.uri) {
      _fetchBooks();
    }
  }

  Future<void> _fetchBooks() async {
    try {
      final dio = Dio(); // AuthProvider를 사용하는 경우 AuthProvider에서 dio 인스턴스를 가져오세요.
      final response = await dio.get(widget.uri);
      if (response.statusCode == 200) {
        setState(() {
          _books = List<Book>.from(response.data.map((book) => Book.fromJson(book)));
        });
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return ListTile(
            title: Text(_books[index].title ?? 'No Title'),
            subtitle: Text(_books[index].author ?? 'No Author'),
          );
        },
        childCount: _books.length,
      ),
    );
  }
}
