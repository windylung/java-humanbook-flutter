import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_java_humanbook/auth_provider.dart';
import 'package:dio/dio.dart';

class WriteBoardScreen extends StatefulWidget {
  @override
  _WriteBoardScreenState createState() => _WriteBoardScreenState();
}

class _WriteBoardScreenState extends State<WriteBoardScreen> {
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
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('확인'),
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
        title: Text('Write Board'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: '제목'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: '내용'),
              maxLines: 10,
            ),
            SizedBox(height: 16),
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
