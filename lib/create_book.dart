import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

import 'auth_provider.dart'; // AuthProvider를 사용하는 경우, 이 파일을 import 해야 합니다.

class BookCreatePage extends StatefulWidget {
  @override
  _BookCreatePageState createState() => _BookCreatePageState();
}

class _BookCreatePageState extends State<BookCreatePage> {
  bool loading = false;
  String message = '';

  Future<void> _createBook() async {
    try {
      setState(() {
        loading = true;
        message = '';
      });

      final dio = Provider.of<AuthProvider>(context, listen: false).dio;
      final response = await dio.get('http://humanbook.kr/api/book/save');

      if (response.statusCode == 200) {
        setState(() {
          message = 'Book created successfully!';
        });
      } else {
        throw Exception('Failed to create book');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        message = 'Failed to create book: $e';
      });
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Book'),
      ),
      body: Center(
        child: loading
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Creating book, please wait...'),
          ],
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _createBook,
              child: Text('Create Book'),
            ),
            SizedBox(height: 16),
            Text(message),
          ],
        ),
      ),
    );
  }
}
