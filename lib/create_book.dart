import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'common_dialog.dart';

class BookCreatePage extends StatefulWidget {
  @override
  _BookCreatePageState createState() => _BookCreatePageState();
}

class _BookCreatePageState extends State<BookCreatePage> {
  bool loading = false;

  Future<void> _createBook() async {
    try {
      setState(() {
        loading = true;
      });

      final dio = Provider.of<AuthProvider>(context, listen: false).dio;
      final response = await dio.get('http://humanbook.kr/api/book/save');

      if (response.statusCode == 200) {
        showCommonDialog(
          context,
          'Success',
          'Book created successfully!',
          'OK',
          true,
        );
        // 성공 시 홈 페이지로 이동하고 리스트를 새로고침
        Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
      } else {
        throw Exception('Failed to create book');
      }
    } catch (e) {
      print('Error: $e');
      showCommonDialog(
        context,
        'Error',
        'Failed to create book: $e',
        'OK',
        false,
      );
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
          ],
        ),
      ),
    );
  }
}
