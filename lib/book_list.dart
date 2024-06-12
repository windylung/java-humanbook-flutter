import 'package:flutter/material.dart';
import 'book.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
    final response = await http.get(Uri.parse(widget.uri));
    if (response.statusCode == 200) {
      final List<dynamic> bookJson = json.decode(response.body);
      setState(() {
        _books = bookJson.map((json) => Book.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load books');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return ListTile(
            title: Text(_books[index].title!),
            subtitle: Text(_books[index].author!),
          );
        },
        childCount: _books.length,
      ),
    );
  }
}
