import 'package:flutter/material.dart';
import 'book.dart';
import 'book_list.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BookshelfScreen extends StatefulWidget {
  @override
  BookshelfScreenState createState() => BookshelfScreenState();
}

class BookshelfScreenState extends State<BookshelfScreen> {
  String _searchOption = '제목';
  final TextEditingController _searchController = TextEditingController();
  String _uri = 'http://humanbook.kr/api/book/list'; // 초기 URI 값

  void _updateUri() {
    setState(() {
      if (_searchOption == '제목') {
        _uri = 'http://humanbook.kr/api/search?type=title&keyword=${_searchController.text}';
      } else {
        _uri = 'http://humanbook.kr/api/search?type=author&keyword=${_searchController.text}';
      }
      print(_uri);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookshelf'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                DropdownButton<String>(
                  value: _searchOption,
                  items: <String>['제목', '작가']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _searchOption = newValue!;
                    });
                  },
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: '검색어 입력',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: _updateUri,
                  child: Text('검색'),
                ),
              ],
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                BookList(), // 책 목록을 보여주는 BookList 위젯
              ],
            ),
          ),
        ],
      ),
    );
  }
}