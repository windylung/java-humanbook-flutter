import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_java_humanbook/auth_provider.dart';
import 'package:dio/dio.dart';

class BoardWriteScreen extends StatefulWidget {
  @override
  _BoardWriteScreenState createState() => _BoardWriteScreenState();
}

class _BoardWriteScreenState extends State<BoardWriteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Future<void> _submitBoard() async {
    try {
      final dio = Provider.of<AuthProvider>(context, listen: false).dio;
      final response = await dio.post(
        'http://humanbook.kr/api/board/write',
        data: {
          'title': _titleController.text,
          'content': _contentController.text,
        },
      );

      if (response.statusCode == 200) {
        _showDialog('성공', '저장되었습니다.');
        Navigator.pop(context);
      } else {
        _showDialog('실패', '저장되지 않았습니다.');
      }
    } catch (e) {
      _showDialog('실패', '저장되지 않았습니다.');
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('글 쓰기'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: '제목',
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: '내용',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitBoard,
              child: Text('저장하기'),
            ),
          ],
        ),
      ),
    );
  }
}
